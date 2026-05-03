@echo off
REM ====================================================================
REM Paperclip Holding - Local Windows Launcher
REM ====================================================================
REM Onkosul:
REM   1. Windows Developer Mode ON (Settings -> Privacy -> For developers)
REM   2. C:\pcbin\claude.cmd wrapper var (claude-wrapper.cmd.template'tan
REM      kopyala, API key'i doldur)
REM   3. Paperclip data dir initialize edilmis: ~/.paperclip/instances/default
REM ====================================================================

set PATH=C:\pcbin;%PATH%
cd /d C:\PaperClip

REM Eger user profile'in 8.3 short name'i farkliysa asagidaki yolu degistir
REM (FERHAN~1 -> %USERPROFILE%'in kisa adi)
REM dir /X %USERPROFILE%\.. ile bulabilirsiniz
set PAPERCLIP_DATA=C:\Users\FERHAN~1\.paperclip

echo.
echo Starting Paperclip Holding...
echo Data: %PAPERCLIP_DATA%
echo URL : http://127.0.0.1:3100
echo.

npx --yes paperclipai run -d "%PAPERCLIP_DATA%"

pause
