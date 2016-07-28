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
package org.apache.flex.html.beads
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IImageModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The ImageView class creates the visual elements of the org.apache.flex.html.Image component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class VRuleView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function VRuleView()
		{
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			IEventDispatcher(_strand).addEventListener("widthChanged",handleSizeChange);
			IEventDispatcher(_strand).addEventListener("heightChanged",handleSizeChange);
            IEventDispatcher(_strand).addEventListener("sizeChanged",handleSizeChange);
			
			handleSizeChange(null);
		}
				
		/**
		 * @private
		 */
		private function handleSizeChange(event:Object):void
		{
			var ui:UIBase = _strand as UIBase;
            ui.$sprite.graphics.clear();
            ui.$sprite.graphics.beginFill(0);
            ui.$sprite.graphics.drawRect(0, 0, 1, ui.height);
            ui.$sprite.graphics.endFill();
		}
	}
}
