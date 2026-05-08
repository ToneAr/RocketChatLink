directoryRawRequests =
	<|
		"RawDirectory1" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/directory"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"text",
				"type",
				"workspace",
				"query",
				"offset",
				"count",
				"sort",
				"fields"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"query"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;