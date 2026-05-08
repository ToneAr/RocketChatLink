livechatRawRequests =
	<|
		"RawRegisterNewAgentOrManager"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/users/`type`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "type"},
			"BodyParameters"         -> {"username"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"type",
				"username"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfAgentsOrManagers"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/users/`type`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "type"},
			"QueryParameters"        -> {"text", "count", "offset"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"type"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentOrManagerInformation"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/users/`type`/`_id`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "type", "_id"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"type",
				"_id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveAgentOrManager"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/users/`type`/`_id`"
			],
			"HTTPSMethod"            -> "DELETE",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "type", "_id"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"type",
				"_id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentInformation"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/agent.info/`rid`/`token`"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host", "rid", "token"},
			"RequiredParameters"     -> {"host", "rid", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetNextAgentInformation"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/agent.next/`token`"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host", "token"},
			"QueryParameters"        -> {"department"},
			"RequiredParameters"     -> {"host", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAgentInfo"                       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/agents/`agentId`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "agentId"},
			"BodyParameters"         -> {"departments"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"agentId",
				"departments"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAgentStatus"                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/agent.status"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"status", "agentId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"status"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfMonitors"                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/monitors"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"text", "count", "offset"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAMonitor"                           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/monitors/`_id`"
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
		"RawDeleteAMonitor"                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/monitors/`_id`"
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
		"RawCreateAMonitor"                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/monitors"
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
		|>,
		"RawRegisterLivechatVisitor"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/visitor"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"visitor"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"visitor"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVisitorInformation"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/visitor/`token`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "token"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteVisitor"                         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/visitor/`token`"
			],
			"HTTPSMethod"            -> "DELETE",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "token"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOpenConversationOfAVisitor"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/visitor/`token`/room"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "token"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchVisitorsByTerm"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/visitors.search"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"term", "offset", "count", "sort"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"term"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPagesVisitedByLivechatVisitor"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/visitors.pagesVisited/`roomId`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "roomId"},
			"QueryParameters"        -> {"offset", "count", "sort"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatVisitorChatHistory"         -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/visitors.chatHistory/room/`roomId`",
					"/visitor/`visitorId`"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "roomId", "visitorId"},
			"QueryParameters"        -> {"offset", "count", "sort"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"visitorId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchVisitorChat"                     -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/visitors.searchChats/room/`roomId`",
					"/visitor/`visitorId`"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "roomId", "visitorId"},
			"QueryParameters"        -> {
				"searchText",
				"closedChats",
				"servedChats",
				"offset",
				"count",
				"sort"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"visitorId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteVisitors"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/visitors.autocomplete"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"selector"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"selector"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetVisitorsStatus"                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/visitor/`token`/status"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "token"},
			"BodyParameters"         -> {"status"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token",
				"status"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVisitorInformationById1"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/visitors.info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"visitorId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"visitorId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterOrUpdateOmnichannelContact"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contact"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"_id",
				"token",
				"name",
				"email",
				"phone",
				"customFields",
				"contactManager",
				"channels"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchContacts"                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contact.search"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"email", "phone", "custom", "userId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelsGroupedByContactName"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.channels"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"contactId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"contactId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetContactHistory"                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.history"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"contactId",
				"source",
				"offset",
				"count",
				"sort"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"contactId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateOmnichannelContact"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"contactId",
				"name",
				"emails",
				"phones",
				"customFields",
				"contactManager",
				"wipeData"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"contactId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterOmnichannelContacts"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.register"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"emails",
				"phones",
				"contactManager",
				"customFields",
				"channel"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOmnichannelContact"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.get"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"contactId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"contactId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSearchOmnichannelContacts"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.search"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"searchText",
				"offset",
				"count",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckContactsExistence"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.checkExistence"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"email", "phone"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResolveContactConflicts"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.resolveConflict"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"contactId", "fields"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"contactId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawBlockOmnichannelContact"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.block"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"contactId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"contactId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnblockOmnichannelContact"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/omnichannel/contacts.unblock"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"contactId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"contactId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfLivechatRooms"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/rooms"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"agents",
				"offset",
				"count",
				"createdAt",
				"closedAt",
				"open",
				"tags",
				"roomName",
				"sort",
				"departmentId",
				"onhold",
				"customFields"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOrCreateLivechatRooms"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"token",
				"rid",
				"agentId",
				"departmentId"
			},
			"RequiredParameters"     -> {"host", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCloseLivechatRoom"                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room.close"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"rid", "token"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"token"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawJoinLivechatRoom"                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room.join"
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
		"RawUpdateLivechatRoom"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room.saveInfo"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomData", "guestData"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomData",
				"guestData"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawForwardLivechatRoom"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room.forward"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"roomId",
				"userId",
				"departmentId",
				"comment"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDepartmentTransferHistory"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/rooms.filters"
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
		"RawSurveyLivechatRoom"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room.survey"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"rid", "token", "data"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"token",
				"data"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawPutLivechatRoomOnHold"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room.onHold"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUploadFilesToRoom"                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/upload/`rid`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $multipartHeaders,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid"},
			"BodyParameters"         -> {"file", "description"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetLivechatRoomPriority"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room/`rid`/priority"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid"},
			"BodyParameters"         -> {"priorityId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"priorityId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveLivechatRoomPriority"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room/`rid`/priority"
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
		"RawCloseLivechatRoomByUser"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room.closeByUser"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"rid", "comment", "tags"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveClosedOmnichannelRooms"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/rooms/cleanUp"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"departmentIds", "limitDate"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"limitDate"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveAClosedOmnichannelRoom"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room/`rid`"
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
		"RawResumeRoomOnHold"                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room.resumeOnHold"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "comment"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawViewOmnichannelRoomSources"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/rooms.sources"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawVisitorTransferRoom"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/room.transfer"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"rid", "token", "department"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"token",
				"department"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfDepartments"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"text",
				"enabled",
				"onlyMyDepartments",
				"count",
				"offset",
				"sort",
				"fields",
				"excludeDepartmentId",
				"showArchived"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRegisterNewDepartment"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"department", "agents"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"department"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDepartmentInformation"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department/`_id`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "_id"},
			"QueryParameters"        -> {"includeAgents"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateDepartment"                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department/`_id`"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "_id"},
			"BodyParameters"         -> {"department", "agents"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id",
				"department"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveDepartment"                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department/`_id`"
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
		"RawAutocompleteDepartment"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department.autocomplete"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"selector",
				"onlyMyDepartments",
				"showArchived"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"selector"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentsOfDepartment"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department/`departmentId`/agents"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "departmentId"},
			"QueryParameters"        -> {"count", "offset", "sort"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"departmentId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAgentsOfDepartment"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department/`departmentId`/agents"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "departmentId"},
			"BodyParameters"         -> {"upsert", "remove"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"departmentId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDepartmentsById"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/departments.listByIds"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"ids", "fields"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"ids"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetNumberOfChats"                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/departments/amount-of-chats"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"answered",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAverageServiceTime"                 -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/departments/average-serv",
					"ice-time"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAverageChatDuration"                -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/departments/average-chat",
					"-duration-time"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTotalServiceTime"                   -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/departments/total-servic",
					"e-time"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAverageWaitingTime"                 -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/departments/average-wait",
					"ing-time"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTotalTransferredChats"              -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/departments/total-transf",
					"erred-chats"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTotalAbandonedChats"                -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/departments/total-abando",
					"ned-chats"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetPercentageOfAbandonedChats"         -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/departments/percentage-a",
					"bandoned-chats"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetArchivedDepartments"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/departments/archived"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"text", "count", "offset", "sort"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawArchiveADepartment"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department/`_id`/archive"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
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
		"RawUnarchiveADepartment"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/department/`_id`/unarchive"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
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
		"RawCheckDepartmentCreation"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/departmentCreation.checkConditions"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendCustomFieldValue"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/custom.field"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"token", "key", "value", "overwrite"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token",
				"key",
				"value",
				"overwrite"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendArrayOfCustomFieldValues"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/custom.fields"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"token", "customFields"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token",
				"customFields"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatCustomFields"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/custom-fields"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"text", "count", "offset"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCustomFieldInformation"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/custom-fields/`_id`"
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
		"RawDeleteOmnichannelCustomField"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/custom-fields/`_id`"
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
		"RawCreateOmnichannelCustomField"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/custom-fields"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"field",
				"label",
				"defaultValue",
				"scope",
				"visibility",
				"regexp"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"field",
				"label",
				"scope",
				"visibility"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetBusinessHours"                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/business-hours"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"type"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDefaultBusinessHour"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/business-hour"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"_id", "type"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveBusinessHour"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/business-hour"
			],
			"HTTPSMethod"            -> "DELETE",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"_id", "type"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateABusinessHour"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/business-hour"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"businessHour"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"businessHour"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfPriorities"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/priorities"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"filter", "count", "offset", "sort"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAPriority"                          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/priorities/`priorityId`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "priorityId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"priorityId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdatePriority"                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/priorities/`priorityId`"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "priorityId"},
			"BodyParameters"         -> {"name"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"priorityId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawResetPriorities"                       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/priorities.reset"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCheckPriorityReset"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/priorities.checkResetStatus"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfTags"                         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/tags"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"text",
				"viewAll",
				"departmentId",
				"count",
				"offset",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetATag"                               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/tags/`tagId`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "tagId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"tagId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteATag"                            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/tags/`tagId`"
			],
			"HTTPSMethod"            -> "DELETE",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "tagId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"tagId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateATag"                            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/tags"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"name", "departments"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateUnit"                            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/units"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"unit",
				"unitMonitors",
				"unitDepartments"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"unit",
				"unitMonitors",
				"unitDepartments"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfUnits"                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/units"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"text", "count", "offset"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateUnit"                            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/units/`unitId`"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "unitId"},
			"BodyParameters"         -> {
				"unit",
				"unitMonitors",
				"unitDepartments"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"unitId",
				"unit",
				"unitMonitors",
				"unitDepartments"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteAUnit"                           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/units/`unitId`"
			],
			"HTTPSMethod"            -> "DELETE",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "unitId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"unitId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfUnitMonitors"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/units/`unitId`/monitors"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "unitId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"unitId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAvailableDepartmentsByUnitId1"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/units/`unitId`/departments/available"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "unitId"},
			"QueryParameters"        -> {"text", "count", "offset"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"unitId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetDepartmentsByUnitId1"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/units/`unitId`/departments"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "unitId"},
			"QueryParameters"        -> {"count", "offset"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"unitId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAUnit1"                             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/units/`unitId`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "unitId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"unitId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfSlaPolicies"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/sla"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"text", "count", "offset", "sort"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateSlaPolicy"                       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/sla"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"description",
				"dueTimeInMinutes"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name",
				"dueTimeInMinutes"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAnSla"                              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/sla/`slaId`"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "slaId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"slaId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateAnSla"                           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/sla/`slaId`"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "slaId"},
			"BodyParameters"         -> {
				"name",
				"description",
				"dueTimeInMinutes"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"slaId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteAnSla"                           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/sla/`slaId`"
			],
			"HTTPSMethod"            -> "DELETE",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "slaId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"slaId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateOrUpdateOrDeleteACannedResponse" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/canned-responses"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"_id",
				"shortcut",
				"text",
				"scope",
				"tags",
				"departmentId"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"shortcut",
				"text",
				"scope"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListAllCannedResponses"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/canned-responses"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"text",
				"scope",
				"createdBy",
				"departmentId",
				"count",
				"offset",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserCannedResponses"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/canned-responses.get"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetACannedResponse"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/canned-responses/`_id`"
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
		"RawDeleteACannedResponse"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/canned-responses/`_id`"
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
		"RawRequestLivechatTranscript"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/transcript/`rid`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid"},
			"BodyParameters"         -> {"email", "subject"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"email"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendLivechatTranscript"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/transcript"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"rid", "token", "email", "subject"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"token",
				"email"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteLivechatTranscript"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/transcript/`rid`"
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
		"RawRequestPdfTranscript"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/pdf-transcript/`rid`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
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
		"RawGetAgentAnalyticsOverview"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/agent-overview"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"from", "to", "chartOptions"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"from",
				"to",
				"chartOptions"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAnalyticsOverview"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/overview"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"from", "to", "chartOptions"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"from",
				"to",
				"chartOptions"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentDepartments"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/agents/`agentId`/departments"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "agentId"},
			"QueryParameters"        -> {"enabledDepartmentsOnly"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"agentId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentAverageServiceTime"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/agents/average-service-time"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"agentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentTotalServiceTime"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/agents/total-service-time"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"agentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetHistoryOfAgentsAvailableForService" -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/agents/available-for-ser",
					"vice-history"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"agentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationMetrics"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/conversations"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAgentServiceTimeMetrics"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/agents"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"agentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatMetrics"                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/raw-data"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatMetricsByTime"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/raw-data/by-time"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatsStatus"                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/live-chat"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatStatusOfAgents"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/live-chat/by-agent"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"agentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetStatusOfAgents"                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/agent-status"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"agentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatsStatusForDepartments"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/live-chat/by-department"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChatTimes"                          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/analytics/raw-data/chat-times"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"start",
				"end",
				"departmentId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAnalyticsChartData"                 -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/dashboards/charts/chats-",
					"per-agent"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end", "departmentId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationsByStatus"              -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/dashboards/conversations",
					"-by-status"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end", "departmentId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationsByDepartments"         -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/dashboards/conversations",
					"-by-department"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end", "departmentId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationsByTags"                -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/dashboards/conversations",
					"-by-tags"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end", "departmentId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationByAgents"               -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/dashboards/conversations",
					"-by-agent"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end", "departmentId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetConversationsBySource"              -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/livechat/analytics/dashboards/conversations",
					"-by-source"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end", "departmentId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetInquiriesList"                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/inquiries.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"department",
				"offset",
				"count",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTakeInquiry"                           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/inquiries.take"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"inquiryId", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"inquiryId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetInquiryByRoom"                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/inquiries.getOne"
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
		"RawSetSlaPolicyToInquiry"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/inquiries.setSla"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "sla"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"sla"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListQueuedUserInquiries"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/inquiries.queuedForUser"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"agentId", "offset", "count", "sort"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawMoveChatToInquiry"                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/inquiries.promoteToInquiry"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetUpOmnichannelWebhook"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/integrations.settings"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"Livechat_webhookUrl",
				"Livechat_secret_token",
				"Livechat_webhook_on_start",
				"Livechat_webhook_on_close",
				"Livechat_webhook_on_chat_taken",
				"Livechat_webhook_on_chat_queued",
				"Livechat_webhook_on_forward",
				"Livechat_webhook_on_offline_msg",
				"Livechat_webhook_on_visitor_message",
				"Livechat_webhook_on_agent_message"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawTestTheWebhookIntegration"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/integrations.settings.test"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatConfigurations"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/config"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"token", "department", "businessUnit"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatIntegrations"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/integrations.settings"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatQueue"                      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/queue"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"agentId",
				"includeOfflineAgents",
				"departmentId",
				"offset",
				"count",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLivechatSmsIncomingTwilio"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/sms-incoming/twilio"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"From", "To", "Body"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"From",
				"To",
				"Body"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatRoutingConfiguration"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/routing.config"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatAppearance"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/appearance"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetLivechatAppearance"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/appearance"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"settings"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"settings"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfLivechatTriggers"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/triggers"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatTrigger"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/triggers/`_id`"
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
		"RawCreateLivechatTriggers"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/triggers"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"description",
				"enabled",
				"runOnce",
				"conditions",
				"actions"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name",
				"enabled",
				"conditions",
				"actions"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteATrigger"                        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/triggers/`_id`"
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
		"RawTestTriggerWithExternalService"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/triggers.test"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"triggerId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"triggerId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendNewLivechatMessage"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/message"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"token", "rid", "msg", "_id", "agent"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token",
				"rid",
				"msg"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendArrayOfMessages"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/messages.import/`rid`"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "rid"},
			"BodyParameters"         -> {"messages"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"rid",
				"messages"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateLivechatMessage"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/message/`_id`"
			],
			"HTTPSMethod"            -> "PUT",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host", "_id"},
			"BodyParameters"         -> {"token", "rid", "msg"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id",
				"token",
				"rid",
				"msg"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetALivechatMessage"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/message/`_id`"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host", "_id"},
			"QueryParameters"        -> {"token", "rid"},
			"RequiredParameters"     -> {"host", "_id", "token", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteLivechatMessage"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/message/`_id`"
			],
			"HTTPSMethod"            -> "DELETE",
			"PathParameters"         -> {"host", "_id"},
			"QueryParameters"        -> {"token", "rid"},
			"RequiredParameters"     -> {"host", "_id", "token", "rid"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatMessageHistory"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/messages.history/`rid`"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host", "rid"},
			"QueryParameters"        -> {
				"token",
				"ls",
				"end",
				"limit",
				"offset",
				"sort"
			},
			"RequiredParameters"     -> {"host", "rid", "token"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendOfflineLivechatMessage"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/offline.message"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"email",
				"message",
				"department",
				"host"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name",
				"email",
				"message"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetLivechatMessages"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/messages"
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
				"query",
				"fields"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSendVisitorNavigationHistory"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/livechat/page.visited"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"token", "rid", "pageInfo"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"token",
				"rid",
				"pageInfo"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;