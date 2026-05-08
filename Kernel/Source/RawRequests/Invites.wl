invitesRawRequests =
	<|
		"RawFindOrCreateInvite" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/findOrCreateInvite"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"rid", "days", "maxUses"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"days",
				"maxUses"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListInvites"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/listInvites"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteInviteById"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/removeInvite/`_id`"
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
		"RawUseInviteToken"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/useInviteToken"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"token"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;