.. _unix4-grep:

####
grep
####
``grep`` is used on files like this:

.. sourcecode:: bash

    > printf "a\nb\nc\nf\n" > x.txt
    > grep "b" x.txt
    b
    >

or with a redirect like this

.. sourcecode:: bash

    > printf "a\nb\nc\nf\n" > x.txt
    > grep "b" < x.txt
    b
    >

or even on a stream of data like this

.. sourcecode:: bash

    > printf "a\nb\nc\nf\n" | grep "b"
    b
    >

but ``grep`` is *not* used like this

.. sourcecode:: bash

    > grep x.txt "b"
    grep: b: No such file or directory
    >

because the order matters:  ``grep < pattern > < target >``.

One can get the line number of the match:

.. sourcecode:: bash

    > cat x.txt | grep -n "b"
    2:b
    > printf "a\nb\nc\nf\n" | grep -n "b"
    2:b
    > grep -n "b" < x.txt
    2:b
    >

Here we used ``cat`` (unnecessary, but OK), and ``printf``, and a redirect operator ``<``, which uses ``x.txt`` as *input*.

Some other useful flags for ``grep`` include

* ``-A`` print A lines of context
* ``-a`` process binary as if it were text
* ``-b`` print the offset in bytes
* ``-c`` print a count of number of matching lines
* ``-f`` obtain patters from file, one per line
* ``-i`` ignore case
* ``-n`` print line numbers for matches
* ``-r`` recursive (also ``-R``)

.. sourcecode:: bash

    > cd Desktop
    > printf "a\nb\nc\nf\n" | grep -A 1 "b"
    b
    c
    > printf "a\nb\nc\nf\n" | grep -A 2 "b"
    b
    c
    f
    >


The patterns that grep searches for are called regular expressions, or regex for short.  regex is a language defining descriptions of search patterns that are not necessarily exact matches.

Some simple regex symbols and patterns are:

* ``*`` wildcard
* ``\d`` matches a digit [0-9]
* ``\D`` matches a non-digit
* ``\s`` matches whitespace
* ``^`` match only at the beginning of the string
* ``$`` match only at the end of the string
* ``[abc]`` match any of a,b,c
* ``[a-d]`` match any of a,b,c,d

.. sourcecode:: bash

    > grep -n b t.txt
    1:abc
    3:b
    7:bf
    > grep ^b t.txt
    b
    bf
    > grep b$ t.txt
    b
    

.. _find-grep:

Now suppose I want to know how many  ``.mp3`` songs are in my music collection?

.. sourcecode:: bash

    > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music | grep ".mp3" | wc -l
         129
     >

Looks like there are 129 such songs, many more songs are the standard ``m4a`` format:

.. sourcecode:: bash

     > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music | grep ".m4a" | wc -l
         3115
     >

Write to a file the names of all the songs by "10,000 Maniacs":

.. sourcecode:: bash

    > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music | grep "10,000\ Maniacs" > maniacs.txt
    > head -n 5 maniacs.txt
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/.DS_Store
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe/01 What's The Matter Here_.m4a
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe/02 Hey Jack Kerouac.m4a
    >
    ..

This is not quite right, because we wanted only song files, not directories and such.  We could do a second ``grep`` for ``.m4a`` filetype, or we can look at the manual for ``find`` and restrict it to showing only files with ``-type f``

.. sourcecode:: bash

    > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music -type f | grep "10,000\ Maniacs" 
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/.DS_Store
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe/01 What's The Matter Here_.m4a
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe/02 Hey Jack Kerouac.m4a
    ..

That's a little better, but we still have the hidden file ``.DS_Store``.  I'm having trouble with the example because of the space in the directory name, but we can try this:  ``-not -path '*/\.*'``.  

http://askubuntu.com/questions/266179/how-to-exclude-ignore-hidden-files-and-directories-in-a-wildcard-embedded-find

What this does is define a regular expression that matches anything ("*") followed by the path separator "/", then ".", then anything, and it tells ``find`` not to search there if the path contains that regex.

.. sourcecode:: bash

    > find . -type f -not -path '*/\.*' | head -n 3
    ./MyUnix/_build/doctrees/brew.doctree
    ./MyUnix/_build/doctrees/brew2.doctree
    ./MyUnix/_build/doctrees/environment.pickle
    > find . -type f | head -n 3
    ./.DS_Store
    ./MyUnix/.DS_Store
    ./MyUnix/.git/COMMIT_EDITMSG
    >

Looks like it works.

(Notice that ``find`` flag ``-type f`` breaks the rule of using ``--`` for multi-letter flags).

Some more examples:

**search through files for a string**

