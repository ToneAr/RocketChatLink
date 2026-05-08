pushRawRequests =
	<|
		"RawGetPushNotification"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/push.get"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"id"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeletePushToken"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/push.token"
			],
			"HTTPSMethod"            -> "DELETE",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"token"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreatePushToken"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/push.token"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"type", "value", "appName"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"type",
				"value",
				"appName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTestPushNotifications" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/push.test"
			],
			"HTTPSMethod"            -> "POST",
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPushInfo"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/push.info"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;