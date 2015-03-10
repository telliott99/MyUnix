.. _navigation:

################################
Navigating from the command line
################################

**pwd, cd and ls**

"Learning Unix" is, at least at the beginning, a process of becoming familiar with certain commands issued at the command line.  The primary commands for moving around in the file system are:

* ``pwd`` (print working directory)
* ``cd < dirname >`` (change directory)
* ``ls < dirname >`` (list directory contents)

.. sourcecode:: bash

    > pwd
    /Users/telliott_admin
    > cd Desktop/
    > pwd
    /Users/telliott_admin/Desktop
    > cd ..
    > pwd
    /Users/telliott_admin
    > cd ..
    > pwd
    /Users
    > ls
    Shared		telliott	telliott_admin
    >
    
Terminal (the "BASH shell") has a sense of where you are in the file system.  ``pwd`` prints the directory you are "in", according to the shell.  Your home directory is your username (here:  ``telliott_admin``).  It lives under the ``Users`` directory, which is one of the directories at top-level in the file system.

The ``cd`` command usually operates on a destination directory that is typed in.  Invoked without an argument, it means ``cd < home directory >``.

A very useful feature of the shell is "command completion".  Starting from ``/Users/telliott_admin``, if I type

.. sourcecode:: bash

    > cd De

and then press TAB, the rest of ``Desktop/`` will autocomplete.  If there is more than one match to the partial name, the screen will blink with the first press, and then when I press TAB again, the shell will display those options:

.. sourcecode:: bash

    > cd Des
    Desktop/      Destinations/ 
    > cd Des

typing a second letter gives the shell enough information to autocomplete (after another TAB).

Filenames are case-sensitive at the level of the Terminal.

``ls`` with no arguments will list the contents of the current directory.

.. sourcecode:: bash

    > cd /
    > ls
    Applications
    Library
    ..
    > cd
    > pwd
    /Users/telliott_admin
    >

Directory structure in Unix is conceptualized as a tree structure with the idea of a "path" to be followed to each directory or file starting from the from the ``root`` of the directory hierarchy, ``/``.  The symbol ``/`` is used to separate path elements, and it is an idiosyncrasy of Unix that spaces are not allowed in filenames or paths.  

Of course OS X does allow spaces in filenames.  To include a space in a Unix-style filename on OS X, type a forward slash before the space:

.. sourcecode:: bash

    > cd Music/iTunes/iTunes\ Media

Some directories above have the ``path`` given as a "relative path", which starts from the current directory.  But the result of the ``pwd`` command, for example, are shown as an "absolute path" which starts from the ``root``.  

Either the relative or the absolute path method can be used to specify a directory or filename.  If I am in my home directory ``/Users/telliott_admin``, both of these are valid names for the Desktop directory:

.. sourcecode:: bash

    > ls Desktop/
    MyUnix
    > ls /Users/telliott_admin/Desktop/
    MyUnix

I don't know if it's a good thing or not, but I am easily distracted by the output of previous commands in the shell, so I like to clear the screen regularly with CMD-K.  Another important command to remember is the command to kill a process that you have started from the command line and is running amok.  Just do CTL-Z.

.. sourcecode:: bash

    > find /
    ..
    ^Z
    [2]+  Stopped                 find /
    >

Here, I typed ``find /``, which will list every file on my computer.  A lot of output scrolls by.  I have typed ``..`` to stand in for this text.  When I tire of waiting for the command to finish, I enter CTL-Z, which displays as ``^Z``, and then we see ``Stopped``, and finally the command prompt.

The command prompt tells me the computer awaits my instructions.

Many commands have options.  Even ``pwd`` has options, though they are too advanced for us at the moment.  But ``ls`` is usually run with at least a few options.  I make a new empty text file on my Desktop by using ``touch < filename >`` and then do ``ls``:

.. sourcecode:: bash

    > touch x.txt
    > ls
    MyUnix
    x.txt
    > ls -al 
    total 42840
    drwxr-xr-x@ 10 telliott_admin  staff       340 Mar  3 04:29 .
    drwxr-xr-x+ 48 telliott_admin  staff      1632 Mar  3 04:13 ..
    -rw-r--r--@  1 telliott_admin  staff      6148 Mar  3 04:03 .DS_Store
    drwxr-xr-x   9 telliott_admin  staff       306 Mar  3 04:02 MyUnix
    -rw-r--r--   1 telliott_admin  staff         0 Mar  3 04:29 x.txt
    > ls -al x.txt
    -rw-r--r--  1 telliott_admin  staff  0 Mar  3 04:29 x.txt
    >

