.. _dropbox:

###################
Dropbox from the VM
###################

Rather than do their shared folder thing (a huge pain, as I recall)

http://telliott99.blogspot.com/2011/08/trying-ubuntu-linux-1.html

I just set up limited Dropbox access in VB/Ubuntu.

I obtain the Dropbox install helper as ``dropbox_2015.02.12_amd64.deb``.

    cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    ~/.dropbox-dist/dropboxd
    
Even after ``mkdir ~/.dropbox-dist``, it doesn't work because of a permissions problem.  Weird.

Alternatively

http://askubuntu.com/questions/40779/how-do-i-install-a-deb-file-via-the-command-line

    sudo dpkg -i DEB_PACKAGE

Do it from Firefox:

Search for Dropbox and authorize about 50 sites like ``Facebook``.  

Instead

https://help.ubuntu.com/community/VirtualBox/SharedFolders

Get the Terminal running with CTL-OPT-T and drag its icon to the top of the Dock.

And I figured out how to page up and down:  SHIFT + PAGE UP/DOWN on the keyboard.  Not sure about when keyboard is not attached.

After several times through, I am labeling my snapshots of the server in sync with these chapters.  So at this point I will save one as ``server1``.
