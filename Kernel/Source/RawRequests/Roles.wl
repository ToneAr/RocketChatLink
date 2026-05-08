rolesRawRequests =
	<|
		"RawCreateRole"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/roles.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"scope",
				"description",
				"mandatory2fa"
			},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateRole"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/roles.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"roleId",
				"name",
				"scope",
				"description",
				"mandatory2fa"
			},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"roleId",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAssignRoleToUser"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/roles.addUserToRole"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roleId", "username", "roomId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"username"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersOfARole"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/roles.getUsersInRole"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"role", "roomId", "offset", "count"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"role"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetRoles"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/roles.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUpdatedRoles"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/roles.sync"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"updatedSince"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"updatedSince"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteRole"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/roles.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roleId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"roleId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveRoleFromUser"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/roles.removeUserFromRole"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roleId", "username", "scope"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"roleId",
				"username"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersInPublicRoles" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/roles.getUsersInPublicRoles"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;