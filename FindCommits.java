// build map of commits in cdpd
// go over commits of upstrea master and report the ones not in cdpd, report total count as well

import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;

import java.lang.String;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import java.util.logging.Level;
import java.util.logging.Logger;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

class FindCommits {
  //map of cdpd commits
  //list of upstrea master commits
  //
  //
  static Pattern jiraPattern = Pattern.compile("HIVE-\\d+");

  static Logger logger = Logger.getLogger(FindCommits.class.getName());

  private Map<String, String> findCommitsNotInMap(final Map<String, String> upstreamCommits, final Map<String, String> cdpdCommits) {
    logger.log(Level.INFO, "Size of upstream commits: " + upstreamCommits.size() + ". Size of cdpd commits: " + cdpdCommits.size());
    Map<String, String> notCommitted= new HashMap<>();
    for(Map.Entry<String, String> entry:upstreamCommits.entrySet()) {
      if(!cdpdCommits.containsKey(entry.getKey())) {
        notCommitted.put(entry.getKey(), entry.getValue());
      }
    }
    //logger.log(Level.INFO, "Jiras not committed " + notCommitted );
    return notCommitted;
  }

  private String parseJiraFromMsg(final String commitMsg){
    Matcher jiraMatcher = jiraPattern.matcher(commitMsg);
    if(jiraMatcher.find()) {
      String jiraFound = jiraMatcher.group(0);
      //logger.log(Level.INFO, "Commit msg: " + commitMsg + ". jira found: " + jiraFound); 
      //System.out.println("Commit msg: " + commitMsg + ". jira found: " + jiraFound); 
      return jiraFound;
    }
    //System.out.println("Commit msg: " + commitMsg + ". jira not found: "); 
    return null;
  }

  private Map<String, String> parseAndFindCommitInFile(final String filePath) throws IOException{
    BufferedReader inputStream = null;
    Map<String, String> parsedJiras = new HashMap<>();

    try {
      inputStream = new BufferedReader(new FileReader(filePath));
      String line = inputStream.readLine();
      while (line != null) {
        String pJira = parseJiraFromMsg(line);
        if(pJira != null) {
          parsedJiras.put(pJira, line);
        }
        line = inputStream.readLine();
      }
    } catch (Exception e) {
      System.out.println(e);
    } finally {
      if(inputStream != null) {
        inputStream.close();
      }
    }
  return parsedJiras;
  }

  public static void main(String[] args) {
    if(args.length != 2) {
      System.out.println("Ilegal number of arguments. Usage: FindCommits <upstream commmit file> <cdpd commit file>");
      return;
    }

    final String upstreamFile = args[0];
    final String cdpdFile = args[1];

    FindCommits findCommits = new FindCommits();

    try {
      Map<String, String> upstreamCommits = findCommits.parseAndFindCommitInFile(upstreamFile);
      Map<String, String> cdpdCommits = findCommits.parseAndFindCommitInFile(cdpdFile);
      Map<String, String> notCommittedJiras = findCommits.findCommitsNotInMap(upstreamCommits, cdpdCommits);
      System.out.println("Total number of commits not in CDPD: " + notCommittedJiras.size());

      for(Map.Entry<String, String> entry:notCommittedJiras.entrySet()) {
        System.out.println(entry.getValue());
      }
    } catch (Exception e) {
      System.out.print(e);
    }

  }
}
