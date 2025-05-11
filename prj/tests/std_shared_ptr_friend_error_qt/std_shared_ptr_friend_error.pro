#
# repo:         cpputilsdemo
# file:         std_shared_ptr_friend_error.pro
# path:         prj/tests/std_shared_ptr_friend_error_qt/std_shared_ptr_friend_error.pro
# created on:	2025 May 11
# created by:	Davit Kalantaryan (davit.kalantaryan@desy.de)
#

message("!!! $${_PRO_FILE_}")
include ( "$${PWD}/../../common/common_qt/flagsandsys_common.pri" )
DESTDIR = "$${ArifactFinal}/test"

QT -= gui
QT -= core
QT -= widgets
CONFIG -= qt
CONFIG += console

win32{
} else {
    LIBS += -pthread
    LIBS += -ldl
}

SOURCES	+= "$${cpputilsDemoRepoRoot}/src/tests/main_std_shared_ptr_friend_error.cpp"

HEADERS += $$files($${cpputilsDemoRepoRoot}/include/*.h,true)
