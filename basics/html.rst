.. _html:

###########
Simple HTML
###########

Here is a HTML document, stripped-down to the essentials::

    <html>
      <head>
      </head>
      <body>
        This is some text.
      </body>
    </html>

Actually, you don't even need the ``head`` section.

But according to Mark Pilgrim's book:

http://diveintohtml5.info

a more reasonable basic document includes at least this much::

    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>My title</title>
      <body>
        This is some text.
      </body>
    </html>

HTML elements include *anchors* or *hypertext references*::

    <a href="link_url">link_text</a>

where link_url is a URL, of course, and link_text is the text displayed for the link.

Now, back in the old days, you might specify the color of text and maybe even the font and size for a particular paragraph or section of text::

    <p<font color="red">This is red text!</font></p>

but this no longer even works in my browser.  We are supposed to use CSS.  The syntax of CSS is different, just for starters::

    <p style="color:red">This is red text!</p>

and that *does* work.

One step up from this in sophistication is to put some ``style`` into the ``head`` section like this::

    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>My title</title>
        <style type="text/css">
            p.red
            {
              color: red;
            }
          </style>
      <body>
        <p>This is some text.</p>
        <p class="red">This is red text!</p>
      </body>
    </html>

This leads to a bunch of styles being defined for a particular document.  Reuse of styles leads to separation into files called style sheets that define styles, with a file extension like ``css``::

    <link rel="stylesheet" type="text/css" href="mystyle.css">

With this approach, we would have a separate file

``mystyle.css``::

    body {
        background-color: lightblue;
    }
    p.red {
        color: red;
    }

and then ``example.html`` is::

    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>My title</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
      <body>
        <p>This is some text.</p>
        <p class="red">This is red text!</p>
      </body>
    </html>

And this is what it looks like:

.. image:: /figs/css_example.png
   :scale: 50 %

Some other HTML elements include the ``table``::

    <table>
      <tr>
        <td>short</td>
        <td>muchlonger</td>
      </tr>
      <tr>
        <td>c</td>
        <td>d</td>
      </tr>
    </table>

