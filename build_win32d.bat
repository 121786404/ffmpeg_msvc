@ECHO OFF


set path=%CD%\cygwin64\bin;%path%
call "%VS140COMNTOOLS%vsvars32.bat"

rmdir /s/q bin_Win32d


sh build_ffmpeg_msvc.sh
rem sh build_ffmpeg_msvc.sh quick


rem MSBuild.exe msvc_proj\ffmpegvs.sln /nologo /m /t:Rebuild /property:Configuration=Debug;Platform=Win32

rem IF %ERRORLEVEL% NEQ 0 EXIT /B 1

PAUSE

