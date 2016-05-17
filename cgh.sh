#!/bin/sh

which create-github-repo
if [ $? != 0 ]; then
  echo create-github-repo doit être installé:
  echo npm install --global create-github-repo
  exit
fi

git branch --list master|grep -F -q '* '
if [ $? != 0 ]; then
  echo 'Not on "master" branch, exiting.'
  exit
fi

grep -F -q '[remote "origin"]' .git/config
if [ $? = 0 ]; then
  echo 'Remote "origin" already configured.'
  exit
fi

here=`pwd`
bn=`basename $here`

create-github-repo --name=$bn
curl -u "millette:$GITHUB_TOKEN"  -H "Content-Type: application/json" -X POST -d@/home/millette/bin/hookirc.txt https://api.github.com/repos/millette/$bn/hooks > /dev/null
git remote add origin git@github.com:millette/$bn.git
git push --set-upstream origin master
