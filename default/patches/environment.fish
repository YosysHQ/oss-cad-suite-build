#!/usr/bin/env fish

function deactivate -d "Deactivate the ___BRANDING___ virtual environment"

    if set --query _OLD_ENVIRONMENT_PATH
        set --export PATH $_OLD_ENVIRONMENT_PATH
        set --erase _OLD_ENVIRONMENT_PATH
    end

    if set --query _OLD_ENVIRONMENT_PYTHONHOME
        set --export PYTHONHOME $_OLD_ENVIRONMENT_PYTHONHOME
        set --erase _OLD_ENVIRONMENT_PYTHONHOME
    end

    set --erase VIRTUAL_ENV
    set --erase VIRTUAL_ENV_PROMPT
    set --erase VERILATOR_ROOT
    set --erase GHDL_PREFIX

    if functions --query _old_environment_fish_prompt
        functions --erase fish_prompt
        functions --copy _old_environment_fish_prompt fish_prompt
        functions --erase _old_environment_fish_prompt
    end

    if test (count $argv) -eq 0; or test $argv[1] != "nondestructive"
        functions --erase deactivate
    end

end

deactivate nondestructive

set --local release_current_dir (dirname (status -f))

if test (uname) = "Darwin"
    set --global release_topdir_abs ($release_current_dir/libexec/realpath $release_current_dir)
else
    set --global release_topdir_abs (realpath $release_current_dir)
end

set --export VIRTUAL_ENV "$release_topdir_abs"
set --export VIRTUAL_ENV_PROMPT '___BRANDING___'

set --global _OLD_ENVIRONMENT_PATH "$PATH"
set --export PATH "$release_topdir_abs/bin:$release_topdir_abs/py3bin:$PATH"

if set --query PYTHONHOME
    set --export _OLD_ENVIRONMENT_PYTHONHOME "$PYTHONHOME"
    set --erase PYTHONHOME
end

functions --copy fish_prompt _old_environment_fish_prompt
function fish_prompt -d "Write out the prompt"
    set_color magenta
    echo -n -s '(' $VIRTUAL_ENV_PROMPT ') '
    set_color normal
    _old_environment_fish_prompt
end

set --export VERILATOR_ROOT "$release_topdir_abs/share/verilator"
set --export GHDL_PREFIX "$release_topdir_abs/lib/ghdl"
