.. _server4:

##################
Linux:  SSH access
##################

The goal in this chapter is to change the login to the guest Ubuntu machine (on VirtualBox) from password authentication to using an SSH key pair.

Useful commands for this chapter

* ``ssh -p 2222 te@127.0.0.1``
* ``ssh-keygen -l -f < filename >``
* ``sudo service ssh restart``
* ``sudo nano /etc/ssh/sshd_config``
* ``scp -P 2222 ~/.ssh/ubuntu_id_rsa.pub te@127.0.0.1:~/.ssh/authorized_keys``

The password method looks like this (I use my Ubuntu password):

.. sourcecode:: bash

    > ssh -p 2222 te@127.0.0.1
    Password: 
    Welcome to Ubuntu 14.04.2 LTS (GNU/Linux 3.16.0-30-generic x86_64)

     * Documentation:  https://help.ubuntu.com/

    Last login: Sat Mar  7 20:29:19 2015 from 10.0.2.2
    te@te-VB:~$

The fingerprint of the key the ssh server presented to us on first login was 

* ``e8:90:d6:1f:68:d1:0f:f1:1f:4b:88:a7:7a:8c:aa:17``

Generate fingerprints for all the keys in ``known_hosts``

http://superuser.com/questions/529132/how-do-i-extract-fingerprints-from-ssh-known-hosts

On OS X

.. sourcecode:: bash

    > ssh-keygen -l -f ~/.ssh/known_hosts 
    2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48 github.com,192.30.252.130 (RSA)
    2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48 192.30.252.128 (RSA)
    2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48 192.30.252.131 (RSA)
    2048 66:9d:5e:28:32:60:65:ec:99:77:09:87:73:f4:4b:c7 localhost (RSA)
    2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48 192.30.252.129 (RSA)
    2048 66:9d:5e:28:32:60:65:ec:99:77:09:87:73:f4:4b:c7 127.0.0.1 (RSA)
    2048 e8:90:d6:1f:68:d1:0f:f1:1f:4b:88:a7:7a:8c:aa:17 [127.0.0.1]:2222 (RSA)
    >

Seems like we have a number of keys for GitHub, at different ip addresses.

********************
Edit the config file
********************

Configuration is specified in ``/etc/ssh/sshd_config``.

How do we turn on SSH key authentication?

Some notes are here:

https://help.ubuntu.com/10.04/serverguide/openssh-server.html

    To have sshd allow public key-based login credentials, simply add or modify the line:

    PubkeyAuthentication yes

    In the ``/etc/ssh/sshd_config`` file, or if already present, ensure the line is not commented out.

We have done this in a previous chapter.

If you do make a change you need to do a restart.  They recommend ``sudo /etc/init.d/ssh restart`` but ``sudo service ssh restart`` also works.

Then they say to do ``ssh-copy-id username@remotehost``, so

.. sourcecode:: bash

    > ssh-copy-id te@127.0.0.1
    -bash: ssh-copy-id: command not found
    >

So, I don't have ``ssh-copy-id`` on OS X.

I found this:

https://github.com/beautifulcode/ssh-copy-id-for-OSX

but note problems described here:

http://stackoverflow.com/questions/25655450/how-do-you-install-ssh-copy-id-on-a-mac

which says Homebrew has it:

.. sourcecode:: bash

    > brew info ssh-copy-id
    ssh-copy-id: stable 6.7p1 (bottled)
    http://www.openssh.com/
    Not installed
    From: https://github.com/Homebrew/homebrew/blob/master/Library/Formula/ssh-copy-id.rb
    >

I have installed this, but only at the end.  Instead I did the transfer manually.

************
Key transfer
************

So what we need to do is to transfer my public key (one of them) to Ubuntu.  Then ``ssh`` will authenticate with my private key.

I follow my notes from here:

http://telliott99.blogspot.com/2011/08/linux-server-ssh.html

.. sourcecode:: bash

    > ssh -p 2222 te@127.0.0.1
    Password: 
    Welcome to Ubuntu 14.04.2 LTS (GNU/Linux 3.16.0-30-generic x86_64)

     * Documentation:  https://help.ubuntu.com/

    Last login: Sat Mar  7 20:29:19 2015 from 10.0.2.2
    te@te-VB:~$

This next attempt looks OK superficially, but it is a failure.  That's because I am logged into Ubuntu and ``~/.ssh/id_rsa.pub`` is not the OS X version but the Ubuntu key!

.. sourcecode:: bash

    te@te-VB:~$ scp ~/.ssh/id_rsa.pub te@127.0.0.1:~/.ssh/authorized_keys
    The authenticity of host '127.0.0.1 (127.0.0.1)' can't be established.
    ECDSA key fingerprint is fb:60:fa:77:cb:07:1e:8c:19:b5:59:a8:50:0f:be:10.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '127.0.0.1' (ECDSA) to the list of known hosts.
    Password: 
    Password: 
    id_rsa.pub                          100%  390     0.4KB/s   00:00    
    te@te-VB:~$
    
