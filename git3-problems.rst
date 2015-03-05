.. _git2-problems:

##########
Git:  more
##########

**A problem**

I am writing this book alone, and I use git to make sure that none of it gets lost accidently.  So the standard workflow that most occupies people learning git doesn't concern me too much.

However, I do run into occasional problems that need to be solved.  Here is one that, as I first write this, I don't know how to solve yet.

Normally I finish a section of work and do the usual

* ``git status``
* ``git add < filename > ``
* ``git remove --cached < filename >``
* ``commit -m "no message"

Now I ``push`` my changes up to github with

* ``git push -u origin master``

Yesterday, this is what I saw:

.. sourcecode:: bash

    > git push -u origin master
    To git@github.com:telliott99/MyUnix.git
     ! [rejected]        master -> master (fetch first)
    error: failed to push some refs to 'git@github.com:telliott99/MyUnix.git'
    hint: Updates were rejected because the remote contains work that you do
    hint: not have locally. This is usually caused by another repository pushing
    hint: to the same ref. You may want to first integrate the remote changes
    hint: (e.g., 'git pull ...') before pushing again.
    hint: See the 'Note about fast-forwards' in 'git push --help' for details.
    > git log --pretty=format:"%h %s"
    d6a15c5 no message
    1720267 new chapter
    aa986f9 no message
    7258ef5 first draft of git setup
    c098c64 proofreading first day's work
    b89f634 initial commit
    43ef239 initial commit
    > 

Well, of course, there is no "other repository".  Looking at the website, there is a commit that we are missing locally:

.. sourcecode:: bash

    e0aeb3b93a9e7fd535c6bad5baac32ed259b2dbb 1 parent 1720267
    telliott99 telliott99 authored 15 minutes ago

15 minutes!  How much can get lost in 15 minutes?

Possibly what happened is that I did not follow my usual routine with Dropbox.  I usually do ``make clean`` to remove the html (since each ``make html`` build changes the timestamps on the files, if the html goes to Dropbox it churns for a while).  Then I move the ``MyUnix`` folder to my Dropbox folder.  If I do copy (OPT-drag), Dropbox asks about "merging" and I don't like merging.  I like the version that's on my Desktop.  So I move to Dropbox, and then move back to the Desktop when I'm ready to work again.  Maybe somehow I messed this up, and took an old copy from Dropbox after a ``push``.  

Anyway, somehow I have to merge these things.  One thing I tried is certainly wrong, and pretty aggressive.  I saved a few files, but trashed the repo on my Desktop, and then ``git clone git://github.com/telliott99/MyUnix.git`` to start fresh.  (I know).  This leads to a second problem:

.. sourcecode:: bash

    > git push -u origin master
    fatal: remote error: 
      You can't push to git://github.com/telliott99/MyUnix.git
      Use https://github.com/telliott99/MyUnix.git
    >

github is complaining that I am not set up for SSH.

.. sourcecode:: bash

    > git remote set-url origin git@github.com:telliott99/MyUnix.git
    > git push -u origin master

Anyway, I know there is a correct approach here.  I have a folder on my Desktop with the project in it.  There is a commit that is on github which I don't have locally.  I need to get that stuff off github and merge it somehow.

http://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes

Keep in mind that the github repo is called "origin";  it is set up that way if I do ``git clone ..``, at least.  The one in the folder on my Desktop is called "master".

.. sourcecode:: bash

    > git remote -v
    origin	git@github.com:telliott99/MyUnix.git (fetch)
    origin	git@github.com:telliott99/MyUnix.git (push)
    >

You can look at what's up there with

.. sourcecode:: bash

    > git remote show origin
    * remote origin
      Fetch URL: git@github.com:telliott99/MyUnix.git
      Push  URL: git@github.com:telliott99/MyUnix.git
      HEAD branch: master
      Remote branch:
        master tracked
      Local branch configured for 'git pull':
        master merges with remote master
      Local ref configured for 'git push':
        master pushes to master (up to date)
    >

