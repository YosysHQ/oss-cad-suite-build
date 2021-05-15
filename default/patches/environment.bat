:: Find root dir
@if not defined YOSYSHQ_ROOT (
    for /f %%i in ("%~dp0") do @set YOSYSHQ_ROOT=%%~fi
)

@set PATH=C:\Windows\System32;C:\Windows
@set prompt=[OSS CAD Suite] $p$g

@set PATH=%YOSYSHQ_ROOT%bin;%YOSYSHQ_ROOT%lib;%PATH%
@set PYTHON_EXECUTABLE=%YOSYSHQ_ROOT%p3bin\python3.exe
@set QT_PLUGIN_PATH=%YOSYSHQ_ROOT%lib\qt5\plugins
@set QT_LOGGING_RULES=*=false

@set GTK_DATA_PREFIX=%YOSYSHQ_ROOT%
@gdk-pixbuf-query-loaders.exe --update-cache