As usual, the password to use here is the one for my user account on Ubuntu.

Not having noticed the problem, edit ``etc/ssh/sshd_config`` to have ``Password authentication no``

.. sourcecode:: bash

    te@te-VB:~$ sudo nano /etc/ssh/sshd_config
    te@te-VB:~$ sudo service ssh restart
    ssh stop/waiting
    ssh start/running, process 2397
    te@te-VB:~$

Now, logon should just work.

.. sourcecode:: bash

    te@te-VB:~$ logout
    Connection to 127.0.0.1 closed.
    
.. sourcecode:: bash

    > ssh -p 2222 te@127.0.0.1
    Password: 

    [4]+  Stopped                 ssh -p 2222 te@127.0.0.1
    >

And it's not working

Are we even using ``ssh``?  Looks like it:

.. sourcecode:: bash

    te@te-VB:~$ sudo service ssh stop
    [sudo] password for te: 
    ssh stop/waiting
    te@te-VB:~$

.. sourcecode:: bash

    > ssh -p 2222 te@127.0.0.1
    ssh_exchange_identification: Connection closed by remote host
    >

Looks like it

.. sourcecode:: bash

    te@te-VB:~$ sudo service ssh restart
    stop: Unknown instance: 
    ssh start/running, process 2199
    te@te-VB:~$

Looking again at ``/etc/ssh/sshd_config``, I see another problem:

.. sourcecode:: bash

    #AuthorizedKeysFile	%h/.ssh/authorized_keys
    
Looking again at ``/etc/ssh/sshd_config`` edit to produce

.. sourcecode:: bash

    AuthorizedKeysFile	%h/.ssh/authorized_keys

And I also do

.. sourcecode:: bash

    PasswordAuthentication no

So this should work..


At this point, what I did was to generate another RSA key/pair as ``ubuntu_id_rsa``.  No passphrase this time.  The key fingerprint is:

* ``bd:7b:e3:9e:36:5e:3b:4c:5b:0b:9e:dd:81:51:74:18``
* ``telliott_admin@Toms-MacBook-Air.local``

And at this point I realized the problem with my ``scp`` attempt, that ``~/.ssh/id_rsa.pub`` is my account on Ubuntu.

How to specify the src correctly?  I need to be on OS X, not Ubuntu.

.. sourcecode:: bash

    > scp -P 2222 ~/.ssh/ubuntu_id_rsa.pub te@127.0.0.1:~/.ssh/authorized_keys
    Password: 
    ubuntu_id_rsa.pub                         100%  419     0.4KB/s   00:00    
    >

The timestamp is right:

.. sourcecode:: bash

    te@te-VB:/etc/ssh$ ls -al ~/.ssh/authorized_keys 
    -rw-r--r-- 1 te te 419 Mar  8 08:59 /home/te/.ssh/authorized_keys
    te@te-VB:/etc/ssh$


OK.. how to tell ssh to use the key ``ubuntu_id_rsa.pub``?

http://www.cyberciti.biz/faq/force-ssh-client-to-use-given-private-key-identity-file/

What I need to do is to configure ``ssh`` by making a file:  ``config``.

On OS X

.. sourcecode:: bash

    > printf "Host 127.0.0.1\n  IdentityFile ~/.ssh/ubuntu_id_rsa\n" > config
    > ls -al config    drwxr-xr-x+ 43 telliott_admin  staff  1462 Mar  7 10:39 ..
    -rw-r--r--   1 telliott_admin  staff    51 Mar  8 11:57 config
    > cat config
    Host 127.0.0.1
      IdentityFile ~/.ssh/ubuntu_id_rsa
    >
    
This specifies the ``ubuntu_id_rsa`` for 127.0.0.1.

Now

.. sourcecode:: bash

    > ssh -p 2222 te@127.0.0.1
    Welcome to Ubuntu 14.10 (GNU/Linux 3.16.0-23-generic x86_64)

     * Documentation:  https://help.ubuntu.com/

    Last login: Sun Mar  8 11:41:01 2015 from 10.0.2.2
    te@te-vb:~$

And it works!!

One last thing:  turn off PasswordAuthentication in ``sshd_config``

So the key was:

* edit ``/etc/ssh/sshd_config``:  ``AuthorizedKeysFile	%h/.ssh/authorized_keys``
* set up ``~/.ssh/config``
* ``scp -P 2222 ~/.ssh/ubuntu_id_rsa.pub te@127.0.0.1:~/.ssh/authorized_keys``

Other useful commands to remember:

* ``ssh -p 2222 te@127.0.0.1``
* ``ssh-keygen -l -f ~/.ssh/known_hosts``
* ``sudo service ssh restart``
* ``cat /etc/ssh/sshd_config``
* ``scp -P 2222 ~/.ssh/ubuntu_id_rsa.pub te@127.0.0.1:~/.ssh/authorized_keys``

Save a snapshot of the server as ``server4``.
