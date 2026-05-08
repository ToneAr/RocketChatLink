integrationsRawRequests =
	<|
		"RawCreateIntegration"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/integrations.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"type",
				"name",
				"enabled",
				"username",
				"urls",
				"scriptEnabled",
				"channel",
				"event"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"type",
				"name",
				"enabled",
				"username"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetIntegration"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/integrations.get"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"integrationId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"integrationId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetIntegrationHistory" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/integrations.history"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"id",
				"count",
				"offset",
				"sort",
				"createdAt",
				"success",
				"status"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfIntegrations" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/integrations.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"count", "offset", "sort"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateIntegration"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/integrations.update"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"type",
				"name",
				"enabled",
				"username",
				"urls",
				"scriptEnabled",
				"channel",
				"event",
				"integrationId"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"integrationId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveIntegration1"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/integrations.remove"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"integrationId", "type"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"integrationId",
				"type"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;