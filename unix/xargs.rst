.. _xargs:

#####
xargs
#####

Basically "xargs" is used to remove or do some operation on long list of file names which were produced by "find" & "grep" commands.

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
