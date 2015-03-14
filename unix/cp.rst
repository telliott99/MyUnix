.. _cp:

#########################
Copying files (mv and cp)
#########################

**rm**

Previously we saw the use of the ``touch`` command to make a new file quickly (often useful for testing)::

    > touch x.txt
    > ls -al x.txt
    -rw-r--r--  1 telliott_admin  staff  0 Mar  3 05:06 x.txt
    >

If I want to remove this file, I can do::

    > rm x.txt
    > ls -al x.txt
    ls: x.txt: No such file or directory
    >

If I now change my mind, it's too late!  There is no easy recovery from misuse of the ``rm`` command or any other command that writes over file data.  However, this is a lesson that comes pretty early in using computers.  Back up your data.  Back up your data.  

But, to keep from drowning in ephemera, we need some data to be labile.  Wipe it away, and start fresh.

(Of course, you can set up special systems to preserve every file, or get the FBI to do forensics on your disk, since the write usually only puts the new data on disk and alters the metadata.  But I prefer to identify the important stuff first).

To make a new directory, use ``mkdir``::

    > mkdir tmp
    > ls
    MyUnix
    tmp
    > touch tmp/x.txt
    > ls -al tmp
    total 0
    drwxr-xr-x   3 telliott_admin  staff  102 Mar  3 05:13 .
    drwxr-xr-x@ 10 telliott_admin  staff  340 Mar  3 05:13 ..
    -rw-r--r--   1 telliott_admin  staff    0 Mar  3 05:13 x.txt
    > rm tmp
    rm: tmp: is a directory
    > rm -r tmp
    >

Notice that ``rm < dirname >`` doesn't work by itself.  This protects against accidentally deleting a whole directory (with its subdirectories).  The ``-r`` flags (recursive) tells the shell you really mean it.  With ``-r``, ``rm`` will remove a whole directory "tree"::

    > rm -r tmp
    > mkdir tmp
    > mkdir tmp/a
    > ls tmp
    a
    > rm -r tmp
    > ls tmp
    ls: tmp: No such file or directory
    >

There is a well-known command that one should never enter, not even as a joke.  I can't bring myself to type it, but I will specify it as the conjunction of ``rm``, the ``-rf`` flag (recursive plus "force") , and the target directory ``/``.  This will remove all the files on the computer starting from the "root", and it works fairly quickly because it really operates on the metadata for the files.

This is famous "advice" occasionally given by more experienced hackers to "newbies", perhaps to teach a life-lesson.  Opinion is divided on whether it is simply malicious, or both malicious and useful.

**wildcard**

The ``*`` symbol is called a "wildcard".  It matches any text.  Suppose I have a directory full of text files (with a ``.txt`` extension) and I want to list just those files.  I might do::

    > ls *.txt
    x.txt
    >

Or if I have sequentially numbered files::

    > ls x*.txt
    x1.txt
    x2.txt
    ..

(I use the ellipsis ``..`` to indicate there is more output).

**move and copy**

Another useful device to construct test files employs the symbol ``>``, which is a "redirect" that places the results of a command into a text file::

    > ls *.txt > result.txt
    > cat result.txt
    x.txt
    >

The ``cat`` command is useful for many things, but one thing it can do is simply to print the contents of a file.  What we've done is to run ``ls`` and ``*.txt`` on all files in the current directory with the ``.txt`` extension, and written the result to a file ``result.txt`` rather than to the screen.

To place a short string of text into a new file, do::

    > echo "abc" > x.txt
    > cat x.txt
    abc
    >

It's important to note that if the file ``x.txt`` already exists, this command will write over the existing file erasing the old data.

``echo`` automatically adds a newline.  If you don't want this, you can use the ``-n`` flag::

    > echo -n "abc"
    abc> 
    > echo "abc" -n
    abc -n
    >

In the result from the first command above, we see the effect of missing the newline after the output.  The prompt goes right after the last character.  In the second example, we see that placement of the flags can matter.  In this case, the ``-n`` is not interpreted as a flag, but as extra text.

