BeginPackage["ToneAr`RocketChat`", {"ToneAr`RocketChat`Private`"}];
Begin["`FileScope`Utilities`Private`"];

Needs["ServiceFramework`" -> "SF`"];

requestHeaders[_, headers_, _] :=
	KeyValueMap[Lookup[$headerParameterMap, #1, #1] -> #2&, headers];

validRocketChatHostQ[host_String] :=
	StringStartsQ[host, "http://" | "https://"];
validRocketChatHostQ[_] := False;

normalizeRocketChatAuthenticationKeys[auth_Association] :=
	KeyMap[Replace[s_Symbol :> SymbolName[s]], auth];

rocketChatAuthenticationDialog[_] :=
	AuthenticationDialog[
		{"Host" -> $defaultHost, "User" -> "", "Password" -> "" -> "Masked"},
		Identity
	];

rocketChatAuthenticationParser[held_Hold] := held;
rocketChatAuthenticationParser[
	HoldPattern[SystemCredentialData][auth_Association, ___]
] :=
	rocketChatAuthenticationParser[auth];
rocketChatAuthenticationParser[auth_Association] :=
	Module[{
			normalized = normalizeRocketChatAuthenticationKeys[auth]
		},
		Switch[normalized,
			KeyValuePattern[
				{"Host" -> _String, "User" -> _String, "Password" -> _String}
			],
				rocketChatLoginAuthentication[normalized],
			KeyValuePattern[
				{"Host" -> _String, "AuthToken" -> _String, "UserID" -> _String}
			],
				Enclose[
					<|
						"Host"      -> ConfirmMatch[
							normalized["Host"],
							_String?validRocketChatHostQ,
							"InvalidHost"
						],
						"AuthToken" -> normalized["AuthToken"],
						"UserID"    -> normalized["UserID"]
					|>
				],
			_,
				$Failed
		]
	];
rocketChatAuthenticationParser[_] := $Failed;

rocketChatAuthenticationFunction[_] := None;

rocketChatValidAuthenticationQ[auth_Association] :=
	MatchQ[
		normalizeRocketChatAuthenticationKeys[auth],
		KeyValuePattern[
			{
				"Host" -> _String?validRocketChatHostQ,
				"AuthToken" -> _String,
				"UserID" -> _String
			}
		]
	];
rocketChatValidAuthenticationQ[_] := False;

rocketChatAuthenticationOption[args_List] :=
	Replace[
		Replace[
			FilterRules[
				Cases[Flatten @ {args, Options @ ServiceConnect}, _Rule | _RuleDelayed],
				Authentication
			],
			{first_, ___} :> first
		],
		{
			((Authentication | "Authentication") -> val_) :> val,
			((Authentication | "Authentication") :> val_) :> Hold[val]
		}
	];

rocketChatAuthenticationProviderOption[args_List] :=
	Replace[
		FilterRules[
			Cases[Flatten @ args, _Rule | _RuleDelayed],
			"AuthenticationProvider"
		],
		{
			{Rule[_, value_], ___} :> value,
			{RuleDelayed[_, value_], ___} :> value,
			_ :> ServiceFramework`$AuthenticationProvider
		}
	];

rocketChatStaleDefaultConnectionQ[service_String, args_List] :=
	Module[{default},
		If[
			rocketChatAuthenticationOption[args] =!= Automatic ||
			!AllTrue[args, MatchQ[_Rule | _RuleDelayed]],
			Return[False]
		];
		default =
			Block[
				{
					ServiceFramework`$AuthenticationProvider =
						rocketChatAuthenticationProviderOption[args]
				},
				Quiet @ Check[SF`GetDefaultServiceObject[service], None]
			];
		MatchQ[default, _ServiceObject] &&
		!rocketChatValidAuthenticationQ[default["Authentication"]]
	];

rocketChatConnect[service_String, args___] :=
	If[rocketChatStaleDefaultConnectionQ[service, {args}],
		ServiceFramework`PackageScope`serviceConnect[service, "New", args],
		ServiceFramework`PackageScope`serviceConnect[service, args]
	];
rocketChatConnect[service_ServiceObject, args___] :=
	ServiceFramework`PackageScope`serviceConnect[service, args];

rocketChatLoginAuthentication[auth_Association] :=
	Enclose[
		Module[{host, response, data},
			host =
				ConfirmMatch[
					auth["Host"],
					_String?validRocketChatHostQ,
					"InvalidHost"
				];
			response =
				Confirm @
				SF`RequestExecute["RawLogin"][
					<|
						"host"     -> host,
						"user"     -> auth["User"],
						"password" -> auth["Password"]
					|>,
					ServiceObject[
						"Rocket.Chat",
						CreateUUID["LoginAuthentication-"]
					],
					True,
					CallingFunction -> ServiceConnect
				];
			data =
				ConfirmMatch[
					Lookup[response, "data", Missing["KeyAbsent", "data"]],
					_Association,
					"MissingAuthenticationData"
				];
			<|
				"Host"      -> host,
				"AuthToken" -> ConfirmMatch[
					Lookup[
						data,
						"authToken",
						Missing["KeyAbsent", "authToken"]
					],
					_String,
					"MissingAuthToken"
				],
				"UserID"    -> ConfirmMatch[
					Lookup[data, "userId", Missing["KeyAbsent", "userId"]],
					_String,
					"MissingUserID"
				]
			|>
		]
	];

connectionAuthentication[serviceObject_] :=
	Replace[serviceObject["Authentication"], Except[_Association] -> <||>];

connectionRequestParameterRules[validParams_List, serviceObject_] :=
	Module[{
			auth = connectionAuthentication[serviceObject]
		},
		Normal @
		Select[
			KeyTake[
				<|
					"host"       -> Lookup[auth, "Host", None],
					"authToken"  -> Lookup[auth, "AuthToken", None],
					"authUserId" -> Lookup[auth, "UserID", None]
				|>,
				validParams
			],
			UnsameQ[#, None]&
		]
	];

dropEmptyRequestParameters[params_] :=
	DeleteCases[
		Developer`ToList @ If[AssociationQ[params], List @@ params, params],
		(Rule | RuleDelayed)[_, (None | Automatic)]
	];

addConnectionRequestParameters[validParams_List, params_, serviceObject_] :=
	Join[
		connectionRequestParameterRules[validParams, serviceObject],
		dropEmptyRequestParameters[params]
	];

requestParameterNames[request_Association] :=
	DeleteDuplicates @
	Join[
		Lookup[request, "PathParameters", {}],
		Lookup[request, "HeadersParameters", {}],
		Lookup[request, "QueryParameters", {}],
		Lookup[request, "BodyParameters", {}] //
		(Developer`ToList @* Replace["ParameterlessBody" -> {}])
	];

processedRequestName[rawName_String] :=
	StringDelete[rawName, StartOfString ~~ "Raw"];

makeProcessedRequest[rawName_String, request_Association] :=
	With[{
			name = rawName,
			rawParameters = requestParameterNames[request],
			required =
				Complement[
					Lookup[request, "RequiredParameters", {}],
					$connectionParameterNames
				],
			parameterMap =
				requestParameterMap @
				DeleteCases[
					requestParameterNames[request],
					Alternatives @@ $connectionParameterNames
				]
		},
		<|
			"ExecuteFunction"       -> Function[
				{requestParams, serviceObject, options},
				With[{
						res =
							ServiceFramework`Request[name][
								addConnectionRequestParameters[
									rawParameters,
									requestParams,
									serviceObject
								],
								serviceObject,
								options
							]
					},
					If[FailureQ[res],
						res,
						Success[
							ToLowerCase[processedRequestName[name]] <>
							"-success",
							<|
								Replace[res, Except[_Association] -> <||>],
								"MessageTemplate"   -> "Request '`req`' execute success.",
								"MessageParameters" -> <|
									"req" -> processedRequestName[name]
								|>
							|>
						]
					]
				]
			],
			"SubmitFunction"        -> "ExecuteFunction",
			"Parameters"            -> (# -> Automatic& /@ Keys[parameterMap]),
			"RequiredParameters"    -> Lookup[
				AssociationThread[Values[parameterMap], Keys[parameterMap]],
				required,
				required
			],
			"ParameterMap"          -> parameterMap,
			"PreprocessingFunction" -> Identity
		|>
	];

rocketChatDisconnect[conn_ServiceObject, opts___] :=
	(
		Quiet @ ServiceExecute[conn, "Logout"];
		ServiceFramework`PackageScope`serviceDisconnect[conn, opts]
	);

End[];
EndPackage[];
