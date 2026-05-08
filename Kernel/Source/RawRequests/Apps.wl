appsRawRequests =
	<|
		"RawCloseChatOrPerformHandover"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/apps/public/`app-id`/incoming"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "app-id"},
			"BodyParameters"         -> {"action", "sessionId", "actionData"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"app-id",
				"action",
				"sessionId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendAWhatsappTemplateMessage" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/apps/public/`appId`/templateMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"PathParameters"         -> {"host", "appId"},
			"BodyParameters"         -> {
				"phoneNumbers",
				"connectedWhatsAppNo",
				"targetAgent",
				"targetDepartment",
				"template"
			},
			"RequiredParameters"     -> {
				"host",
				"appId",
				"phoneNumbers",
				"connectedWhatsAppNo",
				"template"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;