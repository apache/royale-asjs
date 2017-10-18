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
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.html.Group;
	
	/**
	 * The TitleView class represents a view in a mobile app that has
	 * a title and is typically used in a ViewManager.
	 */
	public class TitleView extends Group implements IViewManagerView
	{
		public function TitleView()
		{
			super();
		}
		
		private var _title:String;
		public function get title():String
		{
			return _title;
		}
		public function set title(value:String):void
		{
			_title = value;
		}
		
		override public function toString():String
		{
			return _title;
		}
		
		private var _viewManager:IViewManager;
		public function get viewManager():IViewManager
		{
			return _viewManager;
		}
		public function set viewManager(value:IViewManager):void
		{
			_viewManager = value;
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
