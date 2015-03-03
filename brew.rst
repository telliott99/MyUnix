.. _brew:

########
Homebrew
########

Homebrew is a "package manager" for OS X.  I have used it happily for several years.  Homebrew was not the first one available:  it was fink and then Macports, but I prefer Homebrew.  Do not even try fink, it is aptly named, and will mess up your machine.

The home page for Homebrew is here:

http://brew.sh

and explains how to obtain it.  Paste this into Terminal and run it:

.. sourcecode:: bash

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

``ruby`` is another interpreted language, in some ways similar to Python and in others quite different.  You may recognize another terminal command in there, ``curl``.  You are downloading a ruby script from that URL and then executing it with the ruby interpreter that is in OS X.

Since I already have Homebrew installed, I've used it to add a bunch of software to my laptop:

.. sourcecode:: bash

    > brew list
    cloog		go		pkg-config
    fasttree	isl		python
    freetype	libmpc		python3
    gdbm		libpng		readline
    gfortran	mpfr		sqlite
    git		muscle		xz
    gmp		openssl		youtube-dl
    >

It is hard for me to demonstrate Homebrew since I already have it installed.  So I think what I'm going to do is to remove it and all the programs that I have installed using it, and try doing it all again.  Wish me luck!

As the website says:

    Homebrew installs packages to their own directory and then symlinks their files into /usr/local.  Homebrew wonâ€™t install files outside its prefix, and you can place a Homebrew installation wherever you like.
    
What this means is that, if I delete ``/usr/local``, Homebrew and everything else will be gone, including two things that aren't Homebrew:  ``MacGPG2`` and ``texlive``.

.. sourcecode:: bash

    > rm -rf /usr/local

and it hung!  That should not have happened.  (The ``-f`` option means don't prompt to ask if I really want to do this for each file.  What's probably happening is a permissions problem that leads to an error, which is silenced).

When I moved into ``/usr/local`` and started deleting subdirectories one-by-one, it became apparent what had happened.  The ``MacGPG2`` files were installed with altered permissions and altered owners.  Bad bad bad boys.  I just used ``sudo`` on that one.  Part of the deal with ``/usr/local`` is it should not have restricted access.

Now to start over:

.. sourcecode:: bash

    > mkdir /usr/local
    mkdir: /usr/local: Permission denied
    >

What's going on?  Permission is being denied because of something about ``/usr``.

.. sourcecode:: bash

    > ls -al usr
    total 16
    drwxr-xr-x@   13 root  wheel    442 Mar  3 11:04 .
    drwxr-xr-x    34 root  wheel   1224 Mar  3 08:29 ..

So the problem is that ``/usr/`` is owned by "root".  As part of "world" in this context, I don't have write permissions for this directory.  That's OK, just use ``sudo`` again.

.. sourcecode:: bash

    > cd /usr
    > sudo mkdir local
    Password:
    > ls local
    > ls -al local
    total 0
    drwxr-xr-x   2 root  wheel   68 Mar  3 11:11 .
    drwxr-xr-x@ 14 root  wheel  476 Mar  3 11:11 ..
    >

Now, I don't want these owner/group designations etc. on ``/usr/local``.  See, for example

http://apple.stackexchange.com/questions/1393/are-my-permissions-for-usr-local-correct

So, time for a little ``sudo`` juice:

.. sourcecode:: bash

    > sudo chown -R `whoami` /usr/local
    > sudo chgrp -R admin /usr/local
    > ls -al local
    total 0
    drwxr-xr-x   2 telliott_admin  admin   68 Mar  3 11:11 .
    drwxr-xr-x@ 14 root            wheel  476 Mar  3 11:11 ..
    >

That's got'er fixed!

.. sourcecode:: bash

    > ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ==> This script will install:
    /usr/local/bin/brew
    /usr/local/Library/...
    /usr/local/share/man/man1/brew.1

    Press RETURN to continue or any other key to abort
    ==> Downloading and installing Homebrew...
    remote: Counting objects: 234552, done.
    remote: Compressing objects: 100% (9/9), done.
    remote: Total 234552 (delta 2), reused 0 (delta 0), pack-reused 234543
    Receiving objects: 100% (234552/234552), 29.91 MiB | 1.39 MiB/s, done.
    Resolving deltas: 100% (175904/175904), done.
    From https://github.com/Homebrew/homebrew
     * [new branch]      master     -> origin/master
    HEAD is now at ad4cebe xctool: update 0.2.3 bottle.
    ==> Installation successful!
    ==> Next steps
    Run `brew doctor` before you install anything
    Run `brew help` to get started
    > brew doctor
    Your system is ready to brew.
    >

