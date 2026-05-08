groupsRawRequests =
	<|
		"RawGetGroupOnlineUsers"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.online"
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
		"RawGetGroupIntegrations"  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.getIntegrations"
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
		"RawAddAllUsersToGroup"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.addAll"
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
		"RawAddGroupLeader"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.addLeader"
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
		"RawAddGroupModerator"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.addModerator"
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
		"RawAddGroupOwner"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.addOwner"
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
		"RawArchiveAGroup"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.archive"
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
		"RawCloseGroup"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.close"
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
		"RawGetGroupCounters"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.counters"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "roomName", "userId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateGroup"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"readOnly",
				"members",
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
		"RawDeleteGroup"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.delete"
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
		"RawGetGroupHistory"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.history"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"latest",
				"oldest",
				"inclusive",
				"unreads",
				"offset",
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
		"RawGetGroupInformation"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "roomName"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawInviteUsersToGroup"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.invite"
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
		"RawRemoveUserFromGroup"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.kick"
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
		"RawGetListOfUserGroups"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.listAll"
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
		"RawGetGroups"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"offset", "count", "sort"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListGroupMembers"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.members"
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
				"status",
				"filter"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupMessages"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.messages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomId",
				"roomName",
				"fields",
				"sort",
				"offset",
				"count",
				"mentionIds",
				"starredIds",
				"pinned"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetGroupModerators"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.moderators"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "roomName"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddGroupToList"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.open"
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
		"RawRemoveGroupLeader"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.removeLeader"
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
		"RawRemoveGroupModerator"  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.removeModerator"
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
		"RawRemoveGroupOwner"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.removeOwner"
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
		"RawRenameGroup"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.rename"
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
		"RawSetGroupAnnouncement"  -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.setAnnouncement"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "announcement"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"announcement"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetsGroupCustomFields" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.setCustomFields"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "customFields"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"customFields"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetGroupDescription"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.setDescription"
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
		"RawSetGroupPurpose"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.setPurpose"
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
		"RawSetGroupAsReadOnly"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.setReadOnly"
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
		"RawSetGroupTopic"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.setTopic"
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
		"RawSetGroupType"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.setType"
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
		"RawUnarchiveGroup"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.unarchive"
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
		"RawGetGroupFiles"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.files"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"roomName",
				"roomId",
				"offset",
				"count",
				"sort",
				"query",
				"fields",
				"typeGroup",
				"name"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawSetGroupAsEncrypted"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.setEncrypted"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"encrypted", "roomId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"encrypted",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawConvertAGroupToTeam"   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.convertToTeam"
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
		"RawListGroupRoles"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.roles"
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
		"RawLeaveGroup1"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/groups.leave"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;