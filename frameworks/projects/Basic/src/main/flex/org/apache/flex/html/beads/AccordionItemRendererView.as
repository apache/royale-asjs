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
package org.apache.flex.html.beads
{		
	import org.apache.flex.events.Event;
	import org.apache.flex.html.supportClasses.ICollapsible;
    
	/**
	 * This class creates and manages the contents of an AccordionItemItemRenderer
     *  
	 *  @viewbead
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
	public class AccordionItemRendererView extends PanelView
	{
		/**
     	 *  The AccordionItemRendererView class is the default view for
         *  the org.apache.flex.html.supportClasses.AccordionItemRenderer classes.
         *  It provides some layout optimizations that can be attained by assuming
		 *  the strand to be an org.apache.flex.html.supportClasses.ICollapsible.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function AccordionItemRendererView()
		{
			super();
		}
		
		override protected function performLayout(event:Event):void
		{
			var collapsibleStrand:ICollapsible = _strand as ICollapsible;
			if (!collapsibleStrand.collapsed)
			{
				super.performLayout(event);
			} else // skip layout for viewport children
			{
				COMPILE::SWF {
				// no longer needed layoutViewBeforeContentLayout();
				afterLayout();
				}
			}
		}
	}
}
