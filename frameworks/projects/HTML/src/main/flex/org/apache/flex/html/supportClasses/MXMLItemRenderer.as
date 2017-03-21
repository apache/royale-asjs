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
package org.apache.flex.html.supportClasses
{
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.ILayoutObject;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IParentIUIBase;
    import org.apache.flex.events.Event;

	/**
	 *  The MXMLItemRenderer class is the base class for itemRenderers that are MXML-based
	 *  and provides support for a layout and a data object.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class MXMLItemRenderer extends DataItemRenderer implements ILayoutParent, ILayoutHost, IStrand, ILayoutObject
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function MXMLItemRenderer()
		{
			super();
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
		
		public function get contentView():ILayoutObject
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


	}
}
