.. _server3:

###########
Linux:  SSH
###########

The goal in this chapter is to login to the guest Ubuntu machine (on VirtualBox) from my the command line in Terminal on the host OS X.

In order to do that we need four things:

* a server on Ubuntu, ``openssh-server``

* a way to establish our credentials for the logon

* tell VirtualBox how to do NAT in the way that we want

* the command to issue in OS X

**********
SSH server
**********

Let's start with the server.  Grab the openssh server software:

https://help.ubuntu.com/lts/serverguide/openssh-server.html

.. sourcecode:: bash

    sudo apt-get install openssh-server
    
While the install runs I see this output:

.. sourcecode:: bash

    Creating SSH2 RSA key; this may take some time ...
    Creating SSH2 DSA key; this may take some time ...
    Creating SSH2 ECDSA key; this may take some time ...
    Creating SSH2 ED25519 key; this may take some time ...
    
.. image:: /figs/server_keys.png
  :scale: 50 %

We'll be using one of these keys eventually (``ssh_host_ecdsa_key``).

I'd like to check the key fingerprints.  Where are the key files?  

Somewhere, I saw the possibility:  ``/etc/ssh/ssh_host_rsa_key``.

.. sourcecode:: bash

    te@te-vb:~$ ls -al /etc/ssh
    total 300
    drwxr-xr-x   2 root root   4096 Mar  8 11:20 .
    drwxr-xr-x 131 root root  12288 Mar  8 11:22 ..
    -rw-r--r--   1 root root 242091 Oct  9 09:29 moduli
    -rw-r--r--   1 root root   1690 Oct  9 09:29 ssh_config
    -rw-r--r--   1 root root   2541 Mar  8 11:20 sshd_config
    -rw-------   1 root root    668 Mar  8 11:20 ssh_host_dsa_key
    -rw-r--r--   1 root root    600 Mar  8 11:20 ssh_host_dsa_key.pub
    -rw-------   1 root root    227 Mar  8 11:20 ssh_host_ecdsa_key
    -rw-r--r--   1 root root    172 Mar  8 11:20 ssh_host_ecdsa_key.pub
    -rw-------   1 root root    399 Mar  8 11:20 ssh_host_ed25519_key
    -rw-r--r--   1 root root     92 Mar  8 11:20 ssh_host_ed25519_key.pub
    -rw-------   1 root root   1675 Mar  8 11:20 ssh_host_rsa_key
    -rw-r--r--   1 root root    392 Mar  8 11:20 ssh_host_rsa_key.pub
    -rw-r--r--   1 root root    338 Mar  8 11:20 ssh_import_id
    te@te-vb:~$

As it turns out, the key we'll use is the ``ecdsa`` key, and its fingerprint is:

.. sourcecode:: bash

    te@te-vb:~$ ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key
    256 b0:7e:5c:45:3b:e2:72:fd:f2:37:fe:d9:51:02:a2:4c  root@te-vb (ECDSA)
    te@te-vb:~$

* ``b0:7e:5c:45:3b:e2:72:fd:f2:37:fe:d9:51:02:a2:4c``

**********************
Test login from Ubuntu
**********************

We'll set up the server in a minute, but the next part of the puzzle is to figure out how to connect.  We need an IP address and a port.  To test it, we can find out about this in Ubuntu:

Start out with this:

.. sourcecode:: bash

    te@te-VB:~$ ifconfig
    eth0      Link encap:Ethernet  HWaddr 08:00:27:36:39:4a  
              inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
              inet6 addr: fe80::a00:27ff:fe36:394a/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:822 errors:0 dropped:0 overruns:0 frame:0
              TX packets:457 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:664116 (664.1 KB)  TX bytes:34605 (34.6 KB)

    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:65536  Metric:1
              RX packets:47 errors:0 dropped:0 overruns:0 frame:0
              TX packets:47 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:3733 (3.7 KB)  TX bytes:3733 (3.7 KB)

    te@te-VB:~$ 

So it looks like the the IP address is 10.0.2.15.  This has been assigned by VirtualBox, which is acting like a router.

