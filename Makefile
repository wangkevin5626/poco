#
# Makefile
#
# The global Makefile for POCO [generated by mkrelease]
#

sinclude config.make

ifndef POCO_BASE
$(warning WARNING: POCO_BASE is not defined. Assuming current directory.)
export POCO_BASE=$(shell pwd)
endif

ifndef POCO_PREFIX
export POCO_PREFIX=/usr/local
endif

.PHONY: all libexecs cppunit tests samples install

all: libexecs tests samples

INSTALLDIR = $(DESTDIR)$(POCO_PREFIX)
COMPONENTS = Foundation XML Util Net

cppunit:
	$(MAKE) -C $(POCO_BASE)/CppUnit 

install: libexecs
	mkdir -p $(INSTALLDIR)/include/Poco
	mkdir -p $(INSTALLDIR)/lib
	mkdir -p $(INSTALLDIR)/bin
	for comp in $(COMPONENTS) ; do \
		if [ -d "$(POCO_BASE)/$$comp/include" ] ; then \
			cp -Rf $(POCO_BASE)/$$comp/include/* $(INSTALLDIR)/include/ ; \
		fi ; \
		if [ -d "$(POCO_BUILD)/$$comp/bin" ] ; then \
			find $(POCO_BUILD)/$$comp/bin -perm -700 -type f -exec cp -Rf {} $(INSTALLDIR)/bin \; ; \
		fi ; \
	done
	find $(POCO_BUILD)/lib -name "libPoco*" -exec cp -Rf {} $(INSTALLDIR)/lib \;

.PHONY: Foundation-libexec XML-libexec Util-libexec Net-libexec
.PHONY: Foundation-tests XML-tests Util-tests Net-tests
.PHONY: Foundation-samples XML-samples Util-samples Net-samples

libexecs: Foundation-libexec XML-libexec Util-libexec Net-libexec
tests: Foundation-tests XML-tests Util-tests Net-tests
samples: Foundation-samples XML-samples Util-samples Net-samples

Foundation-libexec: 
	$(MAKE) -C $(POCO_BASE)/Foundation

Foundation-tests: Foundation-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Foundation/testsuite
	
Foundation-samples: Foundation-libexec 
	$(MAKE) -C $(POCO_BASE)/Foundation/samples

XML-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/XML

XML-tests: XML-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/XML/testsuite
	
XML-samples: XML-libexec 
	$(MAKE) -C $(POCO_BASE)/XML/samples

Util-libexec:  Foundation-libexec XML-libexec
	$(MAKE) -C $(POCO_BASE)/Util

Util-tests: Util-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Util/testsuite
	
Util-samples: Util-libexec 
	$(MAKE) -C $(POCO_BASE)/Util/samples

Net-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/Net

Net-tests: Net-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Net/testsuite
	
Net-samples: Net-libexec  Foundation-libexec XML-libexec Util-libexec
	$(MAKE) -C $(POCO_BASE)/Net/samples
