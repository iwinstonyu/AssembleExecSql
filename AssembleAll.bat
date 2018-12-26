@echo off

set "mysql_exe=D:/Program Files (x86)/MySQL/MySQL Server 5.7/bin/mysql"
set "host=172.24.140.38"
set "user=lp"
set "pwd=123"
set "port=3308"
set "db=lobby_slg_qa1"
set "in_path=../2018.12.27"
set "out_path=%in_path%.sql"
set "log_path=%in_path%.log"

echo Input path: %in_path%
echo Output path: %out_path%
echo Log path: %log_path%

set "out_path_bslash=%out_path:/=\\%"
set "log_path_bslash=%log_path:/=\\%"

echo Output path with back slash: %out_path_bslash%
echo Log path with back slash: %log_path_bslash%
echo ===================================
echo.

echo Clear old files
if exist "%out_path_bslash%" del "%out_path_bslash%"
if exist "%log_path_bslash%" del "%log_path_bslash%"
timeout 1
echo ===================================
echo.

echo Update from svn
svn update %in_path%
if %ERRORLEVEL% NEQ 0 (
	echo Fail update from svn
	goto end
)
echo ===================================
echo.

echo Assemble sql files
AssembleAll.py -i"%in_path%" -o"%out_path%"
if %ERRORLEVEL% NEQ 0 (
	echo Fail assemble sql files
	goto end
)
echo ===================================
echo.

echo Execute sql file
"%mysql_exe%" -h%host% -u%user% -p%pwd% -P%port% -e"use %db%; set names utf8; select now(); source %out_path%; select 'End %out_path%'" -f
echo ===================================
echo.

:end
pause