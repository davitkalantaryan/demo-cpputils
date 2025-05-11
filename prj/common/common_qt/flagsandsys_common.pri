#
# repo:			cinternal
# name:			flagsandsys_common.pri
# path:			prj/common/common_qt/flagsandsys_common.pri
# created on:           2023 Jun 21
# created by:           Davit Kalantaryan (davit.kalantaryan@desy.de)
# usage:		Use this qt include file to calculate some platform specific stuff
#


message("!!! $${PWD}/flagsandsys_common.pri")

isEmpty(cinternalFlagsAndSysCommonIncluded){
    cinternalFlagsAndSysCommonIncluded = 1

    cinternalRepoRoot = $${PWD}/../../..

    isEmpty(artifactRoot) {
        artifactRoot = $$(artifactRoot)
        isEmpty(artifactRoot) {
            artifactRoot = $${cinternalRepoRoot}
        }
    }

    DEFINES += CPPUTILS_COMPILER_WARNINGS_PUSH_POP
    INCLUDEPATH += $${cinternalRepoRoot}/include

    STATIC_LIB_EXTENSION    = a
    LIB_PREFIX		    = lib
    TARGET_PATH_EXTRA	    =

    defineReplace(cinternalToUpper) {
        return($$replace($$1, ., \U&))
    }

    defineReplace(cinternalFlagsToCompileAsC) {
        msvc {
           return (/TC)
        } else {
            return (-xc)
        }
    }

    defineReplace(cinternalFlagsToCompileAsCpp) {
        msvc {
           return (/TP)
        } else {
            return (-xc++)
        }
    }

    defineTest(cinternalSingleFileFlags) {
        QMAKE_CXXFLAGS_$$1 += $$2
    }

    isEmpty( TARGET_PATH ) {
        contains( TEMPLATE, lib ) {
	    TARGET_PATH=lib
	} else {
	    TARGET_PATH=bin
	}
    }

    win32{
        STATIC_LIB_EXTENSION = lib
	LIB_PREFIX =
	msvc {
            CinternalStrongWarings  = /Wall /WX
            CinternalNoSdl = /sdl-
	}
	contains(QMAKE_TARGET.arch, x86_64) {
	    message ("!!!!!!!!!! windows 64")
	    CODENAME = win_x64
	} else {
	    message ("!!!!!!!!!! windows 32")
	    CODENAME = win_x86
	}
    } else:mac {
        message ("!!!!!!!!!! mac")
	CODENAME = mac
        CinternalStrongWarings  = -Wall -Werror
    } else:android {
        # ANDROID_TARGET_ARCH values 1."armeabi-v7a", 2."arm64-v8a", 3."x86", 4."x86_64"
	# x86 and x86_64 are simulators
	#contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
	##ANDROID_EXTRA_LIBS += $$PWD/../platform/android/openssl/armeabi-v7a/libcrypto.so
	##ANDROID_EXTRA_LIBS += $$PWD/../platform/android/openssl/armeabi-v7a/libssl.so
	message("!!!!!!!!!! android: ANDROID_TARGET_ARCH=$$ANDROID_TARGET_ARCH")
	CODENAME = android_$${ANDROID_TARGET_ARCH}
        CinternalStrongWarings  = -Wall -Werror
    } else:ios {
        message ("!!!!!!!!!! ios")
	CODENAME = ios
        CinternalStrongWarings  = -Wall -Werror
    } else:wasm {
        message ("!!!!!!!!!! wasm")
	STATIC_LIB_EXTENSION	= ba
	CODENAME = wasm
	TARGET_PATH_EXTRA = /$${TARGET}
        CinternalStrongWarings  = -Wall -Werror
	QMAKE_CXXFLAGS += -fexceptions
	#QMAKE_CXXFLAGS += -s DISABLE_EXCEPTION_CATCHING=0 -s ASYNCIFY -O3
	QMAKE_CXXFLAGS += -s DISABLE_EXCEPTION_CATCHING=0 -O3 $$(EXTRA_WASM_FLAGS)
    } else:linux {
        CODENAME = $$system(lsb_release -sc)
	message("!!!!!!!!!! linux: Codename:$${CODENAME}")
        CinternalStrongWarings  = -Wall -Werror
    } else {
        message("----------------------- Unknown platform")
    }

    QMAKE_CXXFLAGS += $${CinternalStrongWarings} $${CinternalNoSdl}
    QMAKE_CFLAGS += $${CinternalStrongWarings} $${CinternalNoSdl}

    CONFIGURATION=Profile
    nameExtension=

    CONFIG(debug, debug|release) {
        nameExtension=d
	CONFIGURATION=Debug
	DEFINES += CPPUTILS_DEBUG
    } else:CONFIG(release, debug|release) {
        CONFIGURATION=Release
    }

    DEFINES         += CpputilsNameExtension=\\\"$${nameExtension}\\\"
    MAKEFILE        =  Makefile.$${TARGET}.$${CODENAME}.$${CONFIGURATION}
    ArifactFinal    =  $${artifactRoot}/sys/$${CODENAME}/$$CONFIGURATION
    DESTDIR         =  $${ArifactFinal}/$${TARGET_PATH}$${TARGET_PATH_EXTRA}
    OBJECTS_DIR     =  $${ArifactFinal}/.other/objects/$${TARGET}
    MOC_DIR         =  $${ArifactFinal}/.other/mocs/$${TARGET}
    UI_DIR          =  $${ArifactFinal}/.other/uics/$${TARGET}

    isEmpty(extraLibsDir) {
        extraLibsDir = $$(extraLibsDir)
    }
    !isEmpty(extraLibsDir) {
        exists($${extraLibsDir}) {
            LIBS += -L$${extraLibsDir}
        }
    }

    isEmpty(extraIncludesDir) {
        extraIncludesDir = $$(extraIncludesDir)
    }
    !isEmpty(extraIncludesDir) {
        exists($${extraIncludesDir}) {
            INCLUDEPATH += -L$${extraIncludesDir}
        }
    }

    exists($${cinternalRepoRoot}/sys/$${CODENAME}/$$CONFIGURATION/lib) {
	LIBS += -L$${cinternalRepoRoot}/sys/$${CODENAME}/$$CONFIGURATION/lib
    }
    exists($${cinternalRepoRoot}/sys/$${CODENAME}/$$CONFIGURATION/tlib) {
	LIBS += -L$${cinternalRepoRoot}/sys/$${CODENAME}/$$CONFIGURATION/tlib
    }

    OTHER_FILES += $$files($${PWD}/../common_mkfl/*.Makefile,true)
}
