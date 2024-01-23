# Find root dir
if ($null -eq $env:YOSYSHQ_ROOT) {
    $YOSYSHQ_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
}

function prompt { "[___BRANDING___] " + $(Get-Location) + "> " }
$env:SSL_CERT_FILE = "$YOSYSHQ_ROOT\etc\cacert.pem"

$env:PATH = "$YOSYSHQ_ROOT\bin;$YOSYSHQ_ROOT\lib;$YOSYSHQ_ROOT\py3bin;$env:PATH"
$env:PYTHON_EXECUTABLE = "$YOSYSHQ_ROOT\py3bin\python3.exe"
$env:QT_PLUGIN_PATH = "$YOSYSHQ_ROOT\lib\qt5\plugins"
$env:QT_LOGGING_RULES = "*=false"

$env:GTK_EXE_PREFIX = "$YOSYSHQ_ROOT"
$env:GTK_DATA_PREFIX = "$YOSYSHQ_ROOT"
$env:GDK_PIXBUF_MODULEDIR = "$YOSYSHQ_ROOT\lib\gdk-pixbuf-2.0\2.10.0\loaders"
$env:GDK_PIXBUF_MODULE_FILE = "$YOSYSHQ_ROOT\lib\gdk-pixbuf-2.0\2.10.0\loaders.cache"
& "$YOSYSHQ_ROOT\lib\gdk-pixbuf-query-loaders.exe" --update-cache

$env:OPENFPGALOADER_SOJ_DIR = "$YOSYSHQ_ROOT\share\openFPGALoader"