It says "up to date" because I don't have this problem at the moment. 

To get the data from github, I should do

    > git fetch origin
    

And now I just need to merge it.

[ Read about merging and come back ]

**Simulate problem**

Use our shell script:

    ./git.sh    # make new repo named demo
    
On GitHub, create a new repository ``demo``.  

.. image:: /figs/new_repo.png
   :scale: 50 %

From inside ``demo``

.. sourcecode:: bash

    > git remote add origin git@github.com:telliott99/demo.git
    > git push -u origin master
    ..
    > cd ..  # put this copy in the Trash

Simulate the problem:

.. sourcecode:: bash

    > git clone git@github.com:telliott99/demo.git
    Cloning into 'demo'...
    ..
    > cd demo
    > touch z.txt
    > git add z.txt
    > git commit -m "add z.txt"
    [master d3f7469] add z.txt
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 z.txt
    > git push -u origin master
    Counting objects: 3, done.
    ..

.. sourcecode:: bash

    > cd .. 
    > cp -r demo demo.old
    > cd demo
    > touch a.txt
    > git add a.txt
    > git commit -m "add a.txt"
    > git push -u origin master
    > git push -u origin master
    ..
    To git@github.com:telliott99/demo.git
       d3f7469..cd0b0c1  master -> master
    Branch master set up to track remote branch master from origin.
    >

Now, rename the copy on the Desktop

.. sourcecode:: bash

    > mv demo demo.git
    > mv demo.old demo

So, when we go to push ``demo``, GitHub will complain:

.. sourcecode:: bash

    > cd demo
    > git push -u origin master
    To git@github.com:telliott99/demo.git
     ! [rejected]        master -> master (fetch first)
    error: failed to push some refs to 'git@github.com:telliott99/demo.git'
    hint: Updates were rejected because the remote contains work that you do
    hint: not have locally. This is usually caused by another repository pushing
    hint: to the same ref. You may want to first integrate the remote changes
    hint: (e.g., 'git pull ...') before pushing again.
    hint: See the 'Note about fast-forwards' in 'git push --help' for details.
    >

And the solution should be:

.. sourcecode:: bash

    > git fetch origin
    remote: Counting objects: 2, done.
    remote: Compressing objects: 100% (2/2), done.
    remote: Total 2 (delta 0), reused 2 (delta 0), pack-reused 
    Unpacking objects: 100% (2/2), done.
    From github.com:telliott99/demo
       d3f7469..cd0b0c1  master     -> origin/master
    > git status
    On branch master
    Your branch is behind 'origin/master' by 1 commit, and can be fast-forwarded.
     (use "git pull" to update your local branch)
    nothing to commit, working directory clean
    >
    
.. sourcecode:: bash
    
    > git pull
    Updating d3f7469..cd0b0c1
    Fast-forward
     a.txt | 0
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 a.txt
    > git log --pretty=oneline
    cd0b0c1c7789011d135aeb5529d246c8951a5251 add a.txt
    d3f7469d70b337726692b0fe276323e613b09de6 add z.txt
    1c402334f2ed748bef73249886d72d2a25fa2de8 changed x.txt
    36a3cf6cd6cfb906af88650d1556c11de719665c adding y.txt to project
    ec7b4104005d0985d3de421595fc922ed17698f6 initial project version
    >

.. sourcecode:: bash

    > git show HEAD
    commit cd0b0c1c7789011d135aeb5529d246c8951a5251
    Author: Tom Elliott <telliott@hsc.wvu.edu>
    Date:   Thu Mar 5 10:18:18 2015 -0500

        add a.txt

    diff --git a/a.txt b/a.txt
    new file mode 100644
    index 0000000..e69de29
    > git merge
    Already up-to-date.
    > git push -u origin master
    Branch master set up to track remote branch master from origin.
    Everything up-to-date
    >

Need to try this again.  We successfully added a commit from the remote to the local repo.  But I should have done some work in the meantime to simulate the problem more accurately.




