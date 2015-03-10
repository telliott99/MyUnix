.. _python:

###############
Python packages
###############

``pip`` is a tool to set up various optional packages for Python.  Having been burned a few times over the years, I like to use ``virtualenv`` to set up isolated environments for different projects.  At the end of the last chapter, we installed an updated version of Python 2.7.9 using Homebrew, and found that it had ``pip`` as well as ``virtualenv``.  Now we can get to work.

I've done this a number of times and it has worked fine.  But it is not working today

Unfortunately it looks like ``pip install env`` as well as ``/usr/local/bin/pip install virtualenv`` are trying to write to 

.. sourcecode:: bash


    > /usr/local/bin/pip install virtualenv
    Requirement already satisfied (use --upgrade to upgrade): virtualenv in /Library/Python/2.7/site-packages
    >

That's the System Python and not what I want to do.

Followed suggestions here but it's not working

http://stackoverflow.com/questions/17524234/stop-homebrew-pip-putting-virtualenv-in-usr-local-share

It looks like we are fine and then Python 2.7.9 tries to remove a file from the System Python.  That's a bug.  Maybe we can back up to Python 2.7.8, which I had before.  At the time, I couldn't figure out how to overcome the bug, or to get Homebrew to go back to 2.7.8.

[Update:  I found a way later, it is at the end of the chapter]

Finally, I decided to use the System Python.

.. sourcecode:: bash

    > python /Library/Python/2.7/site-packages/virtualenv.py mpl
    New python executable in mpl/bin/python
    Installing setuptools, pip...done.
    > cd mpl
    > source bin/activate
    (mpl)> python
    Python 2.7.6 (default, Sep  9 2014, 15:04:36) 
    [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.39)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>>
    [1]+  Stopped                 python
    (mpl)>

Well that looks fine.  I will need ``cython`` for ``scipy``, I think.

.. sourcecode:: bash

    (mpl)> pip install cython
    ..
    Successfully installed cython
    Cleaning up...
    (mpl)>
    (mpl)> pip install numpy
    Downloading/unpacking numpy
    ..
    Installing collected packages: numpy
    Successfully installed numpy
    Cleaning up...
    (mpl)>
    (mpl)> pip install matplotlib
    Downloading/unpacking matplotlib
    ..
    Successfully installed matplotlib nose pytz six python-dateutil mock pyparsing
    Cleaning up...
    (mpl)>
    
A quick test:

.. sourcecode:: bash

    (mpl)> python
    Python 2.7.6 (default, Sep  9 2014, 15:04:36) 
    [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.39)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import matplotlib.pyplot as plt
    >>> Y = [1,4,9,16]
    >>> plt.scatter(range(len(Y)),Y,s=250,color='r')
    <matplotlib.collections.PathCollection object at 0x10c54b2d0>
    >>> plt.savefig('example.png')
    >>>
    >>> 
    [3]+  Stopped                 python
    (mpl)> ls
    bin		example.png	include		lib		man
    (mpl)> open -a Preview example.png
    (mpl)> 

Looks good to me.

.. image:: /figs/example.png
   :scale: 25 %

.. sourcecode:: bash

    (mpl)> pip install scipy
    Downloading/unpacking scipy
    ..
    Installing collected packages: scipy
    Successfully installed scipy
    Cleaning up...
    (mpl)>
    (mpl)> python
    Python 2.7.6 (default, Sep  9 2014, 15:04:36) 
    [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.39)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> from scipy import stats
    >>> from scipy.stats import norm
    >>> norm.cdf(0)
    0.5
    >>> norm.cdf(2)
    0.97724986805182079
    >>> 
    [4]+  Stopped                 python
    (mpl)>

Looks like it's working pretty well.

**Problem with pip**

Recall the problem that we had.

.. sourcecode:: bash

    > which pip2.7
    /usr/local/bin/pip2.7
    > which python
    /usr/local/bin/python
    > pip install --upgrade virtualenv
    > pip install virtualenv
    Requirement already satisfied (use --upgrade to upgrade): virtualenv in /Library/Python/2.7/site-packages
    > pip install --upgrade virtualenv
    ..
    OSError: [Errno 13] Permission denied: '/Library/Python/2.7/site-packages/virtualenv-1.11.5-py2.7.egg-info/dependency_links.txt'
    
