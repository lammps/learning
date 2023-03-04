#!/bin/sh

test -x html || exit 1
git branch --show-current > .current-branch
git checkout github-docs
git add html
git commit -m 'update website'
git push
git checkout `cat .current-branch`
rm -f .current-branch
