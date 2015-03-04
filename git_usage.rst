.. _git_usage:

###########
Git:  usage
###########

**Shell scripts**

Working on examples for git, I found it useful to setup (and destroy) the same project multiple times.  To automate this, I wrote the following shell script:

``git.sh``:

.. literalinclude:: /_static/git.sh

To execute it, just put the file ``git.sh`` on the Desktop and do:

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
    
From the log output above, we see there are three commits, with messages.

* ``commit 7bb90f3368deb457e7af52772fa03d25362ef00a``
* ``commit 72e19d2187287fb5accbb4c367d1738c7890cbd6``
* ``commit 7fb86780e7f117cae27c76dec1c7080eb1ee8814``

**git log**

``git log`` takes various arguments

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

shows the ``diff`` for each of the last two commits.

.. sourcecode:: bash

    > git log --pretty=format:"%h - %an, %ar : %s"
    25b2630 - Tom Elliott, 9 minutes ago : adding z.txt
    7bb90f3 - Tom Elliott, 2 hours ago : changed x.txt
    72e19d2 - Tom Elliott, 2 hours ago : adding y.txt to project
    7fb8678 - Tom Elliott, 2 hours ago : initial project version
    > 
    

**Undo**

rollback edited but not staged

* ``git checkout x.txt``

rollback staged

* ``git reset HEAD x.txt``

rollback commit

* ``git reset --soft HEAD^``

rollback after commit and merge (lose information)

* ``> git reset --hard d0dfe1924e391859894033a78d50190d45d6c0e4``

**Simple branching example**

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

Now, go back to ``master`` and merge in our work on ``newbranch``:

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
    
    > git reset --soft HEAD
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

**hotfix example**

http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging

* You are doing some work on a web site.
* Create a branch for a new story you’re working on.
* Do some work in that branch.

At this stage, you’ll receive a call that another issue is critical and you need a hotfix. You’ll do the following:

* Revert back to your production branch.
* Create a branch to add the hotfix.
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

Want working directory clean before switching 

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

To merge:

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

Now, go back to what we were doing:

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

