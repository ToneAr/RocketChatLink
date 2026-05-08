videoConferenceRawRequests =
	<|
		"RawGetCurrentMediaCallState"       -> <|
			"URL"                    -> StringTemplate[
				"`host`/media-calls.state"
			],
			"HTTPSMethod"            -> "POST",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVideoConferenceCapabilities" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/video-conference.capabilities"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetListOfVideoConferences"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/video-conference.list"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"roomId", "offset", "count"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVideoConferenceDetails"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/video-conference.info"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"callId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"callId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetVideoConferenceProviders"    -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/video-conference.providers"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawStartVideoConference"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/video-conference.start"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId", "title", "allowRinging"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawJoinAVideoConference"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/video-conference.join"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"callId", "state"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"callId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawCancelVideoConference"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/video-conference.cancel"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"callId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"callId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawUpdateJitsiTimeout"             -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/video-conference/jitsi.update-timeout"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"roomId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"roomId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;