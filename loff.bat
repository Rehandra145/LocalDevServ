@echo off
:: Check if script is running as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    :: Start elevated process hidden but keep original window
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0 elevated' -Verb RunAs -WindowStyle Hidden"
    :: Keep original window open
    goto end
)

:: Check if this is the elevated instance
if "%1"=="elevated" goto elevated

:elevated
echo      STOPPING APACHE & MYSQL SERVICES    
echo.
:: Hentikan Apache
sc query Apache2.4 | find "RUNNING" >nul
if %errorLevel% equ 0 (
    echo Stopping Apache...
    sc stop Apache2.4 >nul 2>&1
    timeout /t 2 /nobreak >nul
    powershell -Command "Write-Host '[+] Apache Stopped!' -ForegroundColor Green"
) else (
    powershell -Command "Write-Host '[-] Apache is not running.' -ForegroundColor Red"
)
:: Hentikan MySQL
sc query mysql80 | find "RUNNING" >nul
if %errorLevel% equ 0 (
    echo Stopping MySQL...
    sc stop mysql80 >nul 2>&1
    timeout /t 2 /nobreak >nul
    powershell -Command "Write-Host '[+] MySQL Stopped!' -ForegroundColor Green"
) else (
    powershell -Command "Write-Host '[-] MySQL is not running.' -ForegroundColor Red"
)
:: Pastikan semua proses Apache & MySQL benar-benar mati
echo.
echo Cleaning Up Remaining Processes...
taskkill /F /IM httpd.exe /T >nul 2>&1
taskkill /F /IM mysqld.exe /T >nul 2>&1
taskkill /F /IM mysqld-nt.exe /T >nul 2>&1
taskkill /F /IM mysqld-debug.exe /T >nul 2>&1
powershell -Command "Write-Host '[+] Cleanup Complete!' -ForegroundColor Green"
:: Informasi task selesai
echo.
powershell -Command "Write-Host '[+] All Services Successfully Stopped!' -ForegroundColor Green"

:: If this is elevated instance, signal to original window and exit
if "%1"=="elevated" (
    :: Create a temporary file to signal completion
    echo completed > "%TEMP%\services_stopped.tmp"
    exit
)

:end
:: Original window waits for signal from elevated process
echo Please wait while services are being stopped...
:waitloop
if exist "%TEMP%\services_stopped.tmp" (
    del "%TEMP%\services_stopped.tmp"
    echo.
    powershell -Command "Write-Host '[+] All Services Successfully Stopped!' -ForegroundColor Green"
) else (
    timeout /t 1 /nobreak >nul
    goto waitloop
)