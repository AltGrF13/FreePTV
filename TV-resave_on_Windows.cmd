@echo off
set "LOGANET_PATH=d:\Project\LoganetXIPTV"
set "PLAYLISTS=LoganetXAll"
set FAVORITES="Viju Nature HD","Animal Planet HD"
set "BLACK_LIST=Общие Детские Новости Политические Хобби Религия Спорт Музыка"
set "FINAL_FILE=\\192.168.1.1\Flash\IPTV.m3u8"
set LB=^


cd /d %LOGANET_PATH%
git pull
echo/

rem #EXTM3U from LoganetXAll
set /p extm3u=< %LOGANET_PATH%\LoganetXAll.m3u
>%FINAL_FILE% echo %extm3u%
rem echo without newline
<nul set /p =%FINAL_FILE% is created

SETLOCAL ENABLEDELAYEDEXPANSION

for %%n in (%PLAYLISTS%) do (
	set /a "channels_count=0"
	set "playlist_path=%LOGANET_PATH%\%%n.m3u"
	(for /f "skip=1 delims=" %%r in (!playlist_path!) do (
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

	<nul set /p =,!LB! filled with !channels_count! favorites channels from "!playlist_path!"
)
for %%n in (%PLAYLISTS%) do (
	set /a "channels_count=0"
	set "playlist_path=%LOGANET_PATH%\%%n.m3u"
	(for /f "skip=1 delims=" %%r in (!playlist_path!) do (
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

	<nul set /p =,!LB! filled with !channels_count! high-quality channels from "!playlist_path!"
)
echo:.
