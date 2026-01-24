@ECHO OFF
REM - Add FAST.exe directory to Windows search path ---------------------------------
ECHO * Actual Windows search path is:
ECHO * ------------------------------
ECHO * %PATH%
ECHO *
	set PATH=%PATH%D:\FST_V3.0_ON\final\DLC_7.1\RANDSEED1;
ECHO * New Windows search path including FAST directory is:
ECHO * ----------------------------------------------------
ECHO * %PATH%
ECHO *
REM - Call FAST ---------------------------------------------------------------------
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_015.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_030.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_045.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_060.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_075.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_090.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_105.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_120.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_135.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_150.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_165.fst
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW_180.fst
PAUSE
EXIT /B
