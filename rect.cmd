@echo off

set rect_cp=core/engine/lib/log4j.jar;core/engine/lib/ant.jar;core/engine/lib/ant-launcher.jar;core/engine/lib/ant-apache-log4j.jar;core/engine/lib/commons-codec-1.4.jar;core/engine/lib/commons-exec-1.1.jar;core/engine/lib/ant-nodeps.jar

setlocal

title RECT

for /f %%j in ("java.exe") do (
    set JAVA_HOME=%%~dp$PATH:j
)

if %JAVA_HOME%.==. (
    @echo java not found. Please ensure that you have java installed and PATH environment variable refers to correct JAVA installation directory.
    goto run_wlst

) 

:set_env
IF EXIST setenv.cmd CALL setenv.cmd

echo %classpath% | find "weblogic.jar" > nul

if errorlevel 1 goto run_jython

:run_wlst

java -classpath "%rect_cp%;%classpath%" -Dpython.os=nt weblogic.WLST core/engine/main.py %*
if errorlevel 3 goto set_env
goto :EOF

:run_jython

java -classpath "./jython21.jar;%rect_cp%;%classpath%" -Dpython.home=. org.python.util.jython core/engine/main.py %*
if errorlevel 2 goto set_env

endlocal