The plain ``ls`` command just shows the file I made (plus the directory MyUnix which contains this project).  Adding the ``-a`` and ``-l`` "flags" (which may be combined as ``-al``) shows (``-a``) all files, even hidden ones whose names start with a ``.``   For example here we see that the directory contains a reference to itself (the single ``.``), a reference to its parent directory ``..``, and a special hidden OS X file ``.DS_Store``, in addition.

The ``-d`` flag lists a directory rather than its contents:

.. sourcecode:: bash

    > ls -ald MyUnix
    drwxr-xr-x@ 29 telliott_admin  staff  986 Mar  5 04:02 MyUnix
    > ls -al MyUnix/
    total 424
    drwxr-xr-x@ 29 telliott_admin  staff    986 Mar  5 04:02 .
    drwxr-xr-x@ 13 telliott_admin  staff    442 Mar  5 03:59 ..
    -rw-r--r--@  1 telliott_admin  staff   6148 Mar  5 04:02 .DS_Store
    drwxr-xr-x@ 13 telliott_admin  staff    442 Mar  5 03:55 .git
    ..
    > 
    

The ``-l`` flag modifies how the metadata for the files is displayed.  We get a 10- or 11-character group like ``drwxr-xr-x`` for ``MyUnix``.  The ``d`` stands for directory, and the equivalent position in the output for the file ``x.txt`` is just `-`.  Then there are some three-character sets of "permissions".  The three Permissions refer to the ability to ``r`` read, ``w`` write, or `x` execute files or programs.  If a permission is allowed, then the letter is shown, and if not, a ``-`` is shown.  For example ``rw-`` means "read and write, but not execute".

They are arranged by the user, her "group", and the "world", which consists of all users on the machine.

The last character in the group may be ``@`` or ``+`` or no character at all.

http://apple.stackexchange.com/questions/97241/ls-command-what-does-the-in-file-mode-mean-and-how-to-get-rid-of-it

http://superuser.com/questions/155458/what-does-the-mean-on-the-output-of-ls-on-os-x-terminal

See below for what the numbers column (``10``, ``48``, ``1``, etc.) stands for.

Then we have the user, my group, the size of the file and the creation date, followed by the name.  There are lots of options for ``ls`` and many ways to display the data.  To explore these, you could do ``man ls``:

.. sourcecode:: bash

    
    LS(1)                     BSD General Commands Manual                    LS(1)

    NAME
         ls -- list directory contents

    SYNOPSIS
         ls [-ABCFGHLOPRSTUW@abcdefghiklmnopqrstuwx1]
            [file ...]

This is the first of many pages of output for ``man ls``.  Each one of the flags

.. sourcecode:: bash

    -ABCFGHLOPRSTUW@abcdefghiklmnopqrstuwx1
 
means something.  You can page through the output looking for the meaning of a particular flag, like

.. sourcecode:: bash

    -a      Include directory entries whose names
            begin with a dot (.).

To exit from the manual, type ``q`` (quit).

Flags may be combined, as in ``-al``.  One useful option for ``ls`` is to sort the output by size:

.. sourcecode:: bash

    > ls -lS MyUnix/
    total 192
    -rw-r--r--@  1 telliott_admin  staff  12611 Mar  3 12:35 brew.rst
    -rw-r--r--@  1 telliott_admin  staff  11158 Mar  3 10:11 permissions.rst
    -rw-r--r--@  1 telliott_admin  staff  10057 Mar  3 15:04 navigation.rst
    -rw-r--r--@  1 telliott_admin  staff   9492 Mar  3 06:57 file_manip.rst
    -rw-r--r--@  1 telliott_admin  staff   8170 Mar  3 14:38 conf.py
    -rw-r--r--@  1 telliott_admin  staff   6762 Mar  3 04:00 Makefile
    -rw-r--r--@  1 telliott_admin  staff   5828 Mar  3 12:36 python.rst
    -rw-r--r--@  1 telliott_admin  staff   5507 Mar  3 07:58 more_unix.rst
    -rw-r--r--@  1 telliott_admin  staff   5166 Mar  3 12:50 software.rst
    -rw-r--r--@  1 telliott_admin  staff    509 Mar  3 12:27 index.rst
    drwxr-xr-x@ 12 telliott_admin  staff    408 Mar  3 04:03 unix
    drwxr-xr-x@  5 telliott_admin  staff    170 Mar  3 14:38 _build
    drwxr-xr-x@  4 telliott_admin  staff    136 Mar  3 12:14 figs
    drwxr-xr-x@  3 telliott_admin  staff    102 Mar  3 06:22 _static
    drwxr-xr-x@  2 telliott_admin  staff     68 Mar  3 04:00 _templates
    >
    

The number to the left of the username refers to the number of included files for a directory.  For example:

