chatRawRequests =
	<|
		"RawDeleteChatMessage"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "msgId", "asUser"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"msgId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawReactToMessage"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.react"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"messageId",
				"emoji",
				"reaction",
				"shouldReact"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"messageId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateMessage"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"roomId",
				"msgId",
				"text",
				"previewUrls",
				"customFields"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"msgId",
				"text"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawReportMessage"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.reportMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"messageId", "description"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"messageId",
				"description"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawFollowMessage"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.followMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"mid"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"mid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnfollowMessage"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.unfollowMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"mid"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"mid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMessage"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getMessage"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"msgId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"msgId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDeletedMessages"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getDeletedMessages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"count",
				"sort",
				"since",
				"roomId"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"since",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDiscussionsOfARoom"  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getDiscussions"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"offset",
				"count",
				"sort",
				"text"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMentionedMessages"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getMentionedMessages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "offset", "count", "sort"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMessageReadReceipts" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getMessageReadReceipts"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"offset", "count", "messageId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"messageId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPinnedMessages"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getPinnedMessages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "offset", "count", "sort"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetStarredMessages"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getStarredMessages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "offset", "count", "sort"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetThreadMessages"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getThreadMessages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"count",
				"sort",
				"query",
				"fields",
				"tmid"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"tmid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawIgnoreUser"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.ignoreUser"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"rid", "userId", "ignore"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"ignore"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawPinMessage"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.pinMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"messageId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"messageId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawPostMessage"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.postMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"alias",
				"avatar",
				"emoji",
				"roomId",
				"text",
				"parseUrls",
				"attachments",
				"tmid",
				"customFields",
				"channel"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnpinAMessage"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.unPinMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"messageId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"messageId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchMessage"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.search"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"count",
				"offset",
				"roomId",
				"searchText"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"searchText"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendMessage"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.sendMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"message", "previewUrls"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"message"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawStarMessage"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.starMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"messageId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"messageId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnstarMessage"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.unStarMessage"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"messageId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"messageId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSyncThreadList"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.syncThreadsList"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"fields",
				"query",
				"sort",
				"rid",
				"updatedSince"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"updatedSince"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSyncThreadMessages"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.syncThreadMessages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"count",
				"sort",
				"query",
				"fields",
				"updatedSince",
				"tmid"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"updatedSince",
				"tmid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSyncMessages"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.syncMessages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"offset",
				"count",
				"sort",
				"lastUpdate",
				"next",
				"previous",
				"type"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListThreads"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getThreadsList"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"count",
				"sort",
				"query",
				"fields",
				"rid",
				"type",
				"text"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUrlPreview"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/chat.getURLPreview"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "url"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"url"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;