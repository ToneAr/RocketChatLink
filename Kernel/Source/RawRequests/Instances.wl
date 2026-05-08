instancesRawRequests =
	<|
		"RawGetInstances" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/instances.get"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;