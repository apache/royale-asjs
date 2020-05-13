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
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IChrome;
    import org.apache.royale.core.ITitleBarModel;
    import org.apache.royale.utils.loadBeadFromValuesManager;
	
	/**
	 *  The TitleBar class is a Container component that displays a title and an
	 *  optional close button. The TitleBar uses the following bead types:
	 * 
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the title and showCloseButton values.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the component.
	 *  org.apache.royale.core.IBeadLayout: the bead that handles size and position of the component parts 
	 *  (org.apache.royale.html.Label and org.apache.royale.html.Button).
	 *  org.apache.royale.core.IMeasurementBead: a bead that helps determine the size of the 
	 *  org.apache.royale.html.TitleBar for layout.
	 * 
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TitleBar extends Group implements IChrome
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TitleBar()
		{
			super();
			
			typeNames = "jewel titlebar";
		}

		/**
		 *  The title string to display.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.ITitleBarModel
		 */
		public function get title():String
		{
			return ITitleBarModel(model).title;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ITitleBarModel
		 */
		public function set title(value:String):void
		{
			ITitleBarModel(model).title = value;
		}
		
		/**
		 *  The HTML title to display.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.ITitleBarModel
		 */
		public function get htmlTitle():String
		{
			return ITitleBarModel(model).htmlTitle;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ITitleBarModel
		 */
		public function set htmlTitle(value:String):void
		{
			ITitleBarModel(model).htmlTitle = value;
		}
		
		/**
		 *  Whether or not to show a org.apache.royale.html.Button that indicates the component
		 *  may be closed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.ITitleBarModel
		 */
		public function get showCloseButton():Boolean
		{
			return ITitleBarModel(model).showCloseButton;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ITitleBarModel
		 */
		public function set showCloseButton(value:Boolean):void
		{
			ITitleBarModel(model).showCloseButton = value;
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this);
		}
        
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
