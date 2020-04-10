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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
    
	/**
	 *  The MXMLItemRenderer class is the base class for itemRenderers that are MXML-based
	 *  and provides support for a layout and a data object.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class StyledBaseMXMLItemRenderer extends StyledDataItemRenderer implements ILayoutParent, ILayoutHost, IStrand, ILayoutView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function StyledBaseMXMLItemRenderer()
		{
			super();
            typeNames = "";
		}

        [Bindable("dataChange")]
        override public function set data(value:Object):void
        {
            if (value != data)
            {
                super.data = value;
                dispatchEvent(new Event("dataChange"));
            }
        }

		public function getLayoutHost():ILayoutHost
		{
			return this;
		}

		public function get contentView():ILayoutView
		{
			return this;
		}

		override public function adjustSize():void
		{
			var layout:IBeadLayout = getBeadByType(IBeadLayout) as IBeadLayout;
			if (layout != null) {
				layout.layout();
			}
		}
		
		public function beforeLayout():Boolean
		{
			return true;
		}
		
		public function afterLayout():void
		{
			
		}

	}
}
