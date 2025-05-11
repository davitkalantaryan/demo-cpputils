#
# repo:		cpputilsdemo
# file:		cpputilsdemo_all.pro
# path:		workspaces/cpputilsdemo_all_qt/cpputilsdemo_all.pro
# created on:	2025 May 11
# created by:	Davit Kalantaryan (davit.kalantaryan@desy.de)
#

message("!!! $${_PRO_FILE_}")
include ( "$${PWD}/../../prj/common/common_qt/flagsandsys_common.pri" )

TEMPLATE = subdirs
#CONFIG += ordered

SUBDIRS	+= "$${cpputilsDemoRepoRoot}/prj/tests/std_shared_ptr_friend_error_qt/std_shared_ptr_friend_error.pro"


OTHER_FILES += $$files($${cpputilsDemoRepoRoot}/docs/*.md,true)
OTHER_FILES += $$files($${cpputilsDemoRepoRoot}/docs/*.txt,true)
#OTHER_FILES += $$files($${cpputilsDemoRepoRoot}/.github/*.yml,true)
OTHER_FILES += $$files($${cpputilsDemoRepoRoot}/scripts/*.sh,true)
OTHER_FILES += $$files($${cpputilsDemoRepoRoot}/scripts/*.bat,true)
OTHER_FILES += $$files($${cpputilsDemoRepoRoot}/prj/common/common_mkfl/*.Makefile,true)

OTHER_FILES	+=	\
        "$${cpputilsDemoRepoRoot}/.gitattributes"						\
        "$${cpputilsDemoRepoRoot}/.gitignore"							\
        "$${cpputilsDemoRepoRoot}/LICENSE"							\
        "$${cpputilsDemoRepoRoot}/README.md"