.. sourcecode:: bash

    > grep regex MyUnix/*.rst | head -n 1
    MyUnix/index.rst:   unix9-regex
    > egrep -o regex MyUnix/*.rst | head -n 5
    MyUnix/index.rst:regex
    MyUnix/unix4-grep.rst:regex
    regex
    MyUnix/unix4-grep.rst:regex
    MyUnix/unix4-grep.rst:regex
    >

The usual example would be ``grep < pattern > < filepaths >.  This will give the name of the file and the matching line for each match.  Some of these lines are pretty long.  Hence I only printed the first result for the first search.  ``egrep`` has a flag ``-o`` to print only the portion of the line that matches.

Another approach is to feed the results of the search to ``awk``

.. sourcecode:: bash

    > grep regex MyUnix/*.rst | awk '{print $1}' | head -n 5
    MyUnix/index.rst:
    MyUnix/unix4-grep.rst:The
    MyUnix/unix4-grep.rst:Some
    MyUnix/unix4-grep.rst:What
    MyUnix/unix4-grep.rst:
    > grep regex MyUnix/*.rst | awk '{print $1 $2}' | head -n 5
    MyUnix/index.rst:unix9-regex
    MyUnix/unix4-grep.rst:Thepatterns
    MyUnix/unix4-grep.rst:Somesimple
    MyUnix/unix4-grep.rst:Whatthis
    MyUnix/unix4-grep.rst:>
    > 

**search a directory for filenames containing a pattern**

We want *only* the filenames so we use the ``-l`` flag

.. sourcecode:: bash

    -l, --files-with-matches
    Only the names of files containing selected lines are written to
    standard output.  grep will only search a file until a match has
    been found

.. sourcecode:: bash

    > grep -l grep MyUnix/_build/html/*.html 
    MyUnix/_build/html/index.html
    MyUnix/_build/html/unix3-permissions.html
    MyUnix/_build/html/unix4-grep.html
    MyUnix/_build/html/unix5-find-xargs.html
    MyUnix/_build/html/unix7-process.html
    MyUnix/_build/html/unix9-regex.html
    >

Notice that we've given a wildcard for the target files.  Or we can give ``-r`` (recursive) and a directory name(s):

.. sourcecode:: bash

    > grep -rl grep MyUnix/_build/html
    MyUnix/_build/html/_sources/index.txt
    MyUnix/_build/html/_sources/unix4-grep.txt
    MyUnix/_build/html/_sources/unix5-find-xargs.txt
    MyUnix/_build/html/_sources/unix7-process.txt
    MyUnix/_build/html/_sources/unix9-regex.txt
    MyUnix/_build/html/_static/jquery-1.11.1.js
    MyUnix/_build/html/_static/jquery.js
    MyUnix/_build/html/index.html
    MyUnix/_build/html/searchindex.js
    MyUnix/_build/html/unix3-permissions.html
    MyUnix/_build/html/unix4-grep.html
    MyUnix/_build/html/unix5-find-xargs.html
    MyUnix/_build/html/unix7-process.html
    MyUnix/_build/html/unix9-regex.html
    >

And this suggests that we can give multiple file names.  The ``-s`` flag (silence) or ``--no-messages`` will silence complaints:

.. sourcecode:: bash

    > grep -l grep MyUnix/*
    grep: MyUnix/_build: Is a directory
    grep: MyUnix/_static: Is a directory
    grep: MyUnix/figs: Is a directory
    MyUnix/index.rst
    grep: MyUnix/unix: Is a directory
    MyUnix/unix4-grep.rst
    MyUnix/unix5-find-xargs.rst
    MyUnix/unix7-process.rst
    MyUnix/unix9-regex.rst
    >

.. sourcecode:: bash

    > grep -ls grep MyUnix/* 
    MyUnix/index.rst
    MyUnix/unix4-grep.rst
    MyUnix/unix5-find-xargs.rst
    MyUnix/unix7-process.rst
    MyUnix/unix9-regex.rst
    >

**man grep**

It seems like it would be worth it to print out the man page for ``find`` or ``grep`` and study it.

.. sourcecode:: bash

    > man grep > grep.txt
    > wc -l grep.txt
         301 grep.txt
    >

301 lines!  If you do this, you'll find that ``man`` stutters.  

.. note::

    To print man pages to a text file:

.. sourcecode:: bash

     > man grep | col -b > grep.txt
     >

Here is how it looks without that:

.. sourcecode:: bash

    GREP(1)                   BSD General Commands Manual                  GREP(1)

    NNAAMMEE
         ggrreepp, eeggrreepp, ffggrreepp, zzggrreepp, zzeeggrreepp, zzffggrreepp -- file pattern searcher

    SSYYNNOOPPSSIISS
         ggrreepp [--aabbccddDDEEFFGGHHhhIIiiJJLLllmmnnOOooppqqRRSSssUUVVvvwwxxZZ] [--AA _n_u_m] [--BB _n_u_m] [--CC[_n_u_m]]
              [--ee _p_a_t_t_e_r_n] [--ff _f_i_l_e] [----bbiinnaarryy--ffiilleess=_v_a_l_u_e] [----ccoolloorr[=_w_h_e_n]]
              [----ccoolloouurr[=_w_h_e_n]] [----ccoonntteexxtt[=_n_u_m]] [----llaabbeell] [----lliinnee--bbuuffffeerreedd]
              [----nnuullll] [_p_a_t_t_e_r_n] [_f_i_l_e _._._.]

    DDEESSCCRRIIPPTTIIOONN
         The ggrreepp utility searches any given input files, selecting lines that

http://www.electrictoolbox.com/article/linux-unix-bsd/save-manpage-plain-text/
