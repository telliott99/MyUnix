.. _latex:

#####
Latex
#####

**Introduction**

LateX is a specialized computer language used for typesetting documents. 

http://en.wikipedia.org/wiki/LaTeX

It has its own ecosystem now:

http://www.latex-project.org

Latex was based in part on an earlier typesetting system called TeX, which was itself mainly written by the famous computer scientist and algorithm expert Donald Knuth.

http://en.wikipedia.org/wiki/TeX

I have used LateX to typeset numerous writeups on mathematics, and also used it as the last stage in a workflow that randomizes questions for exams and then typesets them as pdf documents.  I have found that it works very well for me.

**TeXShop**

In my Applications directory I have a GUI application called TeXShop which I use as a "frontend" and editor.  A page about it is here:

http://pages.uoregon.edu/koch/texshop/

Yesterday, when I removed the ``/usr/local`` directory to demonstrate how to get Homebrew, I knew that I was also losing some of the necessary tools for LateX.  We are going to have to find out what's required for a minimal installation.  Don't be afraid to make experiments like this!  Any problem can eventually be solved, and it's the only way to really learn.  (Of course, you might be more cautious and simply move the old directory out of the way, but sometimes having the old stuff still around can make you think you understand what's required when you really don't).

I know that LateX is not working at present because an attempt to typeset one of my standard documents from TeXShop (directions for an exam, in ``directions.tex``) fails with this:  ``/usr/texbin/pdflatex`` not found.

``/usr/texbin/pdflatex`` is a directory external to ``/usr/local``.  However, I believe that I also deleted ``/usr/texbin/..`` at the same time that I deleted ``/usr/local``.  I have been irritated in the past because I suspected that my LateX install altered permissions (or users and groups) on ``/usr/local`` and caused trouble.  This is an opportunity to solve that problem.

**Basic TeX Distribution**

The page for TeXShop has a link to a page for a "basic" TeX distribution

http://www.tug.org/mactex/morepackages.html

Notes there:

    A Smaller Distribution

    This page contains an alternate TeX Distribution, BasicTeX, for users who do not want to download the full TeX Live. BasicTeX is a subset of TeX Live; it is much smaller than TeX Live and yet supports most standard TeX typesetting. BasicTeX has been updated to TeX Live 2014. The update requires OS X 10.5 or higher and an Intel processor. BasicTeX does not overwrite the full distribution; it is installed in /usr/local/texlive/2014basic.

    To use TeX on the Mac, it suffices to install BasicTeX and a front end. One way to get this front end is to install MacTeX-Additions below; it contains everything in MacTeX except the TeX Live distribution. Thus it contains Ghostscript and the GUI Applications TeXShop, BibDesk, LaTeXiT, TeX Live Utility, and Excalibur.

**Installation**

I no longer have the BasicTeX installer (I usually save them in ``~/MyDownloads``).  So let's grab it from the link on the page above and then run it.

One thing I've often wondered about is whether there is a simple way to monitor where package installs files as it works.  Maybe we can do ``find /usr`` with a flag to look at recent modification times?

Rather than figure that out I decided to just run the installer and then re-try the TeXShop frontend on ``directions.tex``.  

There is an error, reported in the app's console (unfortunately the log text cannot be copied to the pasteboard).  The console shows a bunch of "stylesheets" in places like ``/usr/local/texlive/2014basic/temf-dist/tex/`` --- both the ``latex`` and ``generic`` sub-directories.  It complains that a stylesheet called ``simplemargins.sty`` is not found.

.. sourcecode:: bash

    > ls /usr/local/texlive/2014basic/texmf-dist/tex/latex/amsmath/
    amsbsy.sty	amsmath.sty	amstext.sty
    amscd.sty	amsopn.sty	amsxtra.sty
    amsgen.sty	amstex.sty
    >

On the other hand, I try one of my math writeups and it works fine.  So it appears that I am just missing this stylesheet (``simplemargins.sty``), which indeed, I make use of in ``directions.tex``

.. sourcecode:: latex

    \usepackage{simplemargins}
    
**Adding a stylesheet**

A Google search leads me to 

http://web.mit.edu/~anime/ASA/simplemargins.sty

Now the question is:  what is the recommended way to make stylesheets available to LateX.  Should I just copy it to the directory above?  According to this:

http://tex.stackexchange.com/questions/1137/where-do-i-place-my-own-sty-or-cls-files-to-make-them-available-to-all-my-te

I should do this:  ``kpsewhich -var-value=TEXMFHOME``

.. sourcecode:: bash

    > kpsewhich -var-value=TEXMFHOME
    /Users/telliott_admin/Library/texmf
    >

I am directed to place the stylesheet in a sub-directory like:  ``texmf/tex/latex/`` and confirm that it is discoverable with ``kpsewhich < filename.sty >``.  So let's try that:

.. sourcecode:: bash

    > mkdir ~/Library/texmf
    > cp simplemargins.sty ~/Library/texmf
    > kpsewhich simplemargins.sty
    >

