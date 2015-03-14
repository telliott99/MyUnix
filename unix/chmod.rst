.. _chmod:

#############################
Permissions and Paths (chmod)
#############################

Here is the output of ``ls -al``::

    > touch x.txt
    > ls -al x.txt
    -rw-r--r--  1 telliott_admin  staff  0 Mar  3 08:07 x.txt
    >

Our brand new file has permissions ``rw-r--r--``.  Permissions are shown in three groups of three activities.  The three groups are for the user, his/her "group" and the "world".  The three activities are read-write-execute.

Another way to specify one group of activities and their permissions is by use of a "bit mask", which is specified as an integer in the range [1..7].  Think of this in binary::

    000  0  nothing
    001  1  execute
    010  2  write
    011  3  write-execute
    100  4  read
    101  5  execute
    110  6  read-write
    111  7  read-write-execute

So the default permissions for ``x.txt`` are ``rw-r--r--`` which is also ``644``.  Permissions can be changed with the command ``chmod``::

    > ls -al x.txt
    -rw-r--r--  1 telliott_admin  staff  0 Mar  3 08:07 x.txt
    > ls -al x.txt
    -rw-r--r--  1 telliott_admin  staff  0 Mar  3 08:07 x.txt
    > chmod 755 x.txt
    > ls -al x.txt
    -rwxr-xr-x  1 telliott_admin  staff  0 Mar  3 08:07 x.txt
    >

By doing ``chmod 755 <filename>``, we add the ability to execute the file, which is useful if it encodes a program in binary.  Not so useful for a text file.

Another shorthand is to specify the particular permission to be altered.  The command ``chmod u+x <filename>`` leaves all other permission the same but upgrades ``u`` (the user) to have ``x`` (execute) priveleges.  We can also downgrade permission(s) with ``-`` (minus)::

    > chmod u+x x.txt
    > ls -al x.txt
    -rwxr--r--  1 telliott_admin  staff  0 Mar  3 09:58 x.txt
    >
    
