@echo off
setlocal EnableDelayedExpansion

set input=%~dp0input-day1.txt

call:get_unique_file "%~dp0temp" "tmp" tempFile

:: Left Numbers
for /f "eol= tokens=1-2 delims= " %%a in (%input%) do (
	echo %%a >> %tempFile%
)

set /a leftNumCount = 0

for /f "usebackq tokens=1 delims= " %%a in (`sort %tempFile%`) do (
	set /a left[!leftNumCount!] = %%a
	set /a leftNumCount += 1
)

break > %tempFile%

:: Right Numbers
for /f "eol= tokens=1-2 delims= " %%a in (%input%) do (
	echo %%b >> %tempFile%
)

set /a rightNumCount = 0

for /f "usebackq tokens=1 delims= " %%a in (`sort %tempFile%`) do (
	set /a right[!rightNumCount!] = %%a
	set /a rightNumCount += 1
)

set /a total = 0
set /a totalNums = %leftNumCount% - 1

for /l %%a in ( 0, 1, %totalNums% ) do (
	set /a temp = !left[%%a]! - !right[%%a]!
	call:abs !temp! absTemp
	set /a total += !absTemp!
)

echo TOTAL: %total%

if not "%tempFile%" == "" del "%tempFile%"

exit /b

:: get_unique_file()
:: arg[%1]: filepath, eg. "C:\test\test_file"
:: arg[%2]: extension, eg. "txt"
:: arg[%3]: output variable, eg. myFile
:get_unique_file
for /f "skip=1" %%a in ('wmic os get localDateTime') do for %%b in (%%a) do set "rtn=%~1_%%b_%random%.%~2"
if exist "%rtn%" (
	goto:get_unique_file
) else (
	2>nul >nul (9>"%rtn%" timeout /nobreak 1) || goto:get_unique_file
)
set "%~3=%rtn%"
exit /b

:: abs()
:: arg[%1]: value
:: arg[%2]: output variable, eg. absVal
:abs
if %1 geq 0 (set rtn=%1) else set /a rtn=0-%1
set "%~2=%rtn%"
exit /b