Let's start with ``git``:

.. sourcecode:: bash

    > brew install git
    ==> Downloading https://homebrew.bintray.com/bottles/git-2.3.1.yosemite.bottle.tar.gz
    ######################################################################## 100.0%
    ==> Pouring git-2.3.1.yosemite.bottle.tar.gz
    ==> Caveats
    The OS X keychain credential helper has been installed to:
      /usr/local/bin/git-credential-osxkeychain

    The "contrib" directory has been installed to:
      /usr/local/share/git-core/contrib

    Bash completion has been installed to:
      /usr/local/etc/bash_completion.d

    zsh completion has been installed to:
      /usr/local/share/zsh/site-functions
    ==> Summary
    í ¼í½º  /usr/local/Cellar/git/2.3.1: 1359 files, 31M
    >

.. sourcecode:: bash

    > brew list
    git
    >

We'll install the latest Python in the 2.xx family.

.. sourcecode:: bash

    > brew install python2.7
    Error: No available formula for python2.7 
    Searching formulae...
    Searching taps...
    > brew install python
    ==> Installing dependencies for python: readline, sqlite, gdbm, openssl
    ==> Installing python dependency: readline
    ==> Downloading https://homebrew.bintray.com/bottles/readline-6.3.8.yosemite.bottle.tar.gz
    ######################################################################## 100.0%
    ==> Pouring readline-6.3.8.yosemite.bottle.tar.gz
    ==> Caveats
    This formula is keg-only, which means it was not symlinked into /usr/local.

    Mac OS X provides similar software, and installing this software in
    parallel can cause all kinds of trouble.

    OS X provides the BSD libedit library, which shadows libreadline.
    In order to prevent conflicts when programs look for libreadline we are
    defaulting this GNU Readline installation to keg-only.

    Generally there are no consequences of this for you. If you build your
    own software and it requires this formula, you'll need to add to your
    build variables:

        LDFLAGS:  -L/usr/local/opt/readline/lib
        CPPFLAGS: -I/usr/local/opt/readline/include

    ==> Summary
    í ¼í½º  /usr/local/Cellar/readline/6.3.8: 40 files, 2.1M
    ==> Installing python dependency: sqlite
    ==> Downloading https://homebrew.bintray.com/bottles/sqlite-3.8.8.3.yosemite.bottle.tar.gz
    ######################################################################## 100.0%
    ==> Pouring sqlite-3.8.8.3.yosemite.bottle.tar.gz
    ==> Caveats
    This formula is keg-only, which means it was not symlinked into /usr/local.

    Mac OS X already provides this software and installing another version in
    parallel can cause all kinds of trouble.

    OS X provides an older sqlite3.

    Generally there are no consequences of this for you. If you build your
    own software and it requires this formula, you'll need to add to your
    build variables:

        LDFLAGS:  -L/usr/local/opt/sqlite/lib
        CPPFLAGS: -I/usr/local/opt/sqlite/include

    ==> Summary
    í ¼í½º  /usr/local/Cellar/sqlite/3.8.8.3: 9 files, 2.1M
    ==> Installing python dependency: gdbm
    ==> Downloading https://homebrew.bintray.com/bottles/gdbm-1.11.yosemite.bottle.2.tar.gz
    ######################################################################## 100.0%
    ==> Pouring gdbm-1.11.yosemite.bottle.2.tar.gz
    í ¼í½º  /usr/local/Cellar/gdbm/1.11: 17 files, 532K
    ==> Installing python dependency: openssl
    ==> Downloading https://homebrew.bintray.com/bottles/openssl-1.0.2.yosemite.bottle.tar.gz
    ######################################################################## 100.0%
    ==> Pouring openssl-1.0.2.yosemite.bottle.tar.gz
    ==> Caveats
    A CA file has been bootstrapped using certificates from the system
    keychain. To add additional certificates, place .pem files in /usr/local/etc/openssl/certs
    and run /usr/local/opt/openssl/bin/c_rehash

    This formula is keg-only, which means it was not symlinked into /usr/local.

    Mac OS X already provides this software and installing another version in
    parallel can cause all kinds of trouble.

    Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries

    Generally there are no consequences of this for you. If you build your
    own software and it requires this formula, you'll need to add to your
    build variables:

        LDFLAGS:  -L/usr/local/opt/openssl/lib
        CPPFLAGS: -I/usr/local/opt/openssl/include

    ==> Summary
    í ¼í½º  /usr/local/Cellar/openssl/1.0.2: 459 files, 18M
    ==> Installing python
    ==> Downloading https://homebrew.bintray.com/bottles/python-2.7.9.yosemite.bottle.10.tar.gz
    ######################################################################## 100.0%
    ==> Pouring python-2.7.9.yosemite.bottle.10.tar.gz
    ==> Caveats
    Setuptools and pip have been installed. To update them
        pip install --upgrade setuptools
        pip install --upgrade pip

    You can install Python packages with
        pip install <package>

    They will install into the site-package directory
        /usr/local/lib/python2.7/site-packages

    See: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Homebrew-and-Python.md

    .app bundles were installed.
    Run `brew linkapps python` to symlink these to /Applications.
    ==> /usr/local/Cellar/python/2.7.9/bin/python -s setup.py --no-user-cfg install --force --verbo
    ==> /usr/local/Cellar/python/2.7.9/bin/python -s setup.py --no-user-cfg install --force --verbo
    ==> Summary
    í ¼í½º  /usr/local/Cellar/python/2.7.9: 4810 files, 78M
    >

