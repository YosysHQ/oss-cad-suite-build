#!/usr/bin/env python3

# Patch to force the addition of -fcoroutines
# Should be removed once YosysHQ/oss-cad-suite-build#84 is properly fixed
def patch_configure_ac():
	file_path="configure.ac"

	with open(file_path, 'r') as file:
		new_content = file.read()

	search_string = """
_MY_CXX_CHECK_SET(CFG_CXXFLAGS_COROUTINES,-fcoroutines-ts)
_MY_CXX_CHECK_SET(CFG_CXXFLAGS_COROUTINES,-fcoroutines)
_MY_CXX_CHECK_SET(CFG_CXXFLAGS_COROUTINES,-fcoroutines-ts -Wno-deprecated-experimental-coroutine)
AC_SUBST(CFG_CXXFLAGS_COROUTINES)
"""

	replace_string = """
CFG_CXXFLAGS_COROUTINES="-fcoroutines"
AC_SUBST(CFG_CXXFLAGS_COROUTINES)
"""

	if search_string in new_content:
		new_content = new_content.replace(search_string, replace_string)

	search_string = """
AC_MSG_CHECKING([whether coroutines are supported by $CXX])
ACO_SAVE_CXXFLAGS="$CXXFLAGS"
CXXFLAGS="$CXXFLAGS $CFG_CXXFLAGS_COROUTINES"
AC_LINK_IFELSE(
    [AC_LANG_PROGRAM([
#ifdef __clang__
#define __cpp_impl_coroutine 1
#endif
#include <coroutine>
    ],[[]])],
    [_my_result=yes
     AC_DEFINE([HAVE_COROUTINES],[1],[Defined if coroutines are supported by $CXX])],
    [AC_LINK_IFELSE(
        [AC_LANG_PROGRAM([#include <experimental/coroutine>],[[]])],
        [_my_result=yes
         AC_DEFINE([HAVE_COROUTINES],[1],[Defined if coroutines are supported by $CXX])],
        [_my_result=no])])
AC_MSG_RESULT($_my_result)
CXXFLAGS="$ACO_SAVE_CXXFLAGS"
AC_SUBST(HAVE_COROUTINES)
"""

	replace_string = """
AC_DEFINE([HAVE_COROUTINES],[1],[Defined for OSS CAD Suite Release])
AC_SUBST(HAVE_COROUTINES)
"""

	if search_string in new_content:
		new_content = new_content.replace(search_string, replace_string)

	with open(file_path, 'w') as file:
		file.write(new_content)

# Run patches
if __name__ == "__main__":
	patch_configure_ac()
