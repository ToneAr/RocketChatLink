mailerRawRequests =
	<|
		"RawSendMailerEndpoint"        -> <|
			"URL"                    -> StringTemplate["`host`/api/v1/mailer"],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"from", "subject", "body", "dryrun"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"from",
				"subject"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMailerUnsubscribeEndpoint" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/mailer.unsubscribe"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"_id", "createdAt"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id",
				"createdAt"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;