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

check if we're on master..

git checkout master   # if not
git merge ______      # the github commit I don't have
git branch -d _____   # no longer need that data

That should do it, for the next time I have this problem.



