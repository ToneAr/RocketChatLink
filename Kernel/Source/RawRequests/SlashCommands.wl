slashCommandsRawRequests =
	<|
		"RawGetSlashCommands"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/commands.get"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"command"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"command"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListSlashCommands"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/commands.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"count", "offset", "sort"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCommandsPreviewData"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/commands.preview"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"command", "roomId", "params"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"command",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawExecuteCommandsPreviewItem" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/commands.preview"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"command",
				"roomId",
				"tmid",
				"params",
				"triggerId",
				"previewItem"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"command",
				"roomId",
				"tmid",
				"previewItem"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawExecuteASlashCommand"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/commands.run"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"command",
				"roomId",
				"params",
				"tmid",
				"triggerId"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"command",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;