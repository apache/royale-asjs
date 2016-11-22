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
package org.apache.flex.mdl
{
	import org.apache.flex.html.List;
	
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.beads.ListView;
        import org.apache.flex.html.supportClasses.DataGroup;
    }
	
	/**
	 *  Indicates that the initialization of the list is complete.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event(name="initComplete", type="org.apache.flex.events.Event")]
	
	/**
	 * The change event is dispatched whenever the list's selection changes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
    [Event(name="change", type="org.apache.flex.events.Event")]
    
	/**
	 *  The List class is a component that displays multiple data items. The List uses
	 *  the following bead types:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model, which includes the dataProvider, selectedItem, and
	 *  so forth.
	 *  org.apache.flex.core.IBeadView:  the bead that constructs the visual parts of the list.
	 *  org.apache.flex.core.IBeadController: the bead that handles input and output.
	 *  org.apache.flex.core.IBeadLayout: the bead responsible for the size and position of the itemRenderers.
	 *  org.apache.flex.core.IDataProviderItemRendererMapper: the bead responsible for creating the itemRenders.
	 *  org.apache.flex.core.IItemRenderer: the class or factory used to display an item in the list.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class List extends org.apache.flex.html.List
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function List()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
		
        /**
         * @flexjsignorecoercion org.apache.flex.html.beads.ListView 
         * @flexjsignorecoercion org.apache.flex.html.supportClasses.DataGroup 
         */
        /*COMPILE::JS
        override public function internalChildren():Array
        {
            var listView:ListView = getBeadByType(ListView) as ListView;
            var dg:DataGroup = listView.dataGroup as DataGroup;
            var renderers:Array = dg.internalChildren();
            return renderers;
        };*/

        /**
         * @return The actual element to be parented.
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
		COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-list";
            
            element = document.createElement('ul') as WrappedHTMLElement;
            element.className = typeNames;
            
            positioner = element;
            
            element.flexjs_wrapper = this;
            
            return positioner;
        }
   	}
}
