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

for /l %%a in ( -1, 1, !count! ) do (
	set ignore=%%a
	set /a invalidAttempt = 0
	set first=
	set second=

	for /l %%b in ( 0, 1, !count! ) do (
		if !ignore! neq %%b (
			if "!first!" == "" (
				set /a first = !arr[%%b]!
			) else (
				if "!second!" == "" (
					set /a second = !arr[%%b]!
					set /a diff = !second! - !first!
					if !diff! equ 0 ( set /a inc = 0 ) else ( if !diff! gtr 0 ( set /a inc = 1 ) else ( set /a inc = -1 ) )
					if !inc! == 0 ( set /a invalidAttempt = 1 )
				) else (
					set /a diff = !arr[%%b]! - !prevValue!
				)

				if !diff! equ 0 ( set /a thisInc = 0 ) else ( if !diff! gtr 0 ( set /a thisInc = 1 ) else ( set /a thisInc = -1 ) )
				if !diff! equ 0 ( set /a invalidAttempt = 1 )
				if !diff! lss -3 ( set /a invalidAttempt = 1 )
				if !diff! gtr 3 ( set /a invalidAttempt = 1 )
				if !inc! neq !thisInc! ( set /a invalidAttempt = 1 )
			)
			set /a prevValue = !arr[%%b]!
		)
	)

	if !invalidAttempt! == 0 (
		goto:valid
	)
)

:invalid
set /a %3=0
exit /b
:valid
set /a %3=1
exit /b