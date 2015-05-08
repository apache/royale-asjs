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
    import flash.events.IOErrorEvent;
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
	public class ImageView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ImageView()
		{
		}
		
		private var bitmap:Bitmap;
		private var loader:Loader;
		
		private var _model:IImageModel;
		
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
			
			_model = value.getBeadByType(IImageModel) as IImageModel;
			_model.addEventListener("urlChanged",handleUrlChange);
			
			handleUrlChange(null);
		}
		
		/**
		 * @private
		 */
		private function handleUrlChange(event:Event):void
		{
			if (_model.source) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener("complete",onComplete);
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
                    trace(e);
                    e.preventDefault();
                });
				loader.load(new URLRequest(_model.source));
			}
		}
		
		/**
		 * @private
		 */
		private function onComplete(event:Object):void
		{
            var host:UIBase = UIBase(_strand);
			if (bitmap) {
				host.removeChild(bitmap);
			}
			
			bitmap = Bitmap(LoaderInfo(event.target).content);
			
			host.addChild(bitmap);
			
            if (host.isWidthSizedToContent())
                host.dispatchEvent(new Event("widthChanged"));
            else
                bitmap.width = UIBase(_strand).width;
                
            if (host.isHeightSizedToContent())
                host.dispatchEvent(new Event("heightChanged"));
            else
                bitmap.height = UIBase(_strand).height;
                
		}
		
		/**
		 * @private
		 */
		private function handleSizeChange(event:Object):void
		{
            var host:UIBase = UIBase(_strand);
            if (bitmap) {
                if (!isNaN(host.explicitWidth) || !isNaN(host.percentWidth))
	    			bitmap.width = UIBase(_strand).width;
                if (!isNaN(host.explicitHeight) || !isNaN(host.percentHeight))
    				bitmap.height = UIBase(_strand).height;
			}
		}
	}
}
