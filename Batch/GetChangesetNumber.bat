@echo off

set _aPath="%1"
set _TFPath="%VS120COMNTOOLS%..\IDE\TF.exe"
if not exist %_TFPath% set set _TFPath="%VS110COMNTOOLS%..\IDE\TF.exe"
if not exist %_TFPath% set set _TFPath="%VS100COMNTOOLS%..\IDE\TF.exe"
if not exist %_TFPath% echo "VS was not installed!"&&exit /b 2

pushd %_aPath%
%_TFPath% history . /r /noprompt /stopafter:1 /Version:W > %temp%\cs.temp
FOR /f "tokens=1" %%a in ('findstr /R "^[0-9][0-9]*" %temp%\cs.temp') do echo %%a
del %temp%\cs.temp
popd