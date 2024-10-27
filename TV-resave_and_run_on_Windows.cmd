@echo off
set "RESAVE_FILENAME=TV-resave_on_Windows.cmd"

set "RESAVE_FILE=%~dp0%RESAVE_FILENAME%"
if not exist %RESAVE_FILE% (
	echo: Download https://raw.githubusercontent.com/AltGrF13/FreePTV/refs/heads/main/%RESAVE_FILENAME%
	echo: in %~dp0
	echo: and try again

	exit /b 1
)
call %RESAVE_FILE%

start %FINAL_FILE%
