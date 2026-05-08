customSoundsRawRequests =
	<|
		"RawListCustomSounds" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/custom-sounds.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"count",
				"query",
				"name",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCustomSound"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/custom-sounds.getOne"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"_id"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;