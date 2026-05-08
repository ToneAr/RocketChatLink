roomsRawRequests =
	<|
		"RawSetRoomNotifications"                              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.saveNotification"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "notifications"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"notifications"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAllRoomAdmins"                                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.adminRooms"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"types",
				"filter",
				"count",
				"offset",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawClearRoomHistory"                                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.cleanHistory"
			],
			"HTTPSMethod"            -> "GET",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"roomId",
				"latest",
				"oldest",
				"inclusive",
				"excludePinned",
				"filesOnly",
				"users",
				"limit",
				"ignoreDiscussion",
				"ignoreThreads"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"latest",
				"oldest"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomInformation"                                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "roomName", "fields"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomDiscussions"                                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.getDiscussions"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomName",
				"roomId",
				"query",
				"count",
				"fields",
				"offset",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRooms"                                          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.get"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"updatedSince"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLeaveRoom"                                         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.leave"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteRoom"                                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.delete"
			],
			"HTTPSMethod"            -> "GET",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawFavoriteunfavouriteARoom"                          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.favorite"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "favorite"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"favorite"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteRoomNameForTeam"                       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.autocomplete.availableForTeams"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"name"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompletePrivateChannel"                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.autocomplete.channelAndPrivate"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"selector"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"selector"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAdminOfRoom"                                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.adminRooms.getRoom"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"rid"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSaveRoomSettings"                                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.saveRoomSettings"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"rid",
				"roomName",
				"roomDescription",
				"roomAvatar",
				"featured",
				"roomTopic",
				"roomAnnouncement",
				"roomCustomFields",
				"roomType",
				"readOnly",
				"reactWhenReadOnly",
				"systemMessages",
				"default",
				"joinCode",
				"streamingOptions",
				"retentionEnabled",
				"retentionMaxAge",
				"retentionExcludePinned",
				"retentionFilesOnly",
				"retentionIgnoreThreads",
				"retentionOverrideGlobal",
				"encrypted",
				"favorite",
				"sidepanel"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawChangeRoomArchiveState"                            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.changeArchivationState"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"rid", "action"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"action"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawExportRoom"                                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.export"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"rid",
				"type",
				"dateFrom",
				"dateTo",
				"format",
				"toUsers",
				"toEmails",
				"messages",
				"subject"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"type"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateDiscussion"                                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.createDiscussion"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"prid",
				"t_name",
				"users",
				"pmid",
				"reply"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"prid",
				"t_name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckIfRoomNameExists"                             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.nameExists"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomName"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMuteUserInRoom"                                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.muteUser"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId", "roomId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnmuteUserInRoom"                                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.unmuteUser"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId", "roomId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAdminAutocompleteRoomNameForPrivateAndPublicRooms" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.autocomplete.adminRooms"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"selector"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"selector"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomImages"                                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.images"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"startingFromId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAuditRooms"                                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/audit/rooms.members"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"filter",
				"count",
				"offset",
				"sort"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUploadMediaFilesToARoom"                           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.media/`rid`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $multipartHeaders,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid"},
			"BodyParameters"         -> {"file"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"file"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomMembersOrderedByRole"                       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.membersOrderedByRole"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"roomName",
				"filter",
				"offset",
				"count",
				"sort",
				"status"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawHideRoom"                                          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.hide"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomRoles"                                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.roles"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"rid"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckRoomMember"                                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.isMember"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteRoomNameWithPagination"                -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/rooms.autocomplete.channelAndPrivate.withPa",
					"gination"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"count", "offset", "sort", "selector"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"selector"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckUploadedFile"                                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/rooms.mediaConfirm/`rid`/`fileId`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid", "fileId"},
			"BodyParameters"         -> {
				"description",
				"emoji",
				"groupable",
				"msg",
				"tmid",
				"avatar",
				"alias",
				"customFields"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"fileId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteUploadedFile"                                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/uploads.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"fileId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"fileId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;