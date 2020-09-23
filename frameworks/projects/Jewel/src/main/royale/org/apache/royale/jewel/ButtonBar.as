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
package org.apache.royale.jewel
{
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.html.beads.models.ButtonBarModel;
	
	/**
	 *  The Jewel ButtonBar class is a component that displays a set of Buttons. The ButtonBar
	 *  is actually a List with a default horizontal layout and an itemRenderer that
	 *  produces Jewel Buttons.
	 *  
	 *  By default buttons are equally sized, by setting `widthType` to NaN.
	 *  
	 *  The ButtonBar uses the following beads:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model for the ButtonBar, including the dataProvider.
	 *  org.apache.royale.core.IBeadView: constructs the parts of the component.
	 *  org.apache.royale.core.IBeadController: handles input events.
	 *  org.apache.royale.core.IBeadLayout: sizes and positions the component parts.
	 *  org.apache.royale.core.IDataProviderItemRendererMapper: produces itemRenderers.
	 *  org.apache.royale.core.IItemRenderer: the class or class factory to use.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class ButtonBar extends List
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function ButtonBar()
		{
			super();

            typeNames = "jewel buttonbar";

			// default height and rowHeight
			//height = rowHeight = 38;
		}
		
		/**
		 *  @see org.apache.royale.html.beads.models.ButtonBarModel#buttonWidths
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 */
		public function get buttonWidths():Array
		{
			return ButtonBarModel(model).buttonWidths;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 */
		public function set buttonWidths(value:Array):void
		{
			ButtonBarModel(model).buttonWidths = value;
		}
		
		/**
		 *  @see org.apache.royale.html.beads.models.ButtonBarModel#widthType
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 */
		// public function get widthType():Number
		// {
		// 	return ButtonBarModel(model).widthType;
		// }
		/**
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 */
		// public function set widthType(value:Number):void
		// {
		// 	ButtonBarModel(model).widthType = value;
		// }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'div');
        }
	}
}
