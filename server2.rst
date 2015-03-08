.. _server2:

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

We'll be using one of these keys eventually (``ssh_host_ecdsa_key``).

I'd like to check the key fingerprint.  Where are the key files?  Somewhere, I saw the possibility:  ``/etc/ssh/ssh_host_rsa_key``.

.. sourcecode:: bash

    te@te-VB:~$ ls -al /etc/ssh
    total 300
    drwxr-xr-x   2 root root   4096 Mar  7 16:10 .
    drwxr-xr-x 128 root root  12288 Mar  7 16:10 ..
    -rw-r--r--   1 root root 242091 May 12  2014 moduli
    -rw-r--r--   1 root root   1690 May 12  2014 ssh_config
    -rw-r--r--   1 root root   2541 Mar  7 17:10 sshd_config
    -rw-------   1 root root    668 Mar  7 16:10 ssh_host_dsa_key
    -rw-r--r--   1 root root    600 Mar  7 16:10 ssh_host_dsa_key.pub
    -rw-------   1 root root    227 Mar  7 16:10 ssh_host_ecdsa_key
    -rw-r--r--   1 root root    172 Mar  7 16:10 ssh_host_ecdsa_key.pub
    -rw-------   1 root root    399 Mar  7 16:10 ssh_host_ed25519_key
    -rw-r--r--   1 root root     92 Mar  7 16:10 ssh_host_ed25519_key.pub
    -rw-------   1 root root   1675 Mar  7 16:10 ssh_host_rsa_key
    -rw-r--r--   1 root root    392 Mar  7 16:10 ssh_host_rsa_key.pub
    -rw-r--r--   1 root root    338 Mar  7 16:10 ssh_import_id
    te@te-VB:~$ ssh-keygen -l -f /etc/ssh/ssh_host_dsa_key
    1024 7d:89:10:c7:11:83:96:94:e8:68:40:73:cd:e2:30:ca  root@te-VB (DSA)
    te@te-VB:~$ ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key
    256 fb:60:fa:77:cb:07:1e:8c:19:b5:59:a8:50:0f:be:10  root@te-VB (ECDSA)
    te@te-VB:~$

As it turns out, the key we'll use is the ``ecdsa`` key, and its fingerprint is:

.. sourcecode:: bash

    fb:60:fa:77:cb:07:1e:8c:19:b5:59:a8:50:0f:be:10

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

We need to edit ``/etc/ssh/sshd_config`` (I should have saved a copy of the original, but I forgot!)

For reference here is the whole file as I have it now.

.. sourcecode:: bash

    te@te-VB:~$ cat /etc/ssh/sshd_config
    # Package generated configuration file
    # See the sshd_config(5) manpage for details

    # What ports, IPs and protocols we listen for
    Port 22
    # Use these options to restrict which interfaces/protocols sshd will bind to
    #ListenAddress ::
    #ListenAddress 0.0.0.0
    Protocol 2
    # HostKeys for protocol version 2
    HostKey /etc/ssh/ssh_host_rsa_key
    HostKey /etc/ssh/ssh_host_dsa_key
    HostKey /etc/ssh/ssh_host_ecdsa_key
    HostKey /etc/ssh/ssh_host_ed25519_key
    #Privilege Separation is turned on for security
    UsePrivilegeSeparation yes

    # Lifetime and size of ephemeral version 1 server key
    KeyRegenerationInterval 3600
    ServerKeyBits 1024

    # Logging
    SyslogFacility AUTH
    LogLevel INFO

    # Authentication:
    LoginGraceTime 120
    PermitRootLogin without-password
    StrictModes yes

    RSAAuthentication yes
    PubkeyAuthentication yes
    #AuthorizedKeysFile	%h/.ssh/authorized_keys

    # Don't read the user's ~/.rhosts and ~/.shosts files
    IgnoreRhosts yes
    # For this to work you will also need host keys in /etc/ssh_known_hosts
    RhostsRSAAuthentication no
    # similar for protocol version 2
    HostbasedAuthentication no
    # Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication
    #IgnoreUserKnownHosts yes

    # To enable empty passwords, change to yes (NOT RECOMMENDED)
    PermitEmptyPasswords no

    # Change to yes to enable challenge-response passwords (beware issues with
    # some PAM modules and threads)
    ChallengeResponseAuthentication yes

    # Change to no to disable tunnelled clear text passwords
    PasswordAuthentication yes

    # Kerberos options
    #KerberosAuthentication no
    #KerberosGetAFSToken no
    #KerberosOrLocalPasswd yes
    #KerberosTicketCleanup yes

    # GSSAPI options
    #GSSAPIAuthentication no
    #GSSAPICleanupCredentials yes

    X11Forwarding yes
    X11DisplayOffset 10
    PrintMotd no
    PrintLastLog yes
    TCPKeepAlive yes
    #UseLogin no

    #MaxStartups 10:30:60
    #Banner /etc/issue.net

    # Allow client to pass locale environment variables
    AcceptEnv LANG LC_*

    Subsystem sftp /usr/lib/openssh/sftp-server

    # Set this to 'yes' to enable PAM authentication, account processing,
    # and session processing. If this is enabled, PAM authentication will
    # be allowed through the ChallengeResponseAuthentication and
    # PasswordAuthentication.  Depending on your PAM configuration,
    # PAM authentication via ChallengeResponseAuthentication may bypass
    # the setting of "PermitRootLogin without-password".
    # If you just want the PAM account and session checks to run without
    # PAM authentication, then enable this but set PasswordAuthentication
    # and ChallengeResponseAuthentication to 'no'.
    UsePAM yes
    te@te-VB:~$ 
    

