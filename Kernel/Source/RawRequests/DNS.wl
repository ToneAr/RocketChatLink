dnsRawRequests =
	<|
		"RawResolveDnsTextRecords" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/dns.resolve.txt"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"url"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"url"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResolveDnsUrlRecords"  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/dns.resolve.srv"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"url"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"url"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;