calendarEventsRawRequests =
	<|
		"RawGetListOfCalendarEvents" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/calendar-events.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"date"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"date"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetCalendarEventInfo"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/calendar-events.info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"id"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"id"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCreateCalendarEvent"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/calendar-events.create"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"startTime",
				"endTime",
				"subject",
				"description",
				"reminderMinutesBeforeStart",
				"busy",
				"externalId"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"startTime",
				"subject",
				"description"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateCalendarEvent"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/calendar-events.update"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"eventId",
				"startTime",
				"endTime",
				"subject",
				"description",
				"reminderMinutesBeforeStart",
				"busy"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"eventId",
				"startTime",
				"subject",
				"description"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteCalendarEvent"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/calendar-events.delete"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"eventId"},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"eventId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawImportCalendarEvent"     -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/calendar-events.import"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authToken", "authUserId"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {
				"externalId",
				"startTime",
				"endTime",
				"subject",
				"description",
				"reminderMinutesBeforeStart",
				"busy"
			},
			"RequiredParameters"     -> {
				"host",
				"authToken",
				"authUserId",
				"externalId",
				"startTime",
				"subject",
				"description"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;