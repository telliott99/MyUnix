.. _git1-setup:

###########
Git:  Setup
###########

**Version control**

Why version control:

http://git-scm.com/book/en/v2/Getting-Started-About-Version-Control

Entire books have been written about **git**.

http://git-scm.com/book/en/v2

Great, free and online.  In the past, other systems (cvs, mercurial) have been popular, but today, git is it.

I am not a power user or anything.  These chapters will just summarize the basic ways that I use it.  The first issue is about setup.

**git init**

git comes with OS X, 

.. sourcecode:: bash

    > ls -al /usr/bin/gi*
    -rwxr-xr-x  1 root  wheel  14160 Sep 29 01:38 /usr/bin/git
    -rwxr-xr-x  1 root  wheel  14176 Sep 29 01:38 /usr/bin/git-cvsserver
    -rwxr-xr-x  1 root  wheel  14192 Sep 29 01:38 /usr/bin/git-receive-pack
    -rwxr-xr-x  1 root  wheel  14160 Sep 29 01:38 /usr/bin/git-shell
    -rwxr-xr-x  1 root  wheel  14192 Sep 29 01:38 /usr/bin/git-upload-archive
    -rwxr-xr-x  1 root  wheel  14192 Sep 29 01:38 /usr/bin/git-upload-pack
    >

but I upgraded it by using Homebrew.

.. sourcecode:: bash

    > which git
    /usr/local/bin/git
    > 

.. sourcecode:: bash

    > brew list
    gdbm     libpng     readline      youtube-dl
    git      openssl    sqlite
    > git --version
    git version 2.3.1
    >

In fact Homebrew makes extensive use of git.

**Basic example**

Make a new directory containing a single file, and then

* ``git init`` to initialize a repository
* ``git add < filename >`` to track files
* ``git status`` to check
* ``git commit -m < "message" >`` to *commit* to the new repository.

.. sourcecode:: bash

    > mkdir tmp
    > cd tmp
    > touch x.txt
    > git init
    Initialized empty Git repository in /Users/telliott_admin/Desktop/tmp/.git/
    > git status
    On branch master

    Initial commit

    Untracked files:
      (use "git add <file>..." to include in what will be committed)

    	x.txt

    nothing added to commit but untracked files present (use "git add" to track)
    > git add x.txt
    > git status
    On branch master

    Initial commit

    Changes to be committed:
      (use "git rm --cached <file>..." to unstage)

    	new file:   x.txt

    > git commit -m "initial commit"
    [master (root-commit) b3a7a88] initial commit
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 x.txt
    > 

Various commands to check things out.

* ``git log``
* ``git log --pretty=oneline``

.. sourcecode:: bash

     > git log
     commit b3a7a8890da7b8008c3ba8b2e368105b49daa60f
     Author: Tom Elliott <telliott@hsc.wvu.edu>
     Date:   Thu Mar 5 17:39:50 2015 -0500

         initial commit
     > git log --pretty=oneline
     b3a7a8890da7b8008c3ba8b2e368105b49daa60f initial commit
     > 
     
The book says one can skip the ``add`` step by using the ``-a`` flag with ``git commit``:

.. sourcecode:: bash

    > man git-commit
    -a, --all
         Tell the command to automatically stage
         files that have been modified and deleted,
         but new files you have not told Git about
         are not affected.

but it doesn't work for me:

.. sourcecode:: bash

    > git status
    On branch master
    nothing to commit, working directory clean
    > echo "abc" >> x.txt
    > git status
    On branch master
    Changes not staged for commit:
      (use "git add <file>..." to update what will be committed)
      (use "git checkout -- <file>..." to discard changes in working directory)

    	modified:   x.txt

    no changes added to commit (use "git add" and/or "git commit -a")
    > git commit -a "no message"
    fatal: Paths with -a does not make sense.
    > git commit -a x.txt
    fatal: Paths with -a does not make sense.
    >


