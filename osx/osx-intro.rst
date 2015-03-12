.. _osx-intro:

#####
Intro
#####

This book is about Unix.  This section is about how to do things that are OS X-specific, but from the command line, taking advantage of its Unixey-ness.

*************
USB-Installer
*************

http://www.macworld.com/article/2367748/how-to-make-a-bootable-os-x-10-10-yosemite-install-drive.html

For the past few iterations of OS X, you install it by downloading an Installer from the App Store, which then downloads yet more files, and finally runs.  At the end, the installer deletes itself.  So the first thing to do is to save a copy elsewhere when you download it, or repeat the download (hold down the Option key while clicking purchases).

Looking in my ``/Applications`` folder I find that I already have it.

Reformat the destination USB drive.  I named my drive "Yosemite Installer", which we will refer to as ``Yosemite\ Installer`` below.  I did Partition and then Erase, but didn't save detailed notes.  The format should be Mac OS Extended (Journaled).  Under Options make sure GUID Partition Table is selected.

The command to make the install media is:

.. sourcecode:: bash

    sudo\
     /Applications/Install\ OS\ X\ Yosemite.app/Contents/Resources/createinstallmedia\
     --volume /Volumes/Yosemite\ Installer\
     --applicationpath /Applications/Install\ OS\ X\ Yosemite.app\
     --nointeraction

It takes about half an hour.  You will see something like this:

.. sourcecode:: bash

    Erasing Disk: 0%... 10%... 20%... 30%...100%...
    Copying installer files to disk...
    Copy complete.
    Making disk bootable...
    Copying boot files...
    Copy complete.
    Done.
    >

To test whether we can boot with it, do restart and then hold down Option key

What if we just wanted OS X on a USB drive, no installer?  I don't believe it is possible.



