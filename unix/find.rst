.. _find:

################
Searching (find)
################

OS X has powerful search capacities in Spotlight, but you might want to generate a list of filenames to pipe into some other program.

``find`` is quite sophisticated, and can filter the output in many ways---I only know a little bit of usage for it.

``find`` is often combined with ``grep``, and we saw an example of that :ref:`before<grep>`::

    > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music | grep ".mp3" | -l wc
         129


https://danielmiessler.com/study/find/

http://content.hccfl.edu/pollock/Unix/FindCmd.htm

Syntax for the ``find`` command::

    find < file/directory > < criteria > < action >

Example::

    find MyUnix
    
``find`` will descend the file hierarchy of dirname and print the name of each file.  

``-name`` is a "primary", it acts as a criterion::

    > find MyUnix -name "find"
    > find MyUnix -name "find.rst"
    MyUnix/unix/find.rst
    >

It needs to be an exact match or use one of the shell's "globbing" patterns::

    > find MyUnix -name "find*"
    MyUnix/_build/doctrees/unix/find.doctree
    MyUnix/_build/html/_sources/unix/find.txt
    MyUnix/_build/html/unix/find.html
    MyUnix/unix/find.rst
    >

This achieves the same as::

    > find MyUnix | grep "find"
    MyUnix/_build/doctrees/unix/find.doctree
    MyUnix/_build/html/_sources/unix/find.txt
    MyUnix/_build/html/unix/find.html
    MyUnix/unix/find.rst
    >

So we see that piping to ``grep`` finds the pattern inside each line whereas ``-name`` in simplest form limits to an exact match.

Primaries

    All primaries which take a numeric argument allow the number to be pre-
    ceded by a plus sign ("+") or a minus sign ("-").  A preceding plus
    sign means "more than n", a preceding minus sign means "less than n"
    and neither means "exactly n".
    
**************
use with xargs
**************

Having generated a list of filenames, often you will want to feed that list to some other command.  Use :ref:`xargs<xargs>`::

    > find MyUnix | sort -r | head -n 2 | xargs ls -l
    -rw-r--r--@ 1 telliott_admin  staff  2054 Mar 13 06:53 MyUnix/unix/tar.rst
    -rw-r--r--@ 1 telliott_admin  staff  1852 Mar 14 18:31 MyUnix/unix/xargs.rst
    >

Here we list file hierarchy, sort (in reversed order, largest first), restrict to the top 2 hits, and then ``ls -l`` them.

**************
filter by type
**************

Types include::

    -type t
	     True if the file is of the specified type.  Possible file types
	     are as follows:

	     b	     block special
	     c	     character special
	     d	     directory
	     f	     regular file
	     l	     symbolic link
	     p	     FIFO
	     s	     socket

***********************
recently modified files
***********************

An example::

    find /usr -type f -mtime -1 | wc
    
The ``-mtime -1`` flag means modified within the last 1 day.  We could try ``find /``, but that would take a while.  I haven't found it so useful for that reason.  Even in my home directory a search takes a while. 

To use the time in minutes, you can substitute the ``-mmin`` flag, or even better, use ``-mtime n[smhdw]``, e.g. ``-mtime -2m``::

    > touch x.txt
    > find . -mtime -2m -type f
    ./x.txt
    > 

``atime`` is access time, this filters for files tht have been read, it is not necessary that they have been modified::

    > find ~/Desktop -atime -1m

Or anything modified more recently than some other file::

    > find MyUnix -newer MyUnix/unix/find.rst -not -path '*/\.*' | head -n2
    MyUnix/unix/grep.rst
    >

The last example uses

********************
exclude hidden files
********************

Example::

    > find MyUnix -not -path '*/\.*' | head -n2
    MyUnix
    MyUnix/_build
    >


**************
filter by size
**************

Movies larger than a specified size.  Example::

    > find ~/Movies/ -size +1024M
    /Users/telliott_admin/Movies//POOH.m4v
    /Users/telliott_admin/Movies//POOH.mpg
    ..

***********************
filter by user or group
***********************

Example::

    find . -user te
    find . -group admin

***********************
exclude sub-directories
***********************

``find . -path ./misc -prune -o -name '*.txt' -print``

implement this example

more than one exclude directory:

http://stackoverflow.com/questions/4210042/exclude-directory-from-find-command

****************
silencing errors
****************

``find /`` can produce a lot of error messages trying to read directories where you don't have permission to read.  Suppress this with

* ``find / -name foo 2>/dev/null``

[ Todo:  link to an explanation of this ]

Other useful flags include

* ``-type f`` files
* ``-mtime -7`` modified within the last 7 days
* ``-mmin -3`` modified within the last 3 minutes