Next is the server:

https://help.ubuntu.com/lts/serverguide/openssh-server.html

************
Server setup
************

We generated a key pair for the server above.  We will get around to using that for authentication, but for the time being we will just use the password for our account on Ubuntu.  We don't need to do anything about credentials for the time being.

Now, to set up the server.

We need to edit ``/etc/ssh/sshd_config``.

(The second time through, I saved a copy as ``sshd_config_orig``;  actually, looking later I intended to do this but instead I copied and saved ``ssh_config``.  Oops).

For reference here is the whole file as I have it now.

.. sourcecode:: bash

    # This is the ssh client system-wide configuration file.  See
    # ssh_config(5) for more information.  This file provides defaults for
    # users, and the values can be changed in per-user configuration files
    # or on the command line.

    # Configuration data is parsed as follows:
    #  1. command line options
    #  2. user-specific file
    #  3. system-wide file
    # Any configuration value is only changed the first time it is set.
    # Thus, host-specific definitions should be at the beginning of the
    # configuration file, and defaults at the end.

    # Site-wide defaults for some commonly used options.  For a comprehensive
    # list of available options, their meanings and defaults, please see the
    # ssh_config(5) man page.

    Host *
    #   ForwardAgent no
    #   ForwardX11 no
    #   ForwardX11Trusted yes
    #   RhostsRSAAuthentication no
    #   RSAAuthentication yes
    #   PasswordAuthentication yes
    #   HostbasedAuthentication no
    #   GSSAPIAuthentication no
    #   GSSAPIDelegateCredentials no
    #   GSSAPIKeyExchange no
    #   GSSAPITrustDNS no
    #   BatchMode no
    #   CheckHostIP yes
    #   AddressFamily any
    #   ConnectTimeout 0
    #   StrictHostKeyChecking ask
    #   IdentityFile ~/.ssh/identity
    #   IdentityFile ~/.ssh/id_rsa
    #   IdentityFile ~/.ssh/id_dsa
    #   Port 22
    #   Protocol 2,1
    #   Cipher 3des
    #   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-cbc,3des-cbc
    #   MACs hmac-md5,hmac-sha1,umac-64@openssh.com,hmac-ripemd160
    #   EscapeChar ~
    #   Tunnel no
    #   TunnelDevice any:any
    #   PermitLocalCommand no
    #   VisualHostKey no
    #   ProxyCommand ssh -q -W %h:%p gateway.example.com
    #   RekeyLimit 1G 1h
        SendEnv LANG LC_*
        HashKnownHosts yes
        GSSAPIAuthentication yes
        GSSAPIDelegateCredentials no
    

The server will listen on port 22.

According to the guide, we should do this:  uncomment ``PasswordAuthentication`` (for now)

.. sourcecode:: bash

    PermitRootLogin no
    ChallengeResponseAuthentication yes
    PasswordAuthentication yes   # we'll set it to no eventually
    
We do the edit with ``nano`` and use ``sudo``


I left the RootLogin as it is for the moment.  I'll come back to this.

At this point in my previous work I did  ``sudo /etc/init.d/ssh restart`` but I am following other notes now and I did something else

.. sourcecode:: bash

    te@te-vb:/etc/ssh$ sudo service ssh restart
    ssh stop/waiting
    ssh start/running, process 2376
    te@te-vb:/etc/ssh$
    
*****************
Login from Ubuntu
*****************

Now, let's try  to connect to ``10.0.2.15`` on port 22

I use my Ubuntu password:

.. sourcecode:: bash

    te@te-vb:/etc/ssh$ ssh te@10.0.2.15
    The authenticity of host '10.0.2.15 (10.0.2.15)' can't be established.
    ECDSA key fingerprint is b0:7e:5c:45:3b:e2:72:fd:f2:37:fe:d9:51:02:a2:4c.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '10.0.2.15' (ECDSA) to the list of known hosts.
    Password: 
    Welcome to Ubuntu 14.10 (GNU/Linux 3.16.0-23-generic x86_64)

     * Documentation:  https://help.ubuntu.com/


    The programs included with the Ubuntu system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
    applicable law.

    te@te-vb:~$

