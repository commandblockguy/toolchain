#----------------------------
# Makefile
#----------------------------

# common/os specific things
ifeq ($(OS),Windows_NT)
NATIVEPATH = $(subst /,\,$(1))
WINPATH    = $(NATIVEPATH)
RM         = del /f 2>nul
RMDIR      = rmdir /s /q
MKDIR      = mkdir
PREFIX    ?= C:
CP         = copy
CPDIR      = xcopy
else
NATIVEPATH = $(subst \,/,$(1))
WINPATH    = $(shell winepath --windows $(1))
RM         = rm -f
MKDIR      = mkdir -p
RMDIR      = rm -rf
PREFIX    ?= $(HOME)
CP         = cp
CPDIR      = cp -r
endif

INSTALLLOC := $(call NATIVEPATH,$(DESTDIR)$(PREFIX))
TOOLSDIR   := $(call NATIVEPATH,$(CURDIR)/tools)
SRCDIR     := $(call NATIVEPATH,$(CURDIR)/src)
SPASMDIR   := $(call NATIVEPATH,$(TOOLSDIR)/spasm-ng)
CONVHEXDIR := $(call NATIVEPATH,$(TOOLSDIR)/convhex)
CONVPNGDIR := $(call NATIVEPATH,$(TOOLSDIR)/convpng)

CEDIR      := $(call NATIVEPATH,$(SRCDIR)/ce)
STDDIR     := $(call NATIVEPATH,$(SRCDIR)/std)

SPASM      := $(call NATIVEPATH,$(SPASMDIR)/spasm)
CONVHEX    := $(call NATIVEPATH,$(CONVHEXDIR)/convhex)
CONVPNG    := $(call NATIVEPATH,$(CONVPNGDIR)/convpng)

BIN        := $(call NATIVEPATH,$(TOOLSDIR)/zds)

GRAPHXDIR  := $(call NATIVEPATH,$(SRCDIR)/graphx)
KEYPADCDIR := $(call NATIVEPATH,$(SRCDIR)/keypadc)
FILEIOCDIR := $(call NATIVEPATH,$(SRCDIR)/fileioc)

INSTALLBIN := $(call NATIVEPATH,$(INSTALLLOC)/CEdev/bin)
INSTALLINC := $(call NATIVEPATH,$(INSTALLLOC)/CEdev/include)
INSTALLLIB := $(call NATIVEPATH,$(INSTALLLOC)/CEdev/lib)
DIRS       := $(INSTALLINC) $(INSTALLINC)/ce $(INSTALLINC)/ce/libs $(INSTALLINC)/std $(INSTALLBIN) $(INSTALLLIB)
DIRS       := $(call NATIVEPATH,$(DIRS))

all: $(SPASM) $(CONVHEX) $(CONVPNG) graphx fileioc keypadc ce std

#----------------------------
# tool rules
#----------------------------
$(SPASM) $(CONVHEX) $(CONVPNG):
	$(MAKE) -C $(dir $@)

clean: clean-graphx clean-fileioc clean-keypadc clean-ce clean-std
	$(MAKE) -C $(SPASMDIR) clean
	$(MAKE) -C $(CONVHEXDIR) clean
	$(MAKE) -C $(CONVPNGDIR) clean
#----------------------------

#----------------------------
# ce rules
#----------------------------
ce:
	$(MAKE) -C $(CEDIR) BIN=$(BIN)

clean-ce:
	$(MAKE) -C $(CEDIR) clean
#----------------------------

#----------------------------
# std rules
#----------------------------
std:
	$(MAKE) -C $(STDDIR) BIN=$(BIN)
clean-std:
	$(MAKE) -C $(STDDIR) clean
#----------------------------

#----------------------------
# graphx rules
#----------------------------
graphx: $(SPASM)
	$(MAKE) -C $(GRAPHXDIR) SPASM=$(SPASM) BIN=$(BIN)
clean-graphx:
	$(MAKE) -C $(GRAPHXDIR) clean
install-graphx:
	$(MAKE) -C $(GRAPHXDIR) install
uninstall-graphx:
	$(MAKE) -C $(GRAPHXDIR) uninstall
#----------------------------

#----------------------------
# fileioc rules
#----------------------------
fileioc: $(SPASM)
	$(MAKE) -C $(FILEIOCDIR) SPASM=$(SPASM) BIN=$(BIN)
clean-fileioc:
	$(MAKE) -C $(FILEIOCDIR) clean
#----------------------------

#----------------------------
# keypadc rules
#----------------------------
keypadc: $(SPASM)
	$(MAKE) -C $(KEYPADCDIR) SPASM=$(SPASM) BIN=$(BIN)
clean-keypadc:
	$(MAKE) -C $(KEYPADCDIR) clean
#----------------------------

uninstall:
	$(RMDIR) $(call NATIVEPATH,$(INSTALLLOC)/CEdev)

install: $(DIRS)
	$(CPDIR) $(call NATIVEPATH,$(CURDIR)/examples) $(call NATIVEPATH,$(INSTALLLOC)/CEdev)
	$(CP) $(call NATIVEPATH,$(SRCDIR)/asm/*) $(call NATIVEPATH,$(INSTALLLIB)/asm)
	$(CP) $(call NATIVEPATH,$(SRCDIR)/example_makefile) $(call NATIVEPATH,$(INSTALLINC)/.makefile)
	$(CP) $(SPASM) $(INSTALLBIN)
	$(CP) $(CONVHEX) $(INSTALLBIN)
	$(CP) $(CONVPNG) $(INSTALLBIN)
	$(CP) $(call NATIVEPATH,$(BIN)/*) $(INSTALLBIN)
	$(MAKE) -C $(GRAPHXDIR) install PREFIX=$(PREFIX) DESTDIR=$(DESTDIR)
	$(MAKE) -C $(KEYPADCDIR) install PREFIX=$(PREFIX) DESTDIR=$(DESTDIR)
	$(MAKE) -C $(FILEIOCDIR) install PREFIX=$(PREFIX) DESTDIR=$(DESTDIR)
	$(MAKE) -C $(CEDIR) install PREFIX=$(PREFIX) DESTDIR=$(DESTDIR)
	$(MAKE) -C $(STDDIR) install PREFIX=$(PREFIX) DESTDIR=$(DESTDIR)

$(DIRS):
	$(MKDIR) $(INSTALLBIN)
	$(MKDIR) $(INSTALLLIB)
	$(MKDIR) $(INSTALLINC)
	$(MKDIR) $(call NATIVEPATH,$(INSTALLLIB)/asm)
	$(MKDIR) $(call NATIVEPATH,$(INSTALLINC)/ce)
	$(MKDIR) $(call NATIVEPATH,$(INSTALLINC)/std)
	$(MKDIR) $(call NATIVEPATH,$(INSTALLINC)/ce/libs)


.PHONY: all clean graphx clean-graphx fileioc clean-fileioc keypadc clean-keypadc install uninstall

