@echo off
setlocal
cd /d "%~dp0"

if exist .git (
  git rev-parse HEAD >nul 2>&1
  if errorlevel 1 (
    echo Trovata una cartella .git incompleta/corrotta da un tentativo precedente.
    echo La rimuovo e riparto da zero...
    rmdir /s /q .git
  ) else (
    echo Repository git gia' presente e funzionante in questa cartella. Non rifaccio l'init.
    echo Usa publish.bat per pubblicare le modifiche.
    pause
    exit /b 0
  )
)

echo ============================================
echo  Setup git per EquaVoce - "E voi... lo sapevate?"
echo ============================================
echo.

echo Inizializzo il repository git...
git init
if errorlevel 1 goto :error

git config user.name "Marco Paleari"
git config user.email "seriousjoker@libero.it"

echo Collego il repository GitHub esistente...
git remote add origin https://github.com/MarcoPaleari/marcopaleari.github.io.git
if errorlevel 1 goto :error

echo Scarico la storia gia' presente su GitHub...
git fetch origin
if errorlevel 1 goto :error

echo Salvo lo stato attuale della cartella (sito + immagini)...
git add -A
git commit -m "Contenuto sito aggiornato (setup iniziale sincronizzazione)"
if errorlevel 1 goto :error

echo Unisco con la storia gia' presente online (LICENSE, README, foto profilo)...
git merge origin/main --allow-unrelated-histories -m "Merge storia esistente del repo GitHub" --no-edit
if errorlevel 1 (
  echo.
  echo Trovati conflitti tra la versione locale e quella online.
  echo Questo e' normale ed atteso per index.html, style.css e songs.json ^(anche solo per fine riga LF/CRLF^): tengo la TUA versione locale, piu' recente.
  git checkout --ours index.html
  git checkout --ours style.css
  git checkout --ours songs.json
  git add index.html style.css songs.json
  git commit --no-edit
  if errorlevel 1 (
    echo.
    echo Ci sono altri conflitti oltre a index.html/style.css/songs.json.
    echo Aprili con un editor, cerca le righe "^<^<^<^<^<^<^<", risolvi a mano,
    echo poi lancia: git add . ^&^& git commit
    goto :error
  )
)

echo Allineo il nome del branch locale a "main" (come su GitHub)...
git branch -M main
git branch --set-upstream-to=origin/main main >nul 2>&1

echo.
echo ============================================
echo  Fatto! Il repository locale e' pronto e allineato con GitHub.
echo  Da ora in poi usa publish.bat ogni volta che vuoi pubblicare
echo  le modifiche sul sito online.
echo ============================================
pause
exit /b 0

:error
echo.
echo ERRORE durante il setup. Controlla il messaggio sopra e riprova.
echo Se il problema persiste, verifica di avere git installato e di essere
echo autenticato su GitHub (potrebbe aprirsi una finestra di login al primo git fetch/push).
pause
exit /b 1
