cloudRawRequests =
	<|
		"RawManualCloudRegister" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/cloud.manualRegister"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"cloudBlob"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"cloudBlob"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;