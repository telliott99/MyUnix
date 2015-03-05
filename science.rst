.. _science:

##############################
Scientific Programming in Unix
##############################

Here is a quick look at some examples of using scientific software from the command line.  ``FastTree`` is a phylogenetic tree program that we compiled previously and have in the ``~/bin`` directory.  ``muscle`` is an alignment program by R. Edgar that we will download from his website.  ``PyCogent`` is a suite of programs for phylogenetics and sequence analysis from Rob Knight and Gavin Huttley's labs.  We will download, build and install PyCogent in the virtual environment that we set up in a previous chapter.

**PyCogent, muscle and FastTree**

The website for Pycogent is:

http://pycogent.org

The instructions for installation are here:

http://pycogent.org/install.html

According to that site the only prerequisites that we need are 

* ``cogent-requirements.txt``

    cogent
    numpy>=1.3.0
    
and they suggest we use ``pip``:

* DONT_USE_PYREX=1 sudo pip install -r path/to/cogent-requirements.txt

However, we will not use ``sudo`` nor ``pip``.  Instead we will use ``virtualenv`` and our Homebrew Python, downloading, building and installing the software the old-fashioned way.

Normally, we'd be installing into ``/Library/Python/site-packages`` and would do ``sudo`` for the install step but we are using instead our virtualenv.  So we don't need ``sudo``.  Here goes:

.. sourcecode:: bash

    > cd mpl2
    > source bin/activate
    (mpl2)> ls
    bin			lib
    example.png		man
    include			pip-selfcheck.json
    (mpl2)> git clone git://github.com/pycogent/pycogent.git
    Cloning into 'pycogent'...
    remote: Counting objects: 22261, done.
    ..
    (mpl2)> python setup.py build
    ..
    (mpl2)> python setup.py install
    ..
    running install_egg_info
    Writing /Users/telliott_admin/mpl2/lib/python2.7/site-packages/cogent-1.5.3_dev-py2.7.egg-info
    (mpl2)> python
    Python 2.7.9 (default, Feb 10 2015, 03:28:08) 
    [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.56)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import cogent
    >>> 
    [1]+  Stopped                 python
    (mpl2)> 
    
Looks good.  Let's go get some sequences.  Start with a file with sequence names and ids:

.. sourcecode:: bash

    AF411020  Ax1  Achromobacter xylosoxidans AU1011
    EU373389  Ax2  Achromobacter xylosoxidans TPL14
    AJ278451  Ax3  Achromobacter xylosoxidans denitrificans
    AF411019  Ax4  Achromobacter xylosoxidans AU0665
    DQ450530  Aa1  Alcaligenaceae bacterium LBM
    AJ002809  Aa2  Alcaligenes sp.

These are 16S ribosomal RNA gene sequences from some closely related bacterial strains.

There are only six of them.  Easy enough to do it "by hand" in Python interpreter (I just type in the Genbank ids):

.. sourcecode:: bash

    (mpl2)> python
    Python 2.7.9 (default, Feb 10 2015, 03:28:08) 
    [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.56)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.

>>> import cogent
>>> from cogent.db.ncbi import EFetch
>>> seqL = ['AF411020','EU373389','AJ278451',
...         'AF411019','DQ450530','AJ002809']
>>> FH = open('/Users/telliott_admin/Desktop/seqs.txt','w')
>>> for seq in seqL:
...     ef = EFetch(id=seq)
...     FH.write(ef.read() + '\n')
... 
>>> FH.close()

And now we have

``seqs.txt``:

.. sourcecode:: bash

    >gi|15384334|gb|AF411020.1| Achromobacter xylosoxidans .. ribosomal RNA ..
    AGTTTGATCCTGGCTCAGATTGAACGCTAGCGGGATGCCTTACACATGCAAGTCGAACGGCAGCACGGAC
    ..

Next we need to make an alignment.  For that, we'll use R. Edgar's ``muscle``.  We will get it from here:

http://www.drive5.com

I thought I would just use Homebrew, but it's in a *tap*.  I haven't done that so many times yet.  So just go to the website and download it.  The 64-bit version for OS X is

* ``muscle3.8.31_i86darwin64``

I put the binary app itself into ``~/bin``.

