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
	import org.apache.royale.style.stylebeads.flexgrid.PlaceItems;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyItems;
	import org.apache.royale.style.stylebeads.flexgrid.AlignContent;
	import org.apache.royale.style.stylebeads.flexgrid.PlaceContent;

	public class ContainerPosition extends CompositeStyle
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
			if(!justifyContentStyle)
			{
				justifyContentStyle = new JustifyContent();
				addStyleBead(justifyContentStyle);
			}
			justifyContentStyle.value = _justifyContent = value;
		}
		private var justifyContentStyle:JustifyContent;

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
			if(!alignItemsStyle)
			{
				alignItemsStyle = new AlignItems();
				addStyleBead(alignItemsStyle);
			}
			alignItemsStyle.value = _alignItems = value;
		}
		private var alignItemsStyle:AlignItems;

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
			if(!justifyItemsStyle)
			{
				justifyItemsStyle = new JustifyItems();
				addStyleBead(justifyItemsStyle);
			}
			justifyItemsStyle.value = _justifyItems = value;
		}
		private var justifyItemsStyle:JustifyItems;

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
			if(!alignContentStyle)
			{
				alignContentStyle = new AlignContent();
				addStyleBead(alignContentStyle);
			}
			alignContentStyle.value = _alignContent = value;
		}
		private var alignContentStyle:AlignContent;

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
			if(!placeContentStyle)
			{
				placeContentStyle = new PlaceContent();
				addStyleBead(placeContentStyle);
			}
			placeContentStyle.value = _placeContent = value;
		}
		private var placeContentStyle:PlaceContent;
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
			if(!placeItemsStyle)
			{
				placeItemsStyle = new PlaceItems();
				addStyleBead(placeItemsStyle);
			}
			placeItemsStyle.value = _placeItems = value;
		}
		private var placeItemsStyle:PlaceItems;
	}
}