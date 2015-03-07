.. _server1:

##########################
Linux on a Virtual Machine
##########################

Our purpose here is to take a look at Linux.  

One way to do that would be to find an old laptop with Windows and wipe it.  But I don't have one.  It is possible to "dual boot" OS X and Linux, but it's a pain, from what I understand.  Another idea is tro try to run Linux on my current laptop, by installing a virtual machine.

There is free software called VirtualBox (owned by Oracle) which can be used to provide our VM.

https://www.virtualbox.org

I have explored this approach previously and blogged about it

http://telliott99.blogspot.com/2011/08/trying-ubuntu-linux-1.html
http://telliott99.blogspot.com/2011/08/trying-ubuntu-linux-2.html
http://telliott99.blogspot.com/2011/08/trying-ubuntu-linux-3.html
http://telliott99.blogspot.com/2011/08/trying-ubuntu-linux-4.html
http://telliott99.blogspot.com/2011/08/trying-ubuntu-linux-5.html
http://telliott99.blogspot.com/2011/08/trying-ubuntu-linux-6.html

http://telliott99.blogspot.com/2011/08/linux-server.html
http://telliott99.blogspot.com/2011/08/linux-server-ssh.html

http://telliott99.blogspot.com/2012/03/ubuntu-under-virtualbox-1.html

The VirtualBox installer is ``VirtualBox-4.3.24-98716-OSX.dmg``.

I downloaded it from the website.  On the site there is a page with digests for various files.  The one for this file is:

.. sourcecode:: bash

    c6d629ca2f5a470b03c48849d2f6c991382c45da5c84255d3c73e78ad5200389

I compare with

.. sourcecode:: bash

    > openssl dgst -sha256 VirtualBox-4.3.24-98716-OSX.dmg 
    SHA256(VirtualBox-4.3.24-98716-OSX.dmg)=\ 
    c6d629ca2f5a470b03c48849d2f6c991382c45da5c84255d3c73e78ad5200389
    >

``openssl`` needs to be called with ``dgst -sha256`` for this version of ``sha``.

I like to paste them right on top of each other:

* ``c6d629ca2f5a470b03c48849d2f6c991382c45da5c84255d3c73e78ad5200389``
* ``c6d629ca2f5a470b03c48849d2f6c991382c45da5c84255d3c73e78ad5200389``

We also need Ubuntu.  I got that from here:

http://www.ubuntu.com/download/desktop

The file is ``ubuntu-14.10-desktop-amd64.iso``, which I move to ``~/MyDownloads``.  Because I had a problem that an answer at StackOverflow blamed on faulty drivers, later I obtained ``ubuntu-14.04.2-desktop-amd64.iso`` because it should be more stable.  It didn't solve that problem, but ``14.04`` is what I'm going to use here.  It is called "Trusty Tahr" in Linux-speak, while 14.10 is "Utopic Unicorn".

I run the VirtualBox installer, and then I run VirtualBox, naming the new machine "Ubuntu", and accepting all the defaults, except I boosted the RAM to 1024.  Start the VM and it prompts for an image:  and I navigate to ``ubuntu-14.04.2-desktop-amd64.iso``.

Now, here is where I had trouble.  I installed Ubuntu in VB numerous times and each time I struggled with the mouse not working in the Ubuntu window.  

Eventually, this is fixed later by installing what is called the VBoxGuestAdditions in Linux.  But it's a chicken-and-egg problem:  the mouse doesn't work well without the guest additions, you need the mouse to do the install, and you need the install to mount the CD and get the additions.

In a few cases, eventually it just started working well enough to accomplish the install, but it is *not* very reliable.

So I installed Ubuntu, and along the way authorized a bunch of connections through LittleSnitch.

.. sourcecode:: bash

    computer tom-VB
    username te
    password ********

Another little hiccup is that the Ubuntu installer prompted me to restart at the end, but when I did that it just hung.  So I quite VB, tried to "send shutdown signal" but then just pulled the plug with "power off machine".

Start up VirtualBox again, and restart Linux.  Now for the guest additions.  The file is inside the VirtualBox application bundle:

``/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso``

I put it on my Desktop, but that was probably a mistake, since I got errors from VirtualBox when I deleted it later (even though I had unmounted the "CD" in Linux).  

Following this advice:

http://www.productionmonkeys.net/guides/virtualbox/guest-additions

I found that the toolbar at the bottom of the Linux window has a disk icon, so I clicked on that and then did a file dialog to find the ``iso`` file.  Mount it and then follow the prompt to run it.  Restart when it's done.

The mouse works fine now!

In VirtualBox under Settings > General > Advanced I set the "Shared Clipboard" and "Drag'n'Drop" to "Bidirectional".

I do CMD-C to copy in OS X as usual, the paste command in Linux is 

* ``CTL-SHIFT-V``

Other good ones:

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

    python x.py

The ``savefig`` command works, as does ``plt.show()`` from the interpreter, though I didn't figure out how to exit cleanly.

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

Now, click the VB window's red close button and choose "save state".  Take a "snapshot" and call it "setup".

Finally, try a virtual environment.

.. sourcecode:: bash

    cd Desktop/
    mkdir tmp
    virtualenv tmp
    cd tmp
    source bin/activate

And the prompt changes.

.. sourcecode:: bash

    (tmp)te@te-VB:~/Desktop/tmp$ pip install numpy

* ``sudo pip install virtualenv``

took a while because ``numpy`` is actually being built.

However,

* ``sudo pip install matplotlib`` 

failed because it couldn't find ``freetype``, ``png``.  I'm going to wait on this, since our objective for the moment is to work on running a server, rather than do scientific computing in a virtual environment setup.


