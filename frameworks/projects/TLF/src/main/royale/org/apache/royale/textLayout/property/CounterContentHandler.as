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
package org.apache.royale.textLayout.property
{
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.ListElement;	
	
	// [ExcludeClass]
	public class CounterContentHandler extends PropertyHandler
	{
		override public function get className():String
		{
			return "CounterContentHandler";
		}
		// check to see if this handler has a custom exporter that must be used when owningHandlerCheck is true
		public override function get customXMLStringHandler():Boolean
		{ return true; }
		
		public override function toXMLString(val:Object):String
		{ 
			if (val.hasOwnProperty("counter"))
				return val.ordered == null ? "counter(ordered)" : "counter(ordered," + val.ordered + ")";
			if (val.hasOwnProperty("counters"))
			{
				var rslt:String = "counters(ordered";
				if (val.suffix != null)
				{
					rslt += ",\"" + val.suffix + "\"";
					if (val.ordered)
						rslt += "," + val.ordered;
				}
				rslt += ")";
				return rslt;
			}
			return val.toString();
		}
		
		/** matches counter(ordered) */
		static private  const _counterContentPattern1:RegExp = /^\s*counter\s*\(\s*ordered\s*\)\s*$/;
		/** matches counter(ordered,ListStyleType) */
		static private  const _counterContentPattern2:RegExp = /^\s*counter\s*\(\s*ordered\s*,\s*\S+\s*\)\s*$/;
		
		/** matches counters(ordered) */
		static private  const _countersContentPattern1:RegExp = /^\s*counters\s*\(\s*ordered\s*\)\s*$/;
		/** matches counters(ordered,"suffix") */
		static private  const _countersContentPattern2:RegExp = /^\s*counters\s*\(\s*ordered\s*,\s*".*"\s*\)\s*$/;
		/** matches counters(ordered,"suffix",ListStyleType) */
		static private  const _countersContentPattern3:RegExp = /^\s*counters\s*\(\s*ordered\s*,\s*".*"\s*,\s*\S+\s*\)\s*$/;
		
		// return a value if this handler "owns" this property - otherwise return undefined
		public override function owningHandlerCheck(newVal:*):*
		{ 
			var listStyleType:String;
			
			// check for the more efficient parsed representation
			if (!(newVal is String))
				return newVal.hasOwnProperty("counter") || newVal.hasOwnProperty("counters") ? newVal : undefined;
			
			if (_counterContentPattern1.test(newVal))
				return newVal;
			
			if (_counterContentPattern2.test(newVal))
			{
				// need to validate the specified listStyleType
				listStyleType = extractListStyleTypeFromCounter(newVal);
				return ListElement.listSuffixes[listStyleType] !== undefined ? newVal : undefined;
			}
			
			if (_countersContentPattern1.test(newVal))
				return newVal;
			
			if (_countersContentPattern2.test(newVal))
				return newVal;
			
			if (_countersContentPattern3.test(newVal))
			{
				listStyleType = extractListStyleTypeFromCounters(newVal);
				return ListElement.listSuffixes[listStyleType] !== undefined ? newVal : undefined;
			}
			
			return undefined;
		}
		
		static private const _counterBeginPattern:RegExp = /^\s*counter\s*\(\s*ordered\s*,\s*/g;
		static private const _trailingStuff:RegExp = /\s*\)\s*/g;
			
		/** @private - from _counterContentPattern2  counters(ordered,"suffix") */
		static public function extractListStyleTypeFromCounter(s:String):String
		{
			CONFIG::debug { assert(_counterContentPattern2.test(s),"Bad Parameter to extractListStyleTypeFromCounter"); }
			_counterBeginPattern.lastIndex = 0;
			_counterBeginPattern.test(s);
			s = s.substr(_counterBeginPattern.lastIndex);

			_trailingStuff.lastIndex = 0;
			_trailingStuff.test(s);
			s = s.substr(0,_trailingStuff.lastIndex-1);

			return s;
		}
		
		static private const _countersTillSuffixPattern:RegExp = /^\s*counters\s*\(\s*ordered\s*,\s*"/g;
		static private const _afterSuffixPattern2:RegExp = /^"\s*\)\s*$/;

		/** @private - from _countersContentPattern2  */
		static public function extractSuffixFromCounters2(s:String):String
		{
			CONFIG::debug { assert(_countersContentPattern2.test(s),"Bad Parameter to extractListStyleTypeFromCounter2"); }
			_countersTillSuffixPattern.lastIndex = 0;
			_countersTillSuffixPattern.test(s);
			s = s.substr(_countersTillSuffixPattern.lastIndex);
			
			var rslt:String = "";
			while (!_afterSuffixPattern2.test(s))
			{
				rslt += s.substr(0,1);
				s = s.substr(1);
			}
			
			return rslt;
		}	
		
		static private const _afterSuffixPattern3:RegExp = /^"\s*,\s*\S+\s*\)\s*$/;
		
		static public function extractSuffixFromCounters3(s:String):String
		{
			CONFIG::debug { assert(_countersContentPattern3.test(s),"Bad Parameter to extractListStyleTypeFromCounter2"); }
			_countersTillSuffixPattern.lastIndex = 0;
			_countersTillSuffixPattern.test(s);
			s = s.substr(_countersTillSuffixPattern.lastIndex);
			
			var rslt:String = "";
			while (!_afterSuffixPattern3.test(s))
			{
				rslt += s.substr(0,1);
				s = s.substr(1);
			}
			
			return rslt;
		}
		
		static private const _countersTillListStyleTypePattern:RegExp = /^\s*counters\s*\(\s*ordered\s*,\s*".*"\s*,\s*/g;
		
		/** @private - from _countersContentPattern2 */
		static public function extractListStyleTypeFromCounters(s:String):String
		{
			CONFIG::debug { assert(_countersContentPattern3.test(s),"Bad Parameter to extractListStyleTypeFromCounter"); }
			_countersTillListStyleTypePattern.lastIndex = 0;
			_countersTillListStyleTypePattern.test(s);
			s = s.substr(_countersTillListStyleTypePattern.lastIndex);
			
			_trailingStuff.lastIndex = 0;
			_trailingStuff.test(s);
			s = s.substr(0,_trailingStuff.lastIndex-1);
			
			return s;
		}
			
		/** parse the input string and create a valid input value */
		public override function setHelper(newVal:*):*
		{ 
			var s:String = newVal as String;
			
			var listStyleType:String;
			var suffix:String;
			
			if (s == null)
				return newVal;	// assume its an object that's been parsed already
			
			if (_counterContentPattern1.test(newVal))
				return { counter:"ordered" }; 

			if (_counterContentPattern2.test(newVal))
			{
				listStyleType = extractListStyleTypeFromCounter(newVal);
				return { counter:"ordered", ordered:listStyleType };
			}
			
			if (_countersContentPattern1.test(newVal))
				return { counters:"ordered" }; 
			
			if (_countersContentPattern2.test(newVal))
			{
				suffix = extractSuffixFromCounters2(newVal);
				return { counters:"ordered", suffix:suffix }; 
			}
			
			if (_countersContentPattern3.test(newVal))
			{
				listStyleType = extractListStyleTypeFromCounters(newVal);
				suffix = extractSuffixFromCounters3(newVal);
				return { counters:"ordered", suffix:suffix, ordered:listStyleType };
			}
			
			return undefined;
		}
	}
}
