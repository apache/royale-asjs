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
package org.apache.flex.mobile.chrome
{
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IChrome;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.Container;
	
	/**
	 * The ToolBar class provides a space below the contentArea of a view manager which can
	 * be used to house controls for the view.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ToolBar extends Container implements IChrome
	{
		public function ToolBar()
		{
			super();
			
			className = "ToolBar";
		}
		
		private var _controls:Array;
		
		/**
		 * The control components of the ToolBar (eg, a settings button).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
			
			var layout:IBeadLayout = this.getBeadByType(IBeadLayout) as IBeadLayout;
			trace("layout = "+layout);
			
			for (var i:int=0; i < _controls.length; i++)
			{
				addElement( _controls[i], false );
			}
			
			dispatchEvent(new Event("layoutNeeded"));
		}
	}
}