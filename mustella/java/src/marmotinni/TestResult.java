/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


package marmotinni;

import java.util.Date;

/**
 *  The class that collects TestResults for a TestCase
 */
public class TestResult 
{
	
	public static final int PASS = 0;
	public static final int FAIL = 1;
	public static final int ERROR = 2;
	
	public static final int SETUP = 0;
	public static final int BODY = 1;
	public static final int CLEANUP = 2;
	
	/** 
	 *  testID
	 */
	public String testID;
	
	/** 
	 *  begin time
	 */
	public long beginTime;
	
	/** 
	 *  end time
	 */
	public long endTime;
	
	/** 
	 *  result
	 */
	public int result = -1;  // "pass", "fail", "error"
	
	/** 
	 *  message. Failures often have messages
	 */
	public String message = "";
	
	/** 
	 *  extraInfo: failures may have a file associated 
	 */
	public String extraInfo = "";
	
	/** 
	 *  Name of the Script associated with this result
	 */
	public String scriptName = "";
	
	/** 
	 *  phase. how far the test finished. setup, body, cleanup
	 */
	public int phase = -1;
	
	/** 
	 *  get printable version of phase
	 */
	public static String getPhaseString(int val) { 
		if (val == CLEANUP) {
			return "cleanup";
		}else if (val == BODY) {
			return "body";
		}else if (val == SETUP) {
			return "setup";
			
		}
		return "no phase set";
	}
	
	/** 
	 *  get printable version of result
	 */
	public static String getResultString(int val) { 
		if (val == PASS) {
			return "pass";
		}else if (val == FAIL) {
			return "fail";
		}else if (val == ERROR) {
			return "error";
		}
		return null;
	}
	
	
	/** 
	 *  default output look
	 */
	public String toString() 
	{ 
		return "RESULT: scriptName=" + scriptName + " id=" + testID + " result=" + getResultString(result)  + " elapsed=" + (endTime-beginTime) + " phase=" + getPhaseString(phase) + " started=" + beginTime + " extraInfo=" + extraInfo + " msg=" + message ;
	}
	
	
	public boolean hasStatus() { 
		return (result != -1);
	}
	
	
	public void doFail (String msg) {
		doFail(msg, null, null, 0);
	}
	
	public void doFail (String msg, String extraInfo) { 
		doFail(msg, extraInfo, null, 0);
	}
	
	public void doFail (String msg, String extraInfo, TestStep lastStep, int lastStepLine) { 
		// first failure is the one we keep
		if (this.result != FAIL)
		{
			this.result = FAIL;
			// this.message = msg;
			if (lastStep != null)
			{ 
				String tmp = lastStep.toString().substring(0, lastStep.toString().indexOf (":")) + "(" + getPhaseString(phase) + ":step " + (lastStepLine + 1) + ") ";
				this.message = tmp + " " + msg;
			} 
			else 
			{
				this.message = msg;
			}
			this.extraInfo = extraInfo;
		}
	}
	
	
}