And I put a symbolic link into ``~/mpl2/```.  The usage is ``ln src target``, where ``src`` is the original binary (of course I can never remember).  Just to check, I try it on the Desktop first:

.. sourcecode:: bash

    > pwd
    /Users/telliott_admin/Desktop
    > ln -s ~/bin/muscle3.8.31_i86darwin64 muscle
    > ./muscle

    MUSCLE v3.8.31 by Robert C. Edgar
    ..

Looks good.  Now we make the link I really want.   This directory is on my ``$PATH`` (see ``echo $PATH``).  So from the Desktop:

.. sourcecode:: bash

    > ln -s ~/bin/muscle3.8.31_i86darwin64 ~/bin/muscle
    > muscle

    MUSCLE v3.8.31 by Robert C. Edgar

    http://www.drive5.com/muscle
    This software is donated to the public domain.
    Please cite: Edgar, R.C. Nucleic Acids Res 32(5), 1792-97.


    Basic usage

        muscle -in <inputfile> -out <outputfile>
    ..

and

.. sourcecode:: bash

    > muscle -in seqs.txt -out seqs.aln

    MUSCLE v3.8.31 by Robert C. Edgar

    http://www.drive5.com/muscle
    This software is donated to the public domain.
    Please cite: Edgar, R.C. Nucleic Acids Res 32(5), 1792-97.

    seqs 6 seqs, max length 1523, avg  length 1498
    00:00:00      1 MB(0%)  Iter   1  100.00%  K-mer dist pass 1
    00:00:00      1 MB(0%)  Iter   1  100.00%  K-mer dist pass 2
    00:00:00     10 MB(0%)  Iter   1  100.00%  Align node       
    00:00:00     10 MB(0%)  Iter   1  100.00%  Root alignment
    00:00:00     10 MB(0%)  Iter   2  100.00%  Root alignment
    00:00:01     12 MB(0%)  Iter   3  100.00%  Refine biparts
    >

Looks good.  Here is part of ``seqs.aln``:

.. sourcecode:: bash

    >AJ002809.1
    ------------------------ATTGAACGCTAGCGGGATGCCTTACACATGCAAGTC
    ..


    >gi|2832590|emb|AJ002809.1| Alcaligenes sp. 16S rRNA gene, isolate R6
    ------------------------ATTGAACGCTAGCGGGATGCCTTACACATGCAAGTC
    

And I realize that there could be a problem with the very long title lines from Genbank.  Since there are only six titles, at this point, I fix them "by hand" as well, and redo the alignment---it doesn't take long.  Here is ``seqs.aln`` again:

Now it's time for FastTree (also in ``~/bin``):

.. sourcecode:: bash

    > FastTree -nt seqs.aln > seqs.tr
    FastTree Version 2.1.7 No SSE3
    Alignment: seqs.aln
    Nucleotide distances: Jukes-Cantor Joins: balanced Support: SH-like 1000
    Search: Normal +NNI +SPR (2 rounds range 10) +ML-NNI opt-each=1
    TopHits: 1.00*sqrtN close=default refresh=0.80
    ML Model: Jukes-Cantor, CAT approximation with 20 rate categories
    Ignored unknown character K (seen 1 times)
    Ignored unknown character R (seen 3 times)
    Ignored unknown character X (seen 3 times)
    Initial topology in 0.00 seconds
    Refining topology: 10 rounds ME-NNIs, 2 rounds ME-SPRs, 5 rounds ML-NNIs
    Total branch-length 0.017 after 0.01 sec
    ML-NNI round 1: LogLk = -2346.097 NNIs 0 max delta 0.00 Time 0.03
    Switched to using 20 rate categories (CAT approximation)
    Rate categories were divided by 0.628 so that average rate = 1.0
    CAT-based log-likelihoods may not be comparable across runs
    Use -gamma for approximate but comparable Gamma(20) log-likelihoods
    ML-NNI round 2: LogLk = -2334.291 NNIs 0 max delta 0.00 Time 0.04
    Turning off heuristics for final round of ML NNIs (converged)
    ML-NNI round 3: LogLk = -2334.291 NNIs 0 max delta 0.00 Time 0.05 (final)
    Optimize all lengths: LogLk = -2334.291 Time 0.05
    Total time: 0.09 seconds Unique: 6/6 Bad splits: 0/3
    >
    
There is a lot to ponder there, but no time.

The tree is in ``seqs.tr``:

.. sourcecode:: bash

    (AF411020.1:0.00067,AF411019.1:0.00055,
    ((AJ002809.1:0.00608,EU373389.1:0.00054)
    0.931:0.00256,(AJ278451.1:0.00398,DQ450530.1:0.00261)
    0.949:0.00342)0.799:0.00067);

Now we could use a fancy plotter for this, but let's go back to PyCogent:

.. sourcecode:: bash

        > cd
        > cd mpl2
        > source bin/activate
        (mpl2)> python
        Python 2.7.9 (default, Feb 10 2015, 03:28:08) 
        [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.56)] on darwin
        Type "help", "copyright", "credits" or "license" for more information.

>>> from cogent import LoadTRee
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ImportError: cannot import name LoadTRee
>>> from cogent import LoadTree
>>> tr = LoadTree('/Users/telliott_admin/Desktop/seqs.tr')
>>> print tr.asciiArt()
          /-AF411020.1
         |
         |--AF411019.1
-root----|
         |                    /-AJ002809.1
         |          /0.931---|
         |         |          \-EU373389.1
          \0.799---|
                   |          /-AJ278451.1
                    \0.949---|
                              \-DQ450530.1


That's a good example of running scientific software from the command line.  There are many more examples in my Python book.

https://github.com/telliott99/PyBioinformatics
