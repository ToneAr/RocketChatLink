emojiRawRequests =
	<|
		"RawListAllCustomEmojis"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/emoji-custom.all"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"name", "offset", "count"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateAnEmoji"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/emoji-custom.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $multipartHeaders,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"emoji", "name", "aliases"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"emoji",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteACustomEmoji"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/emoji-custom.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"emojiId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"emojiId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUpdatedListOfCustomEmojis" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/emoji-custom.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"updatedSince", "_updatedAt", "_id"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateACustomEmoji"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/emoji-custom.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $multipartHeaders,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"emoji", "name", "_id", "aliases"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"name",
				"_id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;