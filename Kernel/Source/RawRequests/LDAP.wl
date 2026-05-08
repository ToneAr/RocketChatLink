ldapRawRequests =
	<|
		"RawLdapSync"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/ldap.syncNow"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {
				"authToken",
				"authUserId",
				"twoFactorCode",
				"twoFactorMethod"
			},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTestLdapConnection" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/ldap.testConnection"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTestLdapUserSearch" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/ldap.testSearch"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"username"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"username"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;