Let's take a look at the ``/bin`` directory::

    > ls -al /bin
    total 5120
    drwxr-xr-x@ 39 root  wheel     1326 Jan 27 15:50 .
    drwxr-xr-x  34 root  wheel     1224 Mar  3 02:46 ..
    -rwxr-xr-x   2 root  wheel    18480 Sep  9 18:44 [
    -r-xr-xr-x   1 root  wheel   628640 Oct 27 00:01 bash
    -rwxr-xr-x   1 root  wheel    19552 Sep  9 18:57 cat
    -rwxr-xr-x   1 root  wheel    30112 Sep  9 18:50 chmod
    ..

This is where the standard Unix utilities live.  Notice that their user is "root" and root's group is "wheel".  Therefore the available permissions for us are those of the "world" because we are not part of the "wheel" group (we are in the "admin" group, however).

I looked around and found a file for which we do not have read permission::

    > cat /private/etc/ssh_host_rsa_key
    cat: /private/etc/ssh_host_rsa_key: Permission denied
    > sudo cat /private/etc/ssh_host_rsa_key
    Password:
    -----BEGIN RSA PRIVATE KEY-----
    MIIEow
    ..

No, I'm not going to show you this private key.

But we got "Permission denied" and then we temporarily elevated our permissions by doing ``sudo <command> <filename>``.  See

http://en.wikipedia.org/wiki/Sudo
http://xkcd.com/149/

``sudo`` stands for "superuser, do once".

For more on root (superuser), see

http://en.wikipedia.org/wiki/Superuser

Root can do anything, go anywhere or read anything on a Unix machine.  Root can delete your account.  Don't run as root, it can be dangerous.

**$PATH**

When we enter a command like ``cat``, the operating system looks through a fixed series of directories called the PATH to find a file matching this name, and then tries to execute it.  In the case of ``cat``, we can see which file was determined to match with ``which``::

    > which cat
    /bin/cat
    > ls -al /bin/cat
    -rwxr-xr-x  1 root  wheel  19552 Sep  9 18:57 /bin/cat
    >

``PATH`` is an "environmental variable" and it's usually called ``$PATH`` because that is how you enter a variable when you want to use it in the shell.  In a freshly made user account, you should get something like this::

    Toms-MacBook-Air:Desktop telliott_admin$ echo $PATH
    /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

The default ``$PATH`` variable consists of five paths (separated by ``:``).  They are specified in ``/private/etc/paths``::

    > cat /private/etc/paths
    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    >

Something else has happened as well.  Rather than make a new account, I moved a file called ``.bash_profile`` that I have in my home directory that dictates some things about my shell.  

So before I did the above I did to simulate starting the shell in a fresh user account.  Now revert that change::

    > mv ~/.bash_profile ~/Desktop/x.txt

The hidden file ``.bash_profile`` contains instructions to customize my shell.  After moving it back where it belongs, we restart Terminal again, and then we take a look::

    > cat ~/.bash_profile
    export PATH=/usr/local/bin:$HOME/bin:$HOME/Software/go/bin:$PATH
    export RDP_JAR_PATH=$HOME/Software/rdp_classifier/rdp_classifier-2.0.jar
    export BLASTMAT=$HOME/bin/blast/programs/blast-2.2.22/data
    PS1="> "
    alias tm='open -a TextMate'
    alias oh='open -a Safari _build/html/index.html'
    alias ts='python typeset/scripts/script.py'
    >
    
As we saw the default command line prompt is long.  I think it's ugly and I don't like it::

    Toms-MacBook-Air:Desktop telliott_admin$ 
    
There is a reason behind it however.  A power user might be logged into multiple machines.  Knowing which one a particular shell is on, and the current directory and the username, can be very helpful.

I fixed my ugly prompt problem by doing ``PS1="> "``.  After that ``>`` (with a space after) is my new prompt.

What this line does::

    export PATH=/usr/local/bin:$HOME/bin:$HOME/Software/go/bin:$PATH

is to re-define the ``$PATH``` variable to be the default ``$PATH`` with several new directories added in front::

    /usr/local/bin
    $HOME/bin
    $HOME/Software/go/bin

After the redefinition, we have to ``export`` the variable by using the given syntax---no ``$`` for the export part.  We could also do::

    PATH=/usr/local/bin:$HOME/bin:$HOME/Software/go/bin:$PATH;  export PATH

``$HOME`` is Unix shorthand for the home directory.  The semicolon ``;`` can be used to put two separate statements or commands on one line.  Also, for commands that might be saved in a file, the symbol ``#`` indicates a comment, anything following the symbol to the end of the line is ignore by the shell.

The above explanation about ``.bash_profile`` conceals something.  When I got rid of ``.bash_profile`` and did ``echo $PATH``, what I actually got was::

    Toms-MacBook-Air:Desktop telliott_admin$ echo $PATH
    /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/usr/texbin
    Toms-MacBook-Air:Desktop telliott_admin$

In other words, I do not have a "stock install" or fresh account here.  Two programs called ``MacGPG2`` and ``Tex`` have modified my ``$PATH``.  To read more about how this was done see:

http://tex.stackexchange.com/questions/29744/where-is-path-modified-to-include-usr-texbin

To see the values of all the environmental variables you can do::

    > env
    TERM_PROGRAM=Apple_Terminal
    SHELL=/bin/bash
    TERM=xterm-256color
    TMPDIR=/var/folders/1l/d7lmw_ln5hb933r7jbkt6mq00000gn/T/
    Apple_PubSub_Socket_Render=/private/tmp/com.apple.launchd.RejRzmTmFD/Render
    TERM_PROGRAM_VERSION=343.6
    OLDPWD=/Users/telliott_admin
    TERM_SESSION_ID=7B0BEDFB-DA9A-459B-947C-A22A5A0F03DA
    USER=telliott_admin
    SSH_AUTH_SOCK=/private/tmp/com.apple.launchd.B6chxxAR0s/Listeners
    __CF_USER_TEXT_ENCODING=0x1F5:0x0:0x0
    PATH=/usr/local/bin:/Users/telliott_admin/bin:/Users/telliott_admin/Software/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/usr/texbin
    PWD=/Users/telliott_admin/.gnupg
    LANG=en_US.UTF-8
    XPC_FLAGS=0x0
    XPC_SERVICE_NAME=0
    SHLVL=1
    HOME=/Users/telliott_admin
    LOGNAME=telliott_admin
    BLASTMAT=/Users/telliott_admin/bin/blast/programs/blast-2.2.22/data
    RDP_JAR_PATH=/Users/telliott_admin/Software/rdp_classifier/rdp_classifier-2.0.jar
    _=/usr/bin/env
    >

Most of the them are not very interesting to me, but the last two were set using these lines in ``~/.bash_profile``::

    export RDP_JAR_PATH=$HOME/Software/rdp_classifier/rdp_classifier-2.0.jar
    export BLASTMAT=$HOME/bin/blast/programs/blast-2.2.22/data

It's the same usage as for ``$PATH``

Read more about setting environmental variables here:

http://stackoverflow.com/questions/135688/setting-environment-variables-in-os-x

Why talk so much about ``$PATH``?

For one thing, a poorly formed ``$PATH`` can be the source of headaches and failures when you install software from the command line.  Also, modifying $PATH helps to keep things organized.  The default ``$PATH``::

    /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

does not include anything in my home directory or sub-directory.  The purpose of adding ``$HOME/bin`` as in::

    $HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
    
is so that I can make a new directory ``~/bin`` and put my own programs there (recall that ``~`` is shorthand for the home directory).  

Let's do something with Python, since it comes with OS X.  Here is a simple Python script:

``hello.py``

.. sourcecode:: python

    print "Hello, world!"

The filename is ``hello.py`` and it's on my Desktop.  I can do this from the ``Desktop`` directory::

    > python hello.py
    Hello, world!
    >

The way this works is that the command ``python`` starts Python.  It is in ``/usr/local/bin/python``::

    > which python
    /usr/local/bin/python
    >

and then Python searches a $PATH which includes the directory where the shell is when Python starts, thus allowing it find my script.  

Now, I can add another line to the script

``hello.py``

.. sourcecode:: python

    #! /usr/local/bin/python
    print "Hello, world!"
    
The ``#!`` is a special instruction that tells the shell to dial up Python and then execute what comes next.

I'll be able to execute this program if I first making it executable with ``chmod`` and then just enter the name of the program::

    > ls -al hello.py
    -rw-r--r--@ 1 telliott_admin  staff  46 Mar  3 09:15 hello.py
    > chmod 755 hello.py
    > hello.py
    -bash: hello.py: command not found
    
Well, there is one more wrinkle!  It seems to be a security issue not to allow invocation of a program name by itself from the current directory.  So what we told the shell was to go to the current directory with ``.``, and then come back down to find ``/hello.py``::

    > ./hello.py
    Hello, world!
    >

Now, I don't want a bunch of scripts littering my Desktop.  So I make a directory to hold them, and move this new one there::

    > mkdir ~/bin
    > mv hello.py ~/bin
    > hello.py
    Hello, world!
    >

I won't actually demonstrate this, if but I didn't have ``$HOME:bin`` (that is ``telliott_admin/bin``) on my ``$PATH``, this would not work.  The operating system wouldn't know where to look for ``hello.py``.  At worst, it might find another file with the same name written at another time or even by someone else!

One last topic:  aliases.  Look again at ``.bash_profile``, and particularly at the last 3 lines::

    alias tm='open -a TextMate'
    alias oh='open -a Safari _build/html/index.html'
    alias ts='python typeset/scripts/script.py'

These mean that I can type a shorthand version for the long commands on the right-hand side.  You can do this for basically any command or series of commands (try to make sure that the alias doesn't already have a meaning before you define it).

For example, every time I ``make`` the html for this book, after that I do ``oh`` and it launches the browser so I can see my results immediately.  That's pretty cool.  I do ``make`` frequently so I can visualize the effect of the changes on the page in the browser.