@echo off
rem Carimbo - inicia o servidor no seu computador (Windows). Nao testado em Windows: escrito a partir dos comandos padrao.
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js nao encontrado.
  echo Instale a versao LTS em https://nodejs.org, feche esta janela e abra o iniciar.bat de novo.
  pause
  exit /b 1
)
where ffmpeg >nul 2>nul
if errorlevel 1 (
  echo FFmpeg nao encontrado.
  echo Abra o Prompt de Comando e rode:  winget install Gyan.FFmpeg
  echo Depois feche tudo e abra o iniciar.bat de novo.
  pause
  exit /b 1
)
start "Carimbo - NAO FECHE ESTA JANELA enquanto estiver usando" node server.js
timeout /t 3 /nobreak >nul
start "" http://localhost:3000
