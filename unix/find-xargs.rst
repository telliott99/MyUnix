.. _find-xargs:

##############
find and xargs
##############

OS X has powerful search capacities in Spotlight, but you might want to generate a list of filenames to pipe into some other program.

``find`` is quite sophisticated, and can filter the output in many ways---I only know a little bit of usage for it.

``find`` is often combined with ``grep``, and we saw an example of that :ref:`before<find-grep>`

.. sourcecode:: bash

    > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music | grep ".mp3" | -l wc
         129


http://content.hccfl.edu/pollock/Unix/FindCmd.htm

Syntax for the ``find`` command:

.. sourcecode:: bash

    find < file/directory > < criteria > < action >

For example:

* ``find / -name foo`` search ``/`` for ``foo``,  display whole path

``find /`` can produce a lot of error messages trying to read directories where you don't have permission to read.  Suppress this with

* ``find / -name foo 2>/dev/null``

[ Todo:  link to an explanation of this ]

Useful flags include

* ``-type f`` files
* ``-mtime -7`` modified within the last 7 days
* ``-mmin -3`` modified within the last 3 minutes

Types include:

.. sourcecode:: bash

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
    

``-mtime`` is called a "primary":


    All primaries which take a numeric argument allow the number to be pre-
    ceded by a plus sign ("+") or a minus sign ("-").  A preceding plus
    sign means "more than n", a preceding minus sign means "less than n"
    and neither means "exactly n".

**time limits**

.. sourcecode:: bash

    find /usr -type f -mtime -1 | wc
    
The ``-mtime -1`` flag means modified within the last 1 day.  We could try ``find /``, but that would take a while.  I haven't found it so useful for that reason.  Even in my home directory a search takes a while. 

To use the time in minutes, you can substitute the ``-mmin`` flag, or even better, use ``-mtime n[smhdw]``, e.g. ``-mtime -2m``.

.. sourcecode:: bash

    > touch x.txt
    > find . -mtime -2m -type f
    ./x.txt
    > 

``atime`` is access time, this filters for files tht have been read, it is not necessary that they have been modified:

.. sourcecode:: bash

    > find ~/Desktop -atime -1m

**exclude sub-directories**

``find . -path ./misc -prune -o -name '*.txt' -print``

implement this example

more than one exclude directory:

http://stackoverflow.com/questions/4210042/exclude-directory-from-find-command

Having generated a list of filenames, often you will want to feed that list to some other command.  Use ``xargs``:

**xargs**

Here is a little bit about ``xargs``.  Basically "xargs" is used to remove or do some operation on long list of file names which were produced by "find" & "grep" commands.

.. sourcecode:: bash

    > echo 1 2 3 | xargs echo
    1 2 3
    > echo 1 2 3 | xargs -n 2
    1 2
    3
    > echo 1 2 3 4 5 | xargs -n 2
    1 2
    3 4
    5
    >

A second, more interesting example:

.. sourcecode:: bash

    > cd Desktop/
    > find .
    .
    ./.DS_Store
    ./xargs.txt
    > find . -type f -print
    ./.DS_Store
    ./xargs.txt
    > find . -type d -print
    .
    > find . -type d -print | xargs ls -al
    total 16
    drwxr-xr-x@  4 telliott_admin  staff   136 Feb 22 08:48 .
    drwxr-xr-x+ 47 telliott_admin  staff  1598 Feb 17 08:34 ..
    -rw-r--r--@  1 telliott_admin  staff  6148 Feb 22 08:48 .DS_Store
    -rw-r--r--@  1 telliott_admin  staff     0 Feb 22 08:48 xargs.txt
    > find . -type f -print | xargs ls -al
    -rw-r--r--@ 1 telliott_admin  staff  6148 Feb 22 08:48 ./.DS_Store
    -rw-r--r--@ 1 telliott_admin  staff     0 Feb 22 08:48 ./xargs.txt
    >

Spaces in filenames can be a pain.  Use ``-print0`` with find and ``-0`` with ls and grep and so on ..

.. sourcecode:: bash

    > ls
    find.txt	x y.txt		xargs.txt
    > find . -name "*.txt" -print0 | xargs -0 ls -al
    ..
    -rw-r--r--  1 telliott_admin  staff      0 Mar  4 13:28 ./x y.txt
    ..
    >

.. sourcecode:: bash

    > find . -name "*.txt" -print0 | xargs grep "y.txt"
    grep: y.txt: No such file or directory
    > find . -name "*.txt" -print0 | xargs -0 grep "y.txt"
    ./xargs.txt:find.txt	x y.txt		xargs.txt
    ./xargs.txt:-rw-r--r--  1 telliott_admin  staff    0 Feb 22 09:05 ./x y.txt
    > 

Notice that in the last step grep is going through the files line by line looking for the match, and it will go through the directory tree recursively.

.. sourcecode:: bash

    > find ~/Dropbox/MyX/MyUnix | xargs ls -al

explain what happens
