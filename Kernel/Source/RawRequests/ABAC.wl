abacRawRequests =
	<|
		"RawReplaceRoomAbacAttributes"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/rooms/`rid`/attributes"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid"},
			"BodyParameters"         -> "ParameterlessBody",
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteAllAbacAttributes"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/rooms/`rid`/attributes"
			],
			"HTTPSMethod"            -> "DELETE",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddAbacAttributeKeyToRoom"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/rooms/`rid`/attributes/`key`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid", "key"},
			"BodyParameters"         -> {"values"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"key"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetRoomAbacAttributeValues"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/rooms/`rid`/attributes/`key`"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid", "key"},
			"BodyParameters"         -> {"values"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"key"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteRoomAbacAttributeKey"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/rooms/`rid`/attributes/`key`"
			],
			"HTTPSMethod"            -> "DELETE",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid", "key"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"key"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListAbacAttributeDefinitions"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/attributes"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"offset", "count", "key", "values"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateAbacAttributeDefinition"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/attributes"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"key", "values"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSyncUsersAbacAttributesFromLdap"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/users/sync"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"usernames",
				"ids",
				"emails",
				"ldapIds"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAbacAttributeDefinition"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/attributes/`_id`"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "_id"},
			"BodyParameters"         -> {"key", "values"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id",
				"key",
				"values"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAbacAttributeDefinitionById"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/attributes/`_id`"
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
		"RawDeleteAbacAttributeDefinitionById" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/attributes/`_id`"
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
		"RawCheckIfAbacAttributeIsInUse"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/attributes/`key`/is-in-use"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "key"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"key"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListRoomsWithAbacAttributes"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/rooms"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"count",
				"filter",
				"filterType"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListAbacAuditEvents"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/audit"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"actor",
				"offset",
				"count",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPdpHealthStatus"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/abac/pdp/health"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;