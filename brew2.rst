.. _brew2:

###################
More about Homebrew
###################

Homebrew works with formula(s/ae) which are recipes for possibly building and then installing software.  In the early days most things were built on the user's computer, now most things come pre-built and install in just a moment.

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
    