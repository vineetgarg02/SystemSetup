import java.util.Properties;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import java.io.FileReader;

class FindTestCliDriver {
  public FindTestCliDriver() {}

  //  map from test name to all driver names
  private Map<String, Set<String>> cliMap = null;

  private void initializeMap(final String fileName, final String testToFind) {
    if(cliMap != null) return;
    try {
      FileReader  reader = new FileReader(fileName);
      cliMap = new HashMap<>();

      Properties p = new Properties();
      p.load(reader);

      for(Map.Entry<Object, Object> entry:p.entrySet()) {
        String cliDriver = getCliDriverName((String)(entry.getKey()));
        String cliTests = (String)(entry.getValue());
        String[] allTests = cliTests.split(",");
          for(String test:allTests) {
            if(test.equals(testToFind)) {
              System.out.println(cliDriver);
            }
          }
      }
    } catch (Exception e) {
      System.out.print(e.getMessage());
    }
  }

  private String getCliDriverName(final String driver) {
    if("minitez.query.files.shared".equals(driver)){
      return "TestMiniTezCliDriver + TestCliDriver";
    } else if("minitez.query.files".equals(driver)){
      return "TestMiniTezCliDriver";
    } else if("minillap.shared.query.files".equals(driver)){
      return "TestMiniLlapCliDriver + TestCliDriver";
    } else if("minillaplocal.shared.query.files".equals(driver)) {
      return "TestMiniLlapLocalCliDriver + TestCliDriver";
    } else if("minillap.query.files".equals(driver)){
      return "TestMiniLlapCliDriver";
    } else if("minillaplocal.query.files".equals(driver)) {
      return "TestMiniLlapLocalCliDriver";
    }
    return driver;
  }

  private void prettyPrint() {
    for(Map.Entry<String, Set<String>> entry : cliMap.entrySet()) {
      System.out.println("Key: " + entry.getKey() +
         "Value = " );
      for(String val:entry.getValue()) {
        System.out.println(val);
      }
    }
  }

  public static void main(String[] args){
    if(args.length < 2) {
      System.out.print("Usage: FindTestCliDriver <filename> <testName>\n");
      return;
    }
    String inputFile = args[0];
    String testToFind = args[1];
    FindTestCliDriver ftcObj = new FindTestCliDriver();
    ftcObj.initializeMap(inputFile, testToFind);
    //ftcObj.prettyPrint();

    }

}
