@echo off
set "PLAYLISTS=https://raw.githubusercontent.com/blackbirdstudiorus/LoganetXIPTV/refs/heads/main/LoganetXAll.m3u https://raw.githubusercontent.com/blackbirdstudiorus/LoganetXIPTV/refs/heads/main/LoganetXStrawberry.m3u"
set FAVORITES="Viju Nature HD","Animal Planet HD"
set "BLACK_LIST=Общие Детские Новости Политические Хобби Религия Спорт Музыка"
set "FINAL_FILE=\\192.168.1.1\Flash\IPTV.m3u8"
set LB=^


SETLOCAL ENABLEDELAYEDEXPANSION
cd /d %~dp0

set "RUN_FILENAME=TV-resave_and_run_on_Windows.cmd"
if not exist "%RUN_FILENAME%" (
	curl -O "https://raw.githubusercontent.com/AltGrF13/FreePTV/refs/heads/main/%RUN_FILENAME%"
)

if exist "*.m3u" (
	del /f *.m3u
	echo:*.m3u are deleted in "%~dp0"
)

for %%p in (%PLAYLISTS%) do (
	curl -O %%p
)

>%FINAL_FILE% echo:#EXTM3U url-tvg="https://iptvx.one/EPG"
rem echo without newline
<nul set /p =%FINAL_FILE% is created

for /r %~dp0 %%f in (*.m3u) do (
	set /a "channels_count=0"
	(for /f "skip=1 delims=" %%r in (%%f) do (
		set "row=%%r"

		if "!row:~0,7!"=="#EXTINF" (
			set "row=!row:&=^&!"
			set "is_favorites="
			for %%c in (%FAVORITES%) do (
				set "str=%%c"
				echo:!row!| findstr /i /c:"!str:~1,-1!" >nul 2>&1 && (
					set "is_favorites=true"
				)
			)

			if defined is_favorites (
				set /a "channels_count=!channels_count!+1"
			)
		)

		if defined is_favorites (
			echo:%%r
		)
	))>>%FINAL_FILE%

	<nul set /p =,!LB! filled with !channels_count! favorites channels from "%%f"
)
for /r %~dp0 %%f in (*.m3u) do (
	set /a "channels_count=0"
	(for /f "skip=1 delims=" %%r in (%%f) do (
		set "row=%%r"

		if "!row:~0,7!"=="#EXTINF" (
			set "row=!row:&=^&!"
			echo:!row!| findstr /i /r /c:"[1-9]k$" /c:"[1-9]k[ ]" /c:"hd$" /c:"hd[ ]" >nul 2>&1
			if errorlevel 1 (
				set "is_filtered="
			) else (
				set "is_filtered=true"
				for %%c in (%BLACK_LIST%) do (
					if not "x!row:%%c=!"=="x!row!" (
						set "is_filtered="
					)
				)

				if defined is_filtered (
					set /a "channels_count=!channels_count!+1"
				)
			)
		)

		if defined is_filtered (
			echo:%%r
		)
	))>>%FINAL_FILE%

	<nul set /p =,!LB! filled with !channels_count! high-quality channels from "%%f"
)
echo:.
