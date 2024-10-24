@echo off
set "loganet_path=d:\Project\LoganetXIPTV"
set "loganet_playlists=LoganetXMovie LoganetXInfo"
set "final_file=\\ROUTER\Flash\IPTV.m3u8"

cd /d %loganet_path%
git pull
echo/

rem #EXTM3U from LoganetXAll
set /p extm3u=< %loganet_path%\LoganetXAll.m3u
>%final_file% echo %extm3u%
rem echo without newline
<nul set /p =%final_file% created

set /a "channels_count=0"
SETLOCAL ENABLEDELAYEDEXPANSION
(for %%n in (%loganet_playlists%) do (
	set "playlist_path=%loganet_path%\%%n.m3u"
	for /f "skip=1 delims=" %%r in (!playlist_path!) do (
		set "row=%%r"

		if "!row:~0,7!"=="#EXTINF" (
			rem problem with ampersand
			set "row=!row:&=!"

			echo:!row!| findstr /i /r "[248]k\s*$ hd\s*$" >nul 2>&1
			if errorlevel 1 (
				set "is_quality="
			) else (
				set "is_quality=true"

				set /a "channels_count=!channels_count!+1"
			)
		)

		if defined is_quality (
			echo:%%r
		)
	)
))>>%final_file%
echo: and filled with !channels_count! channels
