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
package org.apache.royale.mobile.beads
{	
	import org.apache.royale.core.Application;
	import org.apache.royale.core.View;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	
	COMPILE::SWF
	{
		import flash.events.Event;
		import flash.external.ExternalInterface;
		import flash.utils.getQualifiedClassName;
		import flash.display.Stage;
	}
	
	/**
	 * The DeviceSizeBead.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DeviceSizeBead implements IBead
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DeviceSizeBead()
		{
			super();
		}
		
		private var _app:Application;
		
		COMPILE::SWF
		{
			private var stage:Stage;
		}
		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_app = value as Application;
			
			COMPILE::SWF
			{
				stage = _app.$displayObject.stage;
				stage.addEventListener("resize", onResize);     
				onResize(null);
			}
			
			COMPILE::JS {
				window.addEventListener("resize", onResize, false);
				onResize();
			}
		}
		
		COMPILE::JS
		private function onResize():void
		{
			var initialView:UIBase = _app.initialView as UIBase;
			var element:HTMLElement = _app.element;
			//if (!isNaN(initialView.percentWidth) || !isNaN(initialView.percentHeight)) {
				element.style.height = window.innerHeight.toString() + 'px';
				element.style.width = window.innerWidth.toString() + 'px';
				initialView.dispatchEvent('sizeChanged'); // kick off layout if % sizes
			//}
			//initialView.setWidthAndHeight(window.innerWidth, window.innerHeight);
		}
		
		COMPILE::SWF
		private function onResize(event:flash.events.Event):void
		{
			var initialView:UIBase = _app.initialView as UIBase;
			if (!isNaN(initialView.percentWidth) && !isNaN(initialView.percentHeight))
				initialView.setWidthAndHeight(stage.stageWidth, stage.stageHeight);
			else if (!isNaN(initialView.percentWidth))
				initialView.setWidth(stage.stageWidth);
			else if (!isNaN(initialView.percentHeight))
				initialView.setHeight(stage.stageHeight);
		}
	}
}
