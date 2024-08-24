@echo off
setlocal


REM Replace it with the URL of your file
set "filePath=http://example.com/file.zip"  

REM Replace with the destination path
set "destinationPath=C:\users\qwer\file.zip"  

set "taskName="

:checkTask
REM Getting the name of the first BITS task
for /f "tokens=1" %%i in ('bitsadmin /list  ^| findstr /i "TRANSFER"') do (
    set "taskName=%%i"
    goto :taskFound
)

echo The BITS tasks were not found. Waiting 5 seconds before re-checking...
timeout /t 5 >nul
goto checkTask

:taskFound
echo The task name was found: %taskName%

REM Transferring the task to the suspend status
echo Suspending a task "%taskName%"...
bitsadmin /suspend "%taskName%"

REM Adding a file to download
echo Adding the file "%filePath%" for download...
bitsadmin /addfile "%taskName%" "%filePath%" "%destinationPath%"

REM Resuming a task
echo Resuming a task "%taskName%"...
bitsadmin /resume "%taskName%"

echo Done.
endlocal