That does *not* work.  So follow a note on that page that says it won't work and make a subdirectory:  /tex/latex/commonstuff/

.. sourcecode:: bash

    > mkdir ~/Library/texmf
    > mkdir ~/Library/texmf/tex
    > mkdir ~/Library/texmf/tex/latex
    > mv simplemargins.sty ~/Library/texmf/tex/latex/local
    > texhash ~/Library/texmf
    > kpsewhich simplemargins.sty
    >
    
I was in a hurry so I just did this, later I looked it up and found that the ``-p`` flag is the way to go here as in 

* ``mkdir -p /testdir/abc/def/ghi/jkl/mno/p/q/r/s/t/u``

But it still doesn't work.  Yet another answer mentions:

.. sourcecode:: bash

    /usr/local/texlive/2009/texmf
    /usr/local/texlive/2009/texmf-dist
    /usr/local/texlive/texmf-local

which is like where I was above:  

.. sourcecode:: bash

    /usr/local/texlive/2014basic/texmf-dist/tex/latex/amsmath/

I think ``~/Library/..`` should work.  It's where things *should go* on OS X, but it doesn't seem to.  Poking around in those directories:

.. sourcecode:: bash

    > sudo cp simplemargins.sty /usr/local/texlive/2014basic/texmf-dist/tex/latex
    > kpsewhich simplemargins.sty
    > sudo texhash /usr/local/texlive/2014basic/texmf/tex/latex
    texhash: /usr/local/texlive/2014basic/texmf/tex/latex: not a directory, skipping.
    texhash: Updating /usr/local/texlive/2014basic/texmf-config/ls-R... 
    texhash: Updating /usr/local/texlive/2014basic/texmf-dist/ls-R... 
    texhash: Updating /usr/local/texlive/2014basic/texmf-local/ls-R... 
    texhash: Updating /usr/local/texlive/2014basic/texmf-var/ls-R... 
    texhash: Done.
    > kpsewhich simplemargins.sty
    /usr/local/texlive/2014basic/texmf-dist/tex/latex/simplemargins.sty
    >

I think that's got it now:  the combination of using ``/usr/local/..`` and running ``texhash``.

Note:  I needed ``sudo`` but I shouldn't!  They have screwed with my permissions.  And it still doesn't work!  Of course, now it turns out there is another missing stylesheet:  ``enumitem.sty``.  I get it from here:

    http://ctan.math.washington.edu/tex-archive/macros/latex/contrib/enumitem/enumitem.sty

    https://www.ctan.org/tex-archive/macros/latex/contrib/enumitem

.. sourcecode:: bash

    > sudo cp enumitem.sty /usr/local/texlive/2014basic/texmf-dist/tex/latex
    > sudo texhash /usr/local/texlive/2014basic/texmf/tex/latex
    texhash: /usr/local/texlive/2014basic/texmf/tex/latex: not a directory, skipping.
    texhash: Updating /usr/local/texlive/2014basic/texmf-config/ls-R... 
    texhash: Updating /usr/local/texlive/2014basic/texmf-dist/ls-R... 
    texhash: Updating /usr/local/texlive/2014basic/texmf-local/ls-R... 
    texhash: Updating /usr/local/texlive/2014basic/texmf-var/ls-R... 
    texhash: Done.
    > kpsewhich enumitem.sty
    /usr/local/texlive/2014basic/texmf-dist/tex/latex/enumitem.sty
    >

And it works!

One embarrassing point:  I did ``kpsewhich filename.sty`` several times, while complaining that things weren't working.  Oops.  That's why I like the ``kpsewhich < filename.sty >`` way of writing a command when you have to substitute the real filename.

One last thing:  I need to fix the permissions, etc on ``/usr/local``.  I can do that pretty easily:

.. sourcecode:: bash

    > sudo chown -R `whoami` /usr/local
    > sudo chgrp -R admin /usr/local
    > sudo chmod -R 755 /usr/local
    >
    > ls -al /usr/local
    total 96
    drwxr-xr-x  19 telliott_admin  admin    646 Mar  4 08:57 .
    drwxr-xr-x@ 14 root            wheel    476 Mar  4 08:57 ..
    >

That should do it.

Now is the time to use the alias I define in ``~/.bash_profile``:

* ``alias ts='python typeset/scripts/script.py'``

It doesn't work.  The log file is saying it can't find the file ``scantron4.png``, which is missing, sure enough.  I am a little puzzled as to how and when it went missing, but when I look at the source I see:

.. sourcecode:: bash

    \graphicspath{{/Users/telliott_admin/Dropbox/Exams/png/}}

and I recall that I moved the ``Exams`` subdirectory recently!  I'd forgotten that I stashed some images there.  So now I just need to edit my source to give the right path, which is

.. sourcecode:: bash

    \graphicspath{{/Users/telliott_admin/Dropbox/Teaching/Exams/png/}}
    
And it works!

Every problem can be solved.  Go forth and conquer.