Looks like login works.  We needed the restart, and we are on.  Check the fingerprint.

* keyfile:  ``b0:7e:5c:45:3b:e2:72:fd:f2:37:fe:d9:51:02:a2:4c``
* server:   ``b0:7e:5c:45:3b:e2:72:fd:f2:37:fe:d9:51:02:a2:4c``

And that's a match.

*******************************
Login from OS X:  first attempt
*******************************

The next question is how to get on from the host (OS X)?

.. sourcecode:: bash

    > ssh te@10.0.2.15:22
    ssh: Could not resolve hostname 10.0.2.15:22: nodename nor servname provided, or not known
    > ssh te@10.0.2.15
    ^Z
    [4]+  Stopped                 ssh te@10.0.2.15
    >

It just hangs.

***************************
Network Address Translation
***************************

From the discussion in my blog posts, there is stuff about NAT (network address translation).  The VirtualBox reference is here:

http://www.virtualbox.org/manual/ch06.html#network_nat

We need to get VB to allow us to communicate.  Some possibilities:

.. sourcecode:: bash

    VBoxManage modifyvm "VM name" --natpf1 "guestssh,tcp,,2222,,22"

After the protocol ``TCP`` there are four fields:  ip/port for incoming, and ip/port for forwarding.  We (VirtualBox) will listen on 2222 and forward on 22.

according to the manual

    With the above example, all TCP traffic arriving on port 2222 on any host interface will be forwarded to port 22 in the guest. The protocol name tcp is a mandatory attribute defining which protocol should be used for forwarding (udp could also be used). The name guestssh is purely descriptive and will be auto-generated if omitted. The number after --natpf denotes the network card, like in other parts of VBoxManage.
    
To remove this forwarding rule again, use the following command:

.. sourcecode:: bash

    VBoxManage modifyvm "VM name" --natpf1 delete "guestssh"

    If for some reason the guest uses a static assigned IP address not leased from the built-in DHCP server, it is required to specify the guest IP when registering the forwarding rule:

That last part sounds like us.  VirtualBox issues our ip address, it seems to be unchanging.  

Todo:  How to check that it is static?

The first version I tried (from the command line in OS X) was

.. sourcecode:: bash

    VBoxManage modifyvm Ubuntu --natpf1 "guestssh,tcp,,2222,,22"

and it didn't work.  I get an error:

.. sourcecode:: bash

    > VBoxManage modifyvm Ubuntu --natpf1 delete "guestssh"
    VBoxManage: error: The machine 'Ubuntu' is already locked for a session (or being unlocked)
    VBoxManage: error: Details: code VBOX_E_INVALID_OBJECT_STATE (0x80bb0007), component Machine, interface IMachine, callee nsISupports
    VBoxManage: error: Context: "LockMachine(a->session, LockType_Write)" at line 471 of file VBoxManageModifyVM.cpp
    >
    
To run the command ``VBoxManage modifyvm`` I need to power down Ubuntu

Try again:

.. sourcecode:: bash

    VBoxManage modifyvm Ubuntu --natpf1 "guestssh,tcp,,2222,,22"

Power up Ubuntu.

.. sourcecode:: bash

    > ssh te@127.0.0.1
    Password:
    Password:

    [1]+  Stopped                 ssh te@127.0.0.1
    >

It won't take my Ubuntu password.  But there is also another problem.

Power down Ubuntu.

Delete what we've done:

.. sourcecode:: bash

    VBoxManage modifyvm Ubuntu --natpf1 delete "guestssh"

According to the reference, I need to provide the static ip address:

.. sourcecode:: bash

    > VBoxManage modifyvm Ubuntu --natpf1 "guestssh,tcp,,2222,10.0.2.15,22"

Now, let's try again.

Power up Ubuntu.

