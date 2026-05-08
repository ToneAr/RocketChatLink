(* RocketChatTests.wlt
   Integration test suite for ToneAr/RocketChat paclet.
   Requires a local RocketChat instance — start it with:
       cd Tests && ./setup.sh
   Stop it afterwards with:
       cd Tests && ./teardown.sh

   Run with:
       wolframscript -file Tests/RunTests.wls
   or directly via the Wolfram Language TestReport mechanism:
       TestReport["Tests/RocketChatTests.wlt"]
*)
(* ===========================================================================
   Section 0  Global test setup
   =========================================================================== *)
(* -- 0.1  Install and load the paclet -- *)
VerificationTest[
	SetDirectory[$TestFileName // DirectoryName // ParentDirectory];
	PacletDirectoryLoad[Directory[]];
	Quiet[
		Get["ToneAr`RocketChat`"],
		{ServiceFramework`DefineServiceConnection::warn}
	];
	Get["Tests/TestHelpers.wl"];
	True,
	True,
	TestID -> "setup-0.1-paclet-load"
]

(* -- 0.2  Docker server must be reachable -- *)
VerificationTest[
	waitUntilReady[$rcHost, 120],
	True,
	TestID -> "setup-0.2-server-reachable"
]

(* -- 0.3  Connect to the test server -- *)
VerificationTest[
	$rcConnection =
		ServiceConnect[
			"Rocket.Chat",
			"New",
			Authentication -> <|
				"Host"     -> $rcHost,
				"User"     -> $adminUser,
				"Password" -> $adminPassword
			|>
		];
	MatchQ[$rcConnection, _ServiceObject],
	True,
	TestID -> "setup-0.3-service-connect"
]

(* ===========================================================================
   Section 1  Connection data
   =========================================================================== *)
VerificationTest[
	$rcConnection["Authentication"]["Host"],
	$rcHost,
	TestID -> "connection-1.1-host-stored"
]

VerificationTest[
	Module[{requests = ServiceFramework`ConnectionInformation["Rocket.Chat", "ProcessedRequests"]},
		{
			Keys @ requests["GetUserInfo", "Parameters"],
			requests["GetUserInfo", "ParameterMap"]
		}
	],
	{
		{"UserID", "Username", "ImportID", "IncludeUserRooms", "Email"},
		<|
			"UserID" -> "userId",
			"Username" -> "username",
			"ImportID" -> "importId",
			"IncludeUserRooms" -> "includeUserRooms",
			"Email" -> "email"
		|>
	},
	TestID -> "connection-1.2-formal-parameter-map"
]

VerificationTest[
	Quiet @
		ServiceConnect[
			"Rocket.Chat",
			"New",
			Authentication -> <|
				"Host"      -> "not-a-url",
				"AuthToken" -> "tok",
				"UserID"    -> "uid"
			|>
		],
	_Failure,
	SameTest -> MatchQ,
	TestID   -> "connection-1.3-invalid-host-fails"
]

(* ===========================================================================
   Section 2  Authentication
   =========================================================================== *)
(* -- 2.1  Admin login happened during ServiceConnect -- *)
VerificationTest[
	$rcConnection["Authentication"],
	KeyValuePattern[
		{
			"Host" -> $rcHost,
			"AuthToken" -> _String,
			"UserID" -> _String
		}
	],
	SameTest -> MatchQ,
	TestID   -> "auth-2.1-admin-login-during-connect"
]

(* -- 2.2  Auth token is stored after login -- *)
VerificationTest[
	$rcConnection["Authentication"]["AuthToken"],
	_String?(StringLength[#] > 0&),
	SameTest -> MatchQ,
	TestID   -> "auth-2.2-token-stored"
]

(* -- 2.3  Wrong password fails -- *)
VerificationTest[
	Quiet @
		ServiceConnect[
			"Rocket.Chat",
			"New",
			Authentication -> <|
				"Host"     -> $rcHost,
				"User"     -> $adminUser,
				"Password" -> "wrong-password-xyz"
			|>
		],
	_Failure,
	SameTest -> MatchQ,
	TestID   -> "auth-2.3-wrong-password-fails"
]

(* -- 2.4  Token pairs can create a connection directly -- *)
VerificationTest[
	Module[{connection},
		connection =
			ServiceConnect[
				"Rocket.Chat",
				"New",
				Authentication -> <|
					"Host"      -> $rcHost,
					"AuthToken" -> "tok",
					"UserID"    -> "uid"
				|>,
				"SetAsDefault" -> False
			];
		{connection, connection["Authentication"]["AuthToken"], connection["Authentication"]["UserID"]}
	],
	{_ServiceObject, "tok", "uid"},
	SameTest -> MatchQ,
	TestID   -> "auth-2.4-token-authentication"
]

(* -- 2.5  Token pairs must include both token values -- *)
VerificationTest[
	Quiet @
		ServiceConnect[
			"Rocket.Chat",
			"New",
			Authentication -> <|
				"Host"      -> $rcHost,
				"AuthToken" -> "tok"
			|>
		],
	_Failure,
	SameTest -> MatchQ,
	TestID -> "auth-2.5-incomplete-token-authentication-fails"
]

(* ===========================================================================
   Section 3  Server information (no destructive operations)
   =========================================================================== *)
VerificationTest[
	rcRequest["GetServerInfo"],
	_Success?(KeyExistsQ[#[[2]], "version"]&),
	SameTest -> MatchQ,
	TestID   -> "info-3.1-server-info"
]

VerificationTest[
	rcRequest[
		"Directory1",
		"Query" -> "{\"text\":\"\",\"type\":\"users\",\"workspace\":\"local\"}"
	],
	_Success | _Association,
	SameTest -> MatchQ,
	TestID   -> "info-3.2-directory-listing"
]

(* ===========================================================================
   Section 4  Users
   =========================================================================== *)
(* -- 4.1  Create a user -- *)
VerificationTest[
	withTestUser["testcreate", Function[{username, email, userId}, userId]],
	_String?(StringLength[#] > 0&),
	SameTest -> MatchQ,
	TestID   -> "users-4.1-create-user"
]

(* -- 4.2  Get user info by username -- *)
VerificationTest[
	withTestUser[
		"testinfo",
		Function[
			{username, email, userId},
			{
				username,
				rcRequest["GetUserInfo", "Username" -> username][[2]]["user"][
					"username"
				]
			}
		]
	],
	{a_, a_},
	SameTest -> MatchQ,
	TestID   -> "users-4.2-get-user-info"
]

(* -- 4.3  Get user info by userId -- *)
VerificationTest[
	withTestUser[
		"testinfobyid",
		Function[
			{username, email, userId},
			{
				userId,
				rcRequest["GetUserInfo", "UserID" -> userId][[2]]["user"]["_id"]
			}
		]
	],
	{a_, a_},
	SameTest -> MatchQ,
	TestID   -> "users-4.3-get-user-info-by-id"
]

(* -- 4.4  List users contains created user -- *)
VerificationTest[
	withTestUser[
		"testlist",
		Function[
			{username, email, userId},
			SelectFirst[
				rcRequest["GetUsersList"][[2]]["users"],
				#["username"] === username&,
				Missing["NotFound"]
			]
		]
	],
	_Association,
	SameTest -> MatchQ,
	TestID   -> "users-4.4-list-users"
]

(* -- 4.5  Set user active status -- *)
VerificationTest[
	withTestUser[
		"testactive",
		Function[
			{username, email, userId},
			rcRequest[
				"SetUsersStatusActive",
				"ActiveStatus" -> False,
				"UserID" -> userId
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "users-4.5-set-active-status"
]

(* -- 4.6  Get user presence -- *)
VerificationTest[
	withTestUser[
		"testpresence",
		Function[
			{username, email, userId},
			rcRequest["GetSpecificUsersPresence", "UserID" -> userId]
		]
	],
	_Success | _Association,
	SameTest -> MatchQ,
	TestID   -> "users-4.6-get-presence"
]

(* -- 4.7  Get own user info (me) -- *)
VerificationTest[
	rcRequest["GetProfileInfo"][[2]]["username"],
	_String,
	SameTest -> MatchQ,
	TestID   -> "users-4.7-get-me"
]

(* ===========================================================================
   Section 5  Channels
   =========================================================================== *)
(* -- 5.1  Create channel -- *)
VerificationTest[
	withTestChannel["tc-create", Function[{name, roomId}, roomId]],
	_String?(StringLength[#] > 0&),
	SameTest -> MatchQ,
	TestID   -> "channels-5.1-create-channel"
]

(* -- 5.2  Get channel info by roomId -- *)
VerificationTest[
	withTestChannel[
		"tc-info",
		Function[
			{name, roomId},
			{
				roomId,
				rcRequest["GetChannelInformation", "RoomID" -> roomId][[2]][
					"channel"
				][
					"_id"
				]
			}
		]
	],
	{a_, a_},
	SameTest -> MatchQ,
	TestID   -> "channels-5.2-get-info-by-id"
]

(* -- 5.3  Get channel info by roomName -- *)
VerificationTest[
	withTestChannel[
		"tc-infoname",
		Function[
			{name, roomId},
			{
				name,
				rcRequest["GetChannelInformation", "RoomName" -> name][[2]][
					"channel"
				][
					"name"
				]
			}
		]
	],
	{a_, a_},
	SameTest -> MatchQ,
	TestID   -> "channels-5.3-get-info-by-name"
]

(* -- 5.4  List channels -- *)
VerificationTest[
	rcRequest["GetChannelList"][[2]]["channels"],
	_List,
	SameTest -> MatchQ,
	TestID   -> "channels-5.4-list-channels"
]

(* -- 5.5  List joined channels -- *)
VerificationTest[
	rcRequest["GetListOfJoinedChannels"][[2]]["channels"],
	_List,
	SameTest -> MatchQ,
	TestID   -> "channels-5.5-list-joined"
]

(* -- 5.6  Get channel members -- *)
VerificationTest[
	withTestChannel[
		"tc-members",
		Function[
			{name, roomId},
			rcRequest["GetMembersOfAChannel", "RoomID" -> roomId][[2]][
				"members"
			]
		]
	],
	_List,
	SameTest -> MatchQ,
	TestID   -> "channels-5.6-members"
]

(* -- 5.7  Set channel topic -- *)
VerificationTest[
	withTestChannel[
		"tc-topic",
		Function[
			{name, roomId},
			rcRequest[
				"SetChannelTopic",
				"RoomID" -> roomId,
				"Topic" -> "Integration test topic"
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "channels-5.7-set-topic"
]

(* -- 5.8  Set channel description -- *)
VerificationTest[
	withTestChannel[
		"tc-desc",
		Function[
			{name, roomId},
			rcRequest[
				"SetChannelDescription",
				"RoomID" -> roomId,
				"Description" -> "Integration test description"
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "channels-5.8-set-description"
]

(* -- 5.9  Archive and unarchive channel -- *)
VerificationTest[
	withTestChannel[
		"tc-archive",
		Function[
			{name, roomId},
			{
				rcRequest["ArchiveChannel", "RoomID" -> roomId],
				rcRequest["UnarchiveAChannel", "RoomID" -> roomId]
			}
		]
	],
	{_Success, _Success},
	SameTest -> MatchQ,
	TestID   -> "channels-5.9-archive-unarchive"
]

(* -- 5.10  Rename channel -- *)
VerificationTest[
	withTestChannel[
		"tc-rename",
		Function[
			{name, roomId},
			rcRequest[
				"RenameAChannel",
				"RoomID" -> roomId,
				"Name" -> (name <> "x")
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "channels-5.10-rename"
]

(* ===========================================================================
   Section 6  Groups (private channels)
   =========================================================================== *)
(* -- 6.1  Create group -- *)
VerificationTest[
	withTestGroup["tg-create", Function[{name, roomId}, roomId]],
	_String?(StringLength[#] > 0&),
	SameTest -> MatchQ,
	TestID   -> "groups-6.1-create-group"
]

(* -- 6.2  Get group info -- *)
VerificationTest[
	withTestGroup[
		"tg-info",
		Function[
			{name, roomId},
			{
				roomId,
				rcRequest["GetGroupInformation", "RoomID" -> roomId][[2]][
					"group"
				][
					"_id"
				]
			}
		]
	],
	{a_, a_},
	SameTest -> MatchQ,
	TestID   -> "groups-6.2-get-info"
]

(* -- 6.3  List groups -- *)
VerificationTest[
	rcRequest["GetGroups"][[2]]["groups"],
	_List,
	SameTest -> MatchQ,
	TestID   -> "groups-6.3-list-groups"
]

(* -- 6.4  Group history -- *)
VerificationTest[
	withTestGroup[
		"tg-history",
		Function[
			{name, roomId},
			rcRequest["GetGroupHistory", "RoomID" -> roomId][[2]]["messages"]
		]
	],
	_List,
	SameTest -> MatchQ,
	TestID   -> "groups-6.4-history"
]

(* -- 6.5  Group members -- *)
VerificationTest[
	withTestGroup[
		"tg-members",
		Function[
			{name, roomId},
			rcRequest["ListGroupMembers", "RoomID" -> roomId][[2]]["members"]
		]
	],
	_List,
	SameTest -> MatchQ,
	TestID   -> "groups-6.5-members"
]

(* -- 6.6  Set group topic -- *)
VerificationTest[
	withTestGroup[
		"tg-topic",
		Function[
			{name, roomId},
			rcRequest[
				"SetGroupTopic",
				"RoomID" -> roomId,
				"Topic" -> "Private group test topic"
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "groups-6.6-set-topic"
]

(* ===========================================================================
   Section 7  Chat messages
   =========================================================================== *)
(* -- 7.1  Post message to a channel -- *)
VerificationTest[
	withTestChannel[
		"tc-post",
		Function[
			{name, roomId},
			rcRequest[
				"PostMessage",
				"RoomID" -> roomId,
				"Text" -> "Hello from WL test suite!"
			][
				[2]
			][
				"message"
			][
				"_id"
			]
		]
	],
	_String,
	SameTest -> MatchQ,
	TestID   -> "chat-7.1-post-message"
]

(* -- 7.2  Get channel messages -- *)
VerificationTest[
	withTestChannel[
		"tc-getmsg",
		Function[
			{name, roomId},
			rcRequest[
				"PostMessage",
				"RoomID" -> roomId,
				"Text" -> "Message for history test"
			];
			Length[
				rcRequest["GetChannelMessages", "RoomID" -> roomId][[2]][
					"messages"
				]
			]
		]
	],
	_?(# >= 1&),
	SameTest -> MatchQ,
	TestID   -> "chat-7.2-get-channel-messages"
]

(* -- 7.3  Update message -- *)
VerificationTest[
	withTestChannel[
		"tc-updmsg",
		Function[
			{name, roomId},
			With[{
					msgId =
						rcRequest[
							"PostMessage",
							"RoomID" -> roomId,
							"Text" -> "Original text"
						][
							[2]
						][
							"message"
						][
							"_id"
						]
				},
				rcRequest[
					"UpdateMessage",
					"RoomID" -> roomId,
					"MsgID" -> msgId,
					"Text" -> "Updated text"
				]
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "chat-7.3-update-message"
]

(* -- 7.4  Delete message -- *)
VerificationTest[
	withTestChannel[
		"tc-delmsg",
		Function[
			{name, roomId},
			With[{
					msgId =
						rcRequest[
							"PostMessage",
							"RoomID" -> roomId,
							"Text" -> "To be deleted"
						][
							[2]
						][
							"message"
						][
							"_id"
						]
				},
				rcRequest[
					"DeleteChatMessage",
					"RoomID" -> roomId,
					"MsgID" -> msgId
				]
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "chat-7.4-delete-message"
]

(* -- 7.5  Post message to a group -- *)
VerificationTest[
	withTestGroup[
		"tg-post",
		Function[
			{name, roomId},
			rcRequest[
				"PostMessage",
				"RoomID" -> roomId,
				"Text" -> "Hello from group test!"
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "chat-7.5-post-to-group"
]

(* -- 7.6  React to a message -- *)
VerificationTest[
	withTestChannel[
		"tc-react",
		Function[
			{name, roomId},
			With[{
					msgId =
						rcRequest[
							"PostMessage",
							"RoomID" -> roomId,
							"Text" -> "React to this!"
						][
							[2]
						][
							"message"
						][
							"_id"
						]
				},
				rcRequest[
					"ReactToMessage",
					"MessageID" -> msgId,
					"Emoji" -> ":thumbsup:",
					"ShouldReact" -> True
				]
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "chat-7.6-react-to-message"
]

(* -- 7.7  Search messages -- *)
VerificationTest[
	withTestChannel[
		"tc-search",
		Function[
			{name, roomId},
			rcRequest[
				"PostMessage",
				"RoomID" -> roomId,
				"Text" -> "Unique search term xyz987"
			];
			Length[
				rcRequest[
					"SearchMessage",
					"RoomID" -> roomId,
					"SearchText" -> "xyz987"
				][
					[2]
				][
					"messages"
				]
			]
		]
	],
	_?(# >= 1&),
	SameTest -> MatchQ,
	TestID   -> "chat-7.7-search-messages"
]

(* -- 7.8  Pin and unpin a message -- *)
VerificationTest[
	withTestChannel[
		"tc-pin",
		Function[
			{name, roomId},
			With[{
					msgId =
						rcRequest[
							"PostMessage",
							"RoomID" -> roomId,
							"Text" -> "Pin this message"
						][
							[2]
						][
							"message"
						][
							"_id"
						]
				},
				{
					rcRequest["PinMessage", "MessageID" -> msgId],
					rcRequest["UnpinAMessage", "MessageID" -> msgId]
				}
			]
		]
	],
	{_Success, _Success},
	SameTest -> MatchQ,
	TestID   -> "chat-7.8-pin-unpin-message"
]

(* ===========================================================================
   Section 8  Direct messages (DMs)
   =========================================================================== *)
(* -- 8.1  Open a DM with a newly created user -- *)
VerificationTest[
	withTestUser[
		"dm-user",
		Function[
			{username, email, userId},
			rcRequest["CreateDm1", "Username" -> username][[2]]["room"]["_id"]
		]
	],
	_String,
	SameTest -> MatchQ,
	TestID   -> "dm-8.1-create-dm"
]

(* -- 8.2  Post a message in DM -- *)
VerificationTest[
	withTestUser[
		"dm-postuser",
		Function[
			{username, email, userId},
			With[{
					roomId =
						rcRequest["CreateDm1", "Username" -> username][[2]][
							"room"
						][
							"_id"
						]
				},
				rcRequest[
					"PostMessage",
					"RoomID" -> roomId,
					"Text" -> "DM integration test"
				]
			]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "dm-8.2-post-dm"
]

(* ===========================================================================
   Section 9  Rooms
   =========================================================================== *)
(* -- 9.1  Get admin rooms -- *)
VerificationTest[
	rcRequest["GetAllRoomAdmins"][[2]]["rooms"],
	_List,
	SameTest -> MatchQ,
	TestID   -> "rooms-9.1-admin-rooms"
]

(* -- 9.2  Get a room's info -- *)
VerificationTest[
	withTestChannel[
		"tc-room-info",
		Function[
			{name, roomId},
			rcRequest["GetRoomInformation", "RoomID" -> roomId]
		]
	],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "rooms-9.2-room-info"
]

(* -- 9.3  Leave and re-join a channel -- *)
VerificationTest[
	withTestUser[
		"leaveowner",
		Function[
			{username, email, userId},
			withTestChannel[
				"tc-leave",
				Function[
					{name, roomId},
					{
						rcRequest[
							"AddUsersToChannel",
							"RoomID" -> roomId,
							"UserID" -> userId
						],
						rcRequest[
							"AddChannelOwner",
							"RoomID" -> roomId,
							"UserID" -> userId
						],
						rcRequest["LeaveChannel", "RoomID" -> roomId],
						rcRequest["JoinAChannel", "RoomID" -> roomId]
					}
				]
			]
		]
	],
	{_Success, _Success, _Success, _Success},
	SameTest -> MatchQ,
	TestID   -> "rooms-9.3-leave-rejoin"
]

(* ===========================================================================
   Section 10  Subscriptions
   =========================================================================== *)
VerificationTest[
	rcRequest["GetAllSubscriptions"][[2]]["update"],
	_List,
	SameTest -> MatchQ,
	TestID   -> "subscriptions-10.1-get-all"
]

(* ===========================================================================
   Section 11  Permissions
   =========================================================================== *)
VerificationTest[
	rcRequest["ListAllPermissions"],
	_Success | _Association,
	SameTest -> MatchQ,
	TestID   -> "permissions-11.1-get-all"
]

(* ===========================================================================
   Section 12  Settings
   =========================================================================== *)
VerificationTest[
	rcRequest["GetPrivateSettings"],
	_Success | _Association,
	SameTest -> MatchQ,
	TestID   -> "settings-12.1-private-settings"
]

VerificationTest[
	rcRequest["GetPublicSettings"],
	_Success | _Association,
	SameTest -> MatchQ,
	TestID   -> "settings-12.2-public-settings"
]

(* ===========================================================================
   Section 13  Statistics
   =========================================================================== *)
VerificationTest[
	rcRequest["GetLastStatistics"],
	_Success?(KeyExistsQ[#[[2]], "version"]&),
	SameTest -> MatchQ,
	TestID   -> "stats-13.1-statistics"
]

VerificationTest[
	rcRequest["GetStatisticsList"],
	_Success | _Association,
	SameTest -> MatchQ,
	TestID   -> "stats-13.2-statistics-list"
]

(* ===========================================================================
   Section 14  Roles
   =========================================================================== *)
VerificationTest[
	rcRequest["GetRoles"][[2]]["roles"],
	_List,
	SameTest -> MatchQ,
	TestID   -> "roles-14.1-list-roles"
]

VerificationTest[
	rcRequest["GetUsersOfARole", "Role" -> "admin"][[2]]["users"],
	_List,
	SameTest -> MatchQ,
	TestID   -> "roles-14.2-users-with-role"
]

(* ===========================================================================
   Section 15  Teams
   =========================================================================== *)
VerificationTest[
	Module[{
			teamName = "testteam" <> ToString[RandomInteger[{100000, 999999}]],
			teamId
		},
		With[
			{
				res =
					rcRequest[
						"CreateANewTeam",
						"Name" -> teamName,
						"Type" -> 0
						(* public *)
					]
			},
			teamId = res[[2]]["team"]["_id"];
			Quiet @ rcRequest["DeleteATeam", "TeamID" -> teamId];
			{res, teamId}
		]
	],
	{_Success, _String},
	SameTest -> MatchQ,
	TestID   -> "teams-15.1-create-delete-team"
]

VerificationTest[
	rcRequest["GetListOfAllTeams"],
	_Success | _Association,
	SameTest -> MatchQ,
	TestID   -> "teams-15.2-list-teams"
]

(* ===========================================================================
   Section 16  Integrations (incoming webhooks)
   =========================================================================== *)
VerificationTest[
	rcRequest["GetListOfIntegrations"][[2]]["integrations"],
	_List,
	SameTest -> MatchQ,
	TestID   -> "integrations-16.1-list-integrations"
]

(* ===========================================================================
   Section 17  Emoji / Custom emoji
   =========================================================================== *)
VerificationTest[
	rcRequest["ListAllCustomEmojis"],
	_Success | _Association,
	SameTest -> MatchQ,
	TestID   -> "emoji-17.1-list-custom-emoji"
]

(* ===========================================================================
   Section 18  Invites
   =========================================================================== *)
VerificationTest[
	Quiet @ rcRequest["UseInviteToken", "Token" -> "invalid-token"],
	_Success | _Failure,
	SameTest -> MatchQ,
	TestID   -> "invites-18.1-use-invite-graceful"
]

(* ===========================================================================
   Section 99  Teardown  –  logout
   =========================================================================== *)
VerificationTest[
	rcRequest["Logout"],
	_Success,
	SameTest -> MatchQ,
	TestID   -> "teardown-99.1-logout"
]