.. sourcecode:: bash

    > ls -al MyUnix/_static/
    total 16
    drwxr-xr-x@  3 telliott_admin  staff   102 Mar  3 06:22 .
    drwxr-xr-x@ 20 telliott_admin  staff   680 Mar  3 11:30 ..
    -rw-r--r--@  1 telliott_admin  staff  6148 Mar  3 06:22 .DS_Store
    > ls -al MyUnix/_templates/
    total 0
    drwxr-xr-x@  2 telliott_admin  staff   68 Mar  3 04:00 .
    drwxr-xr-x@ 20 telliott_admin  staff  680 Mar  3 11:30 ..
    > ls -al MyUnix/_build/
    total 8
    drwxr-xr-x@  5 telliott_admin  staff  170 Mar  3 14:38 .
    drwxr-xr-x@ 20 telliott_admin  staff  680 Mar  3 11:30 ..
    -rwxr--r--@  1 telliott_admin  staff   71 Mar  3 10:04 .gitignore
    drwxr-xr-x  11 telliott_admin  staff  374 Mar  3 14:38 doctrees
    drwxr-xr-x  18 telliott_admin  staff  612 Mar  3 14:59 html
    >

Compare this with the numbers shown above.

Sometimes flags are whole words (or may be either whole words or single letter abbreviations).  For a flag that is a whole word, Unix uses a double-dash prefix.  Here is a made-up example:

.. sourcecode:: bash

    > myprog --myflag

As we said, ``.`` is a shorthand symbol for the current directory, and ``..`` is for the parent of the current directory.  Another such symbol is ``~``, which means the user's home directory.  So, for example

.. sourcecode:: bash

    > pwd
    /Users/telliott_admin/Desktop
    > cd ..
    > pwd
    /Users/telliott_admin
    > cd Desktop/
    > pwd
    /Users/telliott_admin/Desktop
    > cd ~
    > pwd
    /Users/telliott_admin
    >

The shell keeps track of the commands you've entered.  One way to navigate this history is to use the up- and down-arrows, which will move you successively backward in time, displaying one command after the prompt, but not executing it.  To run the command, press RETURN.  This is great for repeating a command or even a series of commands.  Like a set of 3 commands:  

.. sourcecode:: bash

    UP-UP-UP-RUN-UP-UP-UP-RUN-UP-UP-UP-RUN
    
It looks weird here but it's easy to do and works great.

To see all of your history, enter ``history``

.. sourcecode:: bash

      ..
      541  touch x.txt
      542  ls
      543  ls -al 
      544  ls -al x.txt
      545  man ls
      546  pwd
      547  pwd ..
      548  cd .
      549  pwd
      550  cd ..
      551  pwd
      552  cd Desktop/
      553  cd ~
      554  pwd
      555  history
    >

To run a particular command from your history, type ``!`` followed by the number from the list, e.g.

.. sourcecode:: bash

    > !556
      ..
      550  cd ..
      551  pwd
      552  cd Desktop/
      553  cd ~
      554  pwd
      555  history
      556  history
    >

A pair of commands that can help sometimes when navigating around to deeply nested directories is ``pushd`` and ``popd``.  ``pushd <dirname>`` does ``cd <dirname>`` and also stores that command in a "stack" of ``cd`` commands.  ``popd`` reverses this ``cd``, bringing us back to where we where when we did the ``pushd``.

For example, suppose we do:

.. sourcecode:: bash

    > cd /usr/local/lib/python2.7/site-packages
    > pushd /Library/Python/2.7/site-packages
    /Library/Python/2.7/site-packages /usr/local/lib/python2.7/site-packages
    > pwd
    /Library/Python/2.7/site-packages
    > 
    > popd
    /usr/local/lib/python2.7/site-packages
    > 
    > pushd /Library/Python/2.7/site-packages  # get this back with up-arrow
    /Library/Python/2.7/site-packages /usr/local/lib/python2.7/site-packages
    > popd
    /usr/local/lib/python2.7/site-packages
    >

If we want to repeat the journey recover the entire ``pushd ..`` command with the up-arrow or from the history.

.. note::

    Both $_ and !$ hold the value of the last argument of the previous command.  Frequently I do ``ls`` to list a long directory name, and then I find I want to ``cd`` into it.  Just do ``cd $_``.

.. sourcecode:: bash

    > cd
    > ls Desktop
    MyUnix
    > cd $_
    > pwd
    /Users/telliott_admin/Desktop
    > 

.. sourcecode:: bash

    > cd
    > ls Desktop
    MyUnix
    > cd !$
    cd Desktop
    > pwd
    /Users/telliott_admin/Desktop
    > 
    

That's an introductory summary of useful navigation commands.
