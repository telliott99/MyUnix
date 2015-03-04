.. _unix-advanced-1:

########################
More advanced Unix usage
########################

The material in this chapter is not really advanced usage (my Unix "foo" is not really that great), but it builds on the first two chapters.

**diff**

A really great utility on Unix is ``diff``, which shows the differences between two text files (like edits).  There are tricks to use it with binary, but it's meant for text.  ``diff`` can be very useful in deciding which file is the version you want to keep, or if there are differences between similar files from two different projects.  ``diff`` is a very good reason to use plaintext, or failing that restructured text like this document, or failing even that ``.rtf`` "rich text format".

(This ``.rtf`` is not a component of ``RTFM``, and this document is intended to provide a partial alternative to the latter, rather belligerent advice).

My example for ``diff`` starts with ``echo`` from the previous chapter, and shows some interesting and slightly unexpected behavior.  Recall that ``\n`` is a Unix newline.

.. sourcecode:: bash

    > echo "a\nb" 
    a\nb
    > echo "a\nb" > x.txt
    > cat x.txt
    a\nb
    > echo "a\nb" | wc -l
           1
    > echo "a\nb" | hexdump -C 
    00000000  61 5c 6e 62 0a                                    |a\nb.|
    00000005
    >

What's going on here is that the ``\n`` that we've typed is not being interpreted by the shell as a newline, but rather as two characters, and ordinary ``\`` and an ``n``.  For example, we see the bytes ``5c 6e`` and the characters ``\n`` in the output from ``hexdump``, and we get 1 as the result when we ask ``wc -l`` to count lines.

Without getting into details, the solution to this problem is to use a different utility that is designed for fancier input:  ``printf``.  One way that ``printf`` differs from ``echo`` is it interprets the ``\n`` as we wanted

.. sourcecode:: bash

    > printf "a\nb"
    a
    b> printf "a\nb\n"
    a
    b
    > printf "a\nb\n" | wc -l
           2
    > 
    > printf "a\nb\n" | hexdump -C
    00000000  61 0a 62 0a                                       |a.b.|
    00000004
    >

``printf`` also allows "string interpolation"

.. sourcecode:: bash

    > printf "%d pages\n" 32
    32 pages
    >

but that's getting ahead of ourselves.
    
On to our example.  We want to construct two files with a small difference, e.g.

.. sourcecode:: bash

    > printf "a\nb\nc\nf\n" > x.txt
    > printf "a\nc\nd\n" > y.txt
    > cat x.txt
    a
    b
    c
    f
    > cat y.txt
    a
    c
    d
    > diff x.txt y.txt
    2d1
    < b
    4c3
    < f
    ---
    > d
    >

``diff`` shows the differences.  The second line in the first file ``x.txt`` has ``b`` for an extra line.  The fourth and the third line are also compared for differences (because they come after the identical line ``c``), with ``f`` in ``x.txt`` and ``d`` in ``y.txt``.

``diff`` is great for verifying in a second whether two textfiles contain any differences, and what they are.

If we capture this output in a file

.. sourcecode:: bash

    > diff x.txt y.txt > xy.diff
    >

Textmate will color the output in a nice way.

.. image:: /figs/xy_diff.png
   :scale: 50 %

Perhaps it's a little garish, but OK.

If you want to check the calendar, there is always ``cal``

.. sourcecode:: bash

    > cal
         March 2015
    Su Mo Tu We Th Fr Sa
     1  2  3  4  5  6  7
     8  9 10 11 12 13 14
    15 16 17 18 19 20 21
    22 23 24 25 26 27 28
    29 30 31

    > cal 9 1752
       September 1752
    Su Mo Tu We Th Fr Sa
           1  2 14 15 16
    17 18 19 20 21 22 23
    24 25 26 27 28 29 30



    >

Notice anything?

http://en.wikipedia.org/wiki/1752

**Another way to make a texfile**

Here is another approach to place alongside ``echo`` and ``printf``

.. sourcecode:: bash

    > cat > x.txt << EOF
    > x
    > y
    > EOF
    > 
    > hexdump -C x.txt
    00000000  78 0a 79 0a                                       |x.y.|
    00000004
    >
    
It's kind of inscrutable, but here goes.  What the first line says is "put all the text that will follow on subsequent lines" into a file named ``x.txt``.  The marker ``EOF`` (end-of-file) will signal where to stop.  (It doesn't have to be ``EOF``, you can use ``ABC`` if you want, but the first token makes more sense).

**find and grep**

OS X has powerful search capacities in Spotlight, but you may want to generate a list of filenames to pipe into some other program.

``find`` is quite sophisticated, and can filter the output in many ways, but I only know a little bit of usage for it.

Often I combine it with ``grep``, so let's talk about that first.  ``grep`` is used like this:

.. sourcecode:: bash

    > printf "a\nb\nc\nf\n" > x.txt
    > grep "b" x.txt
    b
    >

``grep`` is *not* used like this

.. sourcecode:: bash

    > grep x.txt "b"
    grep: b: No such file or directory
    >

Order matters.

Now suppose I want to know how many  ``.mp3`` songs are in my music collection?

.. sourcecode:: bash

    > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music | grep ".mp3" | wc
         129    1192   15561
    >

Looks like there are 129 such songs.  Write a file containing the names of all the songs by "10,000 Maniacs":

.. sourcecode:: bash

    > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music | grep "10,000\ Maniacs"
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/.DS_Store
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe/01 What's The Matter Here_.m4a
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe/02 Hey Jack Kerouac.m4a
    ..

This is not quite right, because we wanted only song files, not directories and such.  We could do a second ``grep`` for ``.m4a`` filetype, or we can look at the manual for ``find`` and restrict it to showing only files with ``-type f``

.. sourcecode:: bash

    > find /Users/telliott_admin/Music/iTunes/iTunes\ Media/Music -type f | grep "10,000\ Maniacs" 
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/.DS_Store
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe/01 What's The Matter Here_.m4a
    /Users/telliott_admin/Music/iTunes/iTunes Media/Music/10,000 Maniacs/In My Tribe/02 Hey Jack Kerouac.m4a
    ..

That's a little better, but we still have the hidden file ``.DS_Store``.  I am still working on this.  

(Notice that ``-type f`` breaks the rule of using ``--`` for multi-letter flags).

It seems like it would be worth it to print out the man page for ``find`` or ``grep`` and study it.

.. sourcecode:: bash

    > man find > x.txt
    > cat x.txt | wc
         583    3714   31107
    >

583 lines!

Also, if you do this, you'll find that ``man`` stutters:

.. sourcecode:: bash

    FIND(1)                   BSD General Commands Manual                  FIND(1)

    NNAAMMEE
         ffiinndd -- walk a file hierarchy

I *did* know how to fix this, but I've forgotten, and Google has failed me at the moment.
