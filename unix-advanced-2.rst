.. _unix-advanced-2:

########################
More advanced Unix usage
########################

**Archives and tar**

We will look next at ``tar``, which stands for "tape archive".  Here is an example

.. sourcecode:: bash

    > mkdir tmp
    > echo "abc" > tmp/x.txt
    > echo "def" > tmp/y.txt
    > tar -cvzf tmp.zip tmp
    a tmp
    a tmp/x.txt
    a tmp/y.txt
    > ls -al tmp.zip
    -rw-r--r--  1 telliott_admin  staff  187 Mar  3 19:12 tmp.zip
    > 

We have simply packaged everything up into what "looks like" a single file.  The standard flags for ``tar`` to make a zip file include ``-cvzf`` as shown above.  ``-c`` create a new archive, ``-v`` verbosely list the files being processed, ``-z`` compress by filtering the archive through ``gzip``, and ``-f`` use the given filename.  The immediate product of ``tar`` is a ``.tar`` file, but usually one compresses it to make a ``.zip`` file.

Given a (an uncompressed) ``tar`` file, one can look at the files it contains:

.. sourcecode:: bash

    > tar -cvf tmp.tar tmp
    a tmp
    a tmp/x.txt
    a tmp/y.txt
    > tar -tvf tmp.tar
    drwxr-xr-x  0 telliott_admin staff       0 Mar  3 19:12 tmp/
    -rw-r--r--  0 telliott_admin staff       4 Mar  3 19:12 tmp/x.txt
    -rw-r--r--  0 telliott_admin staff       4 Mar  3 19:12 tmp/y.txt
    >
    
Add one more flag for a ``.zip`` file:

.. sourcecode:: bash

    > tar -ztvf tmp.zip
    drwxr-xr-x  0 telliott_admin staff       0 Mar  3 19:12 tmp/
    -rw-r--r--  0 telliott_admin staff       4 Mar  3 19:12 tmp/x.txt
    -rw-r--r--  0 telliott_admin staff       4 Mar  3 19:12 tmp/y.txt
    >

To extract and ``untar`` the archive:

.. sourcecode:: bash

    > rm -r tmp
    > tar -xvf tmp.zip
    x tmp/
    x tmp/x.txt
    x tmp/y.txt
    > ls tmp
    x.txt	y.txt
    >

The standard steps for Unix software installation (before package managers) were:  use ``curl`` to get the ``.zip`` archive, use ``tar`` to decompress and unarchive it, and then compile and install it.  Be sure to check the hash of the file the ``curl`` gives so that you know it hasn't been tampered with.

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

    > ls
    find.txt	x y.txt		xargs.txt
    > find . -name "*.txt" -print0 | xargs -0 ls -al
    ..
    -rw-r--r--  1 telliott_admin  staff      0 Mar  4 13:28 ./x y.txt
    ..
    >

    > find . -name "*.txt" -print0 | xargs grep "y.txt"
    grep: y.txt: No such file or directory
    > find . -name "*.txt" -print0 | xargs -0 grep "y.txt"
    ./xargs.txt:find.txt	x y.txt		xargs.txt
    ./xargs.txt:-rw-r--r--  1 telliott_admin  staff    0 Feb 22 09:05 ./x y.txt
    > 

Notice that in the last step grep is going through the files line by line looking for the match, and it will go through the directory tree recursively.

**curl and its flags**

**processes and ps**

**cron**

                 