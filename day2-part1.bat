@echo off
setlocal EnableDelayedExpansion

set input=%~dp0input-day2.txt

set /a total = 0

for /f "eol= tokens=* delims= " %%a in (%input%) do (

	set /a count = 0

	for %%b in (%%a) do (
		set /a arr[!count!] = %%b
		set /a count += 1
	)

	set /a count -= 1

	call:is_safe "!arr!" !count! isSafe

	if !isSafe! == 1 (
		set /a total += 1
	)
)

echo TOTAL: %total%

exit /b

:: is_safe()
:: arg[%1]: arr
:: arg[%2]: count
:: arg[%3]: output variable, eg. isSafe
:is_safe

set arr=%~1
set count=%2

set /a diff = !arr[1]! - !arr[0]!
call:sign !diff! inc

if !inc! == 0 goto:invalid

set /a prevValue = !arr[0]!

for /l %%a in ( 1, 1, !count! ) do (
	set /a diff = !arr[%%a]! - !prevValue!
	call:sign !diff! thisInc

	if !diff! equ 0 goto:invalid
	if !diff! lss -3 goto:invalid
	if !diff! gtr 3 goto:invalid
	if !inc! neq !thisInc! goto:invalid

	set /a prevValue = !arr[%%a]!
)

:valid
set /a %3=1
exit /b
:invalid
set /a %3=0
exit /b

:: abs()
:: arg[%1]: value
:: arg[%2]: output variable, eg. absVal
:abs
if %1 geq 0 ( set rtn = %1 ) else ( set /a rtn = 0 - %1 )
set "%~2=%rtn%"
exit /b

:: sign()
:: arg[%1]: value
:: arg[%2]: output variable, eg. signVal
:sign
if %1 equ 0 ( set rtn = 0 ) else ( if %1 gtr 0 ( set /a rtn = 1 ) else ( set /a rtn = -1 ) )
set "%~2=%rtn%"
exit /b