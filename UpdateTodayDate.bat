@echo off
setlocal enableDelayedExpansion

:: Set the target folder
set "TARGET_FOLDER=D:\Hub\"

:: Ensure the target folder exists
if not exist "%TARGET_FOLDER%" (
    echo Error: Target folder "%TARGET_FOLDER%" does not exist. Please create it before running.
    goto :eof
)

:: --- Get Current Date (YYYYMMDD) ---
:: Using WMIC for robust date retrieval, independent of locale settings.
for /f "skip=1 tokens=1-6" %%a in ('wmic path Win32_LocalTime get Day^,Month^,Year /value') do (
    for /f "tokens=* delims==" %%i in ("%%a") do set %%i
    for /f "tokens=* delims==" %%i in ("%%b") do set %%i
    for /f "tokens=* delims==" %%i in ("%%c") do set %%i
)
set "CurrentDay_raw=%Day%"
set "CurrentMonth_raw=%Month%"
set "CurrentYear_raw=%Year%"

:: Format month and day to two digits (e.g., 01, 07)
if !CurrentMonth_raw! LSS 10 (set "CurrentMonth=0!CurrentMonth_raw!") else (set "CurrentMonth=!CurrentMonth_raw!")
if !CurrentDay_raw! LSS 10 (set "CurrentDay=0!CurrentDay_raw!") else (set "CurrentDay=!CurrentDay_raw!")
set "CurrentYear=!CurrentYear_raw!"

:: Define today's file name
set "TODAY_FILE_NAME=Today_is_!CurrentYear!!CurrentMonth!!CurrentDay!.txt"
set "FULL_TODAY_FILE_PATH=%TARGET_FOLDER%!TODAY_FILE_NAME!"

:: --- Get Yesterday's Date (YYYYMMDD) ---
:: Using PowerShell to get yesterday's date
for /f "usebackq" %%i in (`powershell -command "(Get-Date).AddDays(-1).ToString('yyyyMMdd')"`) do set "YESTERDAY_DATE_FORMATTED=%%i"

:: Define yesterday's file name
set "YESTERDAY_FILE_NAME=Today_is_!YESTERDAY_DATE_FORMATTED!.txt"
set "FULL_YESTERDAY_FILE_PATH=%TARGET_FOLDER%!YESTERDAY_FILE_NAME!"


:: --- File Processing ---

echo Processing folder: "%TARGET_FOLDER%"

:: Check if yesterday's file exists, if so, delete it
if exist "%FULL_YESTERDAY_FILE_PATH%" (
    echo Found yesterday's file: "!YESTERDAY_FILE_NAME!"
    echo Deleting yesterday's file...
    del "%FULL_YESTERDAY_FILE_PATH%"
    if not exist "%FULL_YESTERDAY_FILE_PATH%" (
        echo Yesterday's file deleted successfully.
    ) else (
        echo Error: Failed to delete yesterday's file.
    )
) else (
    echo Yesterday's file not found: "!YESTERDAY_FILE_NAME!"
)

:: Create today's file (regardless of whether yesterday's file existed or was deleted)
echo Creating today's file: "!TODAY_FILE_NAME!"
type nul > "%FULL_TODAY_FILE_PATH%"
if exist "%FULL_TODAY_FILE_PATH%" (
    echo Today's file created successfully.
) else (
    echo Error: Failed to create today's file.
)

echo Script execution completed.
endlocal
