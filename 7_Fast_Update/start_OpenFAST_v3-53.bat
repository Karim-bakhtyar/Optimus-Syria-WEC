@ECHO OFF
REM - Add FAST.exe directory to Windows search path ---------------------------------
ECHO * Actual Windows search path is:
ECHO * ------------------------------
ECHO * %PATH%
ECHO *
	set PATH=%PATH%C:\Users\moham\Desktop\Load Optimus syria\DLC 4.X\4.2\eog_25ms;
ECHO * New Windows search path including FAST directory is:
ECHO * ----------------------------------------------------
ECHO * %PATH%
ECHO *
REM - Call FAST ---------------------------------------------------------------------
	OpenFAST_v3-53_x64 OPTSyria5MW.fst
PAUSE
EXIT /B
