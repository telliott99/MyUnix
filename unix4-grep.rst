.. _unix4-grep:

####
grep
####
``grep`` is used like this:

.. sourcecode:: bash

    > printf "a\nb\nc\nf\n" > x.txt
    > grep "b" x.txt
    b
    >

or this

.. sourcecode:: bash

    > printf "a\nb\nc\nf\n" > x.txt
    > grep "b" < x.txt
    b
    >

or even this

.. sourcecode:: bash

    > printf "a\nb\nc\nf\n" | grep "b"
    b
    >

but ``grep`` is *not* used like this

.. sourcecode:: bash

    > grep x.txt "b"
    grep: b: No such file or directory
    >

Order matters.

One can pipe data to grep and also get the line number of the match:

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

The patterns that grep searches for are regular expressions, or regex.  regex define a language for describing search patterns that are not necessarily exact matches.

Some simple regex patterns are:

* ``*`` wildcard
* ``\d`` matches a digit [0-9]
* ``\D`` matches a non-digit
* ``\s`` matches whitespace
* ``^`` match only at the beginning of the string
* ``$`` match only at the end of the string
* ``[abc]`` match any of a,b,c
* ``[a..d]`` match any of a,b,c,d

.. sourcecode:: bash

    > printf "abc\nb\nfb" | grep "b"
    abc
    b
    fb
    > printf "abc\nb\nfb" | grep -n "^b"
    2:b
    > printf "abc\nb\nfb" | grep -n "b$"
    2:b
    3:fb
    >

.. _find-grep:

Now suppose I want to know how many  ``.mp3`` songs are in my music collection?

.. sourcecode:: bash

    > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music | grep ".mp3" | wc -l
         129
     >

Looks like there are 129 such songs.

.. sourcecode:: bash

     > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music | grep ".m4a" | wc -l
         3115
     >

Write a file containing the names of all the songs by "10,000 Maniacs":

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

That's a little better, but we still have the hidden file ``.DS_Store``.  I will work on this.  

(Notice that ``-type f`` breaks the rule of using ``--`` for multi-letter flags).

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