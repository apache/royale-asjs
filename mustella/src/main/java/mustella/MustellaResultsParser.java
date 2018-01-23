/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package mustella;

import java.util.*;
import java.io.File;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.LineNumberReader;

/**
 * User: aharui
 * Date: Jun 21, 2005
 * Time: 2:55:16 PM
 * read flashlog.txt, look for failures, return 0 if none, otherwise some exit code
 */
public class MustellaResultsParser {

    public static void main(String args[]) {
        
        String filename;
        String flashlog = "/Macromedia/Flash Player/Logs/flashlog.txt";
        
        String osname = System.getProperty("os.name");
        if (osname.indexOf("Windows") != -1) {
            filename = System.getProperty("APPDATA") + flashlog;
        } else if (osname.indexOf("Mac OS") != -1) {
            filename = System.getProperty("user.home") + "/Library/Preferences" + flashlog;
        } else if (osname.indexOf("Unix") != -1 || osname.indexOf("Linux") != -1){
            filename = System.getProperty("user.home") + "/.macromedia/Flash_Player/Logs/flashlog.txt";
        } else {
            filename = System.getProperty("APPDATA") + flashlog;
        }
        
	
        boolean result = false;
				
        if (new File(filename).exists() == false) {
            System.out.println("result file not found: " + filename);
        } else {
			try {
				MustellaResultsParser p = new MustellaResultsParser(filename);
				result = p.parse();
			} catch(IOException e) {}
        }
        int exitValue = result ? 0 : 1;
        System.out.println("results: "+(result?"PASSED":"FAILED"));

		if (exitValue > 0)
			System.exit(exitValue);
    }

	private File file;

    public MustellaResultsParser(String filename) throws IOException {
		file = new File(filename);
        if (!file.isFile()) {
	        System.out.println("file " + filename + " not a file");
        }
    }

    public boolean parse() {
        boolean passed = true;

		LineNumberReader lnr;
		try {
			lnr = new LineNumberReader(new FileReader(file));
		} catch (FileNotFoundException fnfe) {
	        System.out.println("problem creating reader");
			return false;
		}

		String s;
		boolean scriptComplete = false;
		int numResults = 0;

		try {
			while ((s = lnr.readLine()) != null) {
				if (s.startsWith("RESULT: ")) {
					numResults++;
					int index = s.indexOf("result=") + 7;
					String result = s.substring(index, index + 4);
					if (!result.equals("pass")) {
						passed = false;
						index = s.indexOf("id=") + 3;
						int endIndex = s.indexOf(" ", index);
						result = s.substring(s.indexOf("id=") + 3, endIndex);
						System.out.println("test case " + result + " failed");
					}
				}
				else if (s.startsWith("OK: Root-level SWF loaded"))
				{
				}
				else if (s.startsWith("TestCase Start:"))
				{
				}
				else if (s.startsWith("requesting url:"))
				{
				}
				else if (s.startsWith("testComplete"))
				{
				}
				else if (s.startsWith("ScriptComplete:"))
				{
					scriptComplete = true;
				}
				else if (s.startsWith("Created new test output instance"))
				{
				}
				else if (s.startsWith("Send ScriptComplete"))
				{
				}
				else if (s.startsWith("Paused for"))
				{
				}
				else if (s.startsWith("Warning:"))
				{
				}
				else if (s.startsWith("LengthOfTestcases:"))
				{
				}		
				else if (s.startsWith("Created new test output"))
				{
				}		
				else if (s.startsWith("Send ScriptComplete"))
				{
				}		
				else if (s.startsWith("readPNG:requesting"))
				{
				}
				else if (s.startsWith("runid.properties ERROR handler with: [IOErrorEvent"))
				{
				}
				else if (s.startsWith("[IOErrorEvent type=\"ioError\"") && s.contains("localhost:9999/ScriptComplete"))
				{
				}
				else if (s.startsWith("Avertissement"))
				{
				}
				else if (s.trim().equals(""))
				{
				}
				else
				{
					System.out.println("Unexpected Trace: " + s);
					passed = false;
				}
			}
		} catch (IOException e) {
	        System.out.println("ioerror");
		}

		if (numResults == 0)
		{
	        System.out.println("No results.  Is trace output enabled?");
			passed = false;
		}
		else if (!scriptComplete)
		{
	        System.out.println("Script did not complete");
			passed = false;
		}

        return passed;
    }
}
