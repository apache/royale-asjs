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
package org.apache.flex.html
{
	import org.apache.flex.core.GroupBase;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IMXMLDocument;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.utils.MXMLDataInterpreter;
	
	/**
	 *  Indicates that the children of the container is have been added.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event(name="childrenAdded", type="org.apache.flex.events.Event")]
	
	/**
	 * Default property
	 */
	[DefaultProperty("mxmlContent")]
    
    /**
     *  The Group class provides a light-weight container for visual elements. By default
	 *  the Group does not have a layout, allowing its children to be sized and positioned
	 *  using styles or CSS. 
     *  
     *  @toplevel
     *  @see org.apache.flex.html.beads.layout
     *  @see org.apache.flex.html.supportClasses.ScrollingViewport
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class Group extends GroupBase implements ILayoutParent, IParentIUIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Group()
		{
			super();
		}
		
		/**
		 * Returns the ILayoutHost which is its view. From ILayoutParent.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function getLayoutHost():ILayoutHost
		{
			return view as ILayoutHost; 
		}
	}
}
