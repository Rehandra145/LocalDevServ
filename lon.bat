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
echo      STARTING APACHE & MYSQL SERVICES    
echo.
:: Start Apache
sc query Apache2.4 | find "RUNNING" >nul
if %errorLevel% equ 0 (
    powershell -Command "Write-Host '[-] Apache is already running.' -ForegroundColor Yellow"
) else (
    echo Starting Apache...
    sc start Apache2.4 >nul 2>&1
    timeout /t 2 /nobreak >nul
    powershell -Command "Write-Host '[+] Apache Started!' -ForegroundColor Green"
)
:: Start MySQL
sc query mysql80 | find "RUNNING" >nul
if %errorLevel% equ 0 (
    powershell -Command "Write-Host '[-] MySQL is already running.' -ForegroundColor Yellow"
) else (
    echo Starting MySQL...
    sc start mysql80 >nul 2>&1
    timeout /t 2 /nobreak >nul
    powershell -Command "Write-Host '[+] MySQL Started!' -ForegroundColor Green"
)

:: Connect to MySQL with root
echo.
echo Connecting to MySQL...
powershell -Command "Start-Process 'cmd' -ArgumentList '/c mysql -u root -pSUZULYTDR' -NoNewWindow -Wait"

:: Task completion information
echo.
powershell -Command "Write-Host '[+] All Services Successfully Started!' -ForegroundColor Green"

:: If this is elevated instance, signal to original window and exit
if "%1"=="elevated" (
    :: Create a temporary file to signal completion
    echo completed > "%TEMP%\services_started.tmp"
    exit
)

:end
:: Original window waits for signal from elevated process

powershell -Command "Write-Host '[+] All service started' -ForegroundColor Green"