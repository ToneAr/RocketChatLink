With[{
		kernelDir =
			FileNameJoin[
				{PacletObject["ToneAr/RocketChat"]["Location"], "Kernel"}
			]
	},
	Get["ToneAr`RocketChat`Private`"];
	Get /@ FileNameJoin /@ Thread[
		{
			FileNameJoin[{kernelDir, "Source"}],
			{"Globals.wl", "Utilities.wl", "Requests.wl"}
		}
	];
];

BeginPackage[
	"ToneAr`RocketChat`",
	{"ToneAr`RocketChat`Private`", "ServiceFramework`"}
];
$ContextAliases["SF`"] = "ServiceFramework`";
$ContextAliases["SFPvt`"] = "ServiceFramework`PackageScope`";

SF`DefineServiceConnection[
	<|
		"ServiceName"             -> "Rocket.Chat",
		"Information"             -> "A Wolfram Language service connection to Rocket.Chat.",
		"Icon"                    -> $icon,
		"ParameterMap"            -> $parameterMap,
		"RawRequests"             -> $rawRequests,
		"ProcessedRequests"       -> $processedRequests,
		"AuthenticationMethod"    -> "UsernamePassword",
		"AuthenticationDialog"    -> rocketChatAuthenticationDialog,
		"AuthenticationParser"    -> rocketChatAuthenticationParser,
		"AuthenticationFunction"  -> rocketChatAuthenticationFunction,
		"ServiceFrameworkVersion" -> "0.1.0"
	|>
];

SF`AddCustomService[
	"Rocket.Chat",
	<|
		"ConnectFunction"                  -> rocketChatConnect,
		"ExecuteFunction"                  -> SFPvt`serviceExecute,
		"SubmitFunction"                   -> SFPvt`serviceSubmit,
		"ServiceObjectExecuteFunction"     -> ServiceExecute,
		"ServiceObjectTypesettingFunction" -> SFPvt`serviceObjectTypesettingFunction,
		"DisconnectFunction"               -> rocketChatDisconnect
	|>
];

EndPackage[];
