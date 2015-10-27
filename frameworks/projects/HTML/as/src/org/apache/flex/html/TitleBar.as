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
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IChrome;
	import org.apache.flex.core.ITitleBarModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.Label;
	
	/**
	 *  The TitleBar class is a Container component that displays a title and an
	 *  optional close button. The TitleBar uses the following bead types:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model, which includes the title and showCloseButton values.
	 *  org.apache.flex.core.IBeadView:  the bead that constructs the visual parts of the component.
	 *  org.apache.flex.core.IBeadLayout: the bead that handles size and position of the component parts 
	 *  (org.apache.flex.html.Label and org.apache.flex.html.Button).
	 *  org.apache.flex.core.IMeasurementBead: a bead that helps determine the size of the 
	 *  org.apache.flex.html.TitleBar for layout.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TitleBar extends Container implements IChrome
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function TitleBar()
		{
			super();
			
			className = "TitleBar";
		}
		
		/**
		 *  The title string to display.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get title():String
		{
			return ITitleBarModel(model).title;
		}
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
		 *  @productversion FlexJS 0.0
		 */
		public function get htmlTitle():String
		{
			return ITitleBarModel(model).htmlTitle;
		}
		public function set htmlTitle(value:String):void
		{
			ITitleBarModel(model).htmlTitle = value;
		}
		
		/**
		 *  Whether or not to show a org.apache.flex.html.Button that indicates the component
		 *  may be closed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get showCloseButton():Boolean
		{
			return ITitleBarModel(model).showCloseButton;
		}
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
			
			if( getBeadByType(IBeadLayout) == null )
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iBeadLayout")) as IBead);
		}
	}
}
