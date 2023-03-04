#!/bin/sh

test -x html || exit 1
git branch --show-current > .current-branch
git checkout github-docs
cp -ar html/* html/.* docs
git add -A docs
git commit -m 'update website'
git push origin github-docs
git checkout `cat .current-branch`
rm -f .current-branch
