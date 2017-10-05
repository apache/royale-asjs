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
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.IEventDispatcher;
}
COMPILE::JS
{
    import org.apache.royale.events.EventDispatcher;
}
/**
 *  The class that handles redirectable output
 *  The default here is trace, but you can
 *  set the output handler to something else
 */
public class TestOutput extends EventDispatcher
{
	/** 
	 *  Send the string to the output handler
	 */
	public static function logResult(result:String):void
	{
        COMPILE::SWF
        {
		getInstance().dispatchEvent(new MustellaLogEvent ("result", result));
        }
	}


	private static var theInst:TestOutput = null;

    COMPILE::SWF
	public static function getInstance():TestOutput
	{
		if (theInst == null) {
			theInst = new TestOutput();
			trace ("Created new test output instance");
		}

		return theInst;
		
	}

	

	/**
	 *  By default, here, send the output to trace. Mixin something else, and 
	 *  with its own outputHandler function to override this.
	 */
    COMPILE::SWF
	public static var outputHandler:Function = function(s:String):void {trace(s)};

}

}
