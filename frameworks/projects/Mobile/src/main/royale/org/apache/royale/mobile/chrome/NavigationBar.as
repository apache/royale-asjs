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
package org.apache.royale.mobile.chrome
{
	import org.apache.royale.core.IChrome;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.Container;
	
	/**
	 * The NavigationBar class is part of the mobile view manager's chrome. When present,
	 * it provides a place for content at the top of the view, above the contentArea.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class NavigationBar extends Container implements IChrome
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function NavigationBar()
		{
			super();
			
			typeNames = "NavigationBar";
		}
		
		public function hidesBackButton(value:Boolean):void
		{
			
		}
		
		private var _controls:Array;
		
		/**
		 * The controls of the NavigationBar (eg, a button to go back and a title).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set controls(value:Array):void
		{
			_controls = value;
		}
		public function get controls():Array
		{
			return _controls;
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			
			for (var i:int=0; i < _controls.length; i++)
			{
				addElement( _controls[i], false );
				
				var ctrl:IEventDispatcher = _controls[i] as IEventDispatcher;
				ctrl.addEventListener("show", handleVisibilityChange);
				ctrl.addEventListener("hide", handleVisibilityChange);
			}
			
			dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 */
		private function handleVisibilityChange(event:Event):void
		{
			dispatchEvent(new Event("layoutNeeded"));
		}
	}
}
