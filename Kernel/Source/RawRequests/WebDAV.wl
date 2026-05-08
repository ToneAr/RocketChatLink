webdavRawRequests =
	<|
		"RawGetWebdavAccounts"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/webdav.getMyAccounts"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveWebdavAccount" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/webdav.removeWebdavAccount"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"accountId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"accountId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;