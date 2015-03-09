.. _server6:

#################################
Network Address Translation (NAT)
#################################

In the previous chapter, we got a php and a Python script running on Apache in Ubuntu.  The tests we did involved using ``curl`` and Firefox *from Ubuntu*.  

If we test, we cannot reach the server from the OS X host.  Be sure to power up Ubuntu first  :)

From OS X:

.. sourcecode:: bash

    > curl localhost
    curl: (7) Failed to connect to localhost port 80: Connection refused
    >

Another good test is ``nc`` (netcat):

.. sourcecode:: bash

    > nc 127.0.0.1 80 < /dev/null; echo $?
    1
    >

From Ubuntu:

    te@tom-vb:~$ nc 127.0.0.1 80 < /dev/null;  echo $?
    0
    te@tom-vb:~$ nc 127.0.0.1 8080 < /dev/null;  echo $?
    1
    te@tom-vb:~$

So 80 is open, but only from Ubuntu, and 8080 is not open for either.

``1`` is an "error" in Unix;  here it means the port is not open;  while ``0`` means it *is* open.  (or ``nc -zv ip port``).

To get this to work from OS X, we need to get VirtualBox to forward our requests to the virtual machine.

Virtual box has a utility called ``VBoxManage`` which sets up NAT.  Our examples from before used port 8080.  The reason for this is that Unix does not allow ports below a certain value to be reassigned (I believe that value is 1000).

Recall that our server is set up to listen on port 80 (standard).  Is this command enough to get the VirtualBox to route us to the server?

To use the utility, Ubuntu must be powered off.

We already have a rule defined (from previous fooling about), so first we must delete it.

.. sourcecode:: bash

    VBoxManage modifyvm Ubuntu --natpf1 delete "server"
    VBoxManage modifyvm Ubuntu --natpf1 "server,tcp,127.0.0.1,80,,80"

``curl localhost`` doesn't work.  Since we used port 8080 before, I am going to set that up now.

.. sourcecode:: bash

    > VBoxManage modifyvm Ubuntu --natpf1 delete "server"
    > VBoxManage modifyvm Ubuntu --natpf1 "server,tcp,127.0.0.1,8080,,8080"

I was curious about what rules VirtualBox currently has set:

.. image:: /figs/VBnetwork1.png
  :scale: 50 %

.. image:: /figs/VBnetwork2.png
  :scale: 50 %
 
This is not enough to make it work from OS X:

.. sourcecode:: bash

    > nc 127.0.0.1 80 < /dev/null; echo $?
    1
    >

##################
Apache:  Port 8080
##################

Above, we tested port 8080 from Ubuntu and it is not open.

According to my notes, I need to do two things:

.. note::

    todo #1

For configuration files, there are 5 of them in ``conf-enabled``.  These are

.. sourcecode:: bash

    charset.conf
    localized-error-pages.conf
    other-vhosts-access-log.conf
    security.conf
    serve-cgi-bin.conf

For sites files, there is one of them in ``sites-enabled``:  `000-default.conf``.  But remember, we will edit the file in ``sites-available`` and the sym link from ``sites-enabled`` will pick it up.

* ``sudo cp /etc/apache2/sites-available/000-default.conf ~/Dropbox/Ubuntu``
 
File ``000-default.conf`` :

.. sourcecode:: bash

    <VirtualHost *:80>
    	# The ServerName directive sets the request scheme, hostname and port that
    	# the server uses to identify itself. This is used when creating
    	# redirection URLs. In the context of virtual hosts, the ServerName
    	# specifies what hostname must appear in the request's Host: header to
    	# match this virtual host. For the default virtual host (this file) this
    	# value is not decisive as it is used as a last resort host regardless.
    	# However, you must set it for any further virtual host explicitly.
    	#ServerName www.example.com

    	ServerAdmin webmaster@localhost
    	DocumentRoot /var/www/html

    	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
    	# error, crit, alert, emerg.
    	# It is also possible to configure the loglevel for particular
    	# modules, e.g.
    	#LogLevel info ssl:warn

    	ErrorLog ${APACHE_LOG_DIR}/error.log
    	CustomLog ${APACHE_LOG_DIR}/access.log combined

    	# For most configuration files from conf-available/, which are
    	# enabled or disabled at a global level, it is possible to
    	# include a line for only one particular virtual host. For example the
    	# following line enables the CGI configuration for this host only
    	# after it has been globally disabled with "a2disconf".
    	#Include conf-available/serve-cgi-bin.conf
    </VirtualHost>

What we do is to duplicate the whole text, and change the second half to ``<VirtualHost *:8080>``

* ``sudo cp ~/Dropbox/Ubuntu/000-default.conf /etc/apache2/sites-available``

.. note::

    todo #2

File ``ports.conf`` at top-level.  Here is the modified file:

.. sourcecode:: bash

    # If you just change the port or add more ports here, you will likely also
    # have to change the VirtualHost statement in
    # /etc/apache2/sites-enabled/000-default.conf

    Listen 80

    <IfModule ssl_module>
    	Listen 443
    </IfModule>

    <IfModule mod_gnutls.c>
    	Listen 443
    </IfModule>

    Listen 8080
    NameVirtualHost *:8080

    # vim: syntax=apache ts=4 sw=4 sts=4 sr noet

* ``sudo cp /etc/apache2/ports.conf ~/Dropbox/Ubuntu``
* edit to add the directive ``Listen 8080;  NameVirtualHost *:8080``
* ``sudo cp ~/Dropbox/Ubuntu/ports.conf /etc/apache2``

Restart the server and test from Ubuntu:

.. sourcecode:: bash

    te@tom-vb:/etc/apache2$ sudo apachectl restart
    ..
    te@tom-vb:/etc/apache2$ nc localhost 80 < /dev/null;  echo $?
    0
    te@tom-vb:/etc/apache2$ nc localhost 8080 < /dev/null;  echo $?
    0
    te@tom-vb:/etc/apache2$

.. image:: /figs/ubuntu_apache.png
  :scale: 50 %

That looks like success to me.

Now to try from OS X:

.. sourcecode:: bash

    > nc 127.0.0.1 8080 < /dev/null; echo $?
    0
    >
    > curl 127.0.0.1:8080/cgi-bin/script.py

    Hello, world!
    >

.. image:: /figs/OS_X_apache.png
  :scale: 50 %

And it's working on OS X as well!

####################
Apache:  ScriptAlias
####################

One last thing we could do is to change the directory where we put scripts.  The default is ``/usr/lib/cgi-bin``, and it's working fine.

If we wanted to do this, we would need the change the ``ScriptAlias`` directive which is currently like this:

.. sourcecode:: bash

    ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/

and substitute the new directory.  The setting is in ``conf-available/serve-cgi-bin.conf``.

.. sourcecode:: bash

    te@tom-vb:/etc/apache2$ cat ./conf-available/serve-cgi-bin.conf | grep "ScriptAlias"
    		ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
    te@tom-vb:/etc/apache2$

It looks like this:

.. sourcecode:: bash

    <IfDefine ENABLE_USR_LIB_CGI_BIN>
    	ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
    	<Directory "/usr/lib/cgi-bin">
    		AllowOverride None
    		Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
    		Require all granted
    	</Directory>
    </IfDefine>

But I think I'm happy with the way things are.







