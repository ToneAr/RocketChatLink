BeginPackage["ToneAr`RocketChat`"];
Begin["`Private`"];

Needs["GeneralUtilities`" -> None];
Needs["ServiceFramework`" -> "SF`"];

$headers = {
	"Content-Type" -> "application/json"
};
$multipartHeaders = {
	"Content-Type" -> "multipart/form-data"
};
$headerParameterMap = <|
	"authToken" -> "X-Auth-Token",
	"authUserId" -> "X-User-Id",
	"twoFactorCode" -> "x-2fa-code",
	"twoFactorMethod" -> "x-2fa-method",
	"visitorToken" -> "x-visitor-token"
|>;
requestHeaders[_, headers_, _] := KeyValueMap[
	Lookup[$headerParameterMap, #1, #1] -> #2 &,
	headers
];
$defaultHost = "https://rocketchat.example.com";
$host = $defaultHost;
$authToken = None;
$userId = None;

storedRequestParameterRules[] :=
	Normal @ Select[
		<|
			"host" -> $host,
			"authToken" -> $authToken,
			"authUserId" -> $userId
		|>,
		UnsameQ[#, None] &
	];

dropEmptyRequestParameters[params_] :=
	DeleteCases[
		Developer`ToList @ If[AssociationQ[params], List @@ params, params],
		(_ -> Automatic) | (_ :> Automatic) | (_ -> None) | (_ :> None)
	];

addStoredRequestParameters[params_] :=
	Join[
		storedRequestParameterRules[],
		dropEmptyRequestParameters[params]
	];

requestParameterNames[request_Association] :=
	DeleteDuplicates @ Join[
		Lookup[request, "PathParameters", {}],
		Lookup[request, "HeadersParameters", {}],
		Lookup[request, "QueryParameters", {}],
		Lookup[request, "BodyParameters", {}] // (
			Developer`ToList @*
			Replace["ParameterlessBody" -> {}]
		)
	];

processedRequestName[rawName_String] :=
	StringDelete[rawName, StartOfString ~~ "Raw"];

makeProcessedRequest[rawName_String, request_Association] :=
	With[
		{
			name = rawName,
			parameters = requestParameterNames[request],
			required = Complement[Lookup[request, "RequiredParameters", {}], {"host", "authToken", "authUserId"}]
		},
		<|
			"ExecuteFunction" -> Function[ServiceFramework`Request[name][##]],
			"SubmitFunction" -> "ExecuteFunction",
			"Parameters" -> (# -> Automatic & /@ parameters),
			"RequiredParameters" -> required,
			"PreprocessingFunction" -> addStoredRequestParameters
		|>
	];

storeLoginAuthentication[response_] :=
	Module[{data = If[AssociationQ[response], Lookup[response, "data", <||>], <||>]},
		If[AssociationQ[data],
			If[KeyExistsQ[data, "authToken"], $authToken = data["authToken"]];
			If[KeyExistsQ[data, "userId"], $userId = data["userId"]]
		];
		response
	];

clearStoredAuthentication[response_] :=
	(
		If[!FailureQ[response],
			$authToken = None;
			$userId = None
		];
		response
	);

params = <|
	"ServiceFrameworkVersion" -> "0.1.0",
	"ServiceName" -> "RocketChat",
	"Icon" -> Show[
		Import[
			PacletObject["ToneAr/RocketChat"]["AssetLocation", "icon.svg"],
			"Graphics"
		],
		"ImageSize" -> Scaled[0.1]
	],
	"AuthenticationMethod" -> None,
	"Information" -> "A Wolfram Language service connection to Rocket.Chat.",
	"RawRequests" -> <|
		"RawLogin" -> <|
			"URL" -> StringTemplate["`host`/api/v1/login"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"user", "password", "resume", "code"},
			"RequiredParameters" -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLoginWithFacebook" -> <|
			"URL" -> StringTemplate["`host`/api/v1/login"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"serviceName", "accessToken", "secret", "expiresIn"},
			"RequiredParameters" -> {"host", "serviceName", "accessToken", "secret", "expiresIn"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLoginWithTwitter" -> <|
			"URL" -> StringTemplate["`host`/api/v1/login"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"serviceName", "accessToken", "accessTokenSecret", "appSecret", "appId", "expiresIn"},
			"RequiredParameters" -> {"host", "serviceName", "accessToken", "accessTokenSecret", "appSecret", "appId", "expiresIn"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLoginWithGoogle" -> <|
			"URL" -> StringTemplate["`host`/api/v1/login"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"serviceName", "accessToken", "idToken", "expiresIn", "scope"},
			"RequiredParameters" -> {"host", "serviceName", "accessToken", "idToken", "expiresIn"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogout" -> <|
			"URL" -> StringTemplate["`host`/api/v1/logout"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetProfileInfo" -> <|
			"URL" -> StringTemplate["`host`/api/v1/me"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawEnable2faViaEmail" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.2fa.enableEmail"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRequestANewEmailCode" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.2fa.sendEmailCode"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"emailOrUsername"},
			"RequiredParameters" -> {"host", "emailOrUsername"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDisable2faViaEmail" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.2fa.disableEmail"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "twoFactorCode", "twoFactorMethod"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "email", "password", "username", "active", "nickname", "bio", "joinDefaultChannels", "statusText", "roles", "requirePasswordChange", "setRandomPassword", "sendWelcomeEmail", "verified", "customFields"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "name", "email", "password", "username"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.register"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"username", "email", "pass", "name", "secretURL"},
			"RequiredParameters" -> {"host", "username", "email", "pass", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId", "data"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "twoFactorCode", "twoFactorMethod", "data"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateOwnBasicInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.updateOwnBasicInfo"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"data", "customFields"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "data"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserInfo" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"userId", "username", "importId", "includeUserRooms", "email"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersList" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"query", "fields", "offset", "count", "sort", "email"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListUsersByStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.listByStatus"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "sort", "count", "status", "hasLoggedIn", "type", "roles[]", "searchTerm", "inactiveReason[]"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUserAvatar" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.setAvatar"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"avatarUrl", "userId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "avatarUrl"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserAvatar" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.getAvatar"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"userId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResetUserAvatar" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.resetAvatar"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUserStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.setStatus"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"message", "status", "userId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "message", "status"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.getStatus"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"userId"},
			"RequiredParameters" -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUsersStatusActive" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.setActiveStatus"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"activeStatus", "userId", "confirmRelinquish"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "activeStatus"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeactivateIdleUsers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.deactivateIdle"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"daysIdle", "role"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "daysIdle"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSpecificUsersPresence" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.getPresence"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"userId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersPresence" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.presence"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"from", "ids"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId", "confirmRelinquish"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteOwnUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.deleteOwnAccount"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"password", "confirmRelinquish"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "password"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateUserToken" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.createToken"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId", "secret"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "secret"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserPreferences" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.getPreferences"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUserPreferences" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.setPreferences"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId", "data"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "data"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawForgotPassword" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.forgotPassword"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"email"},
			"RequiredParameters" -> {"host", "email"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsernameSuggestion" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.getUsernameSuggestion"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGeneratePersonalAccessToken" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.generatePersonalAccessToken"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"tokenName", "bypassTwoFactor"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "tokenName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegeneratePersonalAccessToken" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.regeneratePersonalAccessToken"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"tokenName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "tokenName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPersonalAccessTokens" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.getPersonalAccessTokens"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemovePersonalAccessToken" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.removePersonalAccessToken"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"tokenName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "tokenName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRequestDataDownload" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.requestDataDownload"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"fullExport"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogoutOtherClients" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.logoutOtherClients"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.autocomplete"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"selector"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "selector"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveOtherTokens" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.removeOtherTokens"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResetUsersE2eKey" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.resetE2EKey"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResetUsersTotp" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.resetTOTP"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListUserTeams" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.listTeams"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawReportUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.reportUser"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId", "description"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "description"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogoutUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.logout"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAvatars" -> <|
			"URL" -> StringTemplate["`host`/api/v1/avatar/`subject`"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host", "subject"},
			"QueryParameters" -> {"format", "size", "rc_uid", "rc_token"},
			"RequiredParameters" -> {"host", "subject"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckUsernameAvailability" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.checkUsernameAvailability"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"username"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "username"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendUserWelcomeEmail" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.sendWelcomeEmail"],
			"HTTPSMethod" -> "GET",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"email"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "email"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendInvitationEmail" -> <|
			"URL" -> StringTemplate["`host`/api/v1/sendInvitationEmail"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"emails"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "emails"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendEmailVerification" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.sendConfirmationEmail"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"email"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "email"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAvatarSuggestion" -> <|
			"URL" -> StringTemplate["`host`/api/v1/users.getAvatarSuggestion"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLdapSync" -> <|
			"URL" -> StringTemplate["`host`/api/v1/ldap.syncNow"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTestLdapConnection" -> <|
			"URL" -> StringTemplate["`host`/api/v1/ldap.testConnection"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTestLdapUserSearch" -> <|
			"URL" -> StringTemplate["`host`/api/v1/ldap.testSearch"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"username"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "username"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListAllPermissions" -> <|
			"URL" -> StringTemplate["`host`/api/v1/permissions.listAll"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"updatedSince"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdatePermissions" -> <|
			"URL" -> StringTemplate["`host`/api/v1/permissions.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"permissions"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "permissions"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateRole" -> <|
			"URL" -> StringTemplate["`host`/api/v1/roles.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "scope", "description", "mandatory2fa"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateRole" -> <|
			"URL" -> StringTemplate["`host`/api/v1/roles.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roleId", "name", "scope", "description", "mandatory2fa"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roleId", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAssignRoleToUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/roles.addUserToRole"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roleId", "username", "roomId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "username"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersOfARole" -> <|
			"URL" -> StringTemplate["`host`/api/v1/roles.getUsersInRole"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"role", "roomId", "offset", "count"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "role"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/roles.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUpdatedRoles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/roles.sync"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"updatedSince"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "updatedSince"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteRole" -> <|
			"URL" -> StringTemplate["`host`/api/v1/roles.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roleId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roleId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveRoleFromUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/roles.removeUserFromRole"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roleId", "username", "scope"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roleId", "username"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersInPublicRoles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/roles.getUsersInPublicRoles"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupOnlineUsers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.online"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupIntegrations" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.getIntegrations"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count", "sort", "query", "fields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddAllUsersToGroup" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.addAll"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "activeUsersOnly"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddGroupLeader" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.addLeader"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddGroupModerator" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.addModerator"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddGroupOwner" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.addOwner"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawArchiveAGroup" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.archive"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCloseGroup" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.close"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupCounters" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.counters"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateGroup" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "readOnly", "members", "excludeSelf", "customFields", "extraData"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteGroup" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "roomName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupHistory" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.history"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "latest", "oldest", "inclusive", "unreads", "offset", "count"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawInviteUsersToGroup" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.invite"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveUserFromGroup" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.kick"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfUserGroups" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.listAll"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "query", "fields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroups" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListGroupMembers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.members"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "sort", "count", "offset", "status", "filter"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.messages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "fields", "sort", "offset", "count", "mentionIds", "starredIds", "pinned"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupModerators" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.moderators"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddGroupToList" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.open"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveGroupLeader" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.removeLeader"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveGroupModerator" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.removeModerator"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveGroupOwner" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.removeOwner"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRenameGroup" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.rename"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "name"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetGroupAnnouncement" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.setAnnouncement"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "announcement"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "announcement"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetsGroupCustomFields" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.setCustomFields"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "customFields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "customFields"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetGroupDescription" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.setDescription"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "description"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "description"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetGroupPurpose" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.setPurpose"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "purpose"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "purpose"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetGroupAsReadOnly" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.setReadOnly"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "readOnly"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "readOnly"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetGroupTopic" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.setTopic"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "topic"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "topic"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetGroupType" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.setType"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "type"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "type"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnarchiveGroup" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.unarchive"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupFiles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.files"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomName", "roomId", "offset", "count", "sort", "query", "fields", "typeGroup", "name"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetGroupAsEncrypted" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.setEncrypted"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"encrypted", "roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "encrypted", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawConvertAGroupToTeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.convertToTeam"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListGroupRoles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.roles"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLeaveGroup1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/groups.leave"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "members", "readOnly", "excludeSelf", "customFields", "extraData"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddAllUsersToAChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.addAll"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "activeUsersOnly"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddChannelLeader" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.addLeader"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddChannelModerator" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.addModerator"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddChannelOwner" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.addOwner"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawReadChannelMessagesAnonymously" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.anonymousread"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "offset", "count", "sort", "query", "fields"},
			"RequiredParameters" -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawArchiveChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.archive"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCloseChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.close"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelCounters" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.counters"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "roomName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelFiles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.files"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "fields", "query", "sort", "count", "offset", "typeGroup", "name"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelHistory" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.history"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "sort", "count", "offset", "latest", "oldest", "inclusive", "showThreadMessages", "unreads"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddUsersToChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.invite"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId", "userIds"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawJoinAChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.join"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "joinCode"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveUserFromChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.kick"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "roomId", "userId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLeaveChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.leave"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfJoinedChannels" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.list.joined"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "query", "fields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelList" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "query", "fields", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMembersOfAChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.members"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "status", "filter", "sort", "count", "offset"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.messages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "count", "sort", "offset", "mentionIds", "starredIds", "pinned"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelModerators" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.moderators"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListOnlineUsersInAChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.online"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddChannelToUserList" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.open"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveChannelLeader" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.removeLeader"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveChannelModerator" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.removeModerator"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveChannelOwner" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.removeOwner"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRenameAChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.rename"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "name"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelRoles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.roles"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName"},
			"RequiredParameters" -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelAnnouncement" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.setAnnouncement"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "announcement"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roomId", "announcement"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelCustomFields" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.setCustomFields"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "customFields"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roomId", "customFields"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetDefaultChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.setDefault"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "default"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "default"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelDescription" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.setDescription"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "description"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "description"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelJoinCode" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.setJoinCode"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "joinCode"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "joinCode"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelPurpose" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.setPurpose"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "purpose"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "purpose"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelReadonly" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.setReadOnly"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "readOnly"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "readOnly"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelTopic" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.setTopic"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "topic"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "topic"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelType" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.setType"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "type"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "type"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnarchiveAChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.unarchive"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAllUserMentionsInAChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.getAllUserMentionsByChannel"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelIntegrations" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.getIntegrations"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "sort", "fields", "query", "count"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawConvertChannelToTeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/channels.convertToTeam"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"channelId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "channelId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetRoomNotifications" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.saveNotification"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "notifications"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "notifications"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAllRoomAdmins" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.adminRooms"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"types", "filter", "count", "offset", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawClearRoomHistory" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.cleanHistory"],
			"HTTPSMethod" -> "GET",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "latest", "oldest", "inclusive", "excludePinned", "filesOnly", "users", "limit", "ignoreDiscussion", "ignoreThreads"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "latest", "oldest"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "fields"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomDiscussions" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.getDiscussions"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomName", "roomId", "query", "count", "fields", "offset", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRooms" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.get"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"updatedSince"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLeaveRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.leave"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.delete"],
			"HTTPSMethod" -> "GET",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawFavoriteunfavouriteARoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.favorite"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "favorite"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "favorite"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteRoomNameForTeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.autocomplete.availableForTeams"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"name"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompletePrivateChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.autocomplete.channelAndPrivate"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"selector"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "selector"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAdminOfRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.adminRooms.getRoom"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"rid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSaveRoomSettings" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.saveRoomSettings"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"rid", "roomName", "roomDescription", "roomAvatar", "featured", "roomTopic", "roomAnnouncement", "roomCustomFields", "roomType", "readOnly", "reactWhenReadOnly", "systemMessages", "default", "joinCode", "streamingOptions", "retentionEnabled", "retentionMaxAge", "retentionExcludePinned", "retentionFilesOnly", "retentionIgnoreThreads", "retentionOverrideGlobal", "encrypted", "favorite", "sidepanel"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawChangeRoomArchiveState" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.changeArchivationState"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"rid", "action"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "action"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawExportRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.export"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"rid", "type", "dateFrom", "dateTo", "format", "toUsers", "toEmails", "messages", "subject"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "type"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateDiscussion" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.createDiscussion"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"prid", "t_name", "users", "pmid", "reply"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "prid", "t_name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckIfRoomNameExists" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.nameExists"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMuteUserInRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.muteUser"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId", "roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnmuteUserInRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.unmuteUser"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId", "roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAdminAutocompleteRoomNameForPrivateAndPublicRooms" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.autocomplete.adminRooms"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"selector"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "selector"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomImages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.images"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "startingFromId", "offset", "count"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAuditRooms" -> <|
			"URL" -> StringTemplate["`host`/api/v1/audit/rooms.members"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "filter", "count", "offset", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUploadMediaFilesToARoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.media/`rid`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $multipartHeaders,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"BodyParameters" -> {"file"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "file"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomMembersOrderedByRole" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.membersOrderedByRole"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "roomName", "filter", "offset", "count", "sort", "status"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawHideRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.hide"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoomRoles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.roles"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"rid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckRoomMember" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.isMember"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteRoomNameWithPagination" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.autocomplete.channelAndPrivate.withPagination"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"count", "offset", "sort", "selector"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "selector"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckUploadedFile" -> <|
			"URL" -> StringTemplate["`host`/api/v1/rooms.mediaConfirm/`rid`/`fileId`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid", "fileId"},
			"BodyParameters" -> {"description", "emoji", "groupable", "msg", "tmid", "avatar", "alias", "customFields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "fileId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteUploadedFile" -> <|
			"URL" -> StringTemplate["`host`/api/v1/uploads.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"fileId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "fileId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawReplaceRoomAbacAttributes" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/rooms/`rid`/attributes"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"BodyParameters" -> "ParameterlessBody",
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteAllAbacAttributes" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/rooms/`rid`/attributes"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddAbacAttributeKeyToRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/rooms/`rid`/attributes/`key`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid", "key"},
			"BodyParameters" -> {"values"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "key"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetRoomAbacAttributeValues" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/rooms/`rid`/attributes/`key`"],
			"HTTPSMethod" -> "PUT",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid", "key"},
			"BodyParameters" -> {"values"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "key"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteRoomAbacAttributeKey" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/rooms/`rid`/attributes/`key`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid", "key"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "key"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListAbacAttributeDefinitions" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/attributes"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "key", "values"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateAbacAttributeDefinition" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/attributes"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"key", "values"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSyncUsersAbacAttributesFromLdap" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/users/sync"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"usernames", "ids", "emails", "ldapIds"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAbacAttributeDefinition" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/attributes/`_id`"],
			"HTTPSMethod" -> "PUT",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"BodyParameters" -> {"key", "values"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id", "key", "values"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAbacAttributeDefinitionById" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/attributes/`_id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteAbacAttributeDefinitionById" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/attributes/`_id`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckIfAbacAttributeIsInUse" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/attributes/`key`/is-in-use"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "key"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "key"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListRoomsWithAbacAttributes" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/rooms"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "filter", "filterType"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListAbacAuditEvents" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/audit"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "actor", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPdpHealthStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/abac/pdp/health"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAllSubscriptions" -> <|
			"URL" -> StringTemplate["`host`/api/v1/subscriptions.get"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"updatedSince"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSubscriptionRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/subscriptions.getOne"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMarkChannelAsRead" -> <|
			"URL" -> StringTemplate["`host`/api/v1/subscriptions.read"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "readThreads", "rid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMarkChannelAsUnread" -> <|
			"URL" -> StringTemplate["`host`/api/v1/subscriptions.unread"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "firstUnreadMessage"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateANewTeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "type", "members", "room", "sidepanel", "owner"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "type"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfAllTeams" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.listAll"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfTeams" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"sort", "offset", "count", "query"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTeamInfo" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"teamId", "teamName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateATeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"teamId", "data"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "teamId", "data"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddMembersToTheTeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.addMembers"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"teamId", "members"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "teamId", "members"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListTeamMembers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.members"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"teamName", "teamId", "name", "username", "status"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateTeamMemberInfo" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.updateMember"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"teamId", "member"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "teamId", "member"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLeaveATeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.leave"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"teamId", "rooms"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "teamId", "rooms"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveMemberFromTeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.removeMember"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"teamId", "userId", "rooms"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "teamId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteATeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"teamName", "teamId", "roomsToRemove"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteTeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.autocomplete"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"name"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawConvertTeamToChannel" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.convertToChannel"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"teamId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "teamId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddRoomsToATeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.addRooms"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"teamId", "rooms"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "teamId", "rooms"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveRoomFromTheTeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.removeRoom"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"teamName", "teamId", "roomId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateRoomInATeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.updateRoom"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "isDefault"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "isDefault"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListRoomsOfATeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.listRooms"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"teamId", "teamName", "type", "count", "offset"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListUserRoomsOfATeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.listRoomsOfUser"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"teamName", "teamId", "userId", "offset", "count"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListRoomsAndDiscussionsOfATeam" -> <|
			"URL" -> StringTemplate["`host`/api/v1/teams.listChildren"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"teamName", "teamId", "offset", "count", "sort", "filter", "type", "roomId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDirectory1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/directory"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"text", "type", "workspace", "query", "offset", "count", "sort", "fields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "query"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawFindOrCreateInvite" -> <|
			"URL" -> StringTemplate["`host`/api/v1/findOrCreateInvite"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"rid", "days", "maxUses"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "days", "maxUses"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListInvites" -> <|
			"URL" -> StringTemplate["`host`/api/v1/listInvites"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteInviteById" -> <|
			"URL" -> StringTemplate["`host`/api/v1/removeInvite/`_id`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUseInviteToken" -> <|
			"URL" -> StringTemplate["`host`/api/v1/useInviteToken"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"token"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteChatMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "msgId", "asUser"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "msgId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawReactToMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.react"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"messageId", "emoji", "reaction", "shouldReact"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "messageId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "msgId", "text", "previewUrls", "customFields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "msgId", "text"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawReportMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.reportMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"messageId", "description"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "messageId", "description"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawFollowMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.followMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"mid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "mid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnfollowMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.unfollowMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"mid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "mid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getMessage"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"msgId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "msgId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDeletedMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getDeletedMessages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "since", "roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "since", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDiscussionsOfARoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getDiscussions"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count", "sort", "text"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMentionedMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getMentionedMessages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMessageReadReceipts" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getMessageReadReceipts"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "messageId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "messageId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPinnedMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getPinnedMessages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetStarredMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getStarredMessages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetThreadMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getThreadMessages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "query", "fields", "tmid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "tmid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawIgnoreUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.ignoreUser"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"rid", "userId", "ignore"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "ignore"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawPinMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.pinMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"messageId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "messageId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawPostMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.postMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"alias", "avatar", "emoji", "roomId", "text", "parseUrls", "attachments", "tmid", "customFields", "channel"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnpinAMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.unPinMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"messageId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "messageId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.search"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"count", "offset", "roomId", "searchText"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "searchText"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.sendMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"message", "previewUrls"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "message"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawStarMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.starMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"messageId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "messageId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnstarMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.unStarMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"messageId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "messageId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSyncThreadList" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.syncThreadsList"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"fields", "query", "sort", "rid", "updatedSince"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "updatedSince"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSyncThreadMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.syncThreadMessages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "query", "fields", "updatedSince", "tmid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "updatedSince", "tmid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSyncMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.syncMessages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count", "sort", "lastUpdate", "next", "previous", "type"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListThreads" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getThreadsList"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "query", "fields", "rid", "type", "text"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUrlPreview" -> <|
			"URL" -> StringTemplate["`host`/api/v1/chat.getURLPreview"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "url"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "url"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCloseDm1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.close"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDmCounters1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.counters"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateDm1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"username", "excludeSelf", "usernames"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteDm1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "username"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDmFiles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.files"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "query", "fields", "typeGroup", "name", "roomId", "username"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDmHistory1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.history"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count", "sort", "latest", "oldest", "inclusive", "showThreadMessages", "unreads"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListAllDms" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.list.everyone"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "query", "fields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListDms1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListDmMembers1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.members"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "query", "roomId", "username"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListDmMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.messages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "fields", "query", "roomId", "username", "mentionIds", "starredIds", "pinned", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMessageOthers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.messages.others"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count", "sort", "query", "fields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawOpenDm1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.open"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetDmTopic1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dm.setTopic"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "topic"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "topic"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSupportedLanguages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/autotranslate.getSupportedLanguages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"targetLanguage"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "targetLanguage"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSaveAutoTranslateSettings" -> <|
			"URL" -> StringTemplate["`host`/api/v1/autotranslate.saveSettings"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "field", "value", "defaultLanguage"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "field", "value"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTranslateMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/autotranslate.translateMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"messageId", "targetLanguage"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "messageId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterNewAgentOrManager" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/users/`type`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "type"},
			"BodyParameters" -> {"username"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "type", "username"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfAgentsOrManagers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/users/`type`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "type"},
			"QueryParameters" -> {"offset", "count", "sort", "onlyAvailable", "showIdleAgents", "excludeId", "text"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "type"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentOrManagerInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/users/`type`/`_id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "type", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "type", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveAgentOrManager" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/users/`type`/`_id`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "type", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "type", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/agent.info/`rid`/`token`"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host", "rid", "token"},
			"RequiredParameters" -> {"host", "rid", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetNextAgentInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/agent.next/`token`"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host", "token"},
			"RequiredParameters" -> {"host", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAgentInfo" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/agents.saveInfo"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"agentId", "agentData", "agentDepartments"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "agentId", "agentData", "agentDepartments"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAgentStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/agent.status"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"agentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfMonitors" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/monitors"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "text"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAMonitor" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/monitors/`username`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "username"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "username"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteAMonitor" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/monitors.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"username"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "username"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateAMonitor" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/monitors.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"username"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "username"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterLivechatVisitor" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitor"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"visitor"},
			"RequiredParameters" -> {"host", "visitor"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVisitorInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitor/`token`"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host", "token"},
			"RequiredParameters" -> {"host", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteVisitor" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitor/`token`"],
			"HTTPSMethod" -> "DELETE",
			"PathParameters" -> {"host", "token"},
			"RequiredParameters" -> {"host", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOpenConversationOfAVisitor" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitor/`token`/room"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "token"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchVisitorsByTerm" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitors.search"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"term", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "term"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPagesVisitedByLivechatVisitor" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitors.pagesVisited/`roomId`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatVisitorChatHistory" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitors.chatHistory/room/`roomId`/visitor/`visitorId`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "roomId", "visitorId"},
			"QueryParameters" -> {"offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "visitorId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchVisitorChat" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitors.searchChats/room/`roomId`/visitor/`visitorId`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "roomId", "visitorId"},
			"QueryParameters" -> {"offset", "count", "sort", "searchText", "closedChatsOnly", "servedChatsOnly", "source"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "visitorId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteVisitors" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitors.autocomplete"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"selector"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "selector"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetVisitorsStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitors.status"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"token", "status"},
			"RequiredParameters" -> {"host", "token", "status"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVisitorInformationById1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitors.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"visitorId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "visitorId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterOrUpdateOmnichannelContact" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contact"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"token", "name", "email", "phone", "contactManager"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "token", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchContacts" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contact.search"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"email", "phone", "custom"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelsGroupedByContactName" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts.channels"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"contactId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "contactId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetContactHistory" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts.history"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "contactId", "source"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "contactId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateOmnichannelContact" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> "ParameterlessBody",
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterOmnichannelContacts" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "phones", "emails", "customFields", "contactManager"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "phones", "emails"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOmnichannelContact" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts.get"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"contactId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "contactId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchOmnichannelContacts" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts.search"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "searchText", "unknown"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckContactsExistence" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts.checkExistence"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"contactId", "email", "phone"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResolveContactConflicts" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts.conflicts"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"contactId", "name", "customFields", "contactManager", "wipeConflicts"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "contactId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawBlockOmnichannelContact" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts.block"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"visitor"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "visitor"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnblockOmnichannelContact" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/contacts.unblock"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"visitor"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "visitor"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfLivechatRooms" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/rooms"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"agents", "departmentId", "open", "createdAt", "closedAt", "tags", "customFields", "roomName", "onhold", "queued", "units", "offset", "count", "sort", "fields", "query"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOrCreateLivechatRooms" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"token", "rid", "agentId"},
			"RequiredParameters" -> {"host", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCloseLivechatRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room.close"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"rid", "token"},
			"RequiredParameters" -> {"host", "rid", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawJoinLivechatRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room.join"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateLivechatRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room.saveInfo"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"guestData", "roomData"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawForwardLivechatRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room.forward"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "userId", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDepartmentTransferHistory" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/transfer.history/`rid`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"QueryParameters" -> {"count", "offset", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSurveyLivechatRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room.survey"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"rid", "token", "data"},
			"RequiredParameters" -> {"host", "rid", "token", "data"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawPutLivechatRoomOnHold" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room.onHold"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUploadFilesToRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/upload/`rid`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $multipartHeaders,
			"HeadersParameters" -> {"visitorToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"BodyParameters" -> {"file", "description"},
			"RequiredParameters" -> {"host", "visitorToken", "rid", "file"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetLivechatRoomPriority" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room/`rid`/priority"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"BodyParameters" -> {"priorityId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "priorityId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveLivechatRoomPriority" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room/`rid`/priority"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCloseLivechatRoomByUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room.closeByUser"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"rid", "comment", "forceClose", "tags", "generateTranscriptPdf", "transcriptEmail"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveClosedOmnichannelRooms" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/rooms.removeAllClosedRooms"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveAClosedOmnichannelRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/rooms.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResumeRoomOnHold" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/room.resumeOnHold"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawViewOmnichannelRoomSources" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/rooms/filters"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawVisitorTransferRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/visitor/department.transfer"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"token", "rid", "department"},
			"RequiredParameters" -> {"host", "token", "rid", "department"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfDepartments" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"text", "enabled", "showArchived", "onlyMyDepartments", "excludeDepartmentId", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterNewDepartment" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"department", "agents", "departmentUnit"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "department"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDepartmentInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department/`_id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"QueryParameters" -> {"includeAgents"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateDepartment" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department/`_id`"],
			"HTTPSMethod" -> "PUT",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"BodyParameters" -> {"department", "agents", "departmentUnit"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id", "department"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveDepartment" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department/`_id`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteDepartment" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department.autocomplete"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"selector", "onlyMyDepartments", "showArchived"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "selector"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentsOfDepartment" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department/`_id`/agents"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"QueryParameters" -> {"offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAgentsOfDepartment" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department/`_id`/agents"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"BodyParameters" -> {"upsert", "remove"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id", "upsert", "remove"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDepartmentsById" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department.listByIds"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"ids"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "ids"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetNumberOfChats" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/departments/amount-of-chats"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "start", "end", "answered", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAverageServiceTime" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/departments/average-service-time"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "offset", "count", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAverageChatDuration" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/departments/average-chat-duration-time"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "offset", "count", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTotalServiceTime" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/departments/total-service-time"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "offset", "count", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAverageWaitingTime" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/departments/average-waiting-time"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "offset", "count", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTotalTransferredChats" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/departments/total-transferred-chats"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "offset", "count", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTotalAbandonedChats" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/departments/total-abandoned-chats"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "offset", "count", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPercentageOfAbandonedChats" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/departments/percentage-abandoned-chats"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "offset", "count", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetArchivedDepartments" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/departments/archived"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawArchiveADepartment" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department/archive/`_id`"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnarchiveADepartment" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department/unarchive/`_id`"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckDepartmentCreation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/department/isDepartmentCreationAvailable"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendCustomFieldValue" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/custom.field"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"token", "key", "value", "overwrite"},
			"RequiredParameters" -> {"host", "token", "key", "value", "overwrite"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendArrayOfCustomFieldValues" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/custom.fields"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"token", "customFields"},
			"RequiredParameters" -> {"host", "token", "customFields"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatCustomFields" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/custom-fields"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "text"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCustomFieldInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/custom-fields/`_id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteOmnichannelCustomField" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/custom-fields.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"customFieldId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "customFieldId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateOmnichannelCustomField" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/custom-fields.save"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"customFieldId", "customFieldData"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "customFieldData"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetBusinessHours" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/business-hours"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"name", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDefaultBusinessHour" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/business-hour"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveBusinessHour" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/business-hours.remove"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"_id", "type"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id", "type"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateABusinessHour" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/business-hours.save"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "timezoneName", "daysOpen", "departmentsToApplyBusinessHour", "active", "type", "workHours", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "timezoneName", "daysOpen", "departmentsToApplyBusinessHour", "active", "type", "workHours"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfPriorities" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/priorities"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "text"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAPriority" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/priorities/`priorityId`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "priorityId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "priorityId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdatePriority" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/priorities/`priorityId`"],
			"HTTPSMethod" -> "PUT",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "priorityId"},
			"BodyParameters" -> {"name"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "priorityId", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResetPriorities" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/priorities.reset"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckPriorityReset" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/priorities.reset"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfTags" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/tags"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "text", "department", "viewAll", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetATag" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/tags/`tagId`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "tagId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "tagId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteATag" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/tags.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateATag" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/tags.save"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"tagData", "tagDepartments", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "tagData"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateUnit" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/units"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"unitData", "unitMonitors", "unitDepartments"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "unitData", "unitMonitors", "unitDepartments"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfUnits" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/units"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"text", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateUnit" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/units/`id`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "id"},
			"BodyParameters" -> {"unitData", "unitMonitors", "unitDepartments"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "id", "unitData", "unitMonitors", "unitDepartments"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteAUnit" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/units/`id`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfUnitMonitors" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/units/`unitId`/monitors"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "unitId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "unitId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAvailableDepartmentsByUnitId1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/units/`unitId`/departments/available"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "unitId"},
			"QueryParameters" -> {"offset", "count", "text", "onlyMyDepartments"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "unitId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDepartmentsByUnitId1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/units/`unitId`/departments"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "unitId"},
			"QueryParameters" -> {"offset", "count"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "unitId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAUnit1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/units/`id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfSlaPolicies" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/sla"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"text", "count", "sort", "offset"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateSlaPolicy" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/sla"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "description", "dueTimeInMinutes"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "description", "dueTimeInMinutes"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAnSla" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/sla/`slaId`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "slaId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "slaId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAnSla" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/sla/`slaId`"],
			"HTTPSMethod" -> "PUT",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "slaId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "slaId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteAnSla" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/sla/`slaId`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "slaId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "slaId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateOrUpdateOrDeleteACannedResponse" -> <|
			"URL" -> StringTemplate["`host`/api/v1/canned-responses"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"shortcut", "text", "scope", "tags", "departmentId", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "shortcut", "text", "scope"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListAllCannedResponses" -> <|
			"URL" -> StringTemplate["`host`/api/v1/canned-responses"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"shortcut", "text", "scope", "tags", "departmentId", "offset", "count", "sort", "fields", "createdBy"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserCannedResponses" -> <|
			"URL" -> StringTemplate["`host`/api/v1/canned-responses.get"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetACannedResponse" -> <|
			"URL" -> StringTemplate["`host`/api/v1/canned-responses/`_id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteACannedResponse" -> <|
			"URL" -> StringTemplate["`host`/api/v1/canned-responses/`_id`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRequestLivechatTranscript" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/transcript"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"rid", "token", "email"},
			"RequiredParameters" -> {"host", "rid", "token", "email"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendLivechatTranscript" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/transcript/`rid`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"BodyParameters" -> {"email", "subject"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid", "email", "subject"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteLivechatTranscript" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/transcript/`rid`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRequestPdfTranscript" -> <|
			"URL" -> StringTemplate["`host`/api/vi/omnichannel/`rid`/request-transcript"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentAnalyticsOverview" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/agent-overview"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"name", "from", "to", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "from", "to"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAnalyticsOverview" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/overview"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"name", "from", "to", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "from", "to"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentDepartments" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/agents/`agentId`/departments"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "agentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "agentId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentAverageServiceTime" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/agents/average-service-time"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "count", "offset"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentTotalServiceTime" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/agents/total-service-time"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "offset", "count"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetHistoryOfAgentsAvailableForService" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/agents/available-for-service-history"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "fullReport", "offset", "count"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationMetrics" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/conversation-totalizers"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentServiceTimeMetrics" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/agents-productivity-totalizers"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatMetrics" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/chats-totalizers"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatMetricsByTime" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/productivity-totalizers"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatsStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/charts/chats"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatStatusOfAgents" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/charts/chats-per-agent"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetStatusOfAgents" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/charts/agents-status"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatsStatusForDepartments" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/charts/chats-per-department"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatTimes" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/charts/timings"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAnalyticsChartData" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/livechat/analytics/dashboards/charts-data"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "chartName", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end", "chartName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationsByStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/conversations-by-status"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationsByDepartments" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/conversations-by-department"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationsByTags" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/conversations-by-tags"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationByAgents" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/conversations-by-agent"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationsBySource" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/analytics/dashboards/conversations-by-source"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetInquiriesList" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/inquiries.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"department", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTakeInquiry" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/inquiries.take"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"inquiryId", "userId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "inquiryId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetInquiryByRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/inquiries.getOne"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetSlaPolicyToInquiry" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/inquiry.setSLA"],
			"HTTPSMethod" -> "PUT",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "sla"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId", "sla"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListQueuedUserInquiries" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/inquiries.queuedForUser"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"department", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMoveChatToInquiry" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/inquiries.returnAsInquiry"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "departmentId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUpOmnichannelWebhook" -> <|
			"URL" -> StringTemplate["`host`/api/v1/omnichannel/integrations"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"LivechatWebhookUrl", "LivechatSecretToken", "LivechatHttpTimeout", "LivechatWebhookOnStart", "LivechatWebhookOnClose", "LivechatWebhookOnChatTaken", "LivechatWebhookOnChatQueued", "LivechatWebhookOnForward", "LivechatWebhookOnOfflineMsg", "LivechatWebhookOnVisitorMessage", "LivechatWebhookOnAgentMessage"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTestTheWebhookIntegration" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/webhook.test"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatConfigurations" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/config"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"token", "department"},
			"RequiredParameters" -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatIntegrations" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/integrations.settings"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatQueue" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/queue"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"departmentId", "agentId", "includeOfflineAgents", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLivechatSmsIncomingTwilio" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/sms-incoming/`service`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host", "service"},
			"BodyParameters" -> {"From", "To", "Body", "ToCountry", "ToState", "ToCity", "ToZip", "FromCountry", "FromState", "FromCity", "FromZip"},
			"RequiredParameters" -> {"host", "service"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatRoutingConfiguration" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/config/routing"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatAppearance" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/appearance"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetLivechatAppearance" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/appearance"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> "ParameterlessBody",
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfLivechatTriggers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/triggers"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatTrigger" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/triggers/`_id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateLivechatTriggers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/triggers"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"_id", "name", "description", "enabled", "runOnce", "conditions", "actions"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "description", "enabled", "runOnce", "conditions", "actions"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteATrigger" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/triggers/`_id`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTestTriggerWithExternalService" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/triggers/external-service/test"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"webhookUrl", "timeout", "fallbackMessage"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "webhookUrl", "timeout", "fallbackMessage"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendNewLivechatMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/message"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"token", "rid", "msg", "_id", "agent"},
			"RequiredParameters" -> {"host", "token", "rid", "msg"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendArrayOfMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/messages"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"visitor", "messages"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "visitor", "messages"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateLivechatMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/message/`_id`"],
			"HTTPSMethod" -> "PUT",
			"Headers" -> $headers,
			"PathParameters" -> {"host", "_id"},
			"BodyParameters" -> {"token", "rid", "msg"},
			"RequiredParameters" -> {"host", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetALivechatMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/message/`_id`"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host", "_id"},
			"QueryParameters" -> {"token", "rid"},
			"RequiredParameters" -> {"host", "_id", "token", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteLivechatMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/message/`_id`"],
			"HTTPSMethod" -> "DELETE",
			"Headers" -> $headers,
			"PathParameters" -> {"host", "_id"},
			"BodyParameters" -> {"token", "rid"},
			"RequiredParameters" -> {"host", "_id", "token", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatMessageHistory" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/messages.history/`rid`"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host", "rid"},
			"QueryParameters" -> {"token", "ls", "end", "limit"},
			"RequiredParameters" -> {"host", "rid", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendOfflineLivechatMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/offline.message"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "email", "message", "department", "host"},
			"RequiredParameters" -> {"host", "name", "email", "message", "department"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/messages/`rid`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "rid"},
			"QueryParameters" -> {"offset", "count", "sort", "searchTerm"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendVisitorNavigationHistory" -> <|
			"URL" -> StringTemplate["`host`/api/v1/livechat/page.visited"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"token", "rid", "pageInfo"},
			"RequiredParameters" -> {"host", "token", "pageInfo"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateIntegration" -> <|
			"URL" -> StringTemplate["`host`/api/v1/integrations.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"type", "username", "channel", "scriptEnabled", "script", "name", "enabled", "alias", "avatar", "emoji", "event", "urls", "triggerWords", "token", "skipTranspile"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "type", "username", "channel", "scriptEnabled", "name", "enabled", "event", "urls"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetIntegration" -> <|
			"URL" -> StringTemplate["`host`/api/v1/integrations.get"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"integrationId", "createdBy"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "integrationId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetIntegrationHistory" -> <|
			"URL" -> StringTemplate["`host`/api/v1/integrations.history"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"id", "offset", "count", "sort", "query", "fields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfIntegrations" -> <|
			"URL" -> StringTemplate["`host`/api/v1/integrations.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "query", "fields", "name", "type", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateIntegration" -> <|
			"URL" -> StringTemplate["`host`/api/v1/integrations.update"],
			"HTTPSMethod" -> "PUT",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"type", "name", "enabled", "username", "scriptEnabled", "channel", "integrationId", "urls", "event", "triggerWords", "alias", "avatar", "emoji", "token", "script", "targetChannel", "target_url", "skipTranspile"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "type", "name", "enabled", "username", "scriptEnabled", "channel", "integrationId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveIntegration1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/integrations.remove"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"integrationId", "type"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "integrationId", "type"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetWebdavAccounts" -> <|
			"URL" -> StringTemplate["`host`/api/v1/webdav.getMyAccounts"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveWebdavAccount" -> <|
			"URL" -> StringTemplate["`host`/api/v1/webdav.removeWebdavAccount"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"accountId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "accountId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateOauthApp" -> <|
			"URL" -> StringTemplate["`host`/api/v1/oauth-apps.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "redirectUri", "active"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "redirectUri", "active"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateOauthApp" -> <|
			"URL" -> StringTemplate["`host`/api/v1/oauth-apps.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "redirectUri", "active", "appId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "redirectUri", "active", "appId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfOauthApps" -> <|
			"URL" -> StringTemplate["`host`/api/v1/oauth-apps.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOauthApp" -> <|
			"URL" -> StringTemplate["`host`/api/v1/oauth-apps.get"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"clientId", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteOauthApp" -> <|
			"URL" -> StringTemplate["`host`/api/v1/oauth-apps.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"appId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "appId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetBannerById" -> <|
			"URL" -> StringTemplate["`host`/api/v1/banners/`id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "id"},
			"QueryParameters" -> {"platform"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "id", "platform"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetBanners" -> <|
			"URL" -> StringTemplate["`host`/api/v1/banners"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"platform"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "platform"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDismissABanner" -> <|
			"URL" -> StringTemplate["`host`/api/v1/banners.dismiss"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"bannerId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "bannerId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPushNotification" -> <|
			"URL" -> StringTemplate["`host`/api/v1/push.get"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeletePushToken" -> <|
			"URL" -> StringTemplate["`host`/api/v1/push.token"],
			"HTTPSMethod" -> "DELETE",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"token"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreatePushToken" -> <|
			"URL" -> StringTemplate["`host`/api/v1/push.token"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"type", "value", "appName"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "type", "value", "appName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTestPushNotifications" -> <|
			"URL" -> StringTemplate["`host`/api/v1/push.test"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPushInfo" -> <|
			"URL" -> StringTemplate["`host`/api/v1/push.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetAsset" -> <|
			"URL" -> StringTemplate["`host`/api/v1/assets.setAsset"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $multipartHeaders,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"asset", "assetName", "refreshAllClients"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "asset", "assetName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnsetAsset" -> <|
			"URL" -> StringTemplate["`host`/api/v1/assets.unsetAsset"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"assetName", "refreshAllClients"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "assetName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListAllCustomEmojis" -> <|
			"URL" -> StringTemplate["`host`/api/v1/emoji-custom.all"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"name", "offset", "count"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateAnEmoji" -> <|
			"URL" -> StringTemplate["`host`/api/v1/emoji-custom.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $multipartHeaders,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"emoji", "name", "aliases"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "emoji", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteACustomEmoji" -> <|
			"URL" -> StringTemplate["`host`/api/v1/emoji-custom.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"emojiId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "emojiId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUpdatedListOfCustomEmojis" -> <|
			"URL" -> StringTemplate["`host`/api/v1/emoji-custom.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"updatedSince", "_updatedAt", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateACustomEmoji" -> <|
			"URL" -> StringTemplate["`host`/api/v1/emoji-custom.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $multipartHeaders,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"emoji", "name", "_id", "aliases"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "name", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListCustomSounds" -> <|
			"URL" -> StringTemplate["`host`/api/v1/custom-sounds.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "query", "name", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCustomSound" -> <|
			"URL" -> StringTemplate["`host`/api/v1/custom-sounds.getOne"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListCustomUserStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/custom-user-status.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"name", "_id", "count", "offset", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateCustomStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/custom-user-status.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name", "statusType"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "statusType"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateCustomStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/custom-user-status.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"_id", "name", "statusType"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id", "name", "statusType"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteCustomUserStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/custom-user-status.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"customUserStatusId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "customUserStatusId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetStatisticsList" -> <|
			"URL" -> StringTemplate["`host`/api/v1/statistics.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"count", "offset", "sort", "fields", "query"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLastStatistics" -> <|
			"URL" -> StringTemplate["`host`/api/v1/statistics"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"refresh"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetNewUsers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/engagement-dashboard/users/new-users"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetActiveUsers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/engagement-dashboard/users/active-users"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserByTimeOfTheDay" -> <|
			"URL" -> StringTemplate["`host`/api/v1/engagement-dashboard/users/users-by-time-of-the-day-in-a-week"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetHourlyDataWhenChatIsBusier" -> <|
			"URL" -> StringTemplate["`host`/api/v1/engagement-dashboard/users/chat-busier/hourly-data"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetWeeklyDataWhenChatIsBusier" -> <|
			"URL" -> StringTemplate["`host`/api/v1/engagement-dashboard/users/chat-busier/weekly-data"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMessagesSent" -> <|
			"URL" -> StringTemplate["`host`/api/v1/engagement-dashboard/messages/messages-sent"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOriginOfMessageSent" -> <|
			"URL" -> StringTemplate["`host`/api/v1/engagement-dashboard/messages/origin"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTheMostPopularChannels" -> <|
			"URL" -> StringTemplate["`host`/api/v1/engagement-dashboard/messages/top-five-popular-channels"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelsEngagement" -> <|
			"URL" -> StringTemplate["`host`/api/v1/engagement-dashboard/channels/list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"start", "end", "count", "offset"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "start", "end"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPublicSettings" -> <|
			"URL" -> StringTemplate["`host`/api/v1/settings.public"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "fields", "_id", "sort"},
			"RequiredParameters" -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOauthSettings" -> <|
			"URL" -> StringTemplate["`host`/api/v1/settings.oauth"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPrivateSettings" -> <|
			"URL" -> StringTemplate["`host`/api/v1/settings"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"includeDefaults", "offset", "count"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddCustomOauth" -> <|
			"URL" -> StringTemplate["`host`/api/v1/settings.addCustomOAuth"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"name"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateSetting" -> <|
			"URL" -> StringTemplate["`host`/api/v1/settings/`_id`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"BodyParameters" -> {"value", "color", "editor", "execute"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "_id", "value"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSetting" -> <|
			"URL" -> StringTemplate["`host`/api/v1/settings/`_id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOauthServiceConfiguration" -> <|
			"URL" -> StringTemplate["`host`/api/v1/service.configurations"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawManualCloudRegister" -> <|
			"URL" -> StringTemplate["`host`/api/v1/cloud.manualRegister"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"cloudBlob"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "cloudBlob"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResolveDnsTextRecords" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dns.resolve.txt"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"url"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "url"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResolveDnsUrlRecords" -> <|
			"URL" -> StringTemplate["`host`/api/v1/dns.resolve.srv"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"url"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "url"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetE2eKeys" -> <|
			"URL" -> StringTemplate["`host`/api/v1/e2e.fetchMyKeys"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersOfRoomWithoutE2eKey" -> <|
			"URL" -> StringTemplate["`host`/api/v1/e2e.getUsersOfRoomWithoutKey"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"rid"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetRoomE2eKey" -> <|
			"URL" -> StringTemplate["`host`/api/v1/e2e.setRoomKeyID"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"rid", "keyID"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "rid", "keyID"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUserKey" -> <|
			"URL" -> StringTemplate["`host`/api/v1/e2e.setUserPublicAndPrivateKeys"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"public_key", "private_key"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "public_key", "private_key"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateUserE2eKeyInRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/e2e.updateGroupKey"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"uid", "rid", "key"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "uid", "rid", "key"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUploadImportFile" -> <|
			"URL" -> StringTemplate["`host`/api/v1/uploadImportFile"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"binaryContent", "importerKey", "fileName", "contentType"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "binaryContent", "importerKey", "fileName", "contentType"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDownloadPublicImportFile" -> <|
			"URL" -> StringTemplate["`host`/api/v1/downloadPublicImportFile"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"fileUrl", "importerKey"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "fileUrl", "importerKey"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawStartImport" -> <|
			"URL" -> StringTemplate["`host`/api/v1/startImport"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"input"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "input"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetImportFileData" -> <|
			"URL" -> StringTemplate["`host`/api/v1/getImportFileData"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetImportProgress" -> <|
			"URL" -> StringTemplate["`host`/api/v1/getImportProgress"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLatestImportOperations" -> <|
			"URL" -> StringTemplate["`host`/api/v1/getLatestImportOperations"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDownloadPendingFiles" -> <|
			"URL" -> StringTemplate["`host`/api/v1/downloadPendingFiles"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDownloadPendingAvatars" -> <|
			"URL" -> StringTemplate["`host`/api/v1/downloadPendingAvatars"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCurrentImportOperations1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/getCurrentImportOperation"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfImports" -> <|
			"URL" -> StringTemplate["`host`/api/v1/importers.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateNewImportOperation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/import.new"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddUsers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/import.addUsers"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"users"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRunImportOperation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/import.run"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetImportOperationStatus" -> <|
			"URL" -> StringTemplate["`host`/api/v1/import.status"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAbortImportOperation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/import.clear"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetInstances" -> <|
			"URL" -> StringTemplate["`host`/api/v1/instances.get"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddFederatedServer" -> <|
			"URL" -> StringTemplate["`host`/api/v1/federation/addServerByUser"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"serverName"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "serverName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetFederatedServers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/federation/listServersByUser"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveFederatedServer" -> <|
			"URL" -> StringTemplate["`host`/api/v1/federation/removeServerByUser"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"serverName"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "serverName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchPublicRooms" -> <|
			"URL" -> StringTemplate["`host`/api/v1/federation/searchPublicRooms"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"serverName", "roomName", "pageToken", "count"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "serverName"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawJoinExternalPublicRoom" -> <|
			"URL" -> StringTemplate["`host`/api/v1/federation/joinExternalPublicRoom"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"externalRoomId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "externalRoomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCurrentMediaCallState" -> <|
			"URL" -> StringTemplate["`host`/media-calls.state"],
			"HTTPSMethod" -> "POST",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVideoConferenceCapabilities" -> <|
			"URL" -> StringTemplate["`host`/api/v1/video-conference.capabilities"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfVideoConferences" -> <|
			"URL" -> StringTemplate["`host`/api/v1/video-conference.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"roomId", "offset", "count"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVideoConferenceDetails" -> <|
			"URL" -> StringTemplate["`host`/api/v1/video-conference.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"callId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "callId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVideoConferenceProviders" -> <|
			"URL" -> StringTemplate["`host`/api/v1/video-conference.providers"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawStartVideoConference" -> <|
			"URL" -> StringTemplate["`host`/api/v1/video-conference.start"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId", "title", "allowRinging"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawJoinAVideoConference" -> <|
			"URL" -> StringTemplate["`host`/api/v1/video-conference.join"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"callId", "state"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "callId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCancelVideoConference" -> <|
			"URL" -> StringTemplate["`host`/api/v1/video-conference.cancel"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"callId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "callId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetReportedMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.reportsByUsers"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"oldest", "latest", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersReportedMessages" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.user.reportedMessages"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "userId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetReportsOfAMessage" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.reports"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "count", "sort", "msgId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "msgId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetReportInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.reportInfo"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"reportId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "reportId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDismissReports" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.dismissReports"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId", "msgId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteReportedMessagesOfAUser" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.user.deleteReportedMessages"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDismissUserReports" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.dismissUserReports"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"userId", "reason"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserReportsByUserId" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.user.reportsByUserId"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"userId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetReportedUsers" -> <|
			"URL" -> StringTemplate["`host`/api/v1/moderation.userReports"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCurrentUserSessions" -> <|
			"URL" -> StringTemplate["`host`/api/v1/sessions/list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"filter", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAllCurrentUserSessions" -> <|
			"URL" -> StringTemplate["`host`/api/v1/sessions/list.all"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"filter", "offset", "count", "sort"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAllCurrentUserSessions1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/sessions/info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"sessionId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "sessionId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSessionInformation" -> <|
			"URL" -> StringTemplate["`host`/api/v1/sessions/info.admin"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"sessionId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "sessionId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogoutCurrentUserSession" -> <|
			"URL" -> StringTemplate["`host`/api/v1/sessions/logout.me"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"sessionId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "sessionId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogoutSession" -> <|
			"URL" -> StringTemplate["`host`/api/v1/sessions/logout"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken", "twoFactorCode", "twoFactorMethod"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"sessionId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "sessionId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPasswordPolicy" -> <|
			"URL" -> StringTemplate["`host`/api/v1/pw.getPolicy"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawShieldSvg" -> <|
			"URL" -> StringTemplate["`host`/api/v1/shield.svg"],
			"HTTPSMethod" -> "GET",
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"type", "icon", "channel", "name"},
			"RequiredParameters" -> {"host", "channel", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSpotlight" -> <|
			"URL" -> StringTemplate["`host`/api/v1/spotlight"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"query"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "query"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawExecuteAMeteorMethodCall" -> <|
			"URL" -> StringTemplate["`host`/api/v1/method.call/`method`"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "method"},
			"BodyParameters" -> {"message"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "method", "message"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListEmailInbox" -> <|
			"URL" -> StringTemplate["`host`/api/v1/email-inbox.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"offset", "sort", "count", "query", "fields"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetEmailInbox" -> <|
			"URL" -> StringTemplate["`host`/api/v1/email-inbox"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"_id", "name", "email", "active", "description", "senderInfo", "department", "smtp", "imap"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "name", "email", "active", "smtp", "imap"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawEmailInboxById" -> <|
			"URL" -> StringTemplate["`host`/api/v1/email-inbox/`_id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteEmailInboxById" -> <|
			"URL" -> StringTemplate["`host`/api/v1/email-inbox/`_id`"],
			"HTTPSMethod" -> "DELETE",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchEmailInbox" -> <|
			"URL" -> StringTemplate["`host`/api/v1/email-inbox.search"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"email"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "email"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendTestEmailToEmailInbox" -> <|
			"URL" -> StringTemplate["`host`/api/v1/email-inbox.send-test/`_id`"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "_id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckSmtp" -> <|
			"URL" -> StringTemplate["`host`/api/v1/smtp.check"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfCalendarEvents" -> <|
			"URL" -> StringTemplate["`host`/api/v1/calendar-events.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"date"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "date"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCalendarEventInfo" -> <|
			"URL" -> StringTemplate["`host`/api/v1/calendar-events.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"id"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "id"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateCalendarEvent" -> <|
			"URL" -> StringTemplate["`host`/api/v1/calendar-events.create"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"startTime", "endTime", "subject", "description", "reminderMinutesBeforeStart", "busy", "externalId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "startTime", "subject", "description"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateCalendarEvent" -> <|
			"URL" -> StringTemplate["`host`/api/v1/calendar-events.update"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"eventId", "startTime", "endTime", "subject", "description", "reminderMinutesBeforeStart", "busy"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "eventId", "startTime", "subject", "description"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteCalendarEvent" -> <|
			"URL" -> StringTemplate["`host`/api/v1/calendar-events.delete"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"eventId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "eventId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawImportCalendarEvent" -> <|
			"URL" -> StringTemplate["`host`/api/v1/calendar-events.import"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"externalId", "startTime", "endTime", "subject", "description", "reminderMinutesBeforeStart", "busy"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "externalId", "startTime", "subject", "description"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCloseChatOrPerformHandover" -> <|
			"URL" -> StringTemplate["`host`/api/apps/public/`app-id`/incoming"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host", "app-id"},
			"BodyParameters" -> {"action", "sessionId", "actionData"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "app-id", "action", "sessionId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateJitsiTimeout" -> <|
			"URL" -> StringTemplate["`host`/api/v1/video-conference/jitsi.update-timeout"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"roomId"},
			"RequiredParameters" -> {"host", "authUserId", "authToken", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendAWhatsappTemplateMessage" -> <|
			"URL" -> StringTemplate["`host`/api/apps/public/`appId`/templateMessage"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"PathParameters" -> {"host", "appId"},
			"BodyParameters" -> {"phoneNumbers", "connectedWhatsAppNo", "targetAgent", "targetDepartment", "template"},
			"RequiredParameters" -> {"host", "appId", "phoneNumbers", "connectedWhatsAppNo", "template"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddLicense" -> <|
			"URL" -> StringTemplate["`host`/api/v1/licenses.add"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"license"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMaximumActiveUser" -> <|
			"URL" -> StringTemplate["`host`/licenses.maxActiveUsers"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLicenses1" -> <|
			"URL" -> StringTemplate["`host`/api/v1/licenses.info"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSlashCommands" -> <|
			"URL" -> StringTemplate["`host`/api/v1/commands.get"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"command"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "command"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListSlashCommands" -> <|
			"URL" -> StringTemplate["`host`/api/v1/commands.list"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"count", "offset", "sort"},
			"RequiredParameters" -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCommandsPreviewData" -> <|
			"URL" -> StringTemplate["`host`/api/v1/commands.preview"],
			"HTTPSMethod" -> "GET",
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"QueryParameters" -> {"command", "roomId", "params"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "command", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawExecuteCommandsPreviewItem" -> <|
			"URL" -> StringTemplate["`host`/api/v1/commands.preview"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"command", "roomId", "tmid", "params", "triggerId", "previewItem"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "command", "roomId", "tmid", "previewItem"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawExecuteASlashCommand" -> <|
			"URL" -> StringTemplate["`host`/api/v1/commands.run"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"command", "roomId", "params", "tmid", "triggerId"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "command", "roomId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendMailerEndpoint" -> <|
			"URL" -> StringTemplate["`host`/api/v1/mailer"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"from", "subject", "body", "dryrun"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "from", "subject"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMailerUnsubscribeEndpoint" -> <|
			"URL" -> StringTemplate["`host`/api/v1/mailer.unsubscribe"],
			"HTTPSMethod" -> "POST",
			"Headers" -> $headers,
			"HeadersParameters" -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters" -> {"host"},
			"BodyParameters" -> {"_id", "createdAt"},
			"RequiredParameters" -> {"host", "authToken", "authUserId", "_id", "createdAt"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>,
	"ProcessedRequests" -> <||>
|>;

params["ProcessedRequests"] = <|
	"GetRocketchatHost" -> <|
		"ExecuteFunction" -> Function[$host],
		"SubmitFunction" -> None,
		"Parameters" -> {}
	|>,
	"SetRocketchatHost" -> <|
		"ExecuteFunction" -> Function[$host = Lookup[Association @ #, "Host"]],
		"SubmitFunction" -> None,
		"Parameters" -> {"Host" -> Automatic},
		"RequiredParameters" -> {"Host"}
	|>,
	"ResetRocketChatHost" -> <|
		"ExecuteFunction" -> Function[$host = $defaultHost],
		"SubmitFunction" -> None,
		"Parameters" -> {}
	|>,
	"GetRocketChatAuthentication" -> <|
		"ExecuteFunction" -> Function[
			<|
				"authToken" -> $authToken,
				"authUserId" -> $userId,
				"userId" -> $userId
			|>
		],
		"SubmitFunction" -> None,
		"Parameters" -> {}
	|>,
	"SetRocketChatAuthentication" -> <|
		"ExecuteFunction" -> Function[
			Module[{requestParams = Association @ #},
				$authToken = requestParams["AuthToken"];
				$userId = requestParams["UserId"];
				<|
					"authToken" -> $authToken,
					"authUserId" -> $userId,
					"userId" -> $userId
				|>
			]
		],
		"SubmitFunction" -> None,
		"Parameters" -> {"AuthToken" -> Automatic, "UserId" -> Automatic},
		"RequiredParameters" -> {"AuthToken", "UserId"}
	|>,
	"ClearRocketChatAuthentication" -> <|
		"ExecuteFunction" -> Function[
			$authToken = None;
			$userId = None;
			<|
				"authToken" -> $authToken,
				"authUserId" -> $userId,
				"userId" -> $userId
			|>
		],
		"SubmitFunction" -> None,
		"Parameters" -> {}
	|>,
	KeyValueMap[
		processedRequestName[#1] -> makeProcessedRequest[#1, #2] &,
		params["RawRequests"]
	]
|>;

Scan[
	If[KeyExistsQ[params["ProcessedRequests"], #],
		params["ProcessedRequests", #, "ExecuteResultProcessing"] = storeLoginAuthentication
	] &,
	{"Login", "LoginWithFacebook", "LoginWithTwitter", "LoginWithGoogle"}
];

If[KeyExistsQ[params["ProcessedRequests"], "Logout"],
	params["ProcessedRequests", "Logout", "ExecuteResultProcessing"] = clearStoredAuthentication
];

End[];
EndPackage[];

ServiceFramework`DefineServiceConnection[ToneAr`RocketChat`Private`params]
