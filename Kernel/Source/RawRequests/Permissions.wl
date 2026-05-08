permissionsRawRequests =
	<|
		"RawListAllPermissions" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/permissions.listAll"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"updatedSince"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdatePermissions"  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/permissions.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"permissions"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"permissions"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;