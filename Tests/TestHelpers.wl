(* TestHelpers.wl
   Shared helper utilities for the ToneAr/RocketChat integration test suite.
   Get this file at the start of each test section; it expects the paclet to
   already be loaded (done once in RocketChatTests.wlt).
*)
BeginPackage["ToneAr`RocketChat`Tests`", {"ToneAr`RocketChat`"}];

(* -- Public symbols ------------------------------------------------------- *)
$rcHost;
$adminUser;
$adminPassword;
$adminEmail;
$rcConnection;

rcOK;
rcFail;
rcSuccessQ;
rcGetData;
rcRequest;
rcSE;
withCleanup;
withTestChannel;
withTestGroup;
withTestUser;
waitUntilReady;

Begin["`Private`"];

(* -- Default test-server configuration ----------------------------------- *)
(* Override by setting environment variables before starting WolframKernel:
     RC_HOST=http://localhost:3100
     RC_ADMIN_USER=rc_admin
     RC_ADMIN_PASS=Test1234!
*)
$rcHost = Replace[Environment["RC_HOST"], $Failed -> "http://localhost:3100"];

$adminUser = Replace[Environment["RC_ADMIN_USER"], $Failed -> "rc_admin"];

$adminPassword = Replace[Environment["RC_ADMIN_PASS"], $Failed -> "Test1234!"];

$adminEmail =
	Replace[Environment["RC_ADMIN_EMAIL"], $Failed -> "admin@localhost.test"];

(* -- Small predicates ---------------------------------------------------- *)
(* True when result is a Success *)
rcSuccessQ[r_] := MatchQ[r, _Success];

(* True when result is a Failure *)
rcFail[r_] := FailureQ[r];

(* True when result is a Success *)
rcOK[r_] := rcSuccessQ[r];

(* Extract inner data association from a Success or raw Association *)
rcGetData[s_Success] := s[[2]];
rcGetData[a_Association] := a;

(* Call a processed request by name through ServiceExecute *)
rcRequest[name_String, params___Rule] :=
	ServiceExecute[$rcConnection, name, {params}];

(* Short alias for readability inside tests *)
rcSE = rcRequest;

(* -- Docker health-check helper ------------------------------------------ *)
waitUntilReady[host_String, timeoutSecs_Integer : 120] :=
	Module[{
		url = host <> "/api/info",
		deadline = Now + Quantity[timeoutSecs, "Seconds"],
		ready = False
	},
		While[
			Now < deadline && !TrueQ[ready],
			ready = Quiet[URLRead[url, "StatusCode"] === 200];
			If[!TrueQ[ready], Pause[3]]
		];
		TrueQ[ready]
	];

(* -- Cleanup helpers ------------------------------------------------------ *)
(* Run body[], then always run cleanup[] *)
SetAttributes[withCleanup, HoldAll];
withCleanup[cleanup_, body_] :=
	Module[{result}, result = body; Quiet[cleanup]; result];

(* Create a public channel for the duration of body[], then delete it *)
SetAttributes[withTestChannel, HoldAll];
withTestChannel[nameStem_String, body_] :=
	Module[
		{
			channelName = nameStem <> ToString[RandomInteger[{100000, 999999}]],
			roomId,
			result
		},
		(* create *)
		With[{
			res =
				ServiceExecute[
					$rcConnection,
					"CreateChannel",
					{"Name" -> channelName}
				]
		},
			roomId = Lookup[rcGetData[res], "channel", <||>]["_id"]
		];
		result = body[channelName, roomId];
		(* delete *)
		Quiet[
			ServiceExecute[$rcConnection, "DeleteChannel", {"RoomID" -> roomId}]
		];
		result
	];

(* Create a private group for the duration of body[], then delete it *)
SetAttributes[withTestGroup, HoldAll];
withTestGroup[nameStem_String, body_] :=
	Module[{
		groupName = nameStem <> ToString[RandomInteger[{100000, 999999}]],
		roomId,
		result
	},
		With[{
			res =
				ServiceExecute[
					$rcConnection,
					"CreateGroup",
					{"Name" -> groupName}
				]
		},
			roomId = Lookup[rcGetData[res], "group", <||>]["_id"]
		];
		result = body[groupName, roomId];
		Quiet[
			ServiceExecute[$rcConnection, "DeleteGroup", {"RoomID" -> roomId}]
		];
		result
	];

(* Create a user for the duration of body[], then delete them *)
SetAttributes[withTestUser, HoldAll];
withTestUser[usernameStem_String, body_] :=
	Module[{
		suffix = ToString[RandomInteger[{100000, 999999}]],
		username,
		email,
		userId,
		result
	},
		username = usernameStem <> suffix;
		email = username <> "@localhost.test";
		With[{
			res =
				ServiceExecute[
					$rcConnection,
					"CreateUser",
					{
						"Username" -> username,
						"Email" -> email,
						"Password" -> "UserPass1!",
						"Name" -> "Test " <> username
					}
				]
		},
			userId = Lookup[rcGetData[res], "user", <||>]["_id"]
		];
		result = body[username, email, userId];
		Quiet[
			ServiceExecute[$rcConnection, "DeleteUser", {"UserID" -> userId}]
		];
		result
	];

End[];
EndPackage[];
