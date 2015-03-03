.. _navigation:

################################
Navigating from the command line
################################

When you first run the Terminal application, or obtain a command line environment, you will be greeted with a prompt.  I like mine as simple as possible, so I have modified my shell to show only this:

.. sourcecode:: bash

    > 

This is called the command prompt.  When you see the command prompt, the shell is ready and awaits your input.

**pwd, cd and ls**

The three most often useful commands are ``pwd`` (print working directory), ``cd < dirname >`` (change directory), and ``ls < dirname >``.

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
    
``pwd`` prints the directory you are "in", according to the shell.  Terminal has a sense of where you are in the file system.  Your home directory is your username (here:  ``telliott_admin``).  It lives under the ``Users`` directory, which is one of the directories at top-level in the file system.

The ``cd`` command usually operates on a destination directory name that is typed in.  A very useful feature of the shell is "command completion".  Starting from ``/Users/telliott_admin``, if I type

.. sourcecode:: bash

    > cd De

and then press TAB, the rest of ``Desktop/`` will autocomplete.  If there is more than one possibility, the screen will blink with the first press, and then when I press TAB again, the shell will display options:

.. sourcecode:: bash

    > cd Des
    Desktop/      Destinations/ 
    > cd Des

typing another letter gives the shell enough information to autocomplete (after another TAB).

Used by itself the ``cd`` command will return you to your home directory.  ``ls`` (with no arguments) will list the contents of the current directory.

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

Directory structure in Unix is conceptualized by the idea of a "path" to each directory or file, starting from the from the ``root`` of the directory hierarchy, ``/Users``.  The symbol ``/`` is used to separate path elements, and it is an idiosyncrasy of Unix that spaces are not allowed in filenames or paths.  Of course OS X allows spaces.  To include a space in a Unix-style filename on OS X, type a forward slash before the space:

.. sourcecode:: bash

    > cd my\ sub-directory

Some directories above have the ``path`` given as a "relative path", which starts from the current directory.  But the result of the ``pwd`` command, for example, shows an "absolute path" which starts from ``root``.  

Either method can be used to specify a directory or filename.  If we are in my home directory ``/Users/telliott_admin``, both of these are valid names for the Desktop directory:

.. sourcecode:: bash

    > ls Desktop/
    MyUnix
    > ls /Users/telliott_admin/Desktop/
    MyUnix

I don't know if it's a good thing or not, but I am easily distracted by the output of previous commands in the shell, so I like to clear the screen regularly with CMD-K.  Another important command to remember is the command to kill a process that you've started from the command line and is running amok.  Just do CTL-Z.

.. sourcecode:: bash

    > find /
    ..
    ^Z
    [2]+  Stopped                 find /
    >

Here, I typed ``find /``, which will list every file on my computer.  When I tire of seeing the output scroll by, I enter CTL-Z, which displays as ``^Z``, and then we see ``Stopped``, and finally the command prompt.

Many commands have options.  Even ``pwd`` has options, though they are too advanced for us at the moment.  But ``ls`` is usually run with options.  I make an empty file on my Desktop by using ``touch`` and then do ``ls``:

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

The plain ``ls`` command just shows the file I made (plus the directory MyUnix which contains this project).  Adding the ``-a`` and ``-l`` "flags" (combined as ``-al``) shows (``-a``) all files, even hidden ones whose names start with a ``.``.  For example here we see that the directory contains a reference to itself (the single ``.``), a reference to its parent directory ``..``, and a special hidden OS X file ``.DS_Store``, in addition.

The ``-l`` flag modifies how the data for the files is displayed.  We get a 10- or 11-character group like ``drwxr-xr-x`` for ``MyUnix``.  The ``d`` stands for directory, and the equivalent position in the output for the file ``x.txt`` is just `-`.  Then there are three sets of three "permissions".  The three sets are for the user, her group, and the "world", all users on the machine.  Permissions refer to the ability to ``r`` read, ``w`` write, or `x` execute files or programs.  I am not sure what the ``1``.

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

As we said, flags can be combined, as in ``-al``.  Sometimes flags are whole words (or may be either whole words or single letter abbreviations).  For a flag that's a whole word, Unix uses a double-dash prefix.  Here is a made-up example:

.. sourcecode:: bash

    > myprog --update

As we said, ``.`` is a shorthand symbol for the current directory, and ``..`` is a symbol for the parent of the current directory.  Another such symbol is ``~``, which means the user's home directory.  So, for example

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

The shell keeps track of the commands you've entered.  One way to navigate this history is to use the up-arrow, which will move you successively backward in time, displaying one command after the prompt, but not executing it.  To run the command, press RETURN.  To see all of your history, enter ``history``

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

      ..
      550  cd ..
      551  pwd
      552  cd Desktop/
      553  cd ~
      554  pwd
      555  history
      556  history
    >

That's a introductory summary of useful navigation commands.
