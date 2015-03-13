.. _regex:

###########################
Regular Expressions (regex)
###########################

To repeat a bit from the chapter on ``grep``:  the "patterns" that one composes as targets for grep to find in a file are called regular expressions, regex or re for short.  regex is a language defining descriptions of search patterns that are not necessarily exact matches.

.. sourcecode:: bash

    > printf "abc\ndef" | grep b
    abc
    > printf "abc\ndef" > x.txt
    > grep b x.txt
    abc
    > grep b < x.txt
    abc
    > grep "b" < x.txt
    abc
    >

This target text is in ``x.txt`` (with a newline at the end):

.. sourcecode:: bash

    abc
    ab c
    a b c
    a bc

* Quotes are often used, but not always required
* target text is a *line of text*
* re may contain spaces
* The ``-n`` flag gives us line numbers.

.. sourcecode:: bash

    > grep -n "b " < x.txt
    2:ab c
    3:a b c
    > grep -n "b" < x.txt
    1:abc
    2:ab c
    3:a b c
    4:a bc
    >

* ``*`` wildcard
* ``^`` match only at the beginning of the string
* ``$`` match only at the end of the string

``*`` will match when the preceding character is found 0 or more times

.. sourcecode:: bash

    > grep x < x.txt
    > grep x* < x.txt
    > grep "x*" < x.txt
    abc
    ab c
    a b c
    a bc
    > grep " x*" < x.txt
    ab c
    a b c
    a bc
    >

The search for ``x*`` finds everything.  The search for `` x*`` finds a space.

Anchors

* ``^`` match at the beginning of a string
* ``$`` match at the end of a string

.. sourcecode:: bash

    > grep "^a" x.txt
    abc
    ab c
    a b c
    a bc
    > grep "a$" x.txt
    > grep "b$" x.txt
    > grep "c$" x.txt
    abc
    ab c
    a b c
    a bc
    >

What is going on here is that **the string to be searched is each line**.  Hence, ``^a`` finds ``abc``, but ``^b`` does not find ``a bc``.

Additional simple regex symbols and patterns:

* ``\d`` matches a digit [0-9]
* ``\D`` matches a non-digit
* ``\s`` matches whitespace
* ``[abc]`` match any of a,b,c
* ``[a-d]`` match any of a,b,c,d

(The backslash is an *escape* character, so ``\d`` means "this is not just a ``d`` but has a special meaning".  If you really want to search for ``\``, do ``\\``)!

Suppose we have the following text file:

``x.txt``:

.. sourcecode:: bash

    abc
    xyz
    b
    pqr
    9: a
    1967
    bf

* match any of several characters

.. sourcecode:: bash

    > grep [af] x.txt
    abc
    9: a
    bf
    >

* whitespace

.. sourcecode:: bash

    > grep ":\s[ab]" t.txt
    9: a
    >

A space would work here, but ``\s`` will also match a tab or newline.

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

Here the ``{4}`` is a *count* of how many repetitions of a decimal character we are searching for.

* ``{n}`` occurs n times exactly
* ``{n,}`` occurs *at least* n times
* ``{n,m}`` occurs at least n but not more than m times

A regex for social security numbers I found in *bash Cookbook*

* ``'[0-9]\{3\}-\{0,1\}[0-9]\{2\}-\{0,1\}[0-9]\{4\}'``

.. sourcecode:: bash

    > echo "553-26-4787" | grep '[0-9]\{3\}-\{0,1\}[0-9]\{2\}-\{0,1\}[0-9]\{4\}'
    553-26-4787
    >

Explanation:

* ``[0-9]\{3\}-`` any digit from 0-9, 3 of them
* ``-\{0,1\}`` the dash ``-`` may not be present
* ``[0-9]\{2\}``
* ``-\{0,1\}`` the dash ``-`` may not be present
* ``[0-9]\{4\}``

For the first part, ``\{`` is escaping the special character ``{`` and later ``}`` with a backslash.  Not clear when that's required.

Quotes seem to be required as well.  When to quote a pattern?

**substitution**

Using ``tr``

.. sourcecode:: bash

    > echo "abc" | tr /b/ /x/
    axc
    > echo "abc" | tr /ab/ /xb/
    xbc
    >