federationRawRequests =
	<|
		"RawAddFederatedServer"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/federation/addServerByUser"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"serverName"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"serverName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetFederatedServers"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/federation/listServersByUser"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveFederatedServer"  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/federation/removeServerByUser"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"serverName"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"serverName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchPublicRooms"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/federation/searchPublicRooms"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"serverName",
				"roomName",
				"pageToken",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"serverName"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawJoinExternalPublicRoom" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/federation/joinExternalPublicRoom"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"externalRoomId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"externalRoomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;