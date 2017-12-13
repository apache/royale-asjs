////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package {

COMPILE::SWF
{
import flash.display.DisplayObject;
import flash.utils.*;
}

/**
 *  The class that collects TestResults for a TestCase
 */
public class TestResult 
{

	public static const PASS:int = 0;
	public static const FAIL:int = 1;
	public static const ERROR:int = 2;

	public static const SETUP:int=0;
	public static const BODY:int=1;
	public static const CLEANUP:int=2;

	/** 
	 *  testID
	 */
	public var testID:String;

	/** 
	 *  begin time
	 */
	public var beginTime:Number;

	/** 
	 *  end time
	 */
	public var endTime:Number;

	/** 
	 *  hang on to the context, ie, the script
	 */
	public var context:UnitTester;

	/** 
	 *  result
	 */
	public var result:int = -1;  // "pass", "fail", "error"

	/** 
	 *  message. Failures often have messages
	 */
	public var message:String = "";

	/** 
	 *  extraInfo: failures may have a file associated 
	 */
	public var extraInfo:String = "";

	/** 
	 *  Name of the Script associated with this result
	 */
	public var scriptName:String = "";

	/** 
	 *  phase. how far the test finished. setup, body, cleanup
	 */
	public var phase:int = -1;

	/** 
	 *  get printable version of phase
	 */
    COMPILE::SWF
	public static function getPhaseString(val:int):String { 
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
    COMPILE::SWF
	public static function getResultString(val:int):String { 
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
    COMPILE::SWF
	public function toString():String 
	{ 

		var className:String =  getQualifiedClassName (context);

		return "RESULT: scriptName="+context.testDir + className+" id="+ testID + " result=" + getResultString(result)  + " elapsed=" + (endTime-beginTime) + " phase=" + getPhaseString(phase) + " started=" + beginTime + " extraInfo=" + extraInfo + " msg=" + message ;
	}


	public function hasStatus():Boolean { 
		return (result != -1);
	}

	public function doFail (msg:String, extraInfo:String=null):void { 
        COMPILE::SWF
        {
		// first failure is the one we keep
		if (UnitTester.noFail)
		{
			return;	

		}
		if (this.result != FAIL)
		{
			this.result = FAIL;
			// this.message = msg;
			if (UnitTester.run_id == "-1")
			{ 
				var tmp:String = UnitTester.lastStep.toString().substr(0,UnitTester.lastStep.toString().indexOf (":")) + "(" +getPhaseString(phase) + ":step " + (UnitTester.lastStepLine+1) + ") ";
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
		

}
}
