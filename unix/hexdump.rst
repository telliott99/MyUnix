.. _hexdump:

###############
Examining files
###############

My go-to utility for reading binary data in files has been ``hexdump``.

.. sourcecode:: bash

    > echo "0abcff" > x.txt
    > hexdump -C x.txt
    00000000  30 61 62 63 66 66 0a                              |0abcff.|
    00000007
    > xxd x.txt
    0000000: 3061 6263 6666 0a                        0abcff.
    >
    
**xxd**

``xxd`` is sorta like ``hexdump`` except use of the ``-p`` flag gives reads the binary data from the file in ASCII-encoding, and gives us the hex equivalent:

.. sourcecode:: bash

    > echo "ab" > x.txt
    > xxd -p < x.txt
    61620a
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


