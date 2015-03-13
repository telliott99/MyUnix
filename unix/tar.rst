.. _tar:

##############
Archives (tar)
##############

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