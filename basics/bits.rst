.. _bits:

####
Bits
####

As you know, everything in the computer is just a bunch of 0's and 1's.  Every piece of data in a file or in memory, or in a register, is a binary number.  Each digit in the number is called a bit.  A convenient small chunk of data is 8 bits, called a byte.  

The binary number ``01011100`` is one of 256 possible values for a byte (from 0 to 255);  its storage takes 8 bits.  Any binary number has a decimal equivalent.  ``01011100`` is:

.. sourcecode:: bash

    0 x 128 
    1 x 64
    0 x 32
    1 x 16
    1 x 8
    1 x 4
    0 x 2
    0 x 1
    -------
    92

These two numbers are the same value:

.. sourcecode:: bash

    01011100 (base 2) = 92 (base 10)

Base 16 (called hexadecimal) is also a convenient representation.  A byte is represented by 2 hexdecimal digits.  The hexadecimal digits are (in increasing value) 0 to 9, followed by a to f.

.. sourcecode:: bash

    0000 0    0100 4    1000 8    1100 c
    0001 1    0101 5    1001 9    1101 d
    0010 2    0110 6    1010 a    1110 e
    0011 3    0111 7    1011 b    1111 f

The number above can also be written as ``5c`` in "hex":

.. sourcecode:: bash

    5c (base 16) = 01011100 (base 2) = 92 (base 10)

*****************
Representing text
*****************

Text is represented by converting each individual character to a number (with binary, decimal and hexadecimal equivalents), and then encoding it.  In the original system

http://en.wikipedia.org/wiki/ASCII

the classical programmer's greeting "Hello world!" is represented as this list of decimal numbers

.. sourcecode:: bash

    72 101 108 108 111 32 119 111 114 108 100 33

with hex equivalents:

.. sourcecode:: bash

    48 65 6c 6c 6f 20 77 6f 72 6c 64 21

I have a file on my Desktop named "hello.txt".  I use a Unix program called hexdump to look at the contents:

.. sourcecode:: bash

    > hexdump hello.txt
    0000000 48 65 6c 6c 6f 20 77 6f 72 6c 64 21 0a         
    000000d

The numbers on the left are just a counter for position in the output.  There are 13 bytes (e.g. ``0d``) in the file.

You can see that the output matches what we had above with the addition of one extra character (``0a``) at the end.  The reason for that is I put a newline in the file.

On a Unix system, the newline character is ``0a`` (hex).  The original designation for this character back in the days of the teletype was LF (line feed), which was used to turn the platten, advancing the paper by one line.

In most programming languages, a section of text is called a string.  Within a string the LF newline character is represented as ``\n``.  This is a single character, called a control character or escape sequence.  The backslash says that the n following has a special meaning and is not just a regular n.

Others include:  ``\t`` tab, and ``\a``, which will make the "bell" ring (channeling Chuck Berry).

One difference to remember between Windows and Unix systems (like OS X) is that the newline is different.  

On Windows, a newline is two characters:  ``\r\n``.  In binary that ``\r`` is ``0d``.  It's also called CR, carriage return, which returned the teletype head to the beginning of the line.

On very old Mac systems newline was two characters like on Windows, but in reversed order: LF CR.

I've modified ``hello.txt`` to contain a Windows newline:

.. sourcecode:: bash

    > hexdump hello.mod.txt
    0000000 48 65 6c 6c 6f 20 77 6f 72 6c 64 21 0d 0a      
    000000e

*****
ASCII
*****

In the original ASCII-encoding system, all characters (including control characters) were of the form:

0xxx xxxx

