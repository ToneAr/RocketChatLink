sessionsRawRequests =
	<|
		"RawGetCurrentUserSessions"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/sessions/list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"filter", "offset", "count", "sort"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAllCurrentUserSessions"  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/sessions/list.all"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {
				"authUserId",
				"authToken",
				"X-2fa-code",
				"X-2fa-method"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"filter", "offset", "count", "sort"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAllCurrentUserSessions1" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/sessions/info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"sessionId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"sessionId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSessionInformation"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/sessions/info.admin"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {
				"authUserId",
				"authToken",
				"X-2fa-code",
				"X-2fa-method"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"sessionId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"sessionId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogoutCurrentUserSession"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/sessions/logout.me"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"sessionId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"sessionId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogoutSession"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/sessions/logout"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authUserId",
				"authToken",
				"X-2fa-code",
				"X-2fa-method"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"sessionId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"sessionId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;