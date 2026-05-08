customStatusRawRequests =
	<|
		"RawListCustomUserStatus"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/custom-user-status.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"name",
				"_id",
				"count",
				"offset",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateCustomStatus"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/custom-user-status.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"name", "statusType"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name",
				"statusType"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateCustomStatus"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/custom-user-status.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"_id", "name", "statusType"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id",
				"name",
				"statusType"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteCustomUserStatus" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/custom-user-status.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"customUserStatusId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"customUserStatusId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;