The server will listen on port 22.

According to the guide, we should do this:  uncomment

.. sourcecode:: bash

    PermitRootLogin no
    ChallengeResponseAuthentication yes
    PasswordAuthentication yes   # we'll set it to no eventually

I left the RootLogin as it is for the moment.  I'll come back to this.

At this point in my previous work I did  ``sudo /etc/init.d/ssh restart`` but I am following other notes now and I did something else

.. sourcecode:: bash

    sudo service ssh restart
    
*****************
Login from Ubuntu
*****************

Now, let's try  to connect to ``10.0.2.15`` on port 22

I use my Ubuntu password:

.. sourcecode:: bash

    te@te-VB:~$ ssh te@10.0.2.15
    ssh: connect to host 10.0.2.15 port 22: Connection refused
    te@te-VB:~$ sudo service ssh restart
    ssh stop/waiting
    ssh start/running, process 3127
    te@te-VB:~$ ssh te@10.0.2.15
    The authenticity of host '10.0.2.15 (10.0.2.15)' can't be established.
    ECDSA key fingerprint is fb:60:fa:77:cb:07:1e:8c:19:b5:59:a8:50:0f:be:10.
    Are you sure you want to continue connecting (yes/no)? y
    Please type 'yes' or 'no': yes
    Warning: Permanently added '10.0.2.15' (ECDSA) to the list of known hosts.
    Password: 
    Welcome to Ubuntu 14.04.2 LTS (GNU/Linux 3.16.0-30-generic x86_64)

     * Documentation:  https://help.ubuntu.com/


    The programs included with the Ubuntu system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
    applicable law.

    te@te-VB:~$

Looks like login works.  We needed the restart, and we are on.  Check the fingerprint.

* keyfile:  ``fb:60:fa:77:cb:07:1e:8c:19:b5:59:a8:50:0f:be:10``
* server:   ``fb:60:fa:77:cb:07:1e:8c:19:b5:59:a8:50:0f:be:10``

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

It won't take my Ubuntu password.  But there is another problem.

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

A repeat login gives:

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

* ``78:22:84:af:98:d4:89:c8:1b:b1:ca:d6:a6:35:a5:b1``

.. sourcecode:: bash

    te@te-VB:~$ ssh-keygen -l -f /etc/ssh/ssh_host_dsa_key
    1024 7d:89:10:c7:11:83:96:94:e8:68:40:73:cd:e2:30:ca  root@te-VB (DSA)
    te@te-VB:~$ ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key
    256 fb:60:fa:77:cb:07:1e:8c:19:b5:59:a8:50:0f:be:10  root@te-VB (ECDSA)
    te@te-VB:~$ ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key
    2048 78:22:84:af:98:d4:89:c8:1b:b1:ca:d6:a6:35:a5:b1  root@te-VB (RSA)
    te@te-VB:~$

So we received the ``ssh_host_rsa_key``.

Password login is a security risk.  Better to use an SSH key pair.  We'll do that in another chapter.






