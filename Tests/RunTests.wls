#!/usr/bin/wolframscript

(* RunTests.wls
   Command-line entry point for the ToneAr/RocketChat integration test suite.

   Usage (from the paclet root):
       wolframscript -file Tests/RunTests.wls

   Optional environment variables:
       RC_HOST        RocketChat URL            (default: http://localhost:3100)
       RC_ADMIN_USER  Admin username            (default: rc_admin)
       RC_ADMIN_PASS  Admin password            (default: Test1234!)
       RC_TIMEOUT     Server readiness timeout  (default: 120 s)
       RC_NO_DOCKER   Set to "1" to skip Docker start/stop management

   Exit codes:
       0  all tests passed
       1  one or more tests failed or errored
       2  setup failed (server unreachable, paclet install error, etc.)
*)
(* -- Locate the paclet root ----------------------------------------------- *)
$pacletRoot =
	ParentDirectory @ DirectoryName @ AbsoluteFileName[$InputFileName];

$testsDir = FileNameJoin[{$pacletRoot, "Tests"}];

(* -- Load the test helpers first so $rcHost etc. are available ------------- *)
PacletDirectoryLoad[$pacletRoot];
Get["ToneAr`RocketChat`"];
Get[FileNameJoin[{$testsDir, "TestHelpers.wl"}]];

$timeout = ToExpression[Replace[Environment["RC_TIMEOUT"], $Failed -> "120"]];

(* -- Optionally start Docker ----------------------------------------------- *)
$manageDocker = (Environment["RC_NO_DOCKER"] =!= "1");

If[$manageDocker, Print["Starting Docker stack ..."];
With[{rc = Run["bash " <> FileNameJoin[{$testsDir, "setup.sh"}]]},
	If[rc =!= 0,
		Print["ERROR: Docker setup failed (exit code: ", rc, ")."]; Exit[2]
	]
]];

(* -- Run the test suite ---------------------------------------------------- *)
Print["Running test suite ..."];

$report =
	TestReport[
		FileNameJoin[{$testsDir, "RocketChatTests.wlt"}],
		TimeConstraint -> 600
		(* 10 min total *)
	];

(* -- Print summary --------------------------------------------------------- *)
Print["\n===================================="];
Print["Test Report Summary"];
Print["======================================"];
Print[
	"Tests run     : ",
	$report["TestsSucceededCount"] + $report["TestsFailedCount"]
];
Print["Passed        : ", $report["TestsSucceededCount"]];
Print["Failed        : ", $report["TestsFailedCount"]];
Print["Errored       : ", $report["TestsFailedWithErrorsCount"]];
Print["======================================\n"];

(* Print details of any failures *)
If[$report["TestsFailedCount"] > 0 || $report["TestsFailedWithErrorsCount"] > 0,
	Print["FAILURES:"];
	Scan[
		Function[
			tr,
			If[tr["Outcome"] =!= "Success",
				Print["  FAIL  [", tr["TestID"], "]"];
				Print["    Failure  : ", tr["FailureType"]];
				Print["    Input    : ", InputForm[tr["Input"]]];
				Print["    Expected : ", InputForm[tr["ExpectedOutput"]]];
				Print["    Actual   : ", InputForm[tr["ActualOutput"]]];
				Print[]
			]
		],
		Values @ $report["TestResults"]
	]
];

(* -- Optionally stop Docker ------------------------------------------------ *)
If[$manageDocker, Print["Stopping Docker stack ..."];
Run["bash " <> FileNameJoin[{$testsDir, "teardown.sh"}]]];

(* -- Exit with appropriate code ------------------------------------------- *)
If[$report["AllTestsSucceeded"],
	Print["All tests passed."]; Exit[0],
	Print["Some tests failed."]; Exit[1]
]
