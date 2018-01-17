.. git-usage:

#####
Usage
#####

**Shell scripts**

Working on examples for git, I found it useful to setup (and destroy) the same project multiple times.  To automate this, I wrote the following shell script.  It works similarly to the Python script we saw previously.  Just do ``chmod u+x git.sh`` on  it first.

``git.sh``:

.. literalinclude:: /_static/git.sh

To execute it, put the file ``git.sh`` on the Desktop and do:

.. sourcecode:: bash

    > ./git.sh
    Initialized empty Git repository in /Users/telliott_admin/Desktop/tmp/.git/
    [master (root-commit) 7fb8678] initial project version
     1 file changed, 2 insertions(+)
     create mode 100644 x.txt
    [master 72e19d2] adding y.txt to project
     1 file changed, 2 insertions(+)
     create mode 100644 y.txt
    [master 7bb90f3] changed x.txt
     1 file changed, 1 insertion(+)
    commit 7bb90f3368deb457e7af52772fa03d25362ef00a
    Author: Tom Elliott <telliott@hsc.wvu.edu>
    Date:   Wed Mar 4 03:56:57 2015 -0500

        changed x.txt

    commit 72e19d2187287fb5accbb4c367d1738c7890cbd6
    Author: Tom Elliott <telliott@hsc.wvu.edu>
    Date:   Wed Mar 4 03:56:55 2015 -0500

        adding y.txt to project

    commit 7fb86780e7f117cae27c76dec1c7080eb1ee8814
    Author: Tom Elliott <telliott@hsc.wvu.edu>
    Date:   Wed Mar 4 03:56:53 2015 -0500

        initial project version
    (END)
    
Do ``q`` to quit ``git log``.

So we added ``x.txt`` to the project, then ``y.txt`` and then edited ``x.txt`` to add a single line.  We ``cd`` into the ``tmp`` directory from a new Terminal window:

.. sourcecode:: bash

    > cd tmp
    > git status
    On branch master
    nothing to commit, working directory clean
    >
    
From the log output above, we see there are three commits, with the following hashes (signatures).

* ``commit 7bb90f3368deb457e7af52772fa03d25362ef00a``
* ``commit 72e19d2187287fb5accbb4c367d1738c7890cbd6``
* ``commit 7fb86780e7f117cae27c76dec1c7080eb1ee8814``

**git log**

``git log`` may take various arguments:

* ``git log --pretty=format:"%h %s"``
* ``git log --pretty=oneline``
* ``git log -p -2`` # see the last two commits 

.. sourcecode:: bash

    > git log --pretty=format:"%h %s"
    7bb90f3 changed x.txt
    72e19d2 adding y.txt to project
    7fb8678 initial project version
    >
    > git log --pretty=oneline
    7bb90f3368deb457e7af52772fa03d25362ef00a changed x.txt
    72e19d2187287fb5accbb4c367d1738c7890cbd6 adding y.txt to project
    7fb86780e7f117cae27c76dec1c7080eb1ee8814 initial project version
    >

    .. sourcecode:: bash
 
    > git log -p -2
    commit 25b2630c00c3432501ae6289ed2f06128d01018f
    Author: Tom Elliott <telliott@hsc.wvu.edu>
    Date:   Wed Mar 4 05:27:11 2015 -0500

        adding z.txt

    diff --git a/z.txt b/z.txt
    new file mode 100644
    index 0000000..e69de29

    commit 7bb90f3368deb457e7af52772fa03d25362ef00a
    Author: Tom Elliott <telliott@hsc.wvu.edu>
    Date:   Wed Mar 4 03:56:57 2015 -0500

        changed x.txt

    >

.. sourcecode:: bash

    > git log --pretty=format:"%h - %an, %ar : %s"
    25b2630 - Tom Elliott, 9 minutes ago : adding z.txt
    7bb90f3 - Tom Elliott, 2 hours ago : changed x.txt
    72e19d2 - Tom Elliott, 2 hours ago : adding y.txt to project
    7fb8678 - Tom Elliott, 2 hours ago : initial project version
    > 
    

