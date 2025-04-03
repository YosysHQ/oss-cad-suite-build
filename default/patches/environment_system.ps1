# Find root dir
if (-not $env:YOSYSHQ_ROOT) {
    $env:YOSYSHQ_ROOT = Join-Path (Get-Item -Path $PSScriptRoot).FullName "\"
}

# Set environment variables
$envVars = @{
    "SSL_CERT_FILE" = Join-Path $env:YOSYSHQ_ROOT "etc\cacert.pem"
    "PYTHON_EXECUTABLE" = Join-Path $env:YOSYSHQ_ROOT "lib\python3.exe"
    "QT_PLUGIN_PATH" = Join-Path $env:YOSYSHQ_ROOT "lib\qt5\plugins"
    "QT_LOGGING_RULES" = "*=false"
    "GTK_EXE_PREFIX" = $env:YOSYSHQ_ROOT
    "GTK_DATA_PREFIX" = $env:YOSYSHQ_ROOT
    "GDK_PIXBUF_MODULEDIR" = Join-Path $env:YOSYSHQ_ROOT "lib\gdk-pixbuf-2.0\2.10.0\loaders"
    "GDK_PIXBUF_MODULE_FILE" = Join-Path $env:YOSYSHQ_ROOT "lib\gdk-pixbuf-2.0\2.10.0\loaders.cache"
    "OPENFPGALOADER_SOJ_DIR" = Join-Path $env:YOSYSHQ_ROOT "share\openFPGALoader"
}

# Update PATH
$newPath = "$($env:YOSYSHQ_ROOT)bin;$($env:YOSYSHQ_ROOT)lib;$env:PATH"
$envVars["PATH"] = $newPath

# Update environment variables in the registry
foreach ($key in $envVars.Keys) {
    [System.Environment]::SetEnvironmentVariable($key, $envVars[$key], [System.EnvironmentVariableTarget]::Machine)
}

# Reload environment variables for the current session
foreach ($key in $envVars.Keys) {
    [System.Environment]::SetEnvironmentVariable($key, $envVars[$key], [System.EnvironmentVariableTarget]::Process)
}

# Update GDK pixbuf loaders cache
& "$env:YOSYSHQ_ROOT\lib\gdk-pixbuf-query-loaders.exe" --update-cache