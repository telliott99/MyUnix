.. _server7:

#####
nginx
#####

Another popular server that people are using, at least on Linux systems, is *nginx*.

http://nginx.org/en/

Here is an overview to compare Apache and nginx:

https://www.digitalocean.com/community/tutorials/apache-vs-nginx-practical-considerations

I've been wanting to try nginx, so that's what we are going to do.  But before doing anything, we should (use the VirtualBox window to) return the Ubuntu system to a state Apache was installed:  I chose ``server2``.  Then:

.. sourcecode:: bash

    te@tom-vb:~$ sudo service apache restart
    [sudo] password for te: 
    apache: unrecognized service
    te@tom-vb:~$

We'll follow notes from here

https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-14-04-lts

.. sourcecode:: bash

    sudo apt-get update
    sudo apt-get install curl
    sudo apt-get install nginx
    
.. sourcecode:: bash

    te@tom-vb:~$ nc 127.0.0.1 8080 < /dev/null; echo $?
    1
    te@tom-vb:~$ nc 127.0.0.1 80 < /dev/null; echo $?
    1
    te@tom-vb:~$

``1`` is an "error" in Unix;  here it means the port is not open;  while ``0`` means it *is* open.  (or ``nc -zv ip port``).

Following the notes, they suggest

.. sourcecode:: bash

    te@tom-vb:~$ ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
    10.0.2.15
    fe80::a00:27ff:fe83:d25f
    te@tom-vb:~$

10.0.2.15 is the ip address that Ubuntu has received from VB.

.. sourcecode:: bash

    te@tom-vb:~$ curl http://icanhazip.com
    98.236.xx.xxx
    te@tom-vb:~$

98.236.xx.xxx is my Comcast ip address.

I know we had another way of getting the ip address but I can't remember what it was.  Use ``grep`` with the ``-r`` (recursive) flag and also -C (context):

.. sourcecode:: bash

    > grep -r -C 2 "10.0.2.15" MyUnix | head -n 10
    Binary file MyUnix/_build/doctrees/server3.doctree matches
    MyUnix/_build/html/_sources/server3.txt-    te@te-VB:~$ ifconfig
    MyUnix/_build/html/_sources/server3.txt-    eth0      Link encap:Ethernet  HWaddr 08:00:27:36:39:4a  
    MyUnix/_build/html/_sources/server3.txt:              inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
    MyUnix/_build/html/_sources/server3.txt-              inet6 addr: fe80::a00:27ff:fe36:394a/64 Scope:Link
    MyUnix/_build/html/_sources/server3.txt-              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
    --
    --
    MyUnix/_build/html/_sources/server3.txt-    te@te-VB:~$ 
    MyUnix/_build/html/_sources/server3.txt-
    >

Right, it was ``ifconfig``:

.. sourcecode:: bash

    te@tom-vb:~$ ifconfig
    eth0      Link encap:Ethernet  HWaddr 08:00:27:83:d2:5f  
              inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
              inet6 addr: fe80::a00:27ff:fe83:d25f/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:118141 errors:0 dropped:0 overruns:0 frame:0
              TX packets:51711 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:104477739 (104.4 MB)  TX bytes:9255713 (9.2 MB)
    ..

Virtual box has a utility called ``VBoxManage`` which sets up NAT.  Our examples from before used port 8080.  The reason for this is that Unix does not allow ports below a certain value to be reassigned (I believe that value is 1024).

To use the utility, Ubuntu must be powered off.

We already have a rule defined (from previous fooling about), so first we must delete it.

.. sourcecode:: bash

    VBoxManage modifyvm Ubuntu --natpf1 delete "server"
    VBoxManage modifyvm Ubuntu --natpf1 "server,tcp,127.0.0.1,8080,,8080"


.. sourcecode:: bash

***************
Configure nginx
***************

So again, following

https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-14-04-lts

We want to set up a domain name (like ``localhost`` == ``127.0.0.1``).  Actually, two of them, then we can configure them differently.  Since we are just fooling about here, I will set both of the names they use ``example.com`` and ``test.com`` as ``127.0.0.1``.

I need to find the appropriate file.  From ``/etc``:

.. sourcecode:: bash

    te@tom-vb:/etc$ ls -al host*
    -rw-r--r-- 1 root root  92 Feb 19  2014 host.conf
    -rw-r--r-- 1 root root   7 Mar  8 18:13 hostname
    -rw-r--r-- 1 root root 221 Mar  8 18:13 hosts
    -rw-r--r-- 1 root root 411 Oct 22 15:07 hosts.allow
    -rw-r--r-- 1 root root 711 Oct 22 15:07 hosts.deny
    te@tom-vb:/etc$

.. sourcecode:: bash

    te@tom-vb:/etc$ find host* | xargs cat
    # The "order" line is only used by old versions of the C library.
    order hosts,bind
    multi on
    tom-vb
    127.0.0.1	localhost
    127.0.1.1	tom-vb
    ..

And edit it with ``nano``:

.. sourcecode:: bash

    te@tom-vb:/etc$ sudo nano /etc/hosts
    
.. sourcecode:: bash

    te@tom-vb:/etc$ cat /etc/hosts
    127.0.0.1	localhost
    127.0.1.1	tom-vb
    127.0.0.1	example.com
    127.0.0.1	test.com

    # The following lines are desirable for IPv6 capable hosts
    ::1     ip6-localhost ip6-loopback
    fe00::0 ip6-localnet
    ff00::0 ip6-mcastprefix
    ff02::1 ip6-allnodes
    ff02::2 ip6-allrouters
    te@tom-vb:/etc$

This doesn't work yet, but it will later:

.. sourcecode:: bash

    te@tom-vb:/etc$ curl http://example.com
    curl: (7) Failed to connect to example.com port 80: Connection refused
    te@tom-vb:/etc$ nc 127.0.0.1 80 < /dev/null; echo $?
    1
    te@tom-vb:/etc$

According to the tutorial

.. sourcecode:: bash

    te@tom-vb:/etc$ sudo service nginx restart
     * Restarting nginx nginx                                                                                        [ OK ] 
    te@tom-vb:/etc$ sudo update-rc.d nginx defaults
    te@tom-vb:/etc$

will make sure that nginx starts on boot.  Check it.  Reboot and do:

.. sourcecode:: bash

    te@tom-vb:~$ ps aux | grep "nginx"
    root      1305  0.0  0.2  86288  3000 ?        Ss   07:51   0:00 nginx: master process /usr/sbin/nginx
    www-data  1306  0.0  0.3  86636  3532 ?        S    07:51   0:00 nginx: worker process
    www-data  1307  0.0  0.3  86636  3532 ?        S    07:51   0:00 nginx: worker process
    www-data  1308  0.0  0.3  86636  3532 ?        S    07:51   0:00 nginx: worker process
    www-data  1309  0.0  0.3  86636  3532 ?        S    07:51   0:00 nginx: worker process
    te        2379  0.0  0.2  13664  2244 pts/1    S+   07:52   0:00 grep --color=auto nginx
    te@tom-vb:~$

Looks good.

*******************
nginx document root
*******************

The default *server block* directives specify to serve documents from ``/usr/share/nginx/html``, but we want to use ``www/var`` since that is more usual.  We set up the directories:

.. sourcecode:: bash

    te@tom-vb:~$ sudo mkdir -p /var/www/example.com/html
    te@tom-vb:~$ sudo mkdir -p /var/www/test.com/html
    te@tom-vb:~$ 

The ``-p`` flag with ``mkdir`` "creates intermediate directories as required."

Make sure permissions are good:

.. sourcecode:: bash

    te@tom-vb:~$ ls -al /var/www/test.com/html /var/www/example.com/html
    /var/www/example.com/html:
    total 8
    drwxr-xr-x 2 root root 4096 Mar 10 07:59 .
    drwxr-xr-x 3 root root 4096 Mar 10 07:59 ..

    /var/www/test.com/html:
    total 8
    drwxr-xr-x 2 root root 4096 Mar 10 07:59 .
    drwxr-xr-x 3 root root 4096 Mar 10 07:59 ..
    te@tom-vb:~$

Permissions look fine (755), but I should be the owner.  They suggest  ``sudo chown -R $USER:$USER < directory >`` but it doesn't work for me.  But I don't want te for the group.

.. sourcecode:: bash

    te@tom-vb:/var/www$ ls -l
    total 8
    drwxr-xr-x  3 root root 4096 Mar 10 07:59 example.com
    drwxr-xr-x  3 root root 4096 Mar 10 07:59 test.com
    te@tom-vb:/var/www$ sudo chown -R $USER:$USER test.com
    te@tom-vb:/var/www$ ls -l
    total 8
    drwxr-xr-x  3 te   root 4096 Mar 10 07:59 example.com
    drwxr-xr-x  3 te   te   4096 Mar 10 07:59 test.com
    te@tom-vb:/var/www$ sudo chown -R $USER:adm test.com
    te@tom-vb:/var/www$ sudo chown -R $USER:adm example.com
    te@tom-vb:/var/www$ ls -l
    total 8
    drwxr-xr-x  3 te   adm  4096 Mar 10 07:59 example.com
    drwxr-xr-x  3 te   adm  4096 Mar 10 07:59 test.com
    te@tom-vb:/var/www$

Create sample pages:

.. sourcecode:: bash

    te@tom-vb:/var/www$ nano /var/www/example.com/html/index.html

.. sourcecode:: html

    <html>
        <head>
            <title>Welcome to Example.com!</title>
        </head>
        <body>
            <h1>Success!  The example.com server block is working!</h1>
        </body>
    </html>

Copy this to ``/var/www/test.com/html/index.html`` and then use ``nano`` to edit and substitute ``test``.