**Undoing things**

File edited but not staged and you wish to do a rollback

* ``git checkout x.txt``

rollback staged edit

* ``git reset HEAD x.txt``

rollback commit

* ``git reset --soft HEAD^``

rollback after commit and merge (lose information)

* ``> git reset --hard d0dfe1924e391859894033a78d50190d45d6c0e4``

**Simple branching example from ProGit**

To start working on a new part of the project, just "check out" a new branch:  ``git checkout -b < branch >``.

.. sourcecode:: bash

    > cd tmp
    > git checkout -b newbranch
    Switched to a new branch 'newbranch'
    > touch z.txt
    > git add z.txt
    > git commit z.txt -m "adding z.txt"
    [newbranch 25b2630] adding z.txt
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 z.txt
    > git log --pretty=oneline
    25b2630c00c3432501ae6289ed2f06128d01018f adding z.txt
    7bb90f3368deb457e7af52772fa03d25362ef00a changed x.txt
    72e19d2187287fb5accbb4c367d1738c7890cbd6 adding y.txt to project
    7fb86780e7f117cae27c76dec1c7080eb1ee8814 initial project version
    >

Note:  ``git checkout -b newbranch`` is short for

.. sourcecode:: bash

    > git branch newbranch
    > git checkout newbranch

Work a while.  Now, switch back to ``master`` and "merge" in our work on ``newbranch``:

.. sourcecode:: bash

    > git checkout master
    Switched to branch 'master'
    > git merge newbranch
    Updating 7bb90f3..25b2630
    Fast-forward
     z.txt | 0
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 z.txt
    > git log --pretty=oneline
    25b2630c00c3432501ae6289ed2f06128d01018f adding z.txt
    7bb90f3368deb457e7af52772fa03d25362ef00a changed x.txt
    72e19d2187287fb5accbb4c367d1738c7890cbd6 adding y.txt to project
    7fb86780e7f117cae27c76dec1c7080eb1ee8814 initial project version
    > 
    > git ls-files
    x.txt
    y.txt
    z.txt
    
Suppose that, after the merge, we decide we've made a mistake.  How to revert the change?  This won't work:

.. sourcecode:: bash
    
    > git reset --soft HEAD^
    > git ls-files
    x.txt
    y.txt
    z.txt
    >

This is what to do:  use the hash for the version we want to reset to.  Here it is

.. sourcecode:: bash

    7bb90f3368deb457e7af52772fa03d25362ef00a

.. sourcecode:: bash

    > git reset --hard  # this is not enough
    HEAD is now at 25b2630 adding z.txt
    > git reset --hard 7bb90f3368deb457e7af52772fa03d25362ef00a
    HEAD is now at 7bb90f3 changed x.txt
    > git ls-files
    x.txt
    y.txt
    > git log --pretty=oneline
    7bb90f3368deb457e7af52772fa03d25362ef00a changed x.txt
    72e19d2187287fb5accbb4c367d1738c7890cbd6 adding y.txt to project
    7fb86780e7f117cae27c76dec1c7080eb1ee8814 initial project version
    > 
    
After the reset, ``z.txt`` is gone.  But it is still possible to get it back!

.. sourcecode:: bash

    > git reset --hard 25b2630c00c3432501ae6289ed2f06128d01018f
    HEAD is now at 25b2630 adding z.txt
    > git ls-files
    x.txt
    y.txt
    z.txt
    > git log --pretty=oneline
    25b2630c00c3432501ae6289ed2f06128d01018f adding z.txt
    7bb90f3368deb457e7af52772fa03d25362ef00a changed x.txt
    72e19d2187287fb5accbb4c367d1738c7890cbd6 adding y.txt to project
    7fb86780e7f117cae27c76dec1c7080eb1ee8814 initial project version
    >