In talking about moving files from place to place, it is common to see ``src`` used as an abbreviation for the source of the data, and ``dst`` used as an abbreviation for destination.  The ``copy`` and ``mv`` commands might be illustrated like::

    copy src dst
    mv src dst

In either event, if ``dst`` already exists, the old data will be overwritten.  The difference between ``copy`` and ``mv`` is that ``mv`` will erase ``src`` after the copy.

**newlines**

In the example above, we used the ``-n`` flag to suppress the newline in using ``echo``.  What is the newline exactly?

Let's first use ``echo`` to write a few characters to disk::

    > echo "abc" > x.txt
    > hexdump x.txt
    0000000 61 62 63 0a                                    
    0000004
    > hexdump -C x.txt
    00000000  61 62 63 0a                                       |abc.|
    00000004
    >

We can examine the binary content of a file (in hex notation) using the ``hexdump`` command, often with the ``-C`` flag to also display the ASCII-encoded data.  Here, we see that the file contains 4 bytes:  ``61 62 63 0a``, which in decimal corresponds to the numbers ``97 98 99 10``.  The ``97 98 99`` is just ``abc``, but ``10`` is, in ASCII, the Unix newline, usually written as ``\n``.  The character output above just shows a ``.`` for bytes like this.

The backslash ``\`` means that what follows is a special character, called a "control character", and not just an ``n``.  

As further examples (and to point out a source of confusion), in the days before OS X, Macs used ``\r`` to symbolize a newline, while on Windows even today a newline is a double "control character":  ``\r\n``.  In the days of the teletype, this would mean "CR LF:  return the platten to the start of the line, and do a linefeed to advance the paper".

It turns out that we don't always need to write the data to a file.  We can use yet another Unix symbol, the ``|`` or pipe.  Try this::

    > echo "abc" | hexdump
    0000000 61 62 63 0a                                    
    0000004
    > echo -n "abc" | hexdump
    0000000 61 62 63                                       
    0000003
    >

The result of ``echo`` was "piped" directly to ``hexdump``.  And now we clearly see the difference between ``echo`` with and without the ``-n`` flag.  Pipes are used extensively in advanced Unix.

There is often more than one way to do something.  For example, we might have just asked how many bytes are in the resulting data::

    > echo "abc" | wc
           1       1       4
    > echo -n "abc" | wc
           0       1       3
    >

In the manual page for ``wc`` (word count)::

    wc -- word, line, character, and byte count

Also, we see that ``wc`` has four possible flags ``-clmw``.  Since there is no newline in the second example, that data is not defined as a line.  The ``-c`` flag means, count bytes::

    > echo "abc" | wc -c
           4
    > echo -n "abc" | wc -c
           3
    >

**cat for concatenate**

As mentioned above, ``cat`` can be used to display the contents of a file, but it is more versatile, as the name suggests.  A look at the man page will show it has a ``-n`` flag, among others::

    cat [-benstuv] [file ...]
    
For example::

    > echo "abc" | cat -n
         1	abc
    >

We get line numbers.  The concatenation aspect comes in handy also.  Suppose we have::

    > echo "a" > x.txt
    > echo "b" > y.txt
    > cat x.txt y.txt
    a
    b
    > echo -n "a" > x.txt
    > cat x.txt y.txt
    ab
    >

``cat`` will accept the wildcard ``*``::

    > echo "a" > x1.txt
    > echo "b" > x2.txt
    > cat x*.txt > x.txt
    > cat x.txt
    a
    b
    >

``cat`` concatenates the contents of one or more files (even many files) and sends the output to the screen, or to a file by using ``>`` redirect.

It can also append to files by using ``>>``::

    > echo "abc" > x.txt
    > echo "def" >> x.txt
    > cat x.txt
    abc
    def
    >

The ``>>`` is also called redirection operator.  In fact there are several more:

