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
JFLAGS = -g -d $(BUILDDIR) -cp $(SRCDIR)

buildAndRun: build run

build: start $(CLASSES) complete

run:
	@java -cp "$(BUILDDIR):$(LIBDIR)/*" $(TARGET)

debug:
	@java -cp "$(BUILDDIR):$(LIBDIR)/*" $(TARGET) --verbose

test:
	@java -cp "$(BUILDDIR):$(LIBDIR)/*" $(TARGET) --test

auth:
	@java -cp "$(BUILDDIR):$(LIBDIR)/*" $(TARGET) --auth

%.class: %.java
	$(JC) $(JFLAGS) $<

start:
	@echo "Building..."
	@mkdir -p $(BUILDDIR)

complete:
	@echo "Completed"
	@echo "------------------------------------------------------ "

clean:
	rm -f *.class