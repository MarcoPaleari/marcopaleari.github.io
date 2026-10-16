@echo off
setlocal
cd /d "%~dp0"

if not exist .git (
  echo Repository git non trovato in questa cartella.
  echo Lancia prima git_setup.bat una volta sola, poi riprova.
  pause
  exit /b 1
)

echo ============================================
echo  Pubblicazione sito EquaVoce
echo ============================================
echo.

echo Aggiungo le modifiche ai file del sito pubblico...
git add index.html style.css songs.json copertine spotify_codes LICENSE README.md "Marco Paleari.JPEG"

git diff --cached --quiet
if not errorlevel 1 (
  echo Nessuna modifica da pubblicare.
  pause
  exit /b 0
)

git commit -m "Aggiornamento contenuti sito - %date% %time%"
if errorlevel 1 goto :error

echo Pubblico su GitHub...
git branch -M main
git push -u origin main
if errorlevel 1 goto :error

echo.
echo ============================================
echo  Fatto! Il sito si aggiornerà su
echo  https://marcopaleari.github.io/
echo  entro un paio di minuti.
echo ============================================
pause
exit /b 0

:error
echo.
echo ERRORE durante la pubblicazione.
echo Controlla la connessione internet o le credenziali GitHub
echo (al primo push potrebbe aprirsi una finestra di login).
pause
exit /b 1
