subscriptionsRawRequests =
	<|
		"RawGetAllSubscriptions" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/subscriptions.get"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"updatedSince"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetSubscriptionRoom" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/subscriptions.getOne"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMarkChannelAsRead"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/subscriptions.read"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "readThreads", "rid"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMarkChannelAsUnread" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/subscriptions.unread"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "firstUnreadMessage"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;