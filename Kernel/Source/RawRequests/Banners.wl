bannersRawRequests =
	<|
		"RawGetBannerById"  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/banners/`id`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "id"},
			"QueryParameters"        -> {"platform"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"id",
				"platform"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetBanners"     -> <|
			"URL"                    -> StringTemplate["`host`/api/v1/banners"],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"platform"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"platform"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDismissABanner" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/banners.dismiss"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"bannerId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"bannerId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;