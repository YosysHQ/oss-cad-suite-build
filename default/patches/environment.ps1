# Find root dir
if (-not $env:YOSYSHQ_ROOT) {
    $env:YOSYSHQ_ROOT = Join-Path (Get-Item -Path $PSScriptRoot).FullName "\"
}

# Set prompt
function Prompt {
    "[___BRANDING___] PS " + $(Get-Location) + "> "
}

# Set environment variables
$env:SSL_CERT_FILE = Join-Path $env:YOSYSHQ_ROOT "etc\cacert.pem"
$env:PATH = "$($env:YOSYSHQ_ROOT)bin;$($env:YOSYSHQ_ROOT)lib;$env:PATH"
$env:PYTHON_EXECUTABLE = Join-Path $env:YOSYSHQ_ROOT "lib\python3.exe"
$env:QT_PLUGIN_PATH = Join-Path $env:YOSYSHQ_ROOT "lib\qt5\plugins"
$env:QT_LOGGING_RULES = "*=false"
$env:GTK_EXE_PREFIX = $env:YOSYSHQ_ROOT
$env:GTK_DATA_PREFIX = $env:YOSYSHQ_ROOT
$env:GDK_PIXBUF_MODULEDIR = Join-Path $env:YOSYSHQ_ROOT "lib\gdk-pixbuf-2.0\2.10.0\loaders"
$env:GDK_PIXBUF_MODULE_FILE = Join-Path $env:YOSYSHQ_ROOT "lib\gdk-pixbuf-2.0\2.10.0\loaders.cache"

# Update GDK pixbuf loaders cache
& "$env:YOSYSHQ_ROOT\lib\gdk-pixbuf-query-loaders.exe" --update-cache

# Additional environment variable
$env:OPENFPGALOADER_SOJ_DIR = Join-Path $env:YOSYSHQ_ROOT "share\openFPGALoader"
