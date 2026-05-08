e2eRawRequests =
	<|
		"RawGetE2eKeys"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/e2e.fetchMyKeys"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersOfRoomWithoutE2eKey" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/e2e.getUsersOfRoomWithoutKey"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"rid"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"rid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetRoomE2eKey"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/e2e.setRoomKeyID"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"rid", "keyID"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"rid",
				"keyID"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUserKey"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/e2e.setUserPublicAndPrivateKeys"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"public_key", "private_key"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"public_key",
				"private_key"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateUserE2eKeyInRoom"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/e2e.updateGroupKey"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"uid", "rid", "key"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"uid",
				"rid",
				"key"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;