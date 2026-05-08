importRawRequests =
	<|
		"RawUploadImportFile"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/uploadImportFile"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"binaryContent",
				"importerKey",
				"fileName",
				"contentType"
			},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"binaryContent",
				"importerKey",
				"fileName",
				"contentType"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDownloadPublicImportFile"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/downloadPublicImportFile"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"fileUrl", "importerKey"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"fileUrl",
				"importerKey"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawStartImport"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/startImport"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"input"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"input"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetImportFileData"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/getImportFileData"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetImportProgress"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/getImportProgress"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLatestImportOperations"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/getLatestImportOperations"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDownloadPendingFiles"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/downloadPendingFiles"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDownloadPendingAvatars"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/downloadPendingAvatars"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCurrentImportOperations1" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/getCurrentImportOperation"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfImports"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/importers.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateNewImportOperation"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/import.new"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddUsers"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/import.addUsers"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"users"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"users"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRunImportOperation"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/import.run"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetImportOperationStatus"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/import.status"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAbortImportOperation"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/import.clear"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;