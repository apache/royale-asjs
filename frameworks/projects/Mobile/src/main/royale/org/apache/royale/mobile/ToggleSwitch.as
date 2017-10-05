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
package org.apache.royale.mobile
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IToggleButtonModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	
	/**
	 * The ToggleSwitch is a UI control that displays on/off or yes/no states.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ToggleSwitch extends UIBase
	{
		/**
		 * Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ToggleSwitch()
		{
			super();
			
			COMPILE::JS {
				setWidthAndHeight(40.0, 25.0, false);
			}
		}
		
		[Bindable("change")]
		/**
		 *  <code>true</code> if the switch is selected.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		
		private var _controller:IBeadController;
        
        /**
         *  Get the controller for the view.
         * 
         *  @royaleignorecoercion Class
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get controller():IBeadController
		{
			if (_controller == null) {
				_controller = getBeadByType(IBeadController) as IBeadController;
				if (_controller == null) {
                    var c:Class = ValuesManager.valuesImpl.getValue(this, "iBeadController") as Class;
					_controller = new c() as IBeadController;
					addBead(_controller);
				}
			}
			return _controller;
		}
		public function set controller(value:IBeadController):void
		{
			_controller = value;
		}
	}
}
