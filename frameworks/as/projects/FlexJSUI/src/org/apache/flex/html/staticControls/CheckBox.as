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
package org.apache.flex.html.staticControls
{
    import flash.events.MouseEvent;
	
	import org.apache.flex.core.IToggleButtonModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIButtonBase;
	import org.apache.flex.events.Event;
	
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user checks or un-checks the CheckBox.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="change", type="org.apache.flex.events.Event")]

    /**
     *  The CheckBox class implements the common user interface
     *  control.  The CheckBox includes its text label.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class CheckBox extends UIButtonBase implements IStrand
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function CheckBox()
		{
			super();
			
			addEventListener(MouseEvent.CLICK, internalMouseHandler);
		}
		
        /**
         *  The text label for the CheckBox.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get text():String
		{
			return IToggleButtonModel(model).text;
		}
        
        /**
         *  @private
         */
		public function set text(value:String):void
		{
			IToggleButtonModel(model).text = value;
		}
		
        /**
         *  <code>true</code> if the check mark is displayed.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get selected():Boolean
		{
			return IToggleButtonModel(model).selected;
		}
		
        /**
         *  @private
         */
		public function set selected(value:Boolean):void
		{
			IToggleButtonModel(model).selected = value;
		}
				
		private function internalMouseHandler(event:Event) : void
		{
			selected = !selected;
			dispatchEvent(new Event("change"));
		}
	}
}