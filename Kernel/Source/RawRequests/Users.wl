usersRawRequests =
	<|
		"RawEnable2faViaEmail"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.2fa.enableEmail"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRequestANewEmailCode"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.2fa.sendEmailCode"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"emailOrUsername"},
			"RequiredParameters"     -> {"host", "emailOrUsername"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDisable2faViaEmail"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.2fa.disableEmail"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {
				"authToken",
				"authUserId",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateUser"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"email",
				"password",
				"username",
				"active",
				"nickname",
				"bio",
				"joinDefaultChannels",
				"statusText",
				"roles",
				"requirePasswordChange",
				"setRandomPassword",
				"sendWelcomeEmail",
				"verified",
				"customFields"
			},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"name",
				"email",
				"password",
				"username"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterUser"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.register"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"username",
				"email",
				"pass",
				"name",
				"secretURL"
			},
			"RequiredParameters"     -> {
				"host",
				"username",
				"email",
				"pass",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateUser"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authUserId",
				"authToken",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId", "data"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"twoFactorCode",
				"twoFactorMethod",
				"data"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateOwnBasicInformation"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.updateOwnBasicInfo"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authUserId",
				"authToken",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"data", "customFields"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"data"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserInfo"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"userId",
				"username",
				"importId",
				"includeUserRooms",
				"email"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersList"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"query",
				"fields",
				"offset",
				"count",
				"sort",
				"email"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListUsersByStatus"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.listByStatus"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"sort",
				"count",
				"status",
				"hasLoggedIn",
				"type",
				"roles[]",
				"searchTerm",
				"inactiveReason[]"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUserAvatar"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.setAvatar"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"avatarUrl", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"avatarUrl"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserAvatar"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.getAvatar"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"userId"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResetUserAvatar"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.resetAvatar"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUserStatus"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.setStatus"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"message", "status", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"message",
				"status"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserStatus"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.getStatus"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"userId"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUsersStatusActive"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.setActiveStatus"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"activeStatus",
				"userId",
				"confirmRelinquish"
			},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"activeStatus"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeactivateIdleUsers"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.deactivateIdle"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"daysIdle", "role"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"daysIdle"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSpecificUsersPresence"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.getPresence"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"userId"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersPresence"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.presence"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"from", "ids"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteUser"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId", "confirmRelinquish"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteOwnUser"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.deleteOwnAccount"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"password", "confirmRelinquish"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"password"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateUserToken"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.createToken"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId", "secret"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"secret"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserPreferences"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.getPreferences"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUserPreferences"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.setPreferences"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId", "data"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"data"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawForgotPassword"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.forgotPassword"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"email"},
			"RequiredParameters"     -> {"host", "email"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsernameSuggestion"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.getUsernameSuggestion"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGeneratePersonalAccessToken"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.generatePersonalAccessToken"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authToken",
				"authUserId",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"tokenName", "bypassTwoFactor"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"tokenName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegeneratePersonalAccessToken" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.regeneratePersonalAccessToken"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authToken",
				"authUserId",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"tokenName"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"tokenName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPersonalAccessTokens"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.getPersonalAccessTokens"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemovePersonalAccessToken"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.removePersonalAccessToken"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authToken",
				"authUserId",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"tokenName"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"tokenName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRequestDataDownload"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.requestDataDownload"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"fullExport"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogoutOtherClients"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.logoutOtherClients"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteUser"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.autocomplete"
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
		"RawRemoveOtherTokens"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.removeOtherTokens"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResetUsersE2eKey"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.resetE2EKey"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authToken",
				"authUserId",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResetUsersTotp"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.resetTOTP"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authToken",
				"authUserId",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListUserTeams"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.listTeams"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"userId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogoutUser"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.logout"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckUsernameAvailability"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.checkUsernameAvailability"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"username"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"username"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendUserWelcomeEmail"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.sendWelcomeEmail"
			],
			"HTTPSMethod"            -> "GET",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"email"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"email"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendEmailVerification"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.sendConfirmationEmail"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"email"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"email"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAvatarSuggestion"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/users.getAvatarSuggestion"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;