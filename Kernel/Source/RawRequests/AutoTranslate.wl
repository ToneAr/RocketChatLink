autoTranslateRawRequests =
	<|
		"RawGetSupportedLanguages"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/autotranslate.getSupportedLanguages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"targetLanguage"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"targetLanguage"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSaveAutoTranslateSettings" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/autotranslate.saveSettings"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"roomId",
				"field",
				"value",
				"defaultLanguage"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"field",
				"value"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTranslateMessage"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/autotranslate.translateMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"messageId", "targetLanguage"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"messageId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;