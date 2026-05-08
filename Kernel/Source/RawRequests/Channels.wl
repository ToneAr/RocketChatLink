channelsRawRequests =
	<|
		"RawCreateChannel"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"members",
				"readOnly",
				"excludeSelf",
				"customFields",
				"extraData"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddAllUsersToAChannel"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.addAll"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "activeUsersOnly"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddChannelLeader"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.addLeader"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddChannelModerator"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.addModerator"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddChannelOwner"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.addOwner"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawReadChannelMessagesAnonymously" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.anonymousread"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"roomName",
				"offset",
				"count",
				"sort",
				"query",
				"fields"
			},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawArchiveChannel"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.archive"
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
		"RawCloseChannel"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.close"
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
		"RawGetChannelCounters"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.counters"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "roomName", "userId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteChannel"                  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "roomName"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelFiles"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.files"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"roomName",
				"fields",
				"query",
				"sort",
				"count",
				"offset",
				"typeGroup",
				"name"
			},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelHistory"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.history"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"roomName",
				"sort",
				"count",
				"offset",
				"latest",
				"oldest",
				"inclusive",
				"showThreadMessages",
				"unreads"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelInformation"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "roomName"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddUsersToChannel"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.invite"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "userId", "userIds"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawJoinAChannel"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.join"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "joinCode"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveUserFromChannel"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.kick"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "userId"},
			"RequiredParameters"     -> {"host", "roomId", "userId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLeaveChannel"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.leave"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfJoinedChannels"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.list.joined"
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
				"fields"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelList"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"offset",
				"count",
				"query",
				"fields",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMembersOfAChannel"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.members"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"roomName",
				"status",
				"filter",
				"sort",
				"count",
				"offset"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelMessages"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.messages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"count",
				"sort",
				"offset",
				"mentionIds",
				"starredIds",
				"pinned"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelModerators"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.moderators"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "roomName"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListOnlineUsersInAChannel"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.online"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"_id"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"_id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddChannelToUserList"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.open"
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
		"RawRemoveChannelLeader"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.removeLeader"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveChannelModerator"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.removeModerator"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveChannelOwner"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.removeOwner"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "userId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRenameAChannel"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.rename"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "name"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelRoles"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.roles"
			],
			"HTTPSMethod"            -> "GET",
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "roomName"},
			"RequiredParameters"     -> {"host"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelAnnouncement"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.setAnnouncement"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "announcement"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"roomId",
				"announcement"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelCustomFields"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.setCustomFields"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "customFields"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"roomId",
				"customFields"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetDefaultChannel"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.setDefault"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "default"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"default"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelDescription"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.setDescription"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "description"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"description"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelJoinCode"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.setJoinCode"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "joinCode"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"joinCode"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelPurpose"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.setPurpose"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "purpose"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"purpose"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelReadonly"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.setReadOnly"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "readOnly"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"readOnly"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelTopic"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.setTopic"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "topic"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"topic"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetChannelType"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.setType"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "type"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"type"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUnarchiveAChannel"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.unarchive"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetAllUserMentionsInAChannel"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.getAllUserMentionsByChannel"
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
		"RawGetChannelIntegrations"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.getIntegrations"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"offset",
				"sort",
				"fields",
				"query",
				"count"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawConvertChannelToTeam"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/channels.convertToTeam"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"channelId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"channelId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;