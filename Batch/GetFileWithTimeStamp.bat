set timestamp=%date:~10,4%-%date:~4,2%-%date:~7,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%
echo %%1: %1
echo %%2: %2
echo %%3: %3
echo %%4: %4
echo %%TEMP%%: %TEMP%

set log="%TEMP%\Setup_%timestamp%.log"
echo Log file: %log%