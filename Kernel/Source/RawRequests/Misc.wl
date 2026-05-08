miscRawRequests =
	<|
		"RawGetServerInfo"            -> <|
			"URL"                    -> StringTemplate["`host`/api/info"],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPasswordPolicy"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/pw.getPolicy"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawShieldSvg"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/shield.svg"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"type", "icon", "channel", "name"},
			"RequiredParameters"     -> {"host", "channel", "name"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSpotlight"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/spotlight"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"query"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"query"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawExecuteAMeteorMethodCall" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/method.call/`method`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "method"},
			"BodyParameters"         -> {"message"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"method",
				"message"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;