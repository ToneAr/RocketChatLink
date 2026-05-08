engagementDashboardRawRequests =
	<|
		"RawGetNewUsers"                   -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/engagement-dashboard/users/new-users"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetActiveUsers"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/engagement-dashboard/users/active-users"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserByTimeOfTheDay"         -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/engagement-dashboard/users/users-by-time-of",
					"-the-day-in-a-week"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetHourlyDataWhenChatIsBusier" -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/engagement-dashboard/users/chat-busier/hour",
					"ly-data"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetWeeklyDataWhenChatIsBusier" -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/engagement-dashboard/users/chat-busier/week",
					"ly-data"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetMessagesSent"               -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/engagement-dashboard/messages/messages-sent"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetOriginOfMessageSent"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/engagement-dashboard/messages/origin"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetTheMostPopularChannels"     -> <|
			"URL"                    -> StringTemplate[
				StringJoin[
					"`host`/api/v1/engagement-dashboard/messages/top-five-popu",
					"lar-channels"
				]
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetChannelsEngagement"         -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/engagement-dashboard/channels/list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"start", "end", "count", "offset"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"start",
				"end"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;