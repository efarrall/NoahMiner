@echo off
cd /d "%~dp0"

if not exist server.jar (
  echo server.jar not found. Double-click scripts\download-server.bat first.
  pause
  exit /b 1
)

findstr /B /C:"eula=true" eula.txt >nul
if errorlevel 1 (
  echo You must accept the Minecraft EULA first.
  echo Open eula.txt in this folder and change eula=false to eula=true
  echo https://aka.ms/MinecraftEULA
  pause
  exit /b 1
)

echo Starting NoahMiner...
echo Minecraft 26.2 requires Java 25 or newer. Check with: java -version
echo Stop the server cleanly: type  stop  in this window, then wait for it to exit.
java -Xms2G -Xmx2G -jar server.jar nogui
pause
