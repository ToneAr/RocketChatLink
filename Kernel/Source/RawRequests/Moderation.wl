moderationRawRequests =
	<|
		"RawGetReportedMessages"           -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/moderation.reportsByUsers"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {
				"oldest",
				"latest",
				"offset",
				"count",
				"sort"
			},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUsersReportedMessages"      -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/moderation.user.reportedMessages"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"offset", "count", "sort", "userId"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetReportsOfAMessage"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/moderation.reports"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"offset", "count", "sort", "msgId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"msgId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetReportInformation"          -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/moderation.reportInfo"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"reportId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"reportId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDismissReports"                -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/moderation.dismissReports"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId", "msgId"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDeleteReportedMessagesOfAUser" -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/moderation.user.deleteReportedMessages"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"userId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawDismissUserReports"            -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/moderation.dismissUserReports"
			],
			"HTTPSMethod"            -> "POST",
			"Headers"                -> $headers,
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"BodyParameters"         -> {"userId", "reason"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"userId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetUserReportsByUserId"        -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/moderation.user.reportsByUserId"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"QueryParameters"        -> {"userId"},
			"RequiredParameters"     -> {
				"host",
				"authUserId",
				"authToken",
				"userId"
			},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>,
		"RawGetReportedUsers"              -> <|
			"URL"                    -> StringTemplate[
				"`host`/api/v1/moderation.userReports"
			],
			"HTTPSMethod"            -> "GET",
			"HeadersParameters"      -> {"authUserId", "authToken"},
			"RequestHeadersFunction" -> requestHeaders,
			"PathParameters"         -> {"host"},
			"RequiredParameters"     -> {"host", "authUserId", "authToken"},
			"HTTPResponseProcessing" -> SF`ImportResponse
		|>
	|>;