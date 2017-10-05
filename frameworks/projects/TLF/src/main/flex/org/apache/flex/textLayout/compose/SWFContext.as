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
package org.apache.royale.textLayout.compose {
	import org.apache.royale.textLayout.compose.ISWFContext;

	public class SWFContext implements ISWFContext {
		public function callInContext(fn : Function, thisArg : Object, argArray : Array, returns : Boolean = true) : * {
		}
		public static function get globalSWFContext():ISWFContext
		{ 
			return GlobalSWFContext.globalSWFContext; 
		}
	}
}
import org.apache.royale.textLayout.compose.ISWFContext;
import org.apache.royale.textLayout.debug.Debugging;
class GlobalSWFContext implements ISWFContext
{
	public function GlobalSWFContext()
	{ }

	static public const globalSWFContext:GlobalSWFContext = new GlobalSWFContext();
	
	public function callInContext(fn:Function, thisArg:Object, argsArray:Array, returns:Boolean=true):*
	{
		CONFIG::debug
		{
			var rslt:*;
			try
			{
				if (returns)
					rslt = fn.apply(thisArg, argsArray);

				else
					fn.apply(thisArg, argsArray);
					
				if (thisArg)
				{
					var traceArgs:Array;
					// later make this table driven
					if (thisArg.hasOwnProperty("createTextLine") && fn == thisArg["createTextLine"])
					{
						traceArgs = [rslt,thisArg,"createTextLine"];
						traceArgs.push.apply(traceArgs, argsArray);
						Debugging.traceFTECall.apply(null,traceArgs);
					}
					else if (thisArg.hasOwnProperty("recreateTextLine") && fn == thisArg["recreateTextLine"])
					{
						traceArgs = [rslt,thisArg,"recreateTextLine"];
						traceArgs.push.apply(traceArgs, argsArray);
						Debugging.traceFTECall.apply(null,traceArgs);
					}
				}
			}
			catch(e:Error)
			{
				// trace(e);
				throw(e);
			}
			return rslt;
		}
		CONFIG::release
		{
			if (returns)
				return fn.apply(thisArg, argsArray);
			fn.apply(thisArg, argsArray);
		}
	}
}
