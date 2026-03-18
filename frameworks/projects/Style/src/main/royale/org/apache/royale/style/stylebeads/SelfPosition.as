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
	import org.apache.royale.style.stylebeads.flexgrid.JustifySelf;
	import org.apache.royale.style.stylebeads.flexgrid.AlignSelf;
	import org.apache.royale.style.stylebeads.flexgrid.PlaceSelf;

	public class SelfPosition extends CompositeStyle
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
		 * @productversion Royale 1.0.0
		 */
		[Inspectable(category="General", enumeration="auto,start,center,end,stretch", defaultValue="")]
		public function get justifySelf():String
		{
			return _justifySelf;
		}
		public function set justifySelf(value:String):void
		{
			if(!jutifySelfStyle)
			{
				jutifySelfStyle = new JustifySelf();
				addStyleBead(jutifySelfStyle);
			}
			_justifySelf = jutifySelfStyle.value = value;
		}
		private var jutifySelfStyle:JustifySelf;

		private var _alignSelf:String;
		/**
		 * Applicabale for both flex and grid containers.
		 * Defines the default alignment for items along the cross axis.
		 * The cross axis is perpendicular to the main axis.
		 * By default, the cross axis is the vertical axis (column).
		 * 
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		[Inspectable(category="General", enumeration="auto,flex-start,flex-end,center,safe center,safe flex-end,stretch,baseline,last baseline", defaultValue="")]
		public function get alignSelf():String
		{
			return _alignSelf;
		}
		public function set alignSelf(value:String):void
		{
			if(!alignSelfStyle)
			{
				alignSelfStyle = new AlignSelf();
				addStyleBead(alignSelfStyle);
			}
			_alignSelf = alignSelfStyle.value = value;
		}
		private var alignSelfStyle:AlignSelf;

		private var _placeSelf:String;

		[Inspectable(category="General", enumeration="auto,start,center,end,safe center,safe end,stretch", defaultValue="")]
		/**
		 * Applicabale for grid containers.
		 * A shorthand property for align-content and justify-content.
		 * The main axis is defined by the flex-direction or grid-auto-flow property.
		 * By default, the main axis is the horizontal axis (row).
		 * 
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get placeSelf():String
		{
			return _placeSelf;
		}

		public function set placeSelf(value:String):void
		{
			if(!placeSelfStyle)
			{
				placeSelfStyle = new PlaceSelf();
				addStyleBead(placeSelfStyle);
			}
			_placeSelf = placeSelfStyle.value = value;
		}
		private var placeSelfStyle:PlaceSelf;

		// public var safe:Boolean = false;

	}
}