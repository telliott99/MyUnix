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

It looks like we are fine and then Python 2.7.9 tries to remove a file from the System Python.  That's a bug.  Maybe we can back up to Python 2.7.8, which I had before.

In the end, I couldn't figure out how to do this!  I'll solve that problem another day.  Finally, I decide to use the System Python.

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
   :scale: 40 %

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