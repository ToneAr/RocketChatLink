licensesRawRequests =
	<|
		"RawAddLicense"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/licenses.add"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"license"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"license"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMaximumActiveUser" -> <|
			"URL"                    -> StringTemplate[
				"`host`/licenses.maxActiveUsers"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLicenses1"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/licenses.info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;