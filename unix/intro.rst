.. _intro:

############
Introduction
############

Starting with this chapter, we are going to learn about Unix and more specifically about the BASH shell, and the command line.  Here is an extended quote from the *bash Cookbook*:

    The Unix operating system popularized the notion of separating the *shell* (the part of the system that lets you type commands) from everything else:  the input/output system, the scheduler, memory management..  The shell was just one more program;  it was a program whose job was executing other programs on behalf of users.
    
    Modern shells are very convenient.  For example, they remember commands that you've typed, and let you re-use those commands.  Modern shells also let you edit those commands.. define your own command abbreviations, shortcuts and other features.  For an experienced user, typing commands (e.g with shorthand, shortcuts, command completion) is a lot more efficient and effective than dragging things around in a fancy windowed interface.
    
    Beyond simple convenience, shells are programmable.  There are many sequences of commands that you type again and again.  **Whenever you do anything a second time, you should ask "Can't I write a program to do this for me?"**  You can. [emphasis added]

For more material on Unix and the command line see :download:`resources.html </_static/unix_resources.html>`

**To begin at the beginning**

When you first run the Terminal application, or obtain a command line environment, you will be greeted with a prompt.  I like mine as simple as possible, so I have modified my shell to show only this:

.. sourcecode:: bash

    > 

This is called the command prompt.  When you see the command prompt, the shell is ready and awaits your input.  You can even do nothing if you want, by pressing RET (return or enter):

.. sourcecode:: bash

    > 
    >
    >

On OS X, yours will look something like this:

.. sourcecode:: bash

    ComputerName:Current_directory Username$ 

I will show you how to customize your prompt later.  For now, I just wanted to explain why what you are seeing is probably be different, since you should be following along at home trying everything I do, yourself.

In the next chapter we will start navigating from the command line.