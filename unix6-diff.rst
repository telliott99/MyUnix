.. _unix6-diff:

####
diff
####

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

What's going on here is that the ``\n`` that we've typed is not being interpreted by the shell as a newline, but rather as two characters, and ordinary ``\`` and an ``n``.  

We use ``hexdump`` to examine the data that is actually on disk.  We see the bytes ``5c 6e`` and the corresonding characters ``\n`` in the output from ``hexdump``, and we get 1 as the result when we ask ``wc -l`` to count lines.

Without getting into details, the solution to this problem is to use a different utility that is designed for fancier input:  ``printf``.  One way that ``printf`` differs from ``echo`` is that it interprets the ``\n`` as we want

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
    
On to our example.  We construct two files with a small difference, e.g.

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

``diff`` shows the differences.  The second line in the first file ``x.txt`` has ``b``, and this line is not present in ``y.txt``.  The fourth line of ``x.txt`` and the third line of ``y.txt`` are also compared for differences (because they come after the identical line ``c``), with ``f`` in ``x.txt`` and ``d`` in ``y.txt``.

``diff`` is great for verifying in just an instant whether two textfiles contain any differences, and then secondarily, what they are.  Often we just want reassurance of identity.

If we capture this output in a file

.. sourcecode:: bash

    > diff x.txt y.txt > xy.diff
    >

Textmate will color the output in a nice way.

.. image:: /figs/xy_diff.png
   :scale: 50 %

Perhaps it's a little garish, but I like it.

