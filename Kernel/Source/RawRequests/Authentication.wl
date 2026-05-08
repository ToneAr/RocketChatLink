authenticationRawRequests =
	<|
		"RawLogin"             -> <|
			"URL"                    -> StringTemplate["`host`/api/v1/login"],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"user", "password", "resume", "code"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLoginWithFacebook" -> <|
			"URL"                    -> StringTemplate["`host`/api/v1/login"],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"serviceName",
				"accessToken",
				"secret",
				"expiresIn"
			},
			"RequiredParameters"     -> {
				"host",
				"serviceName",
				"accessToken",
				"secret",
				"expiresIn"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLoginWithTwitter"  -> <|
			"URL"                    -> StringTemplate["`host`/api/v1/login"],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"serviceName",
				"accessToken",
				"accessTokenSecret",
				"appSecret",
				"appId",
				"expiresIn"
			},
			"RequiredParameters"     -> {
				"host",
				"serviceName",
				"accessToken",
				"accessTokenSecret",
				"appSecret",
				"appId",
				"expiresIn"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLoginWithGoogle"   -> <|
			"URL"                    -> StringTemplate["`host`/api/v1/login"],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"serviceName",
				"accessToken",
				"idToken",
				"expiresIn",
				"scope"
			},
			"RequiredParameters"     -> {
				"host",
				"serviceName",
				"accessToken",
				"idToken",
				"expiresIn"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLogout"            -> <|
			"URL"                    -> StringTemplate["`host`/api/v1/logout"],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetProfileInfo"    -> <|
			"URL"                    -> StringTemplate["`host`/api/v1/me"],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;