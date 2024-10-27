@echo off
set "loganet_path=d:\Project\LoganetXIPTV"
set "playlists=LoganetXAll"
set "black_list=Общие Детские Новости Политические Хобби Религия Спорт Музыка"
set "final_file=\\192.168.1.1\Flash\IPTV.m3u8"
set LB=^


cd /d %loganet_path%
git pull
echo/

rem #EXTM3U from LoganetXAll
set /p extm3u=< %loganet_path%\LoganetXAll.m3u
>%final_file% echo %extm3u%
rem echo without newline
<nul set /p =%final_file% is created

SETLOCAL ENABLEDELAYEDEXPANSION
for %%n in (%playlists%) do (
	set /a "channels_count=0"
	set "playlist_path=%loganet_path%\%%n.m3u"
	(for /f "skip=1 delims=" %%r in (!playlist_path!) do (
		set "row=%%r"

		if "!row:~0,7!"=="#EXTINF" (
			set "row=!row:&=^&!"
			echo:!row!| findstr /i /r /c:"[1-9]k$" /c:"[1-9]k[ ]" /c:"hd$" /c:"hd[ ]" >nul 2>&1
			if errorlevel 1 (
				set "is_filtered="
			) else (
				set "is_filtered=true"
				for %%c in (%black_list%) do (
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
	))>>%final_file%

	<nul set /p =,!LB! filled with !channels_count! high-quality channels from "!playlist_path!"
)
echo:.
