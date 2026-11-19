@echo off
setlocal EnableDelayedExpansion

echo ==========================================================
echo        Unquoted Service Path Enumeration (CMD Only)
echo ==========================================================
echo.

for /f "tokens=2 delims=:" %%S in ('sc query state^= all ^| findstr "SERVICE_NAME"') do (

    set "SERVICE=%%S"
    set "SERVICE=!SERVICE:~1!"

    set "DISPLAY="
    set "PATH="
    set "ACCOUNT="
    set "START="

    for /f "tokens=1,* delims=:" %%A in ('sc qc "!SERVICE!"') do (

        set "KEY=%%A"
        set "VAL=%%B"
        set "VAL=!VAL:~1!"

        if "!KEY!"=="DISPLAY_NAME" set "DISPLAY=!VAL!"
        if "!KEY!"=="BINARY_PATH_NAME" set "PATH=!VAL!"
        if "!KEY!"=="SERVICE_START_NAME" set "ACCOUNT=!VAL!"
        if "!KEY!"=="START_TYPE" set "START=!VAL!"
    )

    REM Skip quoted paths
    echo !PATH! | findstr /b "\"" >nul
    if errorlevel 1 (

        REM Must contain spaces
        echo !PATH! | findstr " " >nul
        if not errorlevel 1 (

            REM Ignore Windows directory
            echo !PATH! | findstr /i "\\Windows\\" >nul
            if errorlevel 1 (

                echo --------------------------------------------------------
                echo Service      : !SERVICE!
                echo Display Name : !DISPLAY!
                echo Start Mode   : !START!
                echo Run As       : !ACCOUNT!
                echo Binary Path  : !PATH!
                echo.
            )
        )
    )
)

echo Finished.
pause