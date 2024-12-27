@echo off
setlocal EnableDelayedExpansion

set input=%~dp0input-day1.txt

set /a numCount = 0

for /f "eol= tokens=1-2 delims= " %%a in (%input%) do (
	set /a left[!numCount!]=%%a
	set /a numCount+=1

	if not "!right[%%b]!" == "" (
		set /a right[%%b] += 1
	) else (
		set /a right[%%b] = 1
	)
)

set /a total = 0
set /a numCount -= 1

for /l %%a in ( 0, 1, %numCount% ) do (

	for %%i in (!left[%%a]!) do set rightValue=!right[%%i]!

	if not "!rightValue!" == "" (
		set /a total += !left[%%a]! * !rightValue!
	)
)

echo TOTAL: %total%

exit /b