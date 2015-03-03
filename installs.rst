.. _installs:

############################
Installing software:  basics
############################

**Overview**

Modern programs are written so that they may be read easily by humans.  There is much more to it than that, of course, but a program might be something like what we had in the previous chapter.

.. sourcecode:: python

    print "Hello, world!"

The filename is ``hello.py`` and it's on my Desktop.  I can do this from the Desktop directory:

.. sourcecode:: bash

    > python hello.py
    Hello, world!

Actually, Python doesn't seem to care any more about file extensions (it seems that I recall it did, but I'm not really sure).  

.. sourcecode:: bash

    > cp hello.py hello.txt
    > cp hello.py hello.x
    > cp hello.py hello
    > python hello.txt
    Hello, world!
    > python hello.x
    Hello, world!
    > python hello
    Hello, world!
    >

The Python interpreter starts up, finds ``hello.py``, and launches the script.  There is an intermediate file type ``hello.pyc``, which you won't see on disk, and then some more steps, but eventually the machine starts "executing" a lot of 64-bit instructions.

We mentioned also that if the script has a hash-bang ``#!`` line, we can do a ``chmod`` on the file, and then run it without specifying Python on the command line, it looks like any other program:

.. sourcecode:: bash

    > cp hello.py hello
    > chmod 755 hello
    > ./hello
    Hello, world!
    >

For another class of programs, each one is "compiled".  Without worrying about the details, writing a new or revised version of a compiled program usually needs two explicit actions by the programmer:  compilation and execution.

The classic compiler for the C and C++ languages was ``GCC``, which is usually invoked with ``gcc``, but these days on OS X ``gcc`` is a newfangled thing called ``clang``.  It doesn't matter for our purposes.  It *looks* like ``gcc`` is present

.. sourcecode:: bash

    > which gcc
    /usr/bin/gcc
    > ls -al /usr/bin/gcc
    -rwxr-xr-x  1 root  wheel  14160 Sep 29 01:38 /usr/bin/gcc
    > 

But a deliberate mistake gives an error code that suggests otherwise.  :)

.. sourcecode:: bash

    > gcc
    clang: error: no input files
    >

Let's write a very simple C program:

.. sourcecode:: C

    #include <stdio.h>
    
    int main()
    {
    	printf("hello, world\n");
    }

Compile and execute, on two lines:

.. sourcecode:: bash

    > clang hello.c -o hello
    > ./hello
    hello, world
    >
    > wc -c hello
        8496 hello
    >


The ``-o`` flag gives a name for the output file, which beats the default ``a.out``.

The resulting file is almost 8500 bytes.  Looking at it with ``hexdump`` will show some English words but not give much clue about how it works.  We can see a little more structure with ``nm``, but we don't really want to go too far into this topic right now.

.. sourcecode:: bash

    > nm hello
    0000000100000000 T __mh_execute_header
    0000000100000f40 T _main
                     U _printf
                     U dyld_stub_binder
    >

**FastTree**

What I would like to do is to show how to install and run a software program from the web (hopefully, from someone we trust).  FastTree is a phylogenetics program that qualifies

http://www.microbesonline.org/fasttree/

http://www.microbesonline.org/fasttree/#Install

The download page has a link which will give you the code in the browser.  Do "save as source" and make sure the filename is ``FastTree.c`` (no ``.txt``).

Or you could use ``curl``

.. sourcecode:: bash

    > curl -O http://www.microbesonline.org/fasttree/FastTree.c
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100  374k  100  374k    0     0   114k      0  0:00:03  0:00:03 --:--:--  114k
    >

Now, at this point, we need to compile it.  We could do ``clang FastTree.c``, but a look at the website gives some recommended options

.. sourcecode:: bash

    gcc -DNO_SSE -O3 -finline-functions -funroll-loops -Wall -o FastTree FastTree.c -lm
    
So that's what I'm going to do, except I will substitute ``clang`` for ``gcc``:

.. sourcecode:: bash

    > clang -DNO_SSE -O3 -finline-functions -funroll-loops -Wall -o FastTree FastTree.c -lm
    > ./FastTree
    Usage for FastTree version 2.1.7 No SSE3:
      FastTree protein_alignment > tree
    ..
    > 

That's all there is to it.  To test the ``FastTree`` "binary", we would need an alignment, but I will put that off for the moment.  Remember to store the FastTree "source" file somewhere and to move the executable program to another directory, like ``bin`` or ``Software`` or whatever, just as long as it is on your ``$PATH``.

It is a good idea to check to make sure that software packages you build (compile) and/or install have not been tampered with.  You need a hash (digital signature) of the file, and you need to know that the hash has not been tampered with!

Something like:

.. sourcecode:: bash

    > openssl sha FastTree.c 
    SHA(FastTree.c)= e6d0b1ffb9daea791f1c82f8fe694107252af2e3
    > openssl md5 FastTree.c 
    MD5(FastTree.c)= 209c15343a878f2b23c44cd326a094e1
    >

But I couldn't actually find a hash on the website.

Let's take a look at Homebrew next.
