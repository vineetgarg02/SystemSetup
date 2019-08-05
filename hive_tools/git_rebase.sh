#!/bin/bash
branchName=$(git branch | grep ^\* | awk '{print $2}')
git checkout master
git fetch upstream
git rebase upstream/master
git push origin master
git checkout $branchName
git rebase origin/master
