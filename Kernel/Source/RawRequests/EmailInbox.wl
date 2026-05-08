emailInboxRawRequests =
	<|
		"RawListEmailInbox"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/email-inbox.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"sort",
				"count",
				"query",
				"fields"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetEmailInbox"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/email-inbox"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"_id",
				"name",
				"email",
				"active",
				"description",
				"senderInfo",
				"department",
				"smtp",
				"imap"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name",
				"email",
				"active",
				"smtp",
				"imap"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawEmailInboxById"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/email-inbox/`_id`"
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
		"RawDeleteEmailInboxById"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/email-inbox/`_id`"
			],
			"HTTPSMethod"            -> "DELETE",
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
		"RawSearchEmailInbox"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/email-inbox.search"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"email"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"email"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendTestEmailToEmailInbox" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/email-inbox.send-test/`_id`"
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
		"RawCheckSmtp"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/smtp.check"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;