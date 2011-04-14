@echo off
set MATLAB=C:\Program Files\MATLAB\R2009b
set MSVCDir=c:\program files\microsoft visual studio 9.0\VC

"C:\Program Files\MATLAB\R2009b\rtw\bin\win32\envcheck" INCLUDE "c:\program files\microsoft visual studio 9.0\VC\include"
if errorlevel 1 goto vcvars32
"C:\Program Files\MATLAB\R2009b\rtw\bin\win32\envcheck" PATH "c:\program files\microsoft visual studio 9.0\VC\bin"
if errorlevel 1 goto vcvars32
goto make

:vcvars32
set VSINSTALLDIR=c:\program files\microsoft visual studio 9.0
set VCINSTALLDIR=c:\program files\microsoft visual studio 9.0\VC
set FrameworkSDKDir=c:\program files\microsoft visual studio 9.0\SDK\v3.5
call "C:\Program Files\MATLAB\R2009b\toolbox\rtw\rtw\private\vcvars32_900.bat"

:make
cd .
nmake -f odefun_nonlinear_rtw.mk  GENERATE_REPORT=0 ADD_MDL_NAME_TO_GLOBALS=0
@if errorlevel 1 goto error_exit
exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
