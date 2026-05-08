assetsRawRequests =
	<|
		"RawSetAsset"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/assets.setAsset"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $multipartHeaders,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"asset",
				"assetName",
				"refreshAllClients"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"asset",
				"assetName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnsetAsset" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/assets.unsetAsset"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"assetName", "refreshAllClients"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"assetName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;