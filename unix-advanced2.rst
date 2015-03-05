.. _unix-advanced2:

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

**curl and its flags**

``curl`` stands for "copy URL".  It is designed to request data from a server on the web by any of a number of protocols, including secure ones, with or without cookies, and more.  It has a number of flags, but the one you always see is:

* ``-O`` write to local file named like the remote one
* ``-#`` use a progress bar rather than the usual meter

.. sourcecode:: bash

    > curl http://en.wikipedia.org/wiki/Main_Page | head -n 5
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
      0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
    <html lang="en" dir="ltr" class="client-nojs">
    <head>
    <meta charset="UTF-8" />
    <title>Wikipedia, the free encyclopedia</title>
    curl: (23) Failed writing body (0 != 9972)
    >

This is kind of fun:  The following command shares all the files in the current folder over HTTP (but you have to be able to get to localhost, which outsiders can't do):

.. sourcecode:: bash

    > echo "abc" > x.txt
    > python -m SimpleHTTPServer 8080

So do that from the Desktop, and then open a new tab in Terminal and do:

.. sourcecode:: bash

    Last login: Thu Mar  5 04:40:50 on ttys000
    > cd Desktop
    -bash: cd: Desktop: No such file or directory
    > curl http://localhost:8080
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><html>
    <title>Directory listing for /</title>
    <body>
    <h2>Directory listing for /</h2>
    <hr>
    <ul>
    <li><a href=".DS_Store">.DS_Store</a>
    <li><a href="Crypto101.pdf">Crypto101.pdf</a>
    <li><a href="MyUnix/">MyUnix/</a>
    <li><a href="network.txt">network.txt</a>
    <li><a href="pkg-config%20notes.txt">pkg-config notes.txt</a>
    <li><a href="ProblemSolvingwithAlgorithmsandDataStructures.pdf">ProblemSolvingwithAlgorithmsandDataStructures.pdf</a>
    <li><a href="pth%20notes.txt">pth notes.txt</a>
    <li><a href="sphinx-rst2pdf.pdf">sphinx-rst2pdf.pdf</a>
    <li><a href="todo.txt">todo.txt</a>
    <li><a href="unixtut.tar.gz">unixtut.tar.gz</a>
    <li><a href="use%20virtualenv.txt">use virtualenv.txt</a>
    <li><a href="x.txt">x.txt</a>
    </ul>
    <hr>
    </body>
    </html>
    > 
    > curl http://localhost:8080/x.txt
    abc
    >

More curl examples:

http://www.thegeekstuff.com/2012/04/curl-examples/

**processes and ps**

Finding and killing a process

The ``ps`` command by itself yields

.. sourcecode:: bash

    > ps
      PID TTY           TIME CMD
      809 ttys000    0:00.01 -bash
    >

A number of its flags select processes to display:

* ``-A`` other peoples process
* ``-a`` others plus mine
* ``-G`` process for group G
* ``-g`` group "leader" g
* ``-p`` process ID
* ``-T`` standard input
* ``-t`` terminal device
* ``-U`` user ID
* ``-u`` username

These flags may be combined and the processes will be combined too.  

Processes can also be sorted (default is process ID) by 

* ``-m`` memory usage
* ``-r`` cpu usage

* ``-o`` select info for display
* ``-v`` certain info for display


**aux**

* a = show processes for all users
* u = display the process's user/owner
* x = also show processes not attached to a terminal

.. sourcecode:: bash

    > ps aux -r | head -n 4
    USER              PID  %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
    telliott_admin    890   1.3  0.6  3678932  46272   ??  S     4:14PM   0:02.45 /Applications/Safari.app/Contents/MacOS/Safari
    _windowserver     117   1.1  0.7  3614568  58988   ??  Ss    1:52PM   2:08.38 /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreGraphics.framework/Resources/WindowServer -daemon
    telliott_admin    806   1.0  0.4  2581004  33304   ??  R     3:59PM   0:09.72 /Applications/Utilities/Terminal.app/Contents/MacOS/Terminal
    > 

**user**

.. sourcecode:: bash

    > ps -f -u `whoami` | head -n 5
      UID   PID  PPID   C STIME   TTY           TIME CMD
      501   200     1   0  1:52PM ??         0:00.84 /usr/libexec/UserEventAgent (Aqua)
      501   202     1   0  1:52PM ??         0:01.65 /usr/sbin/distnoted agent
      501   204     1   0  1:52PM ??         0:01.50 /usr/sbin/cfprefsd agent
      501   207     1   0  1:52PM ??         0:12.42 /System/Library/CoreServices/Dock.app/Contents/MacOS/Dock
    > 

**name or pid**

.. sourcecode:: bash

    > ps aux | grep "bash" 
    telliott_admin    809   0.0  0.0  2461020   1316 s000  S     3:59PM   0:00.04 -bash
    telliott_admin    950   0.0  0.0  2441988    652 s000  R+    4:20PM   0:00.00 grep bash
    > ps -C 809
      PID TTY           TIME CMD
      809 ttys000    0:00.05 -bash
    >

[ Lots more to say ]

Reference:

http://www.binarytides.com/linux-ps-command/

**cron**



**xxd**

``xxd`` is sorta like ``hexdump``

.. sourcecode:: bash

    > echo "0abcff" > x.txt
    > hexdump -C x.txt
    00000000  30 61 62 63 66 66 0a                              |0abcff.|
    00000007
    > xxd x.txt
    0000000: 3061 6263 6666 0a                        0abcff.
    >

Except, use of the ``-p`` flag gives reads the binary data from the file has "0abcff" in ASCII-encoding, and gives us the hex equivalent:

.. sourcecode:: bash

    > xxd -p x.txt
    3061626366660a
    > xxd -p x.txt > x.hex
    > cat x.hex
    3061626366660a
    >


So what we've just done is to convert some hex as a string (or we could get it from a text file) and turn that into actual binary data on disk.  That's useful.

The ``xxd`` ``-r`` flag, when combined with ``-p`` we get:

.. sourcecode:: bash

    > xxd -r x.hex
    > xxd -r -p x.hex
    0abcff
    > xxd -rp x.hex     # cannot combine the flags
    > echo "0abcff" | xxd -p | xxd -r -p
    0abcff
    > 

Using ``-p`` we can go from hex to binary, and using ``-r`` we can go back again.
    
This solves the problem I had with crypto prob #1

.. sourcecode:: bash

    > echo \
    "49276d206b696c6c696e6720796f757220627261696e206c\
    696b65206120706f69736f6e6f7573206d757368726f6f6d"\
     | xxd -r -p | openssl enc -base64
    SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t
    >


                 