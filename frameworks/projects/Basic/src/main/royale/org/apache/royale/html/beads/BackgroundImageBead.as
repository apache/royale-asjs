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
package org.apache.royale.html.beads
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;

	import org.apache.royale.html.beads.IBackgroundBead;
	
	/**
	 *  The BackgroundImageBead is used to render an image as the background to any component
	 *  that supports it, such as Container.
	 * 
	 *  Note that this bead is for ActionScript only since CSS/HTML allows this just by specifying
	 *  a background image in the style selector. To use this bead, place a ClassReference to it
	 *  within @media -royale-swf { } group in the CSS declarations.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class BackgroundImageBead implements IBead, IBackgroundBead
	{
		/**
		 *  Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function BackgroundImageBead()
		{
			backgroundSprite = new Sprite();
		}
		
		private var _strand:IStrand;
		private var backgroundSprite:Sprite;
		private var bitmap:Bitmap;
		private var loader:Loader;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			setupBackground(backgroundSprite);
		}
		
		/**
		 * @private
		 */
		private function setupBackground(sprite:Sprite, state:String = null):void
		{
			var backgroundImage:Object = ValuesManager.valuesImpl.getValue(_strand, "background-image", state);
			if (backgroundImage)
			{
				loader = new Loader();
				var url:String = backgroundImage as String;
				loader.load(new URLRequest(url));
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
					trace(e);
					e.preventDefault();
				});
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function (e:flash.events.Event):void { 
					var host:UIBase = UIBase(_strand);
					if (bitmap) {
						host.removeChild(bitmap);
					}
					
					bitmap = Bitmap(LoaderInfo(e.target).content);
					
					host.$sprite_addChildAt(bitmap,0);
					
					if (isNaN(host.explicitWidth) && isNaN(host.percentWidth))
						host.setWidth(loader.content.width);
					else
						bitmap.width = UIBase(_strand).width;
					
					if (isNaN(host.explicitHeight) && isNaN(host.percentHeight))
						host.setHeight(loader.content.height);
					else
						bitmap.height = UIBase(_strand).height;
				});
			}
		}
	}
}
