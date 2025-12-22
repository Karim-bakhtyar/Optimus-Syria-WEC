@ECHO OFF
REM - Add FAST.exe directory to Windows search path ---------------------------------
ECHO * Actual Windows search path is:
ECHO * ------------------------------
ECHO * %PATH%
ECHO *
	set PATH=%PATH%D:\FST_V3.0_ON\DLC_5.1\12.4ms\RANSEED_1;
ECHO * New Windows search path including FAST directory is:
ECHO * ----------------------------------------------------
ECHO * %PATH%
ECHO *
REM - Call FAST ---------------------------------------------------------------------
	OpenFAST_x64_v3-0-lidarSim OPTSyria5MW.fst
PAUSE
EXIT /B