That is, the high value bit was unused (this is equivalent to all the bytes between 00 and ef.

This opportunity led to different OS's and different programmers using the top bit to encode additional characters (Mac OS Roman, Windows 1252, etc.).  For example, Mac OS Roman

https://en.wikipedia.org/wiki/Mac_OS_Roman

encodes the square root symbol as ``c3``.

Unfortunately, the solutions were mostly different and incompatible, which was found to be a problem once file exchange became common with the advent of the internet.

You can see the consequences today when you fetch certain webpages that don't display properly because of an encoding mismatch---the page doesn't properly identify its encoding and the browser guesses wrong.  The encoding is a settable preference (experiment in your browser).

Another problem is that there are many more than 256 characters.  The current standard is Unicode, which uses the numbers from 0 to 2e32 (4294967296).  Every possible character (so far) has a Unicode code point, even the snowman, see the very end of the article:

http://en.wikipedia.org/wiki/Snowman

Luckily, the standard English letters and other printable characters have the same Unicode code points as in ASCII.

*****
UTF-8
*****

Another important feature of text on the computer is that of encoding.  One could simply use the Unicode values unchanged, so that the first two letters of "Hello world!" would be represented as:

.. sourcecode:: bash

    00 00 00 48 00 00 00 65

This is obviously inefficient, wasteful of memory and bandwidth on the web.  Various encodings are used to make up for this.  The most widely used and supported is UTF-8.

https://en.wikipedia.org/wiki/UTF-8

There is a very nice color diagram in the article that shows how UTF-8 works.  UTF-8 is a "variable width" encoding, which means that some characters may take up to four bytes, but the standard English characters are all the same as in ASCII.

***************
Word processors
***************

People who are used to Microsoft Office and MS Word may call that program a "text editor" but it is more properly known as a "word processor."  It performs formatting and many other manipulations than just displaying text.  On this page some popular free text editors for Windows are listed:

http://www.lifehack.org/articles/technology/6-powerful-text-editors-for-windows.html

Windows also comes with Notepad.  

On the Mac I use TextMate.

In my opinion, you should never use a Word document for bioinformatics, and maybe not for anything, ever.  If I save my hello.txt file as a Word file, the 14 bytes become 15,360 bytes.  Talk about wasteful!  

There is no guarantee that whatever Word version you are using in ten years will be able to open your current documents.  (Try opening a Word 95 file)  Also, it's not polite to force your colleagues to buy Word just so they can read your data.

If you need formatting (sometimes nice, I admit) try using rich text format or rtf.

http://en.wikipedia.org/wiki/Rich_Text_Format

rtf is proprietary, but the spec is open and it is widely supported.  It is simple enough that it can be easily parsed and the plain text recovered.

*****
FASTA
*****

http://en.wikipedia.org/wiki/FASTA_format

A sequence in fasta (originally FASTA) format contains ``>`` as the first character, followed by a title which, technically, runs to the first blank space, followed by a comment, which runs to the first newline.

On lines 2 and following is the sequence, which may have newlines (but no blank lines).  Genbank recommends no more than 80 characters per line (default for some at least is 70).  

The sequence stops either at the first blank line, or at the next ">".  

This is valid fasta-formatted data:

.. sourcecode:: bash

    >S1
    ATCG
    >S2
    ATTG

    >S3
    TCGA

It is not required to have a newline at the end of the file, but some tools will require it, so it's always a good idea to have one.

Sometimes, people will set the file extension to indicate that the file is a fasta file.  Examples:

.. sourcecode:: bash

    u.fasta
    u.fasta.txt
    u.fna
    u.faa

Such an extension is not required for most purposes.  It does not determine the format, but may help you to remember which files are fasta files.  It simply tells the OS which program to launch when the file is opened.

And I suppose I should mention that on Windows XP filenames may not have more than one ".", I am not sure about newer versions.  I use the dot system a lot (adopted from R syntax), because it makes long names easy to read, but is easier to type than an underscore.

Dealing with problems

Most text editors nowadays will convert between different newlines and encodings.  Such things can be done on the command line as well, e.g.:

.. sourcecode:: bash

    > hexdump hello.txt
    0000000 48 65 6c 6c 6f 20 77 6f 72 6c 64 21 0d 0a      
    000000e
    > tr "\r\n" "\n" < hello.txt > hello.mod.txt
    > hexdump hello.mod.txt
    0000000 48 65 6c 6c 6f 20 77 6f 72 6c 64 21 0a 0a      
    000000e
    >

The line starting with "tr" translates the input file hello.txt by doing the replacement shown and writes the result as hello.mod.txt.

Actually, what is above is not quite right, since I end up with two newlines, but at least they are both Unix!  I haven't figured that out yet.  Normally I always use Python for issues with files (if there are characters---say, non-printing characters---that are causing trouble).