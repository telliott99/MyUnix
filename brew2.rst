.. _brew2:

###################
More about Homebrew
###################

**Homebrew:  kegs**

Here is a good page about Homebrew:

http://dghubble.com/blog/posts/homebrew-os-x-package-management/

Homebrew packages are called **kegs**.  All kegs are installed isolated from one another inside their own auto-created directories in **Cellar** ``/usr/local/Cellar``. 

Homebrew places symbolic links to package executables inside a bin directory ``/usr/local/bin``.  The package definition is called a formula and the standard ones are in ``usr/local/Library/Formula/`` as ``usr/local/Library/Formula/foo.rb``.  Technically, a key is something like ``/usr/local/Cellar/foo/0.1``.

A Homebrew **Bottle** is a pre-built binary Key that can be unpacked.
    
Usage:

.. sourcecode:: bash

    brew list                  # list all installed packages
    brew search partial-name   # search for available packages
    brew info pkg-name         # get information about a package
    brew install/uninstall pkg # install/uninstall a package
    brew update                # update package lists and Homebrew
    brew upgrade               # upgrade packages you have installed
    brew upgrade pkg-name      # upgrade a specific package


**Homebrew:  taps**

    Homebrew maintains additional Git repos (inside usr/local/Library/Taps) that describe sets of package formulae that are available for installation. Homebrew calls these repos taps to continue its naming theme. The 'mxcl/master' tap is the primary tap you get by default with Homebrew and it describes all the packages that are available with vanilla Homebrew. You can add any other taps you like to have extra packages available at your fingertips.

.. sourcecode:: bash

    brew tap                   # list tapped repositories
    brew tap tapname           # add tap
    brew untap tapname         # remove a tap


As an example, ``muscle`` is available in a Homebrew "tap" called **homebrew/science**

.. sourcecode:: bash

    > brew tap
    > brew info muscle
    Error: No available formula for muscle 
    > brew tap homebrew/science
    Cloning into '/usr/local/Library/Taps/homebrew/homebrew-science'...
    remote: Counting objects: 9127, done.
    remote: Compressing objects: 100% (18/18), done.
    Receiving objects:  37% (3377/9127), 772.01 KiB | 1.50
    ..
    Receiving objects: 100% (9127/9127), 1.83 MiB | 1.76 MiB/s  Receiving objects: 100% (9127/9127), 2.39 MiB | 1.76 MiB/s, done.
    Resolving deltas: 100% (5091/5091), done.
    Checking connectivity... done.
    Tapped 439 formulae
    > brew install muscle
    ==> Installing muscle from homebrew/homebrew-science
    ==> Downloading https://downloads.sf.net/project/machomebrew
                                                                ###############################                             ######################################################################## 100.0%
    ==> Pouring muscle-3.8.31.yosemite.bottle.tar.gz
    í ¼í½º  /usr/local/Cellar/muscle/3.8.31: 2 files, 304K
    > 

.. sourcecode:: bash

    > which muscle
    /usr/local/bin/muscle
    > muscle -version
    MUSCLE v3.8.31 by Robert C. Edgar
    > ~/bin/muscle -version
    MUSCLE v3.8.31 by Robert C. Edgar
    >

``homebrew/science`` is where many of the programs that I showed with ``brew list`` came from.  This is my old list:

.. sourcecode:: bash

    > brew list
    apple-gcc42
    autoconf
    automake
    boost
    bowtie
    bowtie2
    cloog
    fasttree
    freetype
    gdbm
    gfortran
    git
    gmp
    go
    isl
    libmpc
    libpng
    libyaml
    mercurial
    mpfr
    mrbayes
    muscle
    ninja
    openssl
    pkg-config
    python
    python3
    ragel
    readline
    ruby
    sqlite
    xz
    

And this is what we have now:

.. sourcecode:: bash

    > brew list
    gdbm	muscle	readline
    git	openssl	sqlite
    libpng	python	youtube-dl
    >

.. sourcecode:: bash

    > brew install bowtie bowtie2 fasttree mrbayes pkg-config
    ==> Installing bowtie from homebrew/homebrew-science
    ..
    > 
    > brew list
    bowtie	libpng	python
    bowtie2	mrbayes	readline
    fasttree	muscle	sqlite
    gdbm	openssl	youtube-dl
    git	pkg-config
    >

Simple.

**Homebrew:  cask**

Homebrew **cask** is for 

https://github.com/caskroom/homebrew-cask


**Homebrew:  formulae**

Homebrew works with formula(s/ae) which are recipes for possibly building and then installing software.  In the early days most things were built on the user's computer, now most things come pre-built and install in just a moment.

The Formula Cookbook:

https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md

Formulas live in ``/usr/local/Library/Formula`` and there are a lot of them:

.. sourcecode:: bash

    > find /usr/local/Library/Formula | wc -l
        3023
    >

Let's look at one of them, perhaps ``libpng.rb`` that we use for ``matplotlib``:

.. sourcecode:: bash

    > cat libpng.rb 
    class Libpng < Formula
      homepage "http://www.libpng.org/pub/png/libpng.html"
      url "https://downloads.sf.net/project/libpng/libpng16/1.6.16/libpng-1.6.16.tar.xz"
      sha1 "31855a8438ae795d249574b0da15b34eb0922e13"

      bottle do
        cellar :any
        sha1 "f7b47fcf9d4111075745b04b6fbdb63062982bca" => :yosemite
        sha1 "b67793bae0a5d109be5ad19d27bbeb4509f4ecee" => :mavericks
        sha1 "a2fb283d2f96161ecee5d504adb92b26376b7d9e" => :mountain_lion
      end

      keg_only :provided_pre_mountain_lion

      option :universal

      def install
        ENV.universal_binary if build.universal?
        system "./configure", "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{prefix}"
        system "make"
        system "make", "test"
        system "make", "install"
      end

      test do
        (testpath/"test.c").write <<-EOS.undent
          #include <png.h>

          int main()
          {
            png_structp png_ptr;
            png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
            png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
            return 0;
          }
        EOS
        system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
        system "./test"
      end
    end
    >

While we (or at least I) could not write one of these things, I can sort of puzzle it out.

The script is the definition of a class, an object that has both data and code, which can be utilized by the machinery of Homebrew (defined in some other place).  I can't make out that much of how this works, but there is a URL for the source (and a digest to check authenticity), as well digests for the "bottles" which are pre-built versions of the software that differ as OS X has changed recently.

There is a ``test`` which looks like a program that does ``#include <png.h>`` and then uses two functions from it (``png_create_write_struct`` and ``png_destroy_write_struct``).  The last part includes values for all settings need to build the program.  Above it is ``install`` which presumably is the instructions to install the library.
    