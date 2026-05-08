settingsRawRequests =
	<|
		"RawGetPublicSettings"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/settings.public"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"count",
				"fields",
				"_id",
				"sort"
			},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOauthSettings"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/settings.oauth"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPrivateSettings"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/settings"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"includeDefaults", "offset", "count"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddCustomOauth"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/settings.addCustomOAuth"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authToken",
				"authUserId",
				"X-2fa-code",
				"X-2fa-method"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"name"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateSetting"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/settings/`_id`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {
				"authToken",
				"authUserId",
				"X-2fa-code",
				"X-2fa-method"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "_id"},
			"BodyParameters"         -> {"value", "color", "editor", "execute"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSetting"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/settings/`_id`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "_id"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOauthServiceConfiguration" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/service.configurations"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;