#
#   ManuScripts
#   CS 61 - 17S
#

JC = javac
SRCDIR := src
BUILDDIR := build
LIBDIR := lib
TESTDIR := test
OUTDIR := bin
TARGET := ManuScripts

SOURCES := $(wildcard $(SRCDIR)/*.java)
CLASSES := $(SOURCES:.java=.class)
JFLAGS = -g

buildAndRun: build run

build: $(CLASSES)

run:
	@cd $(BUILDDIR)
	java -cp . $(TARGET).class

%.class: %.java
	$(JC) $(JFLAGS) -d $(BUILDDIR) $<

clean:
	rm -f *.class