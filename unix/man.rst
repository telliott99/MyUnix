.. _man:

##############
Unix man pages
##############


It seems like it would be worth it to print out the man page for ``find`` or ``grep`` and study it.

.. sourcecode:: bash

    > man grep > grep.txt
    > wc -l grep.txt
         301 grep.txt
    >

301 lines!  If you do this, you'll find that ``man`` stutters.  

.. note::

    To print man pages to a text file:

.. sourcecode:: bash

     > man grep | col -b > grep.txt
     >

Here is how it looks without that:

.. sourcecode:: bash

    GREP(1)                   BSD General Commands Manual                  GREP(1)

    NNAAMMEE
         ggrreepp, eeggrreepp, ffggrreepp, zzggrreepp, zzeeggrreepp, zzffggrreepp -- file pattern searcher

    SSYYNNOOPPSSIISS
         ggrreepp [--aabbccddDDEEFFGGHHhhIIiiJJLLllmmnnOOooppqqRRSSssUUVVvvwwxxZZ] [--AA _n_u_m] [--BB _n_u_m] [--CC[_n_u_m]]
              [--ee _p_a_t_t_e_r_n] [--ff _f_i_l_e] [----bbiinnaarryy--ffiilleess=_v_a_l_u_e] [----ccoolloorr[=_w_h_e_n]]
              [----ccoolloouurr[=_w_h_e_n]] [----ccoonntteexxtt[=_n_u_m]] [----llaabbeell] [----lliinnee--bbuuffffeerreedd]
              [----nnuullll] [_p_a_t_t_e_r_n] [_f_i_l_e _._._.]

    DDEESSCCRRIIPPTTIIOONN
         The ggrreepp utility searches any given input files, selecting lines that

http://www.electrictoolbox.com/article/linux-unix-bsd/save-manpage-plain-text/


I always wondered what the numbers meant in references to the manual.  And I found out from my Linux book:

.. image:: /figs/manual_sections.png
   :scale: 50 %

A command may appear in multiple sections.  The parenthesized numbers refer to a section number.