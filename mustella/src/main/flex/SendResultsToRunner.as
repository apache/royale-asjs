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
import flash.utils.*;
import flash.events.Event;
}

[Mixin]
/**
 *  A "marker" class that causes test scripts to write out
 *  bitmaps to the urls instead of reading and comparing
 *  so that baselines/reference-points can be created for
 *  future comparing.
 */
public class SendResultsToRunner 
{

	/**
	 *  Mixin callback that gets everything ready to go.
	 *  The UnitTester waits for an event before starting
	 */
    COMPILE::SWF
	public static function init(root:DisplayObject):void
	{
		TestOutput.getInstance().addEventListener ("result", urlSender);
	}


	public static var midURL:String  = "";


	public static var regExp5:RegExp = /%3D/g;

	public static var msgQueue:Array = [];

    COMPILE::SWF
	public static var u:URLLoader;
	
	/**
  	 * the way out for the result data
	 */
    COMPILE::SWF
	public static function urlSender (event:Event):void 
	{ 

		var s:String = (event as MustellaLogEvent).msg;

		var baseURL:String  = "http://localhost:" + UnitTester.runnerPort;

		/// trace it anyway
		trace (s);

		/// Notice what we've got. Send along to Runner if relevant
		var loc:uint;
		var final:String = "";

		var skip:Boolean = false;
		var noSend:Boolean = false;

		if ( (loc =  s.indexOf ("RESULT: ")) != -1) { 
			s = s.substr (loc + 8);
			midURL = "/testCaseResult";
		} else if ( (loc =  s.indexOf ("ScriptComplete:")) != -1) { 
			midURL = "/ScriptComplete";
			final = "?" + UnitTester.excludedCount;
			skip = true;
		} else if ( (loc =  s.indexOf ("LengthOfTestcases:")) != -1) { 
			midURL = "/testCaseLength?";
			final = s.substring (loc+ "LengthOfTestcases:".length+1);
			skip = true;
		} else if ( (loc = s.indexOf ("TestCase Start:")) != -1) { 
			/// not relevant
			s = s.substr (loc + 15);
			s = s.replace (" ", "");
			midURL = "/testCaseStart?" + s ;
			skip = true;
		} else  { 
			noSend = true;
		}


		if (!skip) { 

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
			for (i=0;i<hdrs.length;i++) { 
		
				if (final =="")
					final="?" + escape(hdrs[i]);
				else
					final+="&" + escape(hdrs[i]);
			}
	
			final = final.replace (regExp5, "=");
	
		}

		/**
		 * Probably we don't need to use URLLoader, since we don't care 
		 * about the response, but for now, for debugging, using it
		 */
		if (!noSend) { 
			// var u:String= baseURL + midURL + final;
			if (!u)
			{
				u = new URLLoader ();

				/*	
				var sock:Socket = new Socket ("localhost",  UnitTester.runnerPort);
				sock.writeUTFBytes(u);
				sock.flush();
				sock.flush();
				*/
			
				u.addEventListener("complete", completeHandler);
				u.addEventListener("complete", httpEvents);
				u.addEventListener("ioError", httpEvents);
				u.addEventListener("open", httpEvents);
				u.addEventListener("progress", httpEvents);
				u.addEventListener("httpStatus", httpEvents);
				u.addEventListener("securityError", httpEvents);
			}
			queueMsg(baseURL + midURL + final);
			UnitTester.pendingOutput++;
		}
	}

    COMPILE::SWF
	public static function queueMsg(s:String):void
	{
		msgQueue.push(s);
		if (msgQueue.length == 1)
		{
			trace ("sending: " + s + " at: " + new Date());
			u.load (new URLRequest (s));
		}
		else
			trace ("queuing: " + s + " at: " + new Date());
	}
	
    COMPILE::SWF
	public static function completeHandler (e:Event):void  {
		UnitTester.pendingOutput--;
		msgQueue.shift();
		if (msgQueue.length > 0)
		{
			var s:String = msgQueue[0];
			u.load (new URLRequest (s));
			trace ("sending: " + s + " at: " + new Date());
		}
	}

    COMPILE::SWF
	public static function httpEvents (e:Event):void  {
		trace (e);
	}

}
}