.. sourcecode:: bash

    > ssh te@127.0.0.1
    The authenticity of host '127.0.0.1 (127.0.0.1)' can't be established.
    RSA key fingerprint is 66:9d:5e:28:32:60:65:ec:99:77:09:87:73:f4:4b:c7.
    Are you sure you want to continue connecting (yes/no)? y
    Please type 'yes' or 'no': yes
    Warning: Permanently added '127.0.0.1' (RSA) to the list of known hosts.
    Password:
    Password:
    Password:
    Permission denied (publickey,keyboard-interactive).
    >

Nope.  Neither the Ubuntu password nor the private key pw.  What is that about publickey?  

What password could this be?


And then I found the magic sauce!

http://stackoverflow.com/questions/5906441/how-to-ssh-to-a-virtualbox-guest-externally-through-a-host

We need to specify the port for the login.

**************************
Successful Login from OS X
**************************

From OS X:

.. sourcecode:: bash

    > ssh -p 2222 te@127.0.0.1
    The authenticity of host '[127.0.0.1]:2222 ([127.0.0.1]:2222)' can't be established.
    RSA key fingerprint is 78:22:84:af:98:d4:89:c8:1b:b1:ca:d6:a6:35:a5:b1.
    Are you sure you want to continue connecting (yes/no)? y
    Please type 'yes' or 'no': yes
    Warning: Permanently added '[127.0.0.1]:2222' (RSA) to the list of known hosts.
    Password: 
    Welcome to Ubuntu 14.04.2 LTS (GNU/Linux 3.16.0-30-generic x86_64)

     * Documentation:  https://help.ubuntu.com/

    Last login: Sat Mar  7 17:11:44 2015 from 10.0.2.15
    te@te-VB:~$
    
That's my Ubuntu password.
    
The second time through I got:

.. sourcecode:: bash

    > ssh -p 2222 te@127.0.0.1
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
    Someone could be eavesdropping on you right now (man-in-the-middle attack)!
    It is also possible that a host key has just been changed.
    The fingerprint for the RSA key sent by the remote host is
    e8:90:d6:1f:68:d1:0f:f1:1f:4b:88:a7:7a:8c:aa:17.
    Please contact your system administrator.
    Add correct host key in /Users/telliott_admin/.ssh/known_hosts to get rid of this message.
    Offending RSA key in /Users/telliott_admin/.ssh/known_hosts:7
    RSA host key for [127.0.0.1]:2222 has changed and you have requested strict checking.
    Host key verification failed.
    >
    
I needed to remove the old key from ``/Users/telliott_admin/.ssh/known_hosts``.  Another job for ``nano``.

A repeat login gives just:

.. sourcecode:: bash

    > ssh -p 2222 te@127.0.0.1
    Password: 
    Welcome to Ubuntu 14.04.2 LTS (GNU/Linux 3.16.0-30-generic x86_64)

     * Documentation:  https://help.ubuntu.com/

    Last login: Sat Mar  7 20:29:19 2015 from 10.0.2.2
    te@te-VB:~$
    
And we're in!!!

Now what we need to do is to change the authentication so that Ubuntu accepts a key rather than have us type in a password.

Which key is this?  The server provided:

* ``e8:90:d6:1f:68:d1:0f:f1:1f:4b:88:a7:7a:8c:aa:17``

.. sourcecode:: bash

    te@te-vb:~$ ssh-keygen -l -f /etc/ssh/ssh_host_dsa_key
    1024 a2:59:a2:9f:a1:63:b0:69:58:8a:87:d4:bc:aa:09:63  root@te-vb (DSA)
    te@te-vb:~$ ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key
    256 b0:7e:5c:45:3b:e2:72:fd:f2:37:fe:d9:51:02:a2:4c  root@te-vb (ECDSA)
    te@te-vb:~$ ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key
    2048 e8:90:d6:1f:68:d1:0f:f1:1f:4b:88:a7:7a:8c:aa:17  root@te-vb (RSA)
    te@te-vb:~$

So it looks like we received the ``ssh_host_rsa_key``.

Password login is a security risk.  Better to use an SSH key pair.  We'll do that in another chapter.






