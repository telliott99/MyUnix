.. _process:

###################
Unix processes (ps)
###################

Finding and killing a process

The ``ps`` command by itself yields information about the shell itself::

    > ps
      PID TTY           TIME CMD
      809 ttys000    0:00.01 -bash
    >

A number of the flags for ``ps`` select different processes to display:

* ``-A`` other peoples' process
* ``-a`` others' plus mine
* ``-G`` processes for group G
* ``-g`` processes for group "leader" g (not sure about this)
* ``-p`` process ID
* ``-T`` standard input
* ``-t`` terminal device
* ``-U`` user ID
* ``-u`` username

These flags may be combined and the processes will be combined too.  

Processes can also be sorted (default criterion is process ID), using

* ``-m`` memory usage
* ``-r`` cpu usage

* ``-o`` select info for display
* ``-v`` certain info for display


**ps aux**

* a = show processes for all users
* u = display the process's user/owner
* x = also show processes not attached to a terminal

Example::

    > ps aux -r | head -n 4
    USER              PID  %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
    telliott_admin    890   1.3  0.6  3678932  46272   ??  S     4:14PM   0:02.45 /Applications/Safari.app/Contents/MacOS/Safari
    _windowserver     117   1.1  0.7  3614568  58988   ??  Ss    1:52PM   2:08.38 /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreGraphics.framework/Resources/WindowServer -daemon
    telliott_admin    806   1.0  0.4  2581004  33304   ??  R     3:59PM   0:09.72 /Applications/Utilities/Terminal.app/Contents/MacOS/Terminal
    > 

**user**

Example::

    > ps -f -u `whoami` | head -n 5
      UID   PID  PPID   C STIME   TTY           TIME CMD
      501   200     1   0  1:52PM ??         0:00.84 /usr/libexec/UserEventAgent (Aqua)
      501   202     1   0  1:52PM ??         0:01.65 /usr/sbin/distnoted agent
      501   204     1   0  1:52PM ??         0:01.50 /usr/sbin/cfprefsd agent
      501   207     1   0  1:52PM ??         0:12.42 /System/Library/CoreServices/Dock.app/Contents/MacOS/Dock
    > 

**name or pid**

Example::

    > ps aux | grep "bash" 
    telliott_admin    809   0.0  0.0  2461020   1316 s000  S     3:59PM   0:00.04 -bash
    telliott_admin    950   0.0  0.0  2441988    652 s000  R+    4:20PM   0:00.00 grep bash
    > ps -C 809
      PID TTY           TIME CMD
      809 ttys000    0:00.05 -bash
    >

[ Lots more to say ]

Reference:

http://www.binarytides.com/linux-ps-command/