These are all pre-built for my OS X version (Yosemite), so it only takes a minute.  There isn't much from my previous brew packages that I really need.  Recall we had:

.. sourcecode:: bash

    > brew list
    cloog		go		pkg-config
    fasttree	isl		python
    freetype	libmpc		python3
    gdbm		libpng		readline
    gfortran	mpfr		sqlite
    git		muscle		xz
    gmp		openssl		youtube-dl
    >

I should not need ``gfortran`` (I think read something about clang or llvm having it?).  I *will* need ``libpng`` for ``matplotlib``, and ``youtube-dl`` is useful.

.. sourcecode:: bash

    > brew install libpng
    ==> Downloading https://homebrew.bintray.com/bottles/libpng-1.6.16.yosemite.bottle.tar.gz
    ######################################################################## 100.0%
    ==> Pouring libpng-1.6.16.yosemite.bottle.tar.gz
    í ¼í½º  /usr/local/Cellar/libpng/1.6.16: 17 files, 1.3M
    > brew install youtube-dl
    ==> Downloading https://homebrew.bintray.com/bottles/youtube-dl-2015.02.28.yosemite.bottle.tar.
    ######################################################################## 100.0%
    ==> Pouring youtube-dl-2015.02.28.yosemite.bottle.tar.gz
    ==> Caveats
    To use post-processing options, `brew install ffmpeg` or `brew install libav`.

    Bash completion has been installed to:
      /usr/local/etc/bash_completion.d

    zsh completion has been installed to:
      /usr/local/share/zsh/site-functions
    ==> Summary
    í ¼í½º  /usr/local/Cellar/youtube-dl/2015.02.28: 8 files, 980K
    >

Python packages are usually installed with a tool called ``pip``.  We want to make sure that the ``pip`` we use is the one for the Python we just installed.  Because of the way our ``$PATH`` is set up, we get the new Python from ``python``

.. sourcecode:: bash

    > which python
    /usr/local/bin/python
    > python
    Python 2.7.9 (default, Feb 10 2015, 03:28:08) 
    [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.56)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> 
    [3]+  Stopped                 python
    >
    > which pip
    /usr/local/bin/pip
    >

The prefix ``/usr/local`` tells me this is the ``pip`` we want.

.. sourcecode:: bash

    > which pip
    /usr/local/bin/pip
    > pip install virtualenv
    Requirement already satisfied (use --upgrade to upgrade): virtualenv in /Library/Python/2.7/site-packages
    >

Guess it was already there.  So now, we are ready to set up Python.  I will do that in the next chapter.

