import re
import subprocess

qualFile='/tmp/ptest.failures'
pattern='org.apache.hadoop.hive.cli.(.*).testCliDriver\[(.*)\].*'
testMap = {}


def executeTest():
    for key in testMap:
        testCommand = 'mvn test -Dtest=' + key + ' -Dqfile=' + testMap[key] + ' -Dtest.output.overwrite=true'
        print('Executing command: ' + testCommand)
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
	

def runTests():
    with open(qualFile) as f:
        line = f.readline()
        while line:
            matchObj = re.match(pattern, line, re.I|re.M)
            if matchObj:
                testDriver = matchObj.group(1)
                testName = matchObj.group(2)
                putInMap(testDriver, testName)
            line = f.readline()
    #displayMap()
    executeTest()

runTests()
