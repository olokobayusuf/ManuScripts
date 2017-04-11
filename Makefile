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
JFLAGS = -g -d $(BUILDDIR) -cp src

buildAndRun: build run

build: $(CLASSES)

run:
	@java -cp ./obj $(TARGET)

%.class: %.java
	@echo "Building..."
	@mkdir -p $(BUILDDIR)
	$(JC) $(JFLAGS) $<
	@echo "Completed"
	@echo "------------------------------------------------------ "

clean:
	rm -f *.class