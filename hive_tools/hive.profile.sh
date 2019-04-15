export PATH=/Applications/IntelliJ\ IDEA\ CE.app/Contents/MacOS:$PATH

# HIVE SOURCE path
export HIVE_SRC=/Users/vgarg/repos/hive.vineet.master
export HIVE_TESTS=$HIVE_SRC/ql/src/test

export EARs=/Users/vgarg/EARs


set runtimepath^=~/.vim/bundle/ctrlp.vim

export MAVEN_OPTS="-Xmx2048m -enableassertions"
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

# export HADOOP_HOME=/Users/vgarg/workspace/hadoop-2.8.1
export HADOOP_HOME=/Users/vgarg/workspace/hadoop-3.0.0-beta1

export HADOOP_CLIENT_OPTS="-Xmx4096m -XX:MaxPermSize=2048m $HADOOP_CLIENT_OPTS"
#export TEZ_JARS=/Users/vgarg/workspace/tez/apache-tez-0.8.4-bin
export TEZ_JARS=/Users/vgarg/workspace/tez/apache-tez-0.9.1-bin
export TEZ_CONF_DIR=/Users/vgarg/workspace/tez/apache-tez-0.9.1-bin/conf
#export TEZ_CONF_DIR=/Users/vgarg/workspace/tez/apache-tez-0.8.4-bin/conf
export HADOOP_CLASSPATH=${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*

export HIVE_OPTS="--hiveconf hive.fetch.task.conversion=minimal"

export HIVE_OPTS="$HIVE_OPTS --hiveconf hive.auto.convert.join.noconditionaltask.size=10000000"
#export HIVE_OPTS="$HIVE_OPTS --hiveconf hive.security.authorization.enabled=true"
export HIVE_OPTS="$HIVE_OPTS --hiveconf tez.local.mode=true"
#export HIVE_OPTS="$HIVE_OPTS --hiveconf tez.counters.max=1000"
#export HIVE_OPTS="$HIVE_OPTS --hiveconf fs.default.name=file:///"
#export HIVE_OPTS="$HIVE_OPTS --hiveconf fs.defaultFS=file:///"

export HIVE_OPTS="$HIVE_OPTS --hiveconf tez.ignore.lib.uris=true --hiveconf tez.runtime.optimize.local.fetch=true --hiveconf hive.tez.container.size=4096 --hiveconf hive.auto.convert.join.noconditionaltask.size=1370 --hiveconf hive.metastore.warehouse.dir=/Users/vgarg/hive_temp/vgarg/hive/warehouse --hiveconf hive.execution.engine=tez --hiveconf hive.user.install.directory=file:///Users/vgarg/hive_temp/vgarg/hive  --hiveconf tez.staging-dir=/Users/vgarg/hive_temp/vgarg/hive --hiveconf tez.ignore.lib.uris=true --hiveconf tez.runtime.optimize.local.fetch=true --hiveconf hive.explain.user=false --hiveconf hive.mapred.mode=nonstrict --hiveconf javax.jdo.option.ConnectionURL=jdbc:derby:;databaseName=/Users/vgarg/hive_temp/metastore_db;create=true --hiveconf hive.log.dir=/Users/vgarg/hive_temp/vgarg --hiveconf hive.log.file=hive.debug2.log "

export HIVE_OPTS="$HIVE_OPTS --hiveconf hive.root.logger=DEBUG,DRFA"

# bypass CBO falling back to AST
# export HIVE_OPTS="--hiveconf hive.in.test=true "$HIVE_OPTS

export BEELINE=$HIVE_SRC/packaging/target/apache-hive-3.0.0-SNAPSHOT-bin/apache-hive-3.0.0-SNAPSHOT-bin
export BEELINE_MASTER=/Users/vgarg/workspace/hive4/packaging/target/apache-hive-2.2.0-SNAPSHOT-bin/apache-hive-2.2.0-SNAPSHOT-bin
export BEELINE_HW=/Users/vgarg/repos/hw.hive2/packaging/target/apache-hive-2.1.0.2.6.0.2-SNAPSHOT-bin/apache-hive-2.1.0.2.6.0.2-SNAPSHOT-bin

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
parse_git_remote_branch() {
    #git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD) 2> /dev/null
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

#export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "
#export PS1="\u\[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)->\[\033[34m\]\$(parse_git_remote_branch)\[\033[00m\]$ "

hiveRunDiff(){
	gvimdiff $HIVE_SRC/itests/qtest/target/qfile-results/clientpositive/$1.q.out $HIVE_SRC/ql/src/test/results/clientpositive/$1.q.out
}

hiveRunDiffLlap(){
	gvimdiff $HIVE_SRC/itests/qtest/target/qfile-results/clientpositive/$1.q.out $HIVE_SRC/ql/src/test/results/clientpositive/llap/$1.q.out
}
hiveRunDiffNegative(){
	gvimdiff $HIVE_SRC/itests/qtest/target/qfile-results/clientnegative/$1.q.out $HIVE_SRC/ql/src/test/results/clientnegative/$1.q.out
}

#test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

hiveRunTestAll() {
	if [ "$2" == "" ]
	then
		echo "Invalid input file!"
		return
	fi
	
	if [ "$1" == "cli" ]
	then
		mvnTest="TestCliDriver"
	fi
	
	if [ "$1" == "llaplocal" ]
	then
		mvnTest="TestMiniLlapLocalCliDriver"
	fi

	if [ "$1" == "llap" ]
	then
		mvnTest="TestMiniLlapCliDriver"
	fi

	if [ "$1" == "perf" ]
	then
		mvnTest="TestTezPerfCliDriver"
	fi

	if [ "$1" == "tez" ]
	then
		mvnTest="TestMiniTezCliDriver"
	fi

	egrep "$mvnTest" "$2" | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n 10 | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest="$mvnTest" -Dtest.output.overwrite=true -Dqfile={}
}


hiveOverrideAll() {
	hiveOverrideTestPerfAll $1
	hiveOverrideTestCliAll $1
	hiveOverrideTestLlapLocalAll $1
	hiveOverrideTestLlapAll $1
	hiveOverrideTestTezAll $1
	cd ..
	hiveOverrideTestSparkAll $1
	hiveOverrideTestSparkPerfAll $1
}

hiveOverrideTestTezAll() {
	if [ "$2" == "" ]
	then
		numFiles=10
	else
		numFiles="$2"
	fi
	echo "numFiles:$numFiles"
	egrep 'TestMiniTezCliDriver' $1 | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n $numFiles | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=TestMiniTezCliDriver -Dtest.output.overwrite=true -Dqfile={}
}
hiveOverrideTestLlapAll() {
	egrep 'TestMiniLlapCliDriver' $1 | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n 10 | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=TestMiniLlapCliDriver -Dtest.output.overwrite=true -Dqfile={}
}
hiveOverrideTestCliAll() {
	if [ "$2" == "" ]
	then
		numFiles=10
	else
		numFiles="$2"
	fi
	echo "numFiles:$numFiles"
	egrep 'TestCliDriver' $1 | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n $numFiles | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=TestCliDriver -Dtest.output.overwrite=true -Dqfile={}
}
hiveOverrideTestSparkAll() {
	if [ "$2" == "" ]
	then
		numFiles=10
	else
		numFiles="$2"
	fi
	echo "numFiles:$numFiles"
	egrep 'TestSparkCliDriver' $1 | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n $numFiles | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=TestSparkCliDriver -Dtest.output.overwrite=true -Dqfile={}
}
hiveOverrideTests() {
	echo "egrep $1 $2 | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n 20 | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=$1 -Dtest.groups="" -Dtest.output.overwrite=true -Dqfile={}"
	egrep $1 $2 | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n 10 | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=$1 -Dtest.groups="" -Dtest.output.overwrite=true -Dqfile={}
}

hiveOverrideTestSparkPerfAll() {
	if [ "$2" == "" ]
	then
		numFiles=10
	else
		numFiles="$2"
	fi
	echo "numFiles:$numFiles"
	egrep 'TestSparkPerfCliDriver' $1 | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n $numFiles | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=TestSparkPerfCliDriver -Dtest.output.overwrite=true -Dqfile={}
}


hiveOverrideTestPerfAll() {
	if [ "$2" == "" ]
	then
		numFiles=10
	else
		numFiles="$2"
	fi
	echo "numFiles:$numFiles"
	egrep 'TestTezPerfCliDriver' $1 | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n $numFiles | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=TestTezPerfCliDriver -Dtest.output.overwrite=true -Dqfile={}
}

hiveRunLipwig() {
	if [ "$1" == "" ]
	then
		echo "Invalid input file!"
		return
	fi
	
	if [ "$2" == "" ]
	then
		echo "Invalid output file!"
		return
	fi

	file1="lipwig.tmp.file.dot"
	python /Users/vgarg/workspace/repos/lipwig/lipwig.py $1 > /tmp/$file1
	dot -Tsvg /tmp/$file1 > $2
	open -a Safari $2
	rm /tmp/$file1
}

hiveRunTest() {
    echo "mvn test -Dtest=$1 -Dqfile=$2 -Dtest.output.overwrite=true"
    mvn test -Dtest=$1 -Dqfile=$2 -Dtest.output.overwrite=true
}

#hiveRunTest() {
#
#	if [ "$1" == "cli" ]
#	then
#		mvnTest="mvn test -Dtest=TestCliDriver"
#	fi
#	
#	if [ "$1" == "negative" ]
#	then
#		mvnTest="mvn test -Dtest=TestNegativeCliDriver"
#	fi
#	
#	if [ "$1" == "llaplocal" ]
#	then
#		mvnTest="mvn test -Dtest=TestMiniLlapLocalCliDriver" 
#	fi
#	
#	if [ "$1" == "perf" ]
#	then
#		mvnTest="mvn test -Dtest=TestTezPerfCliDriver" 
#	fi
#	
#	if [ "$1" == "llap" ]
#	then
#		mvnTest="mvn test -Dtest=TestMiniLlapCliDriver" 
#	fi
#
#	if [ "$1" == "spark" ]
#	then
#		mvnTest="mvn test -Dtest=TestSparkCliDriver" 
#	fi
#
#	if [ "$2" == "" ]
#	then
#		echo "Missing q file.."
#		return
#	fi
#
#	echo "Testing q file: $2 ...."
#
#	mvnTest="$mvnTest -Dqfile=$2.q"
#
#	if [ "$3" == "override" ]
#	then
#		echo "overriding....."
#		mvnTest="$mvnTest -Dtest.output.overwrite=true "
##	fi
#	
#
#	if [ "$2" == "cbo" ]
#	then
#		echo "Return Path on....."
#		mvnTest="$mvnTest -Dhive.cbo.returnpath.hiveop=true -Dhive.calcite.subquery=true"
#	fi
#
#	while getopts ":p" o; do
#   		case "${o}" in
#        		p)
#            			port=${OPTARG}
#	    			if [ "$port" == "" ]
#	    			then
#		    			export port=5005
#	    			fi
#				echo "debuggging..... @ port $port"
#	    			mvnTest="$mvnTest -Dmaven.surefire.debug \"-Xdebug -Xrunjdwp:transport=dt_socket,address=${port},server=y,suspend=y\""
#            			;;
#    	esac
#	done
#	
#	if [ "$3" == "debug" ]
#	then
#		if [ "$4" == "" ]
#		then
#			port=5005
#		else
#			port=$4
#		fi
#		echo "Debugging at port: $port"
#	    	mvnTest="$mvnTest -Dmaven.surefire.debug=\"-Xdebug -Xrunjdwp:transport=dt_socket,address=${port},server=y,suspend=y\""
#		#mvnTest="$mvnTest -Dmaven.surefire.debug" 
#	fi
#	
#	#mvnTest="$mvnTest  -DinitScript=myInitScript.sql"
#
#	#cd $HIVE_SRC/itests/qtest
#	echo $mvnTest
#	eval "$mvnTest"
#}

calciteRunTest() {
	if [ "$1" == "" ]
	then
		echo "Missing test name....."
	fi

	echo "testing... $1"

	mvnTest="mvn test -Dtest=HiveRelOptRulesTest#$1 -DskipGenerate  -Dcheckstyle.skip=true"
	eval "$mvnTest"
}

hiveRunTestQ() {
	if [ "$1" == "" ]
	then
		echo "Missing q file.."
		return
	fi
	
	mvnTest="mvn test -Dtest=TestCliDriver -Dqfile=$1.q"
	#mvnTest="mvn test -Dtest=TestMiniTezCliDriver -Dqfile=$1.q"
	#mvnTest="mvn test -Dtest=TestSparkCliDriver-Dqfile=$1.q"
	#mvnTest="mvn test -Dtest=TestMiniLlapCliDriver -Dqfile=$1.q"
	#mvnTest="$mvnTest  -Dhive.cbo.returnpath.hiveop=true"
	#mvnTest="$mvnTest  -Dhive.calcite.subquery=true"
	#mvnTest="$mvnTest -Dmaven.surefire.debug"
	#mvnTest="$mvnTest  -DinitScript=myInitScript.sql"
	#mvnTest="$mvnTest -Dtest.output.overwrite=true"

	cd /Users/vgarg/workspace/hive3/itests/qtest
	eval "$mvnTest"

}

hiveMakeSrc() {
	#cd $HIVE_SRC
	if [ "$1" == "" ]
	then
		mvn install -DskipTests
		return
	fi
		
	mvn clean install -DskipTests

}

hiveMakeTest() {
	#cd $HIVE_SRC/itests
	if [ "$1" == "" ]
	then
		mvn install -DskipTests
		return
	fi
		
	mvn clean install -DskipTests
}



genAlterUpdate() {

echo "***************************" >> ~/workspace/notes/update_statistics
echo "***************************" >> ~/workspace/notes/update_statistics

echo "Enter table name: "
read tableName
echo "Table: $tableName"
echo $tableName >> ~/workspace/notes/update_statistics

echo "Partition? "
read isPartition
	
	if [ "$isPartition" == "Y" ] || [ "$isPartition" == "y" ]
	then
		morePartition=y;
		echo "Enter all partitions"
		read -a partitionArray
		echo "Partitions entered: "
		for i in "${partitionArray[@]}"
		do
			echo "Enter numRows and rawDataSize for partition: $i"
			read -a tabStatsArray
			stmt="alter table $tableName partition($i) update statistics set('numRows'='${tabStatsArray[0]}', 'rawDataSize'='${tabStatsArray[1]}');"
			echo "statement: $stmt"
			stmtWrite="print \$hivefp \"alter table \$tableName partition($i) update statistics set('numRows'='${tabStatsArray[0]}', 'rawDataSize'='${tabStatsArray[1]}');\n\""
			echo "statement for generate data: $stmtWrite"
			echo $stmtWrite >> ~/workspace/notes/update_statistics
		done
		
		moreColumns=y;
		while [ "$moreColumns" == "y" ]	
		do
			echo "Enter Column:"
			read column
			echo "is it string/binary(s), boolean(b), or integral(i)?"
			read columnType
			for i in "${partitionArray[@]}"
			do
				echo "enter column stats (numNulls, numDvs/numTrues, lowValue/avg/numFalse, highValue/max for partition $i"
				read -a colStat 
				altStmt="alter table $tableName partition($i) update statistics for column $column" 
				altStmtFile="print \$hivefp \"alter table \$tableName partition($i) update statistics for column $column" 
				if [ "$columnType" == 'i' ]
				then
					colStmt="$altStmt set('numNulls'='${colStat[0]}', 'numDVs'='${colStat[1]}', 'lowValue'='${colStat[2]}', 'highValue'='${colStat[3]}');"
					colStmtFile="$altStmtFile set('numNulls'='${colStat[0]}', 'numDVs'='${colStat[1]}', 'lowValue'='${colStat[2]}', 'highValue'='${colStat[3]}');\n\""
				elif [ "$columnType" == 's' ]
				then
					colStmt="$altStmt set('numNulls'='${colStat[0]}', 'numDVs'='${colStat[1]}', 'avgColLen'='${colStat[2]}', 'maxColLen'='${colStat[3]}');"
					colStmtFile="$altStmtFile set('numNulls'='${colStat[0]}', 'numDVs'='${colStat[1]}', 'avgColLen'='${colStat[2]}', 'maxColLen'='${colStat[3]}');\n\""
				else
					colStmt="$altStmt set('numNulls'='${colStat[0]}', 'numTrues'='${colStat[1]}', 'numFalses'='${colStat[2]}');"
					colStmtFile="$altStmtFile set('numNulls'='${colStat[0]}', 'numTrues'='${colStat[1]}', 'numFalses'='${colStat[2]}');\n\""
				fi
				echo "Generated stmt: $colStmt"
				echo "Generate file stmt: $colStmtFile"
				echo $colStmtFile >> ~/workspace/notes/update_statistics
			done
			echo "More columns? "
			read moreColumns
		done
	else
		echo "Enter numRows and rawDataSize for table: $tableName"
		read -a tabStatsArray
		stmt="alter table $tableName update statistics set('numRows'='${tabStatsArray[0]}', 'rawDataSize'='${tabStatsArray[1]}');"
		echo "statement: $stmt"
		stmtWrite="print \$hivefp \"alter table \$tableName update statistics set('numRows'='${tabStatsArray[0]}', 'rawDataSize'='${tabStatsArray[1]}');\n\""
		echo "statement for generate data: $stmtWrite"
		echo $stmtWrite >> ~/workspace/notes/update_statistics

		moreColumns=y;
		while [ "$moreColumns" == "y" ]	
		do
			echo "Enter Column:"
			read column
			echo "is it string/binary(s), boolean(b), or integral(i)?"
			read columnType
			echo "enter column stats (numNulls, numDvs/numTrues, lowValue/avg/numFalse, highValue/max for column $column"
			read -a colStat 
			altStmt="alter table $tableName update statistics for column $column" 
			altStmtFile="print \$hivefp \"alter table \$tableName update statistics for column $column" 
			if [ "$columnType" == 'i' ]
			then
				colStmt="$altStmt set('numNulls'='${colStat[0]}', 'numDVs'='${colStat[1]}', 'lowValue'='${colStat[2]}', 'highValue'='${colStat[3]}');"
				colStmtFile="$altStmtFile set('numNulls'='${colStat[0]}', 'numDVs'='${colStat[1]}', 'lowValue'='${colStat[2]}', 'highValue'='${colStat[3]}');\n\""
			elif [ "$columnType" == 's' ]
			then
				colStmt="$altStmt set('numNulls'='${colStat[0]}', 'numDVs'='${colStat[1]}', 'avgColLen'='${colStat[2]}', 'maxColLen'='${colStat[3]}');"
				colStmtFile="$altStmtFile set('numNulls'='${colStat[0]}', 'numDVs'='${colStat[1]}', 'avgColLen'='${colStat[2]}', 'maxColLen'='${colStat[3]}');\n\""
			else
				colStmt="$altStmt set('numNulls'='${colStat[0]}', 'numTrues'='${colStat[1]}', 'numFalses'='${colStat[2]}');"
				colStmtFile="$altStmtFile set('numNulls'='${colStat[0]}', 'numTrues'='${colStat[1]}', 'numFalses'='${colStat[2]}');\n\""
			fi
			echo "Generated stmt: $colStmt"
			echo "Generate file stmt: $colStmtFile"
			echo $colStmtFile >> ~/workspace/notes/update_statistics
			echo "More columns? "
			read moreColumns
		done
	fi


}

runSQTestsllap() {
	grep '^TestLlap' ../../../projects/subquery-support/subquery.tests | awk '{print $2}' | xargs -n 10 | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=TestMiniLlapLocalCliDriver -Dqfile={}
}

runSQTestsllap() {
	grep '^TestLlap' ../../../projects/subquery-support/subquery.tests | awk '{print $2}' | xargs -n 10 | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=TestMiniLlapLocalCliDriver -Dqfile={}
}

alias hiveMakeCl='mvn clean install -Pdist -DskipTests -Dpackaging.minimizeJar=false -T 1C -DskipShade -Dremoteresources.skip=true -Dmaven.javadoc.skip=true'
#alias hiveMakeCl='mvn clean install -DskipTests -T 1C  -Dmaven.javadoc.skip=true'
#alias hiveMake='mvn install -DskipTests -T 1C  -Dmaven.javadoc.skip=true'
alias hiveMake='mvn install -Pdist -DskipTests -Dpackaging.minimizeJar=false -T 1C -DskipShade -Dremoteresources.skip=true -Dmaven.javadoc.skip=true'

alias sshPG='ssh -i ~/Downloads/openstack-keypair.pem.txt root@172.27.52.141'
alias sshHIVE='ssh -i ~/Downloads/openstack-keypair.pem.txt root@172.27.30.12'


hiveStartHiveCli() {
	branchName=$(git branch | grep ^\* | awk '{print $2}')
	branchVersion=$(xmllint --xpath '/*[local-name()="project"]/*[local-name()="version"]/text()' $HIVE_SRC/pom.xml)
	if [ "$1" = "debug" ]
	then
		~/workspace/hive_jars/$branchName/packaging/target/apache-hive-$branchVersion-bin/apache-hive-$branchVersion-bin/bin/hive --debug
	else
		~/workspace/hive_jars/$branchName/packaging/target/apache-hive-$branchVersion-bin/apache-hive-$branchVersion-bin/bin/hive
	fi
}

hiveOverrideTestsAll() {
	if [ "$2" == "" ]
	then
		numFiles=10
	else
		numFiles="$2"
	fi
	echo "numFiles:$numFiles"
	echo "cli driver: $3"
	egrep "$3" $1 | perl -pe 's@.*testCliDriver_@@g' | awk '{print $1 ".q"}' | xargs -n $numFiles | perl -pe 's@ @,@g' | xargs -I{} mvn test -Dtest=$3 -Dtest.output.overwrite=true -Dqfile={}
}

hiveMakeInternal() {
	BUILD_NUMBER=$1
#	mvn clean install -DskipTests -Daccumulo.version=1.7.0.3.0.0.0-${BUILD_NUMBER} -Dcalcite.version=1.16.0.3.0.0.0-${BUILD_NUMBER} -Dhadoop.version=3.1.0.3.0.0.0-${BUILD_NUMBER} -Dhbase.version=2.0.0.3.0.0.0-${BUILD_NUMBER} -Dhbase.hadoop2.version=2.0.0.3.0.0.0-${BUILD_NUMBER} -Dtez.version=0.9.1.3.0.0.0-${BUILD_NUMBER} -Dzookeeper.version=3.4.6.3.0.0.0-${BUILD_NUMBER} -Dstorage-api.version=2.3.0.3.0.0.0-${BUILD_NUMBER} -Dorc.version=1.4.3.3.0.0.0-${BUILD_NUMBER} -Ddruid.version=0.12.1.3.0.0.0-${BUILD_NUMBER} -Darrow.version=0.8.0.3.0.0.0-${BUILD_NUMBER} -Dparquet.version=1.10.0.3.0.0.0-${BUILD_NUMBER} 
	#mvn clean install -DskipTests -Phadoop-2 -Dhadoop-23.version=3.1.0.3.0.1.0-36 -Dhbase.version=2.0.0.3.0.1.0-36 -Dzookeeper.version=3.4.6.3.0.1.0-36 -Dcalcite.version=1.16.0.3.0.1.0-36 -Dtez.version=0.9.1.3.0.1.0-36 -Daccumulo.version=1.7.0.3.0.1.0-36 -Dhbase.hadoop2.version=2.0.0.3.0.1.0-36 -Davatica.version=1.10.0.3.0.1.0-36 -Dpig.version=0.16.0.3.0.1.0-36 -Dhadoop.version=3.1.0.3.0.1.0-36 -Dstorage-api.version=2.3.0.3.0.1.0-36 -Dorc.version=1.5.1.3.0.1.0-36 
	mvn -s /Users/vgarg/.m2/settings.hdp.xml clean install -DskipTests -T 1C -Dmaven.repo.local=/Users/vgarg/.m2/repository.hdp -Phadoop-2 -Dhadoop-23.version=3.1.1.3.1.0.0-${BUILD_NUMBER} -Dhbase.version=2.0.2.3.1.0.0-${BUILD_NUMBER} -Dzookeeper.version=3.4.6.3.1.0.0-${BUILD_NUMBER} -Dcalcite.version=1.16.0.3.1.0.0-${BUILD_NUMBER} -Dtez.version=0.9.1.3.1.0.0-${BUILD_NUMBER} -Daccumulo.version=1.7.0.3.1.0.0-${BUILD_NUMBER} -Dhbase.hadoop2.version=2.0.2.3.1.0.0-${BUILD_NUMBER} -Davatica.version=1.10.0.3.1.0.0-${BUILD_NUMBER} -Dpig.version=0.16.0.3.1.0.0-${BUILD_NUMBER} -Dhadoop.version=3.1.1.3.1.0.0-${BUILD_NUMBER} -Dorc.version=1.5.1.3.1.0.0-${BUILD_NUMBER} -Ddruid.version=0.12.1.3.1.0.0-${BUILD_NUMBER}
}

hiveRunTestInternal() {
	BUILD_NUMBER=$1
    echo "mvn test -Dtest=$2 -Dqfile=$3 -Dmaven.repo.local=/Users/vgarg/.m2/repository.hdp -Phadoop-2 -Dhadoop-23.version=3.1.1.3.0.1.0-${BUILD_NUMBER} -Dhbase.version=2.0.0.3.0.1.0-${BUILD_NUMBER} -Dzookeeper.version=3.4.6.3.0.1.0-${BUILD_NUMBER} -Dcalcite.version=1.16.0.3.0.1.0-${BUILD_NUMBER} -Dtez.version=0.9.1.3.0.1.0-${BUILD_NUMBER} -Daccumulo.version=1.7.0.3.0.1.0-${BUILD_NUMBER} -Dhbase.hadoop2.version=2.0.0.3.0.1.0-${BUILD_NUMBER} -Davatica.version=1.10.0.3.0.1.0-${BUILD_NUMBER} -Dpig.version=0.16.0.3.0.1.0-${BUILD_NUMBER} -Dhadoop.version=3.1.1.3.0.1.0-${BUILD_NUMBER} -Dorc.version=1.5.1.3.0.1.0-${BUILD_NUMBER} -Ddruid.version=0.12.1.3.0.1.0-${BUILD_NUMBER} -Dtest.output.overwrite=true"
	mvn test -s /Users/vgarg/.m2/settings.hdp.xml -Dtest=$2 -Dqfile=$3 -Dmaven.repo.local=/Users/vgarg/.m2/repository.hdp -Phadoop-2 -Dhadoop-23.version=3.1.1.3.1.0.0-${BUILD_NUMBER} -Dhbase.version=2.0.2.3.1.0.0-${BUILD_NUMBER} -Dzookeeper.version=3.4.6.3.1.0.0-${BUILD_NUMBER} -Dcalcite.version=1.16.0.3.1.0.0-${BUILD_NUMBER} -Dtez.version=0.9.1.3.1.0.0-${BUILD_NUMBER} -Daccumulo.version=1.7.0.3.1.0.0-${BUILD_NUMBER} -Dhbase.hadoop2.version=2.0.2.3.1.0.0-${BUILD_NUMBER} -Davatica.version=1.10.0.3.1.0.0-${BUILD_NUMBER} -Dpig.version=0.16.0.3.1.0.0-${BUILD_NUMBER} -Dhadoop.version=3.1.1.3.1.0.0-${BUILD_NUMBER} -Dorc.version=1.5.1.3.1.0.0-${BUILD_NUMBER} -Ddruid.version=0.12.1.3.1.0.0-${BUILD_NUMBER} -Dtest.output.overwrite=true
}


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
