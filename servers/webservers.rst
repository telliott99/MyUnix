.. _webserver:

####################
Webservers in Python
####################

A server doesn't have to be complicated.  Python has a built-in webserver that you can launch from the command line.

https://docs.python.org/2/library/simplehttpserver.html

.. sourcecode:: bash

    > python -m SimpleHTTPServer
    Serving HTTP on 0.0.0.0 port 8000 ...
    ..
    127.0.0.1 - - [11/Mar/2015 16:55:18] "GET / HTTP/1.1" 200 -

or another port:

.. sourcecode:: bash

    > python -m SimpleHTTPServer 8080
    Serving HTTP on 0.0.0.0 port 8080 ...

In another tab of Terminal I do

.. sourcecode:: bash

    > curl localhost:8000
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><html>
    <title>Directory listing for /</title>
    <body>
    <h2>Directory listing for /</h2>
    <hr>
    <ul>
    <li><a href=".DS_Store">.DS_Store</a>
    <li><a href=".git/">.git/</a>
    <li><a href=".gitignore">.gitignore</a>
    <li><a href="_build/">_build/</a>
    <li><a href="_static/">_static/</a>
    <li><a href="conf.py">conf.py</a>
    <li><a href="figs/">figs/</a>
    <li><a href="git/">git/</a>
    <li><a href="index.rst">index.rst</a>
    <li><a href="Makefile">Makefile</a>
    <li><a href="server/">server/</a>
    <li><a href="Setup.txt">Setup.txt</a>
    <li><a href="software/">software/</a>
    <li><a href="sphinx.rst">sphinx.rst</a>
    <li><a href="todo.txt">todo.txt</a>
    <li><a href="unix/">unix/</a>
    </ul>
    <hr>
    </body>
    </html>
    >

You will be in some directory when the server is started.  The default behavior is to serve a listing of that directory.  If you click on a file in the list, that file will be served.

If the directory contains an index file ``index.html``, then that file will be served first..

Go back to the Python tab and see:

.. sourcecode:: bash

    127.0.0.1 - - [11/Mar/2015 16:59:33] "GET / HTTP/1.1" 200 -

That is the ``GET`` request that the server responded to.

Or in Safari I go to ``localhost:8000``

.. image:: /figs/one_line_server.png
  :scale: 50 %

Take a look at the command we invoked:

.. sourcecode:: bash

    > python -m SimpleHTTPServer

https://docs.python.org/2/using/cmdline.html

The ``-m`` flag to ``python`` on the command line means to load the module given as an additional argument:  ``SimpleHTTPServer``, which means that if there is a ``__main__`` for the module, that will get executed.

Here is the source for the module (not too easy to understand).

http://www.opensource.apple.com/source/python/python-3/python/Lib/SimpleHTTPServer.py






Frameworks:
flask

http://www.lighttpd.net



