.. _popular:

################
Popular commands
################

I found a list of Unix commands sorted by popularity.  

http://www.commandlinefu.com/commands/browse/sort-by-votes

They are all interesting and some are very useful.  Here are a few.

**sudo !!**

You issued a command and forgot to do ``sudo < command >``.  One fix is to use the up-arrow to repeat the command, and then do CTL-a to bring the cursor to the beginning of the the line, and type ``sudo``.  But this is faster::

    > cd Desktop
    > echo "abc" > z.txt
    > chmod 0 z.txt
    > cat z.txt
    cat: z.txt: Permission denied
    > sudo !!
    sudo cat z.txt
    abc
    >

**Quick correction**

Example::

    > echo "abcx" 
    abcx
    > ^x^d
    echo "abcd" 
    abcd
    > touch x.txt
    > rn x.txt
    -bash: rn: command not found
    > ^rn^rm
    rm x.txt
    > ^z
    echo "no typos"
    no typos
    >

**at**

cron alternative::

    > echo "ls -l" | at 4:03
    job 1 at Sat Mar  7 04:03:00 2015
    >

did not actually execute for me

**man ascii**

Example::


     The hexadecimal set:

     00 nul   01 soh   02 stx   03 etx   04 eot   05 enq   06 ack   07 bel
     08 bs    09 ht    0a nl    0b vt    0c np    0d cr    0e so    0f si
     10 dle   11 dc1   12 dc2   13 dc3   14 dc4   15 nak   16 syn   17 etb
     18 can   19 em    1a sub   1b esc   1c fs    1d gs    1e rs    1f us
     20 sp    21  !    22  "    23  #    24  $    25  %    26  &    27  '
     28  (    29  )    2a  *    2b  +    2c  ,    2d  -    2e  .    2f  /
     30  0    31  1    32  2    33  3    34  4    35  5    36  6    37  7
     38  8    39  9    3a  :    3b  ;    3c  <    3d  =    3e  >    3f  ?
     40  @    41  A    42  B    43  C    44  D    45  E    46  F    47  G
     48  H    49  I    4a  J    4b  K    4c  L    4d  M    4e  N    4f  O
     50  P    51  Q    52  R    53  S    54  T    55  U    56  V    57  W
     58  X    59  Y    5a  Z    5b  [    5c  \    5d  ]    5e  ^    5f  _
     60  `    61  a    62  b    63  c    64  d    65  e    66  f    67  g
     68  h    69  i    6a  j    6b  k    6c  l    6d  m    6e  n    6f  o
     70  p    71  q    72  r    73  s    74  t    75  u    76  v    77  w

**stopwatch**

CTL-D to stop:

Example::

     > time read
     ^D
     real	0m3.920s
     user	0m0.000s
     sys	0m0.001s
     >

**cd and jump back**

Example::

     > pwd
     /Users/telliott_admin/Desktop
     > (cd /usr/local && ls)
     CODEOFCONDUCT.md	Frameworks		README.md		etc			opt
     CONTRIBUTING.md		LICENSE.txt		SUPPORTERS.md		include			share
     Cellar			Library			bin			lib			texlive
     > pwd
     /Users/telliott_admin/Desktop
     >


