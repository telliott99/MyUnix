#!/bin/bash

mkdir tmp
cd tmp
git init

cat > x.txt << EOF
a
b
EOF

git add x.txt
git commit -m 'initial project version'

sleep 2
cat > y.txt << EOF
c
d
EOF

git add y.txt
git commit -m 'adding y.txt to project'

sleep 2
echo "f" >> x.txt
git add x.txt
git commit -m 'changed x.txt'
git log
