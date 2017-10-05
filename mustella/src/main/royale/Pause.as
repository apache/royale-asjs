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

import flash.display.DisplayObject;
import flash.utils.setTimeout;

import mx.core.mx_internal;
use namespace mx_internal;

/**
 *  The test step that sets a property to some value
 *  MXML attributes:
 *  
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout 
 */
public class Pause extends TestStep
{
    public var reason:String;
    
	override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		this.root = root;
		this.context = context;
		this.testCase = testCase;
		this.testResult = testResult;

		setTimeout(stepComplete, timeout);
		TestOutput.logResult(this.toString());

		return false;
	}

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
	    var s:String = "Paused for " + timeout + "ms.";
	    
	    if(this.reason != null)
	        s = s + " Reason: " + this.reason;

		return s;
	}
}

}