It is actually very hard to lose information from a repository.  That's why accidentally publishing sensitive items there (SSH keys, for example) is generally not a recoverable error.

**hotfix example**

This second example also comes from the Scott Chacon book.  You should probably just read about it there (I've put the code below to document what happened when I work through the example).

http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging

* You are doing some work on a web site.
* Create a branch for a new story you’re working on.
* Do some work in that branch.

At this stage, you’ll receive a call that another issue is critical and you need a hotfix. Without doing anything about your story branch, you’ll do the following:

* Revert back to your production branch.
* Create a branch to add the hotfix, starting from there.
* After it’s tested, merge the hotfix branch, and push to production.
* Switch back to your original story and continue working.

To do this:

* create a branch and switch to it at same time:

.. sourcecode:: bash

    > git checkout -b story
    Switched to a new branch 'story'
    > cat > story.txt << EOF
    > j
    > k
    > EOF
    > ls
    git		x.txt		z.txt
    story.txt	y.txt
    > cat story.txt
    j
    k
    > git status
    On branch story
    Changes to be committed:
      (use "git reset HEAD <file>..." to unstage)

    	new file:   story.txt

    > git commit -m "story"
    [story d180585] story
     1 file changed, 2 insertions(+)
     create mode 100644 story.txt
     > git log --pretty=format:"%h - %an, %ar : %s"
     d180585 - Tom Elliott, 45 seconds ago : story
     25b2630 - Tom Elliott, 19 minutes ago : adding z.txt
     7bb90f3 - Tom Elliott, 2 hours ago : changed x.txt
     72e19d2 - Tom Elliott, 2 hours ago : adding y.txt to project
     7fb8678 - Tom Elliott, 2 hours ago : initial project version
     >

Want working directory clean (no unstaged, uncommitted work) before switching 

.. sourcecode:: bash

    > git status
    On branch story
    nothing to commit, working directory clean
    > git checkout master
    Switched to branch 'master'
    > git checkout -b hotfix
    Switched to a new branch 'hotfix'
    > cat > p.txt << EOF
    > stuff
    > EOF
    > 
    > git add p.txt
    > git commit -a -m 'fixed the hotfix problem'
    [hotfix bac0f7a] fixed the hotfix problem
     1 file changed, 1 insertion(+)
     create mode 100644 p.txt
    >

To merge hotfix with the master (and delete hotfix after the merge):

.. sourcecode:: bash

    > git checkout master
    Switched to branch 'master'
    > git merge hotfix
    Updating 25b2630..bac0f7a
    Fast-forward
     p.txt | 1 +
     1 file changed, 1 insertion(+)
     create mode 100644 p.txt
    >
    > # delete hotfix (since we merged)
    > git branch -d hotfix
    Deleted branch hotfix (was bac0f7a).
    > 
    
A picture of where we are at this moment

.. image:: /figs/git_merge.png
   :scale: 30 %


Now, go back to what we were doing, finish up and merge.

.. sourcecode:: bash

    > git checkout story
    Switched to branch 'story'
    > git status
    On branch story
    nothing to commit, working directory clean
    > git checkout master
    Switched to branch 'master'
    > git merge story -m "merge"
    Merge made by the 'recursive' strategy.
     story.txt | 2 ++
     1 file changed, 2 insertions(+)
     create mode 100644 story.txt
    > git log --pretty=format:"%h - %an, %ar : %s"
    9612366 - Tom Elliott, 8 seconds ago : merge
    bac0f7a - Tom Elliott, 4 minutes ago : fixed the hotfix problem
    d180585 - Tom Elliott, 6 minutes ago : story
    25b2630 - Tom Elliott, 25 minutes ago : adding z.txt
    7bb90f3 - Tom Elliott, 2 hours ago : changed x.txt
    72e19d2 - Tom Elliott, 2 hours ago : adding y.txt to project
    7fb8678 - Tom Elliott, 2 hours ago : initial project version
    > 

**merge conflicts**

TODO

**reset --hard:  local and remote**

We can do a hard reset to delete some branches.

.. sourcecode:: bash

    > git clone git@github.com:telliott99/demo.git
    Cloning into 'demo'...
    remote: Counting objects: 28, done.
    remote: Compressing objects: 100% (21/21), done.
    remote: Total 28 (delta 8), reused 22 (delta 2), pack-reused 0
    Receiving objects: 100% (28/28), done.
    Resolving deltas: 100% (8/8), done.
    Checking connectivity... done.
    > cd demo
    > git log --pretty=oneline
    1e32a6422878f58423910a97686489d06ea959fd add f
    d10d4522d2e6a6c42554324bfef9d5bec50c3e08 g
    d3c1d9a7e8f1ddc4da1f4900f5740a0f0ef37812 f
    cb0e64f4a9a0be5f1f61a460c66c95039c3d4c86 revert
    f60e8851b72b8dfeb8fa07a7ec6af86e2be74bd5 add a
    8bd1d2c3e7e076c8affd6797f7672620b9cc27d0 revert to xyz
    1885145469510057befc921d5545cd85a2f6bf8c c
    845cbad6fd43b3dde44f464248d1a2b5c460ef72 b
    cd0b0c1c7789011d135aeb5529d246c8951a5251 add a.txt
    d3f7469d70b337726692b0fe276323e613b09de6 add z.txt
    1c402334f2ed748bef73249886d72d2a25fa2de8 changed x.txt
    36a3cf6cd6cfb906af88650d1556c11de719665c adding y.txt to project
    ec7b4104005d0985d3de421595fc922ed17698f6 initial project version
    > git reset --hard cd0b0c1c7789011d135aeb5529d246c8951a5251
    HEAD is now at cd0b0c1 add a.txt

The branches ahead of ``HEAD`` are gone, but only locally.

.. sourcecode:: bash

    > git branch -d 1e32a6422878f58423910a97686489d06ea959fd
    error: branch '1e32a6422878f58423910a97686489d06ea959fd' not found.
    > git log --pretty=oneline
    cd0b0c1c7789011d135aeb5529d246c8951a5251 add a.txt
    d3f7469d70b337726692b0fe276323e613b09de6 add z.txt
    1c402334f2ed748bef73249886d72d2a25fa2de8 changed x.txt
    36a3cf6cd6cfb906af88650d1556c11de719665c adding y.txt to project
    ec7b4104005d0985d3de421595fc922ed17698f6 initial project version

We can't push to the remote because of the conflict:

.. sourcecode:: bash

    > git push -u origin master
    To git@github.com:telliott99/demo.git
     ! [rejected]        master -> master (non-fast-forward)
    error: failed to push some refs to 'git@github.com:telliott99/demo.git'
    hint: Updates were rejected because the tip of your current branch is behind
    hint: its remote counterpart. Integrate the remote changes (e.g.
    hint: 'git pull ...') before pushing again.
    hint: See the 'Note about fast-forwards' in 'git push --help' for details.

The solution to this problem is

* ``git push -f origin master``

This says, we do really want to "force" the push.

.. sourcecode:: bash

    > git push -f origin master
    Total 0 (delta 0), reused 0 (delta 0)
    To git@github.com:telliott99/demo.git
     + 1e32a64...cd0b0c1 master -> master (forced update)
    >

Check for diffs between the remote and the local repo

.. sourcecode:: bash

    > git diff origin/master
    
We can check the log for the remote.  All of these are useful to remember:

* ``git log origin/master``
* ``git remote show origin``
* ``git ls-remote git@github.com:telliott99/demo.git``

especially the last one, which shows where ``HEAD`` is in the remote.

.. sourcecode:: bash

    > git log origin/master
    commit cd0b0c1c7789011d135aeb5529d246c8951a5251
    Author: Tom Elliott <telliott@hsc.wvu.edu>
    Date:   Thu Mar 5 10:18:18 2015 -0500

        add a.txt

    commit d3f7469d70b337726692b0fe276323e613b09de6
    Author: Tom Elliott <telliott@hsc.wvu.edu>
    Date:   Thu Mar 5 10:08:03 2015 -0500

        add z.txt
    ..
    > git remote show origin
    * remote origin
      Fetch URL: git@github.com:telliott99/demo.git
      Push  URL: git@github.com:telliott99/demo.git
      HEAD branch: master
      Remote branch:
        master tracked
      Local branch configured for 'git pull':
        master merges with remote master
      Local ref configured for 'git push':
        master pushes to master (up to date)
    > git ls-remote git@github.com:telliott99/demo.git
    cd0b0c1c7789011d135aeb5529d246c8951a5251	HEAD
    cd0b0c1c7789011d135aeb5529d246c8951a5251	refs/heads/master
    >

Looks correct.  Actually, this last could use ``origin``, I think.

**New local repository**

Here is an example of creating a local repository (analogous to what github is) but on disk.  It might make sense to reduce clutter.  For example, I could add the html folder of MyUnix to a .gitignore, make a repo in my Dropbox folder, then ``push`` and ``pull`` when I want to work.

The repo will be named ``~/Dropbox/repo``.

As an example, just clone ``demo`` from github.  

Then ``mkdir`` and do ``git init --bare`` to start an empty Git repo

.. sourcecode:: bash

    > git clone git@github.com:telliott99/demo.git
    > mkdir ~/Dropbox/repo
    > cd ~/Dropbox/repo
    > git init --bare
    Initialized empty Git repository in /Users/telliott_admin/Dropbox/repo/
    
Go back to the ``demo`` project on the Desktop and add a new remote with the alias ``db``: 

.. sourcecode:: bash
   
    > cd Desktop/demo
    > git remote rm db   # was just ~/Dropbox/demo
    > git remote add db ~/Dropbox/repo
    > git remote -v
    db	/Users/telliott_admin/Dropbox/repo (fetch)
    db	/Users/telliott_admin/Dropbox/repo (push)
    origin	git@github.com:telliott99/demo.git (fetch)
    origin	git@github.com:telliott99/demo.git (push)
    >
    
and ``push`` to it

.. sourcecode:: bash

    > git push -u db master
    Counting objects: 14, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (8/8), done.
    Writing objects: 100% (14/14), 1.15 KiB | 0 bytes/s, done.
    Total 14 (delta 1), reused 14 (delta 1)
    To /Users/telliott_admin/Dropbox/repo
     * [new branch]      master -> master
    Branch master set up to track remote branch master from db.
    >

.. sourcecode:: bash

    > git diff db/master origin/master
    > git log --oneline db/master origin/master
    cd0b0c1 add a.txt
    d3f7469 add z.txt
    1c40233 changed x.txt
    36a3cf6 adding y.txt to project
    ec7b410 initial project version
    >

Of course, there is a lot of potential for the two repos to get out of sync with each other, but that's another story.

.. note::

    Since we didn't push to the remote, it doesn't know about the new repo, and ``log`` doesn't report that difference above.

.. sourcecode:: bash

    > rm -r demo
    > git clone git@github.com:telliott99/demo.git
    Cloning into 'demo'...
    remote: Counting objects: 14, done.
    remote: Compressing objects: 100% (9/9), done.
    remote: Total 14 (delta 1), reused 12 (delta 0), pack-reused 0
    Receiving objects: 100% (14/14), done.
    Resolving deltas: 100% (1/1), done.
    Checking connectivity... done.
    > cd demo
    > git remote -v
    origin	git@github.com:telliott99/demo.git (fetch)
    origin	git@github.com:telliott99/demo.git (push)
    >


