#!/bin/bash

alias hiveMakePackageCl='mvn clean package -Pdist -DskipTests -T 1C -Dmaven.javadoc.skip=true'
alias hiveMakePackage='mvn package -Pdist -DskipTests -T 1C -Dmaven.javadoc.skip=true'

hiveBuildAndMovePackage() {
	if [ "$1" = "clean" ]
	then
		hiveMakePackageCl
	else
		hiveMakePackage
	fi

	branchName=$(git branch | grep ^\* | awk '{print $2}')
	srcPath=~/workspace/hive_jars/$branchName
	mkdir -p $srcPath
	cp -rf packaging $srcPath/
}
