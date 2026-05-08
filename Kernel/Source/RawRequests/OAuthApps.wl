oAuthAppsRawRequests =
	<|
		"RawCreateOauthApp"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/oauth-apps.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"name", "redirectUri", "active"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name",
				"redirectUri",
				"active"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateOauthApp"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/oauth-apps.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"redirectUri",
				"active",
				"appId"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name",
				"redirectUri",
				"active",
				"appId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfOauthApps" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/oauth-apps.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOauthApp"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/oauth-apps.get"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"clientId", "_id"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteOauthApp"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/oauth-apps.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"appId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"appId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;