.. _unix9-regex:

#####
regex
#####

To repeat a bit from the chapter on ``grep``:  the "patterns" that one composes as targets that grep will search for in a file are called regular expressions, or regex for short.  regex is a language defining descriptions of search patterns that are not necessarily exact matches.

Some simple regex symbols and patterns are:

* ``*`` wildcard
* ``\d`` matches a digit [0-9]
* ``\D`` matches a non-digit
* ``\s`` matches whitespace
* ``^`` match only at the beginning of the string
* ``$`` match only at the end of the string
* ``[abc]`` match any of a,b,c
* ``[a-d]`` match any of a,b,c,d

Suppose we have the following text file:

``t.txt``:

.. sourcecode:: bash

    abc
    xyz
    b
    pqr
    1: a
    1967
    bf

* match at the beginning ``^`` or end ``$`` of a word

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
    > grep b t.txt
    abc
    b
    1: a
    bf
    >

* match any of several characters

.. sourcecode:: bash

    > grep [ab] t.txt
    abc
    b
    1: a
    bf
    >

* whitespace

.. sourcecode:: bash

    > grep ":\s[ab]" t.txt
    1: a
    >

    grep is used for simple patterns and basic regu-
    lar expressions (BREs); egrep can handle extended
    regular expressions (EREs).  See re_format(7) for
    more information on regular expressions.

* egrep is needed for fancier expressions

.. sourcecode:: bash

    > egrep "\d{4}" t.txt
    1967
    > egrep \d{4} t.txt
    >
    
A regex for social security numbers I found in *bash Cookbook*

* ``'[0-9]\{3\}-\{0,1\}[0-9]\{2\}-\{0,1\}[0-9]\{4\}'``

.. sourcecode:: bash

    > echo "553-26-4787" | grep '[0-9]\{3\}-\{0,1\}[0-9]\{2\}-\{0,1\}[0-9]\{4\}'
    553-26-4787
    >

And I thought there was an error!  Explanation:

* ``[0-9]\{3\}-`` any digit from 0-9, 3 of them
* ``-\{0,1\}`` the dash ``-`` may not be present
* ``[0-9]\{2\}``
* ``-\{0,1\}`` the dash ``-`` may not be present
* ``[0-9]\{4\}``

For the first part, ``\{`` is escaping the special character ``{`` and later ``}`` with a backslash.  =

Quotes seem to be required as well.  When to quote a pattern?

**substitution**

``tr``


