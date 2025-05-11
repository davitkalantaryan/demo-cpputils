#
# repo:		    cinternal
# file:		    flagsandsys_common.windows.Makefile
# created on:	    2020 Dec 14
# created by:	    Davit Kalantaryan (davit.kalantaryan@desy.de)
# purpose:	    This file can be only as include
#


!IFNDEF cinternalFlagsAndSysCommonIncluded
cinternalFlagsAndSysCommonIncluded		= 1
!IFNDEF cinternalRepoRoot
cinternalRepoRoot	= $(MAKEDIR)\..\..\..
!ENDIF
!include <$(cinternalRepoRoot)\prj\common\common_mkfl\raw\flagsandsys_common_raw.windows.Makefile>
!ENDIF
