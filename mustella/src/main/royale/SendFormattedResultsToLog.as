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
import flash.net.*;
import flash.events.Event;
}

[Mixin]
/**
 * Write formatted results to log for easy parsing
 */
public class SendFormattedResultsToLog
{

	/**
	 *  Mixin callback that gets everything ready to go.
	 *  The UnitTester waits for an event before starting
	 */
    COMPILE::SWF
	public static function init(root:DisplayObject):void
	{
		TestOutput.getInstance().addEventListener ("result", outputWriter);
	}


	public static var midURL:String  = "";


	public static var regExp5:RegExp = /%3D/g;



	/**
  	 * the way out for the result data
	 */
    COMPILE::SWF
	public static function outputWriter (event:Event):void 
	{ 

		var s:String = (event as MustellaLogEvent).msg;


		var loc:uint;
		var final:String = "";

		var skip:Boolean = false;
		var noSend:Boolean = false;

		/// this should be something like |, because it is confusing this way
		/// putting it on, taking it off
		s=s.replace (" msg=", "|msg=");

		s=s.replace (" result=", "|result=");
		s=s.replace (" phase=", "|phase=");
		s=s.replace (" id=", "|id=");
		s=s.replace (" elapsed=", "|elapsed=");
		s=s.replace (" started=", "|started=");
		s=s.replace (" extraInfo=", "|extraInfo=");

		var hdrs:Array = s.split ("|");
	
		var i:uint;
			// rebuild url encoded 
		for (i=0;i<hdrs.length;i++) 
		{ 
			if (final == "")
				final += hdrs[i];	
			else
				final+="&" + hdrs[i];
		}
	
		final = final.replace (regExp5, "=");

		trace (final);


		// exitWhenDone mixin doesn't really work with browsers. 
		// Tell the Runner that we're ending
		if (s.indexOf ("ScriptComplete") != -1 ) 
		{

			trace ("Send ScriptComplete to runner block");
			var u:URLLoader = new URLLoader ();
			u.addEventListener("complete", httpEvents);
			u.addEventListener("ioError", httpEvents);
			u.load(new URLRequest ("http://localhost:" + UnitTester.runnerPort + "/ScriptComplete"));
		}
	
		

	}
    
    COMPILE::SWF
	public static function httpEvents (e:Event):void  {
		trace (e);
	}



}
}