[ Todo:  difference between ``rm`` and ``rm --cached``]

Rather than cycle through all the files you've changed, you can add them all at once with

.. sourcecode:: bash

    > git add .

**gitignore**

Commonly, one may have files present in a project that you don't want to have tracked by git.  Use ``.gitignore`` for this.  For example

.. sourcecode:: bash

    > cd scripter/
    > cat scripter/.gitignore
    cat: scripter/.gitignore: No such file or directory
    > ls
    app		config.py	run.py		scripts
    > ls -al
    total 24
    drwxr-xr-x   8 telliott_admin  staff  272 Mar  4 02:34 .
    drwxr-xr-x@ 14 telliott_admin  staff  476 Mar  4 02:34 ..
    drwxr-xr-x  12 telliott_admin  staff  408 Mar  4 02:34 .git
    -rw-r--r--   1 telliott_admin  staff   22 Mar  4 02:34 .gitignore
    drwxr-xr-x   8 telliott_admin  staff  272 Mar  4 02:34 app
    -rw-r--r--   1 telliott_admin  staff   56 Mar  4 02:34 config.py
    -rwxr-xr-x   1 telliott_admin  staff   66 Mar  4 02:34 run.py
    drwxr-xr-x  10 telliott_admin  staff  340 Mar  4 02:34 scripts
    > cat .gitignore
    **/*.pyc
    **/.DS_Store
    >

This instructs git not to track any ``.pyc`` files and not to track the special OS X file ``.DS_Store``.

* the ** matches all directories

Chacon on glob patterns

    Glob patterns are like simplified regular expressions that shells use. An asterisk (*) matches zero or more characters; [abc] matches any character inside the brackets (in this case a, b, or c); a question mark (?) matches a single character; and brackets enclosing characters separated by a hyphen ([0–9]) matches any character between them (in this case, 0 through 9).

* ``# comment``
* ``*.a``        # no .a files
* ``!lib.a``     # ! negates so do track lib.a
* ``/filename``  # only ignore top-level
* ``build/``     # ignore all files in build dir

**Pull from a repository**

I have several projects up on github.  From the Desktop

.. sourcecode:: bash

    > git clone git://github.com/telliott99/scripter.git
    Cloning into 'scripter'...
    remote: Counting objects: 97, done.
    remote: Total 97 (delta 0), reused 0 (delta 0), pack-reused 97
    Receiving objects: 100% (97/97), 757.23 KiB | 475.00 KiB/s, done.
    Resolving deltas: 100% (48/48), done.
    Checking connectivity... done.
    >

**Configuration**

git may be configured at a *global* level, at the level of the individual *user*, or a *project* basis.  config files for these will be in (respectively):

* ``/etc/gitconfig``
* ``~/.gitconfig``
* ``myproject/.gitconfig``

.. sourcecode:: bash

    > cat scripter/.gitconfig
    cat: scripter/.gitconfig: No such file or directory
    > cat ~/.gitconfig
    [user]
    	name = Tom Elliott
    	email = telliott@hsc.wvu.edu
    [core]
    	editor = TextMate
    [filter "media"]
    	clean = git-media-clean %f
    	smudge = git-media-smudge %f
    > cat /etc/gitconfig
    cat: /etc/gitconfig: No such file or directory
    >

These values were set by doing:

.. sourcecode:: bash

    > git config --global user.name "Tom Elliott"
    > git config --global user.email "telliott@hsc.wvu.edu"
    > git config --global core.editor TextMate

and can be checked by doing:

.. sourcecode:: bash

    > git config --list
    user.name=Tom Elliott
    user.email=telliott@hsc.wvu.edu
    core.editor=TextMate
    filter.media.clean=git-media-clean %f
    filter.media.smudge=git-media-smudge %f
    >

**Adding an existing project to github**

Situation:  you already have a github account, and want to put a new project up there.  Let's say I have already done ``git init`` and have an initial commit.

Next:  login to github.  