.. sourcecode:: html

    te@tom-vb:/var/www$ nano /var/www/example.com/html/index.html
    te@tom-vb:/var/www$ cp /var/www/example.com/html/index.html /var/www/test.com/html/index.html
    te@tom-vb:/var/www$ nano /var/www/test.com/html/index.html

*******************
Server blocks: edit
*******************

.. sourcecode:: html

    te@tom-vb:/var/www$ sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/example.com
    te@tom-vb:/var/www$ cp /etc/nginx/sites-available/example.com ~/Dropbox/Ubuntu

We can look at it in TextMate on OS X.  It has a bunch of comments, but the *server block* is:

.. sourcecode:: html

    server {
    	listen 80 default_server;
    	listen [::]:80 default_server ipv6only=on;

    	root /usr/share/nginx/html;
    	index index.html index.htm;

    	# Make site accessible from http://localhost/
    	server_name localhost;

    	location / {
    		# First attempt to serve request as file, then
    		# as directory, then fall back to displaying a 404.
    		try_files $uri $uri/ =404;
    		# Uncomment to enable naxsi on this location
    		# include /etc/nginx/naxsi.rules
    	}
    	
Only one of the servers can be the ``default_server``.  

We are asked to edit it to:

``example.com``:

.. sourcecode:: html

    server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;

        root /var/www/example.com/html;
        index index.html index.htm;

        server_name example.com www.example.com;

        location / {
            try_files $uri $uri/ =404;
        }
    }

So, just the document ``root`` is changed, and the ``server_name``.

I paste just this text into the file in Dropbox and then copy it back with ``sudo``:

.. sourcecode:: html

    sudo cp ~/Dropbox/Ubuntu/example.com /etc/nginx/sites-available/example.com

Now, for the second one.  It will have

.. sourcecode:: html

    listen 80;
    listen [::]:80;

and the document root and server_name will be changed as well.  It looks like this:

``test.com``:

.. sourcecode:: html

    server {
        listen 80;
        listen [::]:80;

        root /var/www/test.com/html;
        index index.html index.htm;

        server_name test.com www.test.com;

        location / {
            try_files $uri $uri/ =404;
        }
    }

.. sourcecode:: html

    sudo cp ~/Dropbox/Ubuntu/test.com /etc/nginx/sites-available/test.com

*********************
Server blocks: enable
*********************

.. sourcecode:: html

    te@tom-vb:/var/www$ sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
    te@tom-vb:/var/www$ sudo ln -s /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/

Disable the default server block:

.. sourcecode:: html

    te@tom-vb:/var/www$ sudo rm /etc/nginx/sites-enabled/default
    
Edit ``nginx.conf``

.. sourcecode:: html

    te@tom-vb:/var/www$ sudo nano /etc/nginx/nginx.conf

uncomment the line ``server_names_hash_bucket_size 64;`` and save, and then:

.. sourcecode:: html

    te@tom-vb:/var/www$ sudo service nginx restart
     * Restarting nginx nginx                                                                                             [ OK ] 
    te@tom-vb:/var/www$

It should work:

.. sourcecode:: html

    te@tom-vb:/var/www$ curl example.com
    <html>
        <head>
            <title>Welcome to Example.com!</title>
        </head>
        <body>
            <h1>Success!  The example.com server block is working!</h1>
        </body>
    </html>

    te@tom-vb:/var/www$ curl test.com
    <html>
        <head>
            <title>Welcome to Test.com!</title>
        </head>
        <body>
            <h1>Success!  The test.com server block is working!</h1>
        </body>
    </html>

    te@tom-vb:/var/www$

Next

https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-14-04

Oh, one more thing.  We want to reach the server from OS X.  Try editing to substitute ``8080`` for ``80``

.. sourcecode:: html

    te@tom-vb:~$ sudo nano /etc/nginx/sites-available/example.com
    
Do the edit.  Now, from OS X:

.. sourcecode:: html

    te@tom-vb:~$ sudo service nginx restart
     * Restarting nginx nginx                                                [ OK ] 
    te@tom-vb:~$

    > curl localhost:8080
    <html>
        <head>
            <title>Welcome to Example.com!</title>
        </head>
        <body>
            <h1>Success!  The example.com server block is working!</h1>
        </body>
    </html>

    >

.. image:: /figs/example.com.png
  :scale: 50 %

I try ``test.com`` and get a 404:

.. sourcecode:: html

    > curl localhost:8080/test.com
    <html>
    <head><title>404 Not Found</title></head>
    <body bgcolor="white">
    <center><h1>404 Not Found</h1></center>
    <hr><center>nginx/1.6.2 (Ubuntu)</center>
    </body>
    </html>
    > curl localhost:8080/test.com
    <html>
    <head><title>404 Not Found</title></head>
    <body bgcolor="white">
    <center><h1>404 Not Found</h1></center>
    <hr><center>nginx/1.6.2 (Ubuntu)</center>
    </body>
    </html>
    >

That's because I did not change the port yet in ``/etc/nginx/sites-available/test.com``.

And I'll leave that as an exercise for the reader.  :)

