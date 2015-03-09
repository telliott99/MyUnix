.. _server2:

####################
Terminal and apt-get
####################


I do CMD-C to copy in OS X as usual

the paste command in Linux is 

* ``CTL-SHIFT-V``

Other good commands to remember:

* ``CTL-OPT-T`` brings up the Terminal application
* ``CTL-L`` clear screen in Terminal (this works in OS X as well)

I figure out how to drag the Terminal icon to the top of the "Dock" (it's a little awkward).  In Terminal I do:

* ``sudo apt-get update``

``sudo apt-get install``:

* ``python-dev``
* ``gfortran``
* ``python-numpy``
* ``zlib-bin``
* ``libpng3``
* ``libfreetype6``
* ``python-matplotlib``
* ``python-scipy``

And then I do a few tests.  I make a script file with the EOF trick:

.. sourcecode:: bash

    cat << EOF > x.py
    import matplotlib.pyplot as plt
    xL = range(5)
    yL = [n**2 for n in xL]
    plt.scatter (xL,yL,s=100,color='red')
    plt.savefig('example.png')
    EOF

And then

.. sourcecode:: bash

    $ python x.py

The ``savefig`` command works, as does ``plt.show()`` from the interpreter, though I didn't figure out how to exit cleanly.

Later, I put the script in ``~/Dropbox/Ubuntu/test-matplotlib.py``.  It saves to whatever directory you are in when you invoke the script.

.. sourcecode:: bash

    python ~/Dropbox/Ubuntu/test-matplotlib.py

This works as well:

>>> from scipy import stats
>>> from scipy.stats import norm
>>> norm.cdf(0)
0.5
>>> norm.cdf(2)
0.97724986805182079

Finally, 

* ``sudo apt-get install cython``
* ``sudo apt-get install python-pip``
* ``sudo pip install virtualenv``

Permissions are weird on ``/usr/local`` so:

* ``sudo chown `whoami` -R /usr/local``
* ``sudo chmod 755 -R /usr/local``
* ``sudo chgrp adm -R /usr/local``

Note:  even with this ``sudo`` is still required because the install process needs to read ``/var/lib/dpkg/lock`` for some reason.

Now, click the VB window's red close button and choose "save state".  Take a "snapshot" and call it "server2".

Finally, try a virtual environment.

.. sourcecode:: bash

    $ cd Desktop/
    $ mkdir tmp
    $ virtualenv tmp
    $ cd tmp
    $ source bin/activate

The prompt has been ``$`` but note it changes:

.. sourcecode:: bash

    (tmp)te@te-VB:~/Desktop/tmp$ pip install numpy

* ``sudo pip install virtualenv``

took a while because ``numpy`` is actually being built.

However,

* ``sudo pip install matplotlib`` 

failed because it couldn't find ``freetype``, ``png``.  I'm going to wait on this, since our objective for the moment is to work on running a server, rather than do scientific computing in a virtual environment setup.

