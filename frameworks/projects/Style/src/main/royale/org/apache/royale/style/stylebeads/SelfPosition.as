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
package org.apache.royale.style.stylebeads
{
	public class SelfPosition extends StyleBeadBase
	{
		public function SelfPosition()
		{
			super();
		}
		
		private var _justifySelf:String;
		/**
		 * Applicabale for both flex and grid containers.
		 * Defines the alignment along the main axis.
		 * The main axis is defined by the flex-direction or grid-auto-flow property.
		 * By default, the main axis is the horizontal axis (row).
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		[Inspectable(category="General", enumeration="auto,start,center,end,stretch", defaultValue="")]
		public function get justifySelf():String
		{
			return _justifySelf;
		}
		public function set justifySelf(value:String):void
		{
			_justifySelf = value;
		}

		private var _alignSelf:String;
		/**
		 * Applicabale for both flex and grid containers.
		 * Defines the default alignment for items along the cross axis.
		 * The cross axis is perpendicular to the main axis.
		 * By default, the cross axis is the vertical axis (column).
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		[Inspectable(category="General", enumeration="auto,flex-start,flex-end,center,stretch,baseline,last baseline", defaultValue="")]
		public function get alignSelf():String
		{
			return _alignSelf;
		}
		public function set alignSelf(value:String):void
		{
			_alignSelf = value;
		}

		private var _placeSelf:String;

		[Inspectable(category="General", enumeration="auto,start,center,end,stretch", defaultValue="")]
		/**
		 * Applicabale for grid containers.
		 * A shorthand property for align-content and justify-content.
		 * The main axis is defined by the flex-direction or grid-auto-flow property.
		 * By default, the main axis is the horizontal axis (row).
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		public function get placeSelf():String
		{
			return _placeSelf;
		}

		public function set placeSelf(value:String):void
		{
			_placeSelf = value;
		}

		public var safe:Boolean = false;
		private function needsSafe(val:String):Boolean
		{
			if(!safe)
				return false;
			return val == "end" || val == "center" || val == "flex-end";
		}
		private function safeSelector(val:String):String
		{
			if(!safe)
				return "";
			return needsSafe(val) ? "-safe" : "";
		}
		private function safeRule(val:String):String
		{
			if(!safe)
				return "";
			return needsSafe(val) ? ": safe " : ": ";
		}
		override public function get selectors():Array
		{
			var safeStr:String = safeSelector(justifySelf);
			var jsStr:String = ".justify-" + justifySelf + safeStr;
			 safeStr = safeSelector(alignSelf);
			var asStr:String = ".align-" + alignSelf + safeStr;
			 safeStr = safeSelector(placeSelf);
			var psStr:String = ".place-self-" + placeSelf + safeStr;
			
			var retVal:Array = [];
			if(justifySelf)
				retVal.push(jsStr);
			if(alignSelf)
				retVal.push(asStr);
			if(placeSelf)
				retVal.push(psStr);
			return retVal;
		}
	
		override public function get rules():Array
		{
			var safeStr:String = safeRule(justifySelf);
			var jcStr:String = "justify-self" + safeStr + justifySelf;
			 safeStr = safeRule(alignSelf);
			var aiStr:String = "align-self" + safeStr + alignSelf;
			 safeStr = safeRule(placeSelf);
			var psStr:String = "place-self" + safeStr + placeSelf;
			
			var retVal:Array = [];
			if(justifySelf)
				retVal.push(jcStr);
			if(alignSelf)
				retVal.push(aiStr);
			if(placeSelf)
				retVal.push(psStr);
			return retVal;
		}
	}
}