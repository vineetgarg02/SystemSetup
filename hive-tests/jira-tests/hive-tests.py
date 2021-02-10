from jira import JIRA
import re
import subprocess
import sys

testMap = {}

def executeTest(mvnCommand):
    for key in testMap:
        #testCommand = 'mvn test -Dtest=' + key + ' -Dqfile=' + testMap[key] + ' -Dtest.output.overwrite=true -Dmaven.repo.local=/Users/vgarg/.m2/repository.cdp'
        testCommand = mvnCommand + ' -Dtest=' + key + ' -Dqfile=' + testMap[key] + ' -Dtest.output.overwrite=true'
        print('Executing command: ' + testCommand)
        response = raw_input('Run this command?(Y/y)?')
        if response in ['y', 'Y']:
            subprocess.call(testCommand, shell=True)


def displayMap():
    for key in testMap:
        print(key)
        print(testMap[key])

def putInMap(testDriver, testName):
    if testDriver in testMap:
        currVal = testMap[testDriver]
        testMap[testDriver] = currVal + ',' + testName + '.q'
    else:
        testMap[testDriver] = testName + '.q'
	

def executeTests(lines, mvnCommand):
    pattern='org.apache.hadoop.hive.cli.(.*).testCliDriver\[(.*)\].*'
    for line in lines:
        matchObj = re.match(pattern, line, re.I|re.M)
        if matchObj:
            testDriver = matchObj.group(1)
            testName = matchObj.group(2)
            print(testDriver + "\t" + testName)
            putInMap(testDriver, testName)
    response = raw_input('Continue running above tests?(Y/y)')
    if response in [ 'y', 'Y']:
            executeTest(mvnCommand)


def runTests(issueNo, commentNum):
    options = {
    'server': 'https://issues.apache.org/jira'}
    
    jira = JIRA(options)
    issue = jira.issue(issueNo)

    if issue:
        print("Found the issue")
        all_hiveqa_comments = [comment for comment in issue.fields.comment.comments
                if re.search('^hiveqa$', comment.author.name)]
        if all_hiveqa_comments:
            print("Found last run by HiveQA")
            qa_comment_text = all_hiveqa_comments[commentNum].body
            lines = qa_comment_text.splitlines()
            return lines
            


if len(sys.argv) == 3:
    issueNo = raw_input('Enter Hive jira# (hint: HIVE-XXXXX): ')
    commentNum = raw_input('Which comment?')
    mvnCommand = 'mvn test '
    lines = runTests(issueNo, int(commentNum))

else:
    fileName = sys.argv[1]
    f = open(fileName, 'r');
    lines = f.readlines()
    mvnCommand = 'mvn test -Dmaven.repo.local=/Users/vgarg/.m2/repository.cdp '
executeTests(lines, mvnCommand);




