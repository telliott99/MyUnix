.. _virtual-machine:

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

.. note::

   Update:  I've gone back to ubuntu-14.10.

This process is very smooth.  It's much better than when I tried VirtualBox previously.

It takes a minute or so and then displays the install screen for Ubuntu.

Now, here is where I had trouble.  I installed Ubuntu in VB numerous times and each time I struggled with the mouse not working in the Ubuntu window.  

Eventually, this is fixed later by installing what is called the VBoxGuestAdditions in Linux.  But it's a chicken-and-egg problem:  the mouse doesn't work well without the guest additions, you need the mouse to do the install, and you need the install to mount the CD and get the additions.

In a few cases, eventually it just started working well enough to accomplish the install, but it is *not* very reliable.

.. note::

    Reading the manual, I came upon this:

    Your mouse is owned by the VM only after you have clicked in the VM window. The host mouse pointer will disappear, and your mouse will drive the guest's pointer instead of your normal mouse pointer.

We have *two* windows open:

.. image:: /figs/virtualbox_manager.png
   :scale: 50 %

.. image:: /figs/ubuntu_install.png
  :scale: 50 %

*The first window is the VM window*.  You click *in the first window*, and now the mouse will work *in the second window*!

Even with this, it's still flaky.  What you can try is to click ``Disable Mouse Integration`` in the menu on the bottom of the window, then move the mouse into the screen and press LEFT-CMD (the Host key), and then click ``Capture``.  That worked, once. ]

So I installed Ubuntu, and along the way authorized a bunch of connections through LittleSnitch.

.. sourcecode:: bash

    computer tom-VB
    username te
    password ********

Another little hiccup is that the Ubuntu installer prompted me to restart at the end, but when I did that it just hung.  So I tried to "send shutdown signal" but then just pulled the plug with "power off machine".

Start up VirtualBox again, and restart Linux.  Now for the guest additions.  The file is inside the VirtualBox application bundle:

``/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso``

I put it on my Desktop, but that was probably a mistake, since I got errors from VirtualBox when I deleted it later (even though I had unmounted the "CD" in Linux).  

Following this advice:

http://www.productionmonkeys.net/guides/virtualbox/guest-additions

I found that the toolbar at the bottom of the Linux window has a disk icon, so I clicked on that and then did a file dialog to find the ``iso`` file.  Make sure the mouse is working for Ubuntu before you do this!

Follow the prompt to run it.  Restart when it's done.

The mouse should work fine now!

In VirtualBox under Settings > General > Advanced I set the "Shared Clipboard" and "Drag'n'Drop" to "Bidirectional".

.. image:: /figs/clipboard.png
  :scale: 50 %

Rather than do their shared folder thing (a huge pain, as I recall)

http://telliott99.blogspot.com/2011/08/trying-ubuntu-linux-1.html

I just set up limited Dropbox access in VB/Ubuntu.

Get the Terminal running with CTL-OPT-T and drag its icon to the top of the Dock.

And I figured out how to page up and down:  SHIFT + PAGE UP/DOWN on the keyboard.  Not sure about when keyboard is not attached.

After several times through, I am labeling my snapshots of the server in sync with these chapters.  So at this point I will save one as ``server1``.
