.. _make:

####
make
####

The Unix ``make`` tool

http://www.gnu.org/software/make/manual/make.html#Reading

Here is a straightforward makefile that describes the way an executable file called edit depends on eight object files which, in turn, depend on eight C source and three header files.

In this example, all the C files include defs.h, but only those defining editing commands include command.h, and only low level files that change the editor buffer include buffer.h.

.. sourcecode:: html

    edit : main.o kbd.o command.o display.o \
           insert.o search.o files.o utils.o
            cc -o edit main.o kbd.o command.o display.o \
                       insert.o search.o files.o utils.o

    main.o : main.c defs.h
            cc -c main.c
    kbd.o : kbd.c defs.h command.h
            cc -c kbd.c
    command.o : command.c defs.h command.h
            cc -c command.c
    display.o : display.c defs.h buffer.h
            cc -c display.c
    insert.o : insert.c defs.h buffer.h
            cc -c insert.c
    search.o : search.c defs.h buffer.h
            cc -c search.c
    files.o : files.c defs.h buffer.h command.h
            cc -c files.c
    utils.o : utils.c defs.h
            cc -c utils.c
    clean :
            rm edit main.o kbd.o command.o display.o \
               insert.o search.o files.o utils.o

The Unix ``make`` utility is widely used in building software.  This is the classic sequence:

.. sourcecode:: html

    curl -O project_url
    tar -xvf project.tar.zip
    cd project_dir
    ./configure
    make build
    sudo make install

In step 1 we download the software from the web, and in step 2 we de-compress and unarchive the directory and all its project files, followed by a ``cd`` into the project directory.

Next we run a script ``configure`` that extracts various values and paths from system environmental variables and uses them to construct a ``Makefile``.  The ``make`` tool invoked commands in the Makefile to build and test the software.  Finally, the software is installed, typically in a directory that requires ``sudo``.

This project has a simple Makefile.  Here it is:

.. sourcecode:: html

    # Makefile for Sphinx documentation
    #

    # You can set these variables from the command line.
    SPHINXOPTS    =
    SPHINXBUILD   = sphinx-build
    PAPER         =
    BUILDDIR      = _build

    # User-friendly check for sphinx-build
    ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
    $(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD environment variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don't have Sphinx installed, grab it from http://sphinx-doc.org/)
    endif
    ..
    clean:
    	rm -rf $(BUILDDIR)/*

    html:
    	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
    	@echo
    	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

When we do ``make clean`` from the command line, the ``make`` tool finds the Makefile and finds the rule for ``clean``, which says to ``rm -rf`` the ``$(BUILDDIR)/*``.  This directory is just ``_build``.



