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
package org.apache.royale.textLayout.property {
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.TabStopFormat;
		
	// [ExcludeClass]
	/** Property for tab stops. Extends ArrayProperty; setter takes a string representation of tab stops in addition to an array. @private */
	public class TabStopsProperty extends ArrayProperty
	{
		public function TabStopsProperty(nameValue:String, defaultValue:Array, inherited:Boolean, categories:Vector.<String>)
		{ 
			super(nameValue, defaultValue, inherited, categories, TabStopFormat);
		}
			
		/** Helper function when setting the property */
		public override function setHelper(currVal:*,newVal:*):*
		{
			// null is a real value - DO NOT map to undefined like the others
			
			// null, undefined and INHERIT are all valid for arrays
			if (newVal == null || newVal == FormatValue.INHERIT)
				return newVal;
				
			// Accepts either an array or a string representation
			var tabStops:Array;
			if (newVal is Array)
			{
				tabStops = newVal as Array;
				if (!checkArrayTypes(tabStops))
				{
					PropertyUtil.errorHandler(this,newVal);
					return currVal;
				}
			}
			else
			{
				var valString:String = newVal as String;
				if (!valString)
				{
					PropertyUtil.errorHandler(this,newVal);
					return currVal;
				}
					
				// Parse the string representation and create an equivalent array
				tabStops = [];
				
				// Replace escape sequences (\ followed by a space or \) with placeholder strings
				// that can't naturally occur in the passed-in string 
				valString = valString.replace(_escapeBackslashRegex, _backslashPlaceHolder);
				valString = valString.replace(_escapeSpaceRegex, _spacePlaceHolder);
				
				_tabStopRegex.lastIndex = 0;
				var lookup:Object = {
					"s":"start",
					"c":"center",
					"e":"end",
					"d":"decimal"
				};
				do
				{
					var result:Object = _tabStopRegex.exec(valString);
					if (!result)
						break; // no more matches
						
					var tabStop:TabStopFormat = new TabStopFormat();
					tabStop.alignment = lookup[result[1].toLowerCase()] || "start";
					// switch (result[1].toLowerCase())
					// {
					// 	case "s":
					// 	case "": // START is the default
					// 		tabStop.alignment = "start";
					// 		break;
					// 	case "c":
					// 		tabStop.alignment = "center";
					// 		break;
					// 	case "e":
					// 		tabStop.alignment = "end";
					// 		break;
					// 	case "d":
					// 		tabStop.alignment = "decimal";
					// 		break;
					// }
					
					var position:Number = Number(result[2]); 
					if (isNaN(position))
					{
						PropertyUtil.errorHandler(this,newVal);
						return currVal;
					}
					tabStop.position = position;

					if (tabStop.alignment == "decimal")
					{
						if (result[3] == "")
							tabStop.decimalAlignmentToken = "."; //default
						else
						{
							// strip the leading vertical bar and restore \ and space characters where intended
							tabStop.decimalAlignmentToken = result[3].slice(1).replace(_backslashPlaceholderRegex, "\\");
							tabStop.decimalAlignmentToken = tabStop.decimalAlignmentToken.replace(_spacePlaceholderRegex, " ");
						}
					}
					//This was originally a check for an empty string but it appears to be undefined in Javascript
					else if (result[3])
					{
						PropertyUtil.errorHandler(this,newVal);
						return currVal; // if alignment is not decimal, the alignment token is not allowed
					}
						
					tabStops.push(tabStop);
				
				} while (true);
			
			}

			return tabStops.sort(compareTabStopFormats);
		}
		
		/** @private */
		public override function toXMLString(val:Object):String
		{
			var str:String = "";
			var lookup:Object = {
				"start":"s",
				"center":"c",
				"end":"e",
				"decimal":"d"
			};
			var tabStops:Array = val as Array;
			for each (var tabStop:TabStopFormat in tabStops)
			{
				if (str.length)
					str += " ";
				str += lookup[tabStop.alignment];
				// switch (tabStop.alignment)
				// {
				// 	case TabAlignment.START:
				// 		str += "s";
				// 		break;
				// 	case TabAlignment.CENTER:
				// 		str += "c";
				// 		break;
				// 	case TabAlignment.END:
				// 		str += "e";
				// 		break;
				// 	case TabAlignment.DECIMAL:
				// 		str += "d";
				// 		break;
				// }
				
				str += tabStop.position.toString();
				
				if (tabStop.alignment == "decimal")
				{
					var escapedAlignmentToken:String = tabStop.decimalAlignmentToken.replace(_backslashRegex, "\\\\");
					escapedAlignmentToken = escapedAlignmentToken.replace(_spaceRegex, "\\ ");
					str += "|" + escapedAlignmentToken;
				}
			}
			
			return str;
		}
		
		private static function compareTabStopFormats(a:TabStopFormat, b:TabStopFormat):Number
		{
			return a.position == b.position ? 0 : a.position < b.position ? -1 : 1;
		}
		
		// Alignment type: [sScCeEdD]?  - Atmost 1 occurance of one of s/c/e/d (or upper-case equivalents)
		// Position: [^| ]+ - At least character which is not a space or | (further validation is done by the Number constructor)
		// Alignment token and separator:(|[^ ]*)? - Atmost one occurance of a | followed by 0 or more non-space characters
		// Delimiter: ( |$) - A space or end-of-string
		private static const _tabStopRegex:RegExp = /([sScCeEdD]?)([^| ]+)(|[^ ]*)?( |$)/g;
		private static const _escapeBackslashRegex:RegExp = /\\\\/g;
		private static const _escapeSpaceRegex:RegExp = /\\ /g;
		private static const _backslashRegex:RegExp = /\\/g;
		private static const _spaceRegex:RegExp = / /g;
		private static const _backslashPlaceholderRegex:RegExp = new RegExp("\\" + "uE000", "g");
		private static const _spacePlaceholderRegex:RegExp = new RegExp("\\" + "uE001", "g");
		
		// Replace escape sequences (\ followed by a space or \) with placeholder strings
		// containing characters from Unicode private use area (won't naturally occur in the passed-in string) 
		private static const _backslashPlaceHolder:String = String.fromCharCode(0xE000);
		private static const _spacePlaceHolder:String = String.fromCharCode(0xE001);
				
	}
}
