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
	public class ContainerPosition extends StyleBeadBase
	{
		public function ContainerPosition()
		{
			super();
		}
		
		private var _justifyContent:String;
		/**
		 * Applicabale for both flex and grid containers.
		 * Defines the alignment along the main axis.
		 * The main axis is defined by the flex-direction or grid-auto-flow property.
		 * By default, the main axis is the horizontal axis (row).
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		[Inspectable(category="General", enumeration="flex-start,flex-end,center,space-between,space-around,space-evenly,stretch,baseline,normal", defaultValue="")]
		public function get justifyContent():String
		{
			return _justifyContent;
		}
		public function set justifyContent(value:String):void
		{
			_justifyContent = value;
		}

		private var _alignItems:String;
		/**
		 * Applicabale for both flex and grid containers.
		 * Defines the default alignment for items along the cross axis.
		 * The cross axis is perpendicular to the main axis.
		 * By default, the cross axis is the vertical axis (column).
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		[Inspectable(category="General", enumeration="flex-start,flex-end,center,baseline,last baseline,stretch", defaultValue="")]
		public function get alignItems():String
		{
			return _alignItems;
		}
		public function set alignItems(value:String):void
		{
			_alignItems = value;
		}

		private var _justifyItems:String;
		[Inspectable(category="General", enumeration="start,end,center,stretch,normal", defaultValue="")]
		/**
		 * Applicabale for grid containers.
		 * Defines the default alignment for items along the main axis.
		 * The main axis is defined by the flex-direction or grid-auto-flow property.
		 * By default, the main axis is the horizontal axis (row).
		 */
		public function get justifyItems():String
		{
			return _justifyItems;
		}
		public function set justifyItems(value:String):void
		{
			_justifyItems = value;
		}

		private var _alignContent:String;
		[Inspectable(category="General", enumeration="normal,center,flex-start,flex-end,space-between,space-around,space-evenly,baseline,stretch", defaultValue="")]
		/**
		 * Applicabale for grid containers.
		 * Defines the alignment of the grid within the grid container when the size of the grid is smaller than the size of the container.
		 * The main axis is defined by the flex-direction or grid-auto-flow property.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		public function get alignContent():String
		{
			return _alignContent;
		}

		public function set alignContent(value:String):void
		{
			_alignContent = value;
		}

		private var _placeContent:String;

		[Inspectable(category="General", enumeration="center,start,end,space-between,space-around,space-evenly,baseline,stretch", defaultValue="")]
		/**
		 * Applicabale for grid containers.
		 * A shorthand property for align-content and justify-content.
		 * The main axis is defined by the flex-direction or grid-auto-flow property.
		 * By default, the main axis is the horizontal axis (row).
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		public function get placeContent():String
		{
			return _placeContent;
		}

		public function set placeContent(value:String):void
		{
			_placeContent = value;
		}
		private var _placeItems:String;

		[Inspectable(category="General", enumeration="start,end,safe end,center,safe center,baseline,stretch", defaultValue="")]
		/**
		 * Applicabale for grid containers.
		 * A shorthand property for align-items and justify-items.
		 * The main axis is defined by the flex-direction or grid-auto-flow property.
		 * By default, the main axis is the horizontal axis (row).
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		public function get placeItems():String
		{
			return _placeItems;
		}

		public function set placeItems(value:String):void
		{
			_placeItems = value;
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
			var safeStr:String = safeSelector(justifyContent);
			var jcStr:String = ".justify-" + justifyContent + safeStr;
			 safeStr = safeSelector(alignItems);
			var aiStr:String = ".align-" + alignItems + safeStr;
			 safeStr = safeSelector(justifyItems);
			var jiStr:String = ".justify-items-" + justifyItems + safeStr;
			 safeStr = safeSelector(alignContent);
			var acStr:String = ".align-content-" + alignContent + safeStr;
			 safeStr = safeSelector(placeContent);
			var pcStr:String = ".place-content-" + placeContent + safeStr;
			 safeStr = safeSelector(placeItems);
			var piStr:String = ".place-items-" + placeItems + safeStr;
			
			var retVal:Array = [];
			if(justifyContent)
				retVal.push(jcStr);
			if(alignItems)
				retVal.push(aiStr);
			if(justifyItems)
				retVal.push(jiStr);
			if(alignContent)
				retVal.push(acStr);
			if(placeContent)
				retVal.push(pcStr);
			if(placeItems)
				retVal.push(piStr);
			return retVal;
		}
	
		override public function get rules():Array
		{
			var safeStr:String = safeRule(justifyContent);
			var jcStr:String = "justify-content" + safeStr + justifyContent;
			 safeStr = safeRule(alignItems);
			var aiStr:String = "align-items" + safeStr + alignItems;
			 safeStr = safeRule(justifyItems);
			var jiStr:String = "justify-items" + safeStr + justifyItems;
			 safeStr = safeRule(alignContent);
			var acStr:String = "align-content" + safeStr + alignContent;
			 safeStr = safeRule(placeContent);
			var pcStr:String = "place-content" + safeStr + placeContent;
			 safeStr = safeRule(placeItems);
			var piStr:String = "place-items" + safeStr + placeItems;
			
			var retVal:Array = [];
			if(justifyContent)
				retVal.push(jcStr);
			if(alignItems)
				retVal.push(aiStr);
			if(justifyItems)
				retVal.push(jiStr);
			if(alignContent)
				retVal.push(acStr);
			if(placeContent)
				retVal.push(pcStr);
			if(placeItems)
				retVal.push(piStr);
			return retVal;
		}
	}
}