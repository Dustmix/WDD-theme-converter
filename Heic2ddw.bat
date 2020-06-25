@echo off

if ["%~n1"] == [""] goto noparameters
if ["%~n1"] == [-i] goto pyinstall

cd "%~p1"
md "%~n1"
python "%~dp0\extract_heic.py" "%~nx1" "%~n1"
python "%~dp0\convert_to_json.py" "%~n1"
cd "%~n1_wdd"
ren "%~n1_wdd".json theme.json
cd ..
rd /s /q "%~n1"
rd /s /q "%~n1_wdd"
goto exit

:pyinstall
echo Installing python requirements...
pip install bs4 lxml Wand
goto exit

:noparameters
echo No parameters specified. Exiting...
goto exit

:exit
timeout /nobreak /t 3 > nul
goto :eof