The instructions are here:

https://help.github.com/articles/create-a-repo/

On the website, click the ``+`` at the top-right corner (on the github page, next to your username).  Set up a public repository, following the directions

I will do one for this project, which I just started yesterday, so it isn't on github yet.  I'm calling it **MyUnix**.

After that, I should be able to ``cd`` into the  ``MyUnix`` project directory and do:

.. sourcecode:: bash

    > git remote add origin git@github.com:telliott99/MyUnix.git
    > git push -u origin master
    Counting objects: 42, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (38/38), done.
    Writing objects: 100% (42/42), 71.37 KiB | 0 bytes/s, done.
    Total 42 (delta 10), reused 0 (delta 0)
    To git@github.com:telliott99/MyUnix.git
     * [new branch]      master -> master
    Branch master set up to track remote branch master from origin.
    >

Since I am already set up to use SSH to connect, it just works.  No password prompt.

We can check it:

.. sourcecode:: bash

    > git remote -v
    origin	git@github.com:telliott99/MyUnix.git (fetch)
    origin	git@github.com:telliott99/MyUnix.git (push)
    >

**Setting up to do SSH**

These are my notes on setting up SSH for github.  I decided not to mess with my existing setup right now to check it.

Here is the github webpage about it:

https://help.github.com/articles/generating-ssh-keys/

* check for existing ssh keys

.. sourcecode:: bash

    > ls -al ~/.ssh

* make sure you invoke the OS X version of ``ssh-keygen``

.. sourcecode:: bash

    > which ssh-keygen
    /usr/bin/ssh-keygen

* generate a new key pair --- only if necessary

.. sourcecode:: bash

    > ssh-keygen -t rsa -C "telliott999@gmail.com"

* start up ssh-agent:

.. sourcecode:: bash

    eval "$(ssh-agent -s)"

Read about ssh-agent here:

https://en.wikipedia.org/wiki/Ssh-agent

    ssh-agent is a program that, used together with OpenSSH or similar SSH programs, provides a secure way of storing the private key. For private keys that require a passphrase, ssh-agent allows the user to connect multiple times without having to repeatedly type the passphrase.

* use ``ssh-agent`` to add the key pair to my "keychain":

.. sourcecode:: bash

    > ssh-add ~/.ssh/id_rsa

Note:  I actually did

    > ssh-add -K ~/.ssh/id_rsa
    
The ``-K`` flag also adds my passphrase to the keychain.  Which is a good thing since I believe I have forgotten my passphrase:

.. sourcecode:: bash

    > ssh-keygen -p
    Enter file in which the key is (/Users/telliott_admin/.ssh/id_rsa): 
    Enter old passphrase: 
    Bad passphrase.
    >
    
* copy the public key to the pasteboard

.. sourcecode:: bash

    > pbcopy < ~/.ssh/id_rsa.pub

* Using the website, paste the public key to my github account.

No do (as we did above):

.. sourcecode:: bash

    > git remote add origin git@github.com:telliott99/MyUnix.git
    > git push -u origin master

On the website, under settings, fingerprints are listed for two SSH keys associated with the account.  One is for my MacBook Air and one for the Mac mini

* 15:6e:84:e4:3d:7d:30:c7:af:11:f6:a8:35:b2:bb:57
* 76:b1:63:48:b1:55:7d:98:ef:bc:21:bd:fb:36:dc:43

Just check:

.. sourcecode:: bash

    > ssh-keygen -lf ~/.ssh/id_rsa.pub
    2048 15:6e:84:e4:3d:7d:30:c7:af:11:f6:a8:35:b2:bb:57  telliott999@gmail.com (RSA)
    >

Explanation of the different methods.

https://help.github.com/articles/which-remote-url-should-i-use/

You can tell at a glance which method we're using:  if the ``git://`` protocol is shown, that is SSH.  Otherwise, we might have something like

* ``https://github.com/username/myproject.git``

