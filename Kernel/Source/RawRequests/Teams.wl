teamsRawRequests =
	<|
		"RawCreateANewTeam"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"name",
				"type",
				"members",
				"room",
				"sidepanel",
				"owner"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name",
				"type"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfAllTeams"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.listAll"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"offset", "count"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfTeams"                 -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"sort", "offset", "count", "query"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTeamInfo"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"teamId", "teamName"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateATeam"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"teamId", "data"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"teamId",
				"data"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddMembersToTheTeam"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.addMembers"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"teamId", "members"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"teamId",
				"members"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListTeamMembers"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.members"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"teamName",
				"teamId",
				"name",
				"username",
				"status"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateTeamMemberInfo"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.updateMember"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"teamId", "member"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"teamId",
				"member"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawLeaveATeam"                     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.leave"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"teamId", "rooms"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"teamId",
				"rooms"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveMemberFromTeam"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.removeMember"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"teamId", "userId", "rooms"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"teamId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteATeam"                    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"teamName", "teamId", "roomsToRemove"},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAutocompleteTeam"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.autocomplete"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"name"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"name"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawConvertTeamToChannel"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.convertToChannel"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"teamId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"teamId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawAddRoomsToATeam"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.addRooms"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"teamId", "rooms"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"teamId",
				"rooms"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawRemoveRoomFromTheTeam"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.removeRoom"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"teamName", "teamId", "roomId"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateRoomInATeam"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.updateRoom"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "isDefault"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"roomId",
				"isDefault"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListRoomsOfATeam"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.listRooms"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"teamId",
				"teamName",
				"type",
				"count",
				"offset"
			},
			"RequiredParameters"     -> {"host", "authToken", "authUserId"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListUserRoomsOfATeam"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.listRoomsOfUser"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"teamName",
				"teamId",
				"userId",
				"offset",
				"count"
			},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawListRoomsAndDiscussionsOfATeam" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/teams.listChildren"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"teamName",
				"teamId",
				"offset",
				"count",
				"sort",
				"filter",
				"type",
				"roomId"
			},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;