@echo off
title MJ Serial Checker

for /F %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"

set "PURPLE=%ESC%[35m"
set "LIGHTPURPLE=%ESC%[95m"
set "RESET=%ESC%[0m"

color 05
setlocal enabledelayedexpansion
setlocal EnableExtensions EnableDelayedExpansion
cls

echo %PURPLE%Grabbing Serials, please wait.%RESET%
echo.

:: Disk
for /f "delims=" %%A in ('powershell -command "Get-PhysicalDisk | ForEach-Object { $_.SerialNumber }"') do (
    set "Disk=%%A"
)

:: Motherboard
for /f "delims=" %%A in ('powershell -command "(Get-CimInstance Win32_BaseBoard).SerialNumber"') do (
    set "Motherboard=%%A"
)

:: SMBIOS UUID
for /f "delims=" %%A in ('powershell -command "(Get-CimInstance Win32_ComputerSystemProduct).UUID"') do (
    set "UUID=%%A"
)

:: BIOS Version
for /f "delims=" %%A in ('powershell -command "(Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion"') do (
    set "BIOS=%%A"
)

:: MAC Address
for /f "delims=" %%A in ('powershell -command "(Get-NetAdapter | Where-Object { $_.Status -eq 'Up' })[0].MacAddress"') do (
    set "MAC=%%A"
)

:: VolumeID (C: Drive)
for /f "tokens=5 delims= " %%A in ('vol C: ^| find "Serial"') do (
    set "VolumeID=%%A"
)

if not defined Disk set "Disk=N/A"
if not defined Motherboard set "Motherboard=N/A"
if not defined UUID set "UUID=N/A"
if not defined BIOS set "BIOS=N/A"
if not defined MAC set "MAC=N/A"
if not defined VolumeID set "VolumeID=N/A"

cls
echo.
echo %PURPLE%                         %LIGHTPURPLE%System Serials%PURPLE%%RESET%
echo %PURPLE%______________________________________________________________  %RESET%
echo.
echo %PURPLE%   Disk:          %LIGHTPURPLE%!Disk!%PURPLE%                   %RESET%
echo %PURPLE%   Motherboard:   %LIGHTPURPLE%!Motherboard!%PURPLE%            %RESET%
echo %PURPLE%   UUID:          %LIGHTPURPLE%!UUID!%PURPLE%                   %RESET%
echo %PURPLE%   BIOS:          %LIGHTPURPLE%!BIOS!%PURPLE%                   %RESET%
echo %PURPLE%   MAC:           %LIGHTPURPLE%!MAC!%PURPLE%                    %RESET%
echo %PURPLE%   VolumeID (C:): %LIGHTPURPLE%!VolumeID!%PURPLE%               %RESET%
echo %PURPLE%______________________________________________________________  %RESET%
echo.
echo.
pause
