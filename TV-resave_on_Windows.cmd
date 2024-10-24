@echo off
set "loganet_path=d:\Project\LoganetXIPTV"
set "loganet_playlists=LoganetXMovie LoganetXInfo"
set "final_file=\\ROUTER\Flash\IPTV.m3u8"

cd /d %loganet_path%
git pull
echo/

set /p extm3u=< %loganet_path%\LoganetXAll.m3u
>%final_file% echo %extm3u%

SETLOCAL ENABLEDELAYEDEXPANSION
(for %%n in (%loganet_playlists%) do (
    set "playlist_path=%loganet_path%\%%n.m3u"
    for /f "skip=1 delims=" %%r in (!playlist_path!) do (
        echo %%r
    )
))>>%final_file%
