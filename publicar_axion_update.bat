@echo off
setlocal ENABLEDELAYEDEXPANSION

echo ==========================================
echo   PUBLICADOR DE ATUALIZACAO - AXION UNLOCKER
echo ==========================================
echo.

REM =============================
REM CONFERE SE ESTA EM UM REPO GIT
REM =============================
git rev-parse --is-inside-work-tree >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERRO: Esta pasta nao e um repositorio Git.
    pause
    exit /b
)

echo Repositorio Git encontrado.
echo.

REM =============================
REM PEDIR VERSAO
REM =============================
set /p AX_VERSION=Digite a nova versao do Axion Unlocker (ex: 1.0.5): 

if "%AX_VERSION%"=="" (
    echo Versao invalida.
    pause
    exit /b
)

echo.
echo Publicando versao %AX_VERSION%...
echo.

REM =============================
REM ATUALIZAR version.json
REM =============================
if exist version.json (
    powershell -Command ^
        "$v = Get-Content version.json | ConvertFrom-Json;" ^
        "$v.version = '%AX_VERSION%';" ^
        "$v.axion_release = 'v%AX_VERSION%';" ^
        "$v | ConvertTo-Json -Depth 10 | Set-Content version.json"
    echo version.json atualizado.
)

REM =============================
REM ADD EXE + JSONS
REM =============================
git add -f AxionUnlocker.exe version.json changelog.json >nul 2>&1

REM =============================
REM COMMIT
REM =============================
git diff --cached --quiet
if %ERRORLEVEL%==0 (
    echo Nenhuma alteracao detectada. Nada para commitar.
) else (
    git commit -m "Update Axion Unlocker para versao %AX_VERSION%" >nul 2>&1
    echo Commit criado com sucesso.
)

REM =============================
REM PUSH
REM =============================
echo.
echo Enviando para o GitHub...
git push

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERRO ao enviar para o GitHub.
    echo Execute: git pull --rebase
    echo e rode este BAT novamente.
    pause
    exit /b
)

echo.
echo ==========================================
echo  Publicacao concluida - v%AX_VERSION%
echo ==========================================
pause
endlocal