We are getting the right ``pip`` and the right ``python``, but the "stack trace" shows that in a deeply nested function, we are working in ``/usr/local``, working in ``/usr/local`` and then try to remove a file in

.. sourcecode:: bash

    /Library/Python/2.7/site-packages//Library/Python/2.7/site-packages/

Luckily, we are not using ``sudo``.  People suggested using ``sudo`` on StackOverflow and then they can't understand why inside their virtual environment they are getting the System Python!



People had suggested that maybe ``virtualenv`` was still there in ``/usr/local/bin`` but it wasn't.

What I did that worked was to hide the System "pip" and "virtualenv"!

.. sourcecode:: bash

    > cd /Library/Python/2.7/site-packages/
    > ls
    Babel-1.3-py2.7.egg
    Jinja2-2.7.3-py2.7.egg
    MarkupSafe-0.23-py2.7-macosx-10.10-intel.egg
    Pygments-2.0.2-py2.7.egg
    README
    Sphinx-1.3b3-py2.7.egg
    alabaster-0.7.1-py2.7.egg
    docutils-0.12-py2.7.egg
    easy-install.pth
    pip-1.4.1-py2.7.egg
    snowballstemmer-1.2.0-py2.7.egg
    sphinx_rtd_theme-0.1.6-py2.7.egg
    virtualenv-1.11.5-py2.7.egg-info
    virtualenv.py
    virtualenv.pyc
    virtualenv_support
    
.. sourcecode:: bash

    > sudo mkdir tmp
    > sudo rm virtualenv.pyc
    > sudo mv virtualenv.py tmp/virtualenv.py
    > sudo mv pip-1.4.1-py2.7.egg/ tmp/pip-1.4.1-p2.7.egg
    > sudo mv virtualenv-1.11.5-py2.7.egg-info tmp
    > sudo mv virtualenv_support/ tmp

Then, in a new Terminal window

.. sourcecode:: bash

    > pip install virtualenv
    Collecting virtualenv
      Using cached virtualenv-12.0.7-py2.py3-none-any.whl
    Installing collected packages: virtualenv

    Successfully installed virtualenv-12.0.7
    > virtualenv
    You must provide a DEST_DIR
    ..

And finally, move it all back:

.. sourcecode:: bash

    > cd /Library/Python/2.7/site-packages/
    > sudo mv tmp/* .
    > sudo rm -r tmp

Except, I actually did ``sudo mv tmp/* ..`` by mistake (thinking I was in ``tmp``).  I won't show you how I fixed that, though it was easy.  A bit embarrassing.

So now, having obtained ``virtualenv`` that will work with my upgraded Python, we can try it:

.. sourcecode:: bash

    > virtualenv mpl2
    New python executable in mpl2/bin/python2.7
    Also creating executable in mpl2/bin/python
    Installing setuptools, pip...done.
    > cd mpl2
    > source bin/activate
    (mpl2)> python
    Python 2.7.9 (default, Feb 10 2015, 03:28:08) 
    [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.56)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> 
    [3]+  Stopped                 python
    (mpl2)>
    
Looks good.

.. sourcecode:: bash

    (mpl2)> pip install numpy
    ..
    Successfully installed numpy-1.9.2
    (mpl2)> pip install matplotlib
    ....
    Successfully installed matplotlib-1.4.3 mock-1.0.1 nose-1.3.4 pyparsing-2.0.3 python-dateutil-2.4.0 pytz-2014.10 six-1.9.0
    (mpl2)> pip install scipy
    ..
    Installing collected packages: scipy

    Successfully installed scipy-0.15.1
    (mpl2)> python
    Python 2.7.9 (default, Feb 10 2015, 03:28:08) 
    [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.56)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    
>>> from scipy import stats
>>> from scipy.stats import norm
>>> norm.cdf(2)
0.97724986805182079
>>> norm.cdf(0)
0.5
>>> import matplotlib.pyplot as plt
>>> Y = [1,4,9,16]
>>> plt.scatter(range(len(Y)),Y,s=250,color='r')
<matplotlib.collections.PathCollection object at 0x10b227690>
>>> plt.savefig('example.png')

.. sourcecode:: bash

    [4]+  Stopped                 python
    (mpl2)> ls
    bin			lib
    example.png		man
    include			pip-selfcheck.json
    (mpl2)> open -a Preview example.png 
    (mpl2)> 

Looks great to me.  Success at last.

That hiding trick was a nice way around the bug, because actually fixing it is beyond me.

