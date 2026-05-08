BeginPackage["ToneAr`RocketChat`", {"ToneAr`RocketChat`Private`"}];
Begin["`FileScope`Requests`Private`"];

Needs["ServiceFramework`" -> "SF`"];
Needs["GeneralUtilities`" -> None];

With[{
		kernelDir =
			FileNameJoin[
				{PacletObject["ToneAr/RocketChat"]["Location"], "Kernel"}
			]
	},
	Get /@ FileNames[
		"*.wl",
		FileNameJoin[{kernelDir, "Source", "RawRequests"}],
		1
	]
];

$rawRequests =
	<|
		authenticationRawRequests,
		usersRawRequests,
		rolesRawRequests,
		groupsRawRequests,
		channelsRawRequests,
		ldapRawRequests,
		permissionsRawRequests,
		subscriptionsRawRequests,
		autoTranslateRawRequests,
		directoryRawRequests,
		invitesRawRequests,
		roomsRawRequests,
		abacRawRequests,
		teamsRawRequests,
		chatRawRequests,
		dmRawRequests,
		livechatRawRequests,
		integrationsRawRequests,
		webdavRawRequests,
		oAuthAppsRawRequests,
		bannersRawRequests,
		pushRawRequests,
		assetsRawRequests,
		emojiRawRequests,
		customSoundsRawRequests,
		customStatusRawRequests,
		statisticsRawRequests,
		engagementDashboardRawRequests,
		settingsRawRequests,
		cloudRawRequests,
		dnsRawRequests,
		e2eRawRequests,
		importRawRequests,
		instancesRawRequests,
		federationRawRequests,
		videoConferenceRawRequests,
		moderationRawRequests,
		sessionsRawRequests,
		emailInboxRawRequests,
		calendarEventsRawRequests,
		appsRawRequests,
		licensesRawRequests,
		slashCommandsRawRequests,
		mailerRawRequests,
		miscRawRequests
	|>;

$processedRequests =
	<|
		(* Process RawRequests into higher-level ProcessedRequests *)
		KeyValueMap[
			processedRequestName[#1] -> makeProcessedRequest[#1, #2]&,
			$rawRequests
		]
	|>;

End[];
EndPackage[];
