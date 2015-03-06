.. _unix8-tar-curl:

############
tar and curl
############

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


                 