#
#   ManuScripts
#   CS 61 - 17S
#

JC = javac
SRCDIR := src
BUILDDIR := obj
LIBDIR := lib
TESTDIR := test
TARGET := ManuScripts

SOURCES := $(wildcard $(SRCDIR)/*.java)
CLASSES := $(SOURCES:.java=.class)
JFLAGS = -g

buildAndRun: build run

build: $(CLASSES)

run:
	@cd $(BUILDDIR)
	java -cp . $(TARGET)

%.class: %.java
	$(JC) $(JFLAGS) -d $(BUILDDIR) $<

clean:
	rm -f *.class