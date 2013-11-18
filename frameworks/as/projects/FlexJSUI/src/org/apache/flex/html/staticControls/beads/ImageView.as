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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IImageModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class ImageView implements IBeadView
	{
		public function ImageView()
		{
		}
		
		private var bitmap:Bitmap;
		private var loader:Loader;
		
		private var _strand:IStrand;
		private var _model:IImageModel;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(_strand).addEventListener("widthChanged",handleSizeChange);
			IEventDispatcher(_strand).addEventListener("heightChanged",handleSizeChange);
			
			_model = value.getBeadByType(IImageModel) as IImageModel;
			_model.addEventListener("urlChanged",handleUrlChange);
			
			handleUrlChange(null);
		}
		
		private function handleUrlChange(event:Event):void
		{
			if (_model.source) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener("complete",onComplete);
				loader.load(new URLRequest(_model.source));
			}
		}
		
		private function onComplete(event:Object):void
		{
			if (bitmap) {
				UIBase(_strand).removeChild(bitmap);
			}
			
			bitmap = Bitmap(LoaderInfo(event.target).content);
			
			UIBase(_strand).addChild(bitmap);
			
			handleSizeChange(null);
		}
		
		private function handleSizeChange(event:Object):void
		{
			if (bitmap) {
				bitmap.width = UIBase(_strand).width;
				bitmap.height = UIBase(_strand).height;
			}
		}
	}
}