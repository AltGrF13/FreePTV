@echo off
set "resave_filename=TV-resave_on_Windows.cmd"

set "resave_file=%~dp0%resave_filename%"
if not exist %resave_file% (
	echo: Download https://raw.githubusercontent.com/AltGrF13/FreePTV/refs/heads/main/%resave_filename%
	echo: in %~dp0
	echo: and try again

	exit /b 1
)
call %resave_file%

start %final_file%