* < filename : Read standard input from file.
* > filename : Sends standard output to file.
* 2> filename : Sends standard error to file.
* >> filename : Appends standard output to file.

I will explain about the first and third of these later on.

**more or less**

I don't actually have ``more`` on my system.  Typing ``man more`` gives me the man page for ``less``

.. sourcecode:: bash

    DESCRIPTION
           Less  is  a  program  similar  to more (1), but
           which allows backward movement in the  file  as
           well  as forward movement.  Also, less does not
           have to  read  the  entire  input  file  before
           starting,  so  with large input files it starts
           up faster than text editors like vi (1).   Less

It has many flags::

    less [-[+]aBcCdeEfFgGiIJKLmMnNqQrRsSuUVwWX~]

I haven't used it much, but many people do.  It is good for paging through a file slowly, rather than dumping the contents all at once, as ``cat`` does.

To look at just a few lines from a file, use ``head`` or ``tail``.  Let's find some data::

    > ls /etc > x.txt
    > head -n 5 x.txt
    AFP.conf
    afpovertcp.cfg
    aliases
    aliases.db
    apache2
    >

``head`` gives us the specified number of lines from the ``head`` or beginning of the file.  The default number of lines is 10.  ``head`` can accept multiple filenames or even wildcards.

``tail`` gives us the specified number of lines from the end of the file::

    > tail x.txt
    ssh_host_key.pub
    ssh_host_rsa_key
    ssh_host_rsa_key.pub
    sshd_config
    sshd_config~previous
    sudoers
    syslog.conf
    ttys
    xtab
    zshenv
    > tail -n 5 x.txt
    sudoers
    syslog.conf
    ttys
    xtab
    zshenv
    >

We can use ``tail`` to remove a specified number of lines from the beginning of a file.  From the man page for ``tail``::

    SYNOPSIS
         tail [-F | -f | -r] [-q] [-b number | -c number | -n number]
              [file ...]

    DESCRIPTION
         The tail utility displays the contents of file or, by default, its
         standard input, to the standard output.

         The display begins at a byte, line or 512-byte block location in the
         input.  Numbers having a leading plus (`+') sign are relative to the
         beginning of the input, for example, ``-c +2'' starts the display at
         the second byte of the input.  Numbers having a leading minus (`-')
         sign or no explicit sign are relative to the end of the input, for
         example, ``-n 2'' displays the last two lines of the input.

We can count in lines (``-n``), bytes (``-c``) or blocks (``-b``).  We can start the display at count from the beginning with ``+``, or count from the end with ``-``.  A few examples::
    
    > echo "abcdef" | tail -c +2
    bcdef
    > echo "abcdef" | tail -c -3
    ef
    >

and::

    > echo "abc" > x.txt
    > echo "def" > y.txt
    > cat x.txt y.txt 
    abc
    def
    > cat x.txt y.txt | tail -n +1
    abc
    def
    > cat x.txt y.txt | tail -n +2
    def
    > cat x.txt y.txt | tail -n -1
    def
    >

**Editing files**

Example::

    > cd MyUnix/
    > ls -al .gitignore 
    -rw-r--r--@ 1 telliott_admin  staff  20 Mar  3 06:09 .gitignore
    > open -a Textmate .gitignore
    >

``git`` is a system for version control (and much more).  I'll have a summary chapter later.  What's important here is that a ``git``-controlled project can have ``.gitignore`` files in it that contain directives to ``git``.  Since they start with a ``.`` they are hidden files and you won't see them in the Finder.  I find it's convenient to open them from the command line.

I used a standard text editor (Textmate) rather than a Terminal-based editor like ``vim`` or ``emacs``.  (In some ways I envy Richard Stallman or Eric Raymond but I'm not them).  It can be useful to open a "hidden" file for editing in Textmate.  An easy way to do this is to use the ``open`` command::

    > open -a Textmate .gitignore

.. image:: /figs/gitignore_window.png
   :scale: 50 %

