@echo off

set "removeheic=false"
set scriptdir=%~dp0

if ["%~1"] == ["-r"] (set "removeheic=true" & shift)
if ["%~1"] == ["--remove"] (set "removeheic=true" & shift)
if ["%~1"] == [""] (echo Nothing was specified. Please specify something. & goto help)
if ["%~1"] == ["-h"] goto help
if ["%~1"] == ["--help"] goto help
if ["%~1"] == ["-v"] goto version
if ["%~1"] == ["--version"] goto version
if ["%~1"] == ["--install"] goto pyinstall
if ["%~1"] == ["--uninstall"] goto pyremove

:conversion
if NOT EXIST "%~1" (echo File does not exist. & goto :eof)
cd "%~dp1"
md "%~n1"
python "%scriptdir%\extract_heic.py" "%~nx1" "%~n1"
python "%scriptdir%\convert_to_json.py" "%~n1"
cd "%~n1_wdd"
ren "%~n1_wdd".json theme.json
cd ..
rd /s /q "%~n1"
rd /s /q "%~n1_wdd"
if [%removeheic%] == [true] (del /q "%~nx1")
if NOT ["%~n2"] == [""] (shift) else (goto :eof)
goto conversion

:pyinstall
echo Installing python requirements...
pip install bs4 lxml Wand beautifulsoup4
goto :eof

:pyremove
echo Removing python requirements...
pip uninstall bs4 lxml Wand beautifulsoup4 -y
goto :eof

:help
echo.
echo Usage^: heic2ddw 0.2-alpha ^[^<options^>^] ^[^<files^>^]
echo.
echo Options:
echo  -h ^[--help^]         Shows this help message.
echo  --install           Installs python requirements.
echo  --uninstall         Uninstalls python requirements.
echo  -r ^[--remove^]       Deletes heic files after conversion.
echo  -v ^[--version^]       Prints heic2ddw version.
echo.
goto :eof

:version
echo.
echo. heic2ddw Ver. 0.2-alpha.
echo.
goto :eof
