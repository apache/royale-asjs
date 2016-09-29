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
    COMPILE::SWF
    {
        import flash.display.Bitmap;
        import flash.display.Loader;
        import flash.display.LoaderInfo;
        import flash.events.IOErrorEvent;
        import flash.net.URLRequest;            
    }
    COMPILE::JS
    {
        import goog.events;
        import org.apache.flex.utils.URLUtils;
    }
	
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IImageModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.core.IImageView;
	
	/**
	 *  The ImageView class creates the visual elements of the org.apache.flex.html.Image component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ImageView extends BeadViewBase implements IImageView
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
		
        COMPILE::SWF
		protected var bitmap:Bitmap;
        COMPILE::SWF
		private var _loader:Loader;
		
		protected var _model:IImageModel;
		
		COMPILE::SWF
		public function get loader():Loader
		{
			return _loader;
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
			
            COMPILE::SWF
            {
                IEventDispatcher(_strand).addEventListener("widthChanged",handleSizeChange);
                IEventDispatcher(_strand).addEventListener("heightChanged",handleSizeChange);                    
            }
			
            _model = value.getBeadByType(IImageModel) as IImageModel;
            _model.addEventListener("urlChanged",handleUrlChange);
			handleUrlChange(null);
		}
		
		/**
		 * @private
         * @flexjsignorecoercion HTMLImageELement
		 */
		protected function handleUrlChange(event:Event):void
		{
            COMPILE::SWF
            {
                if (_model.url) {
                    setupLoader();
                    loader.load(new URLRequest(_model.url));
                }                    
            }
            COMPILE::JS
            {
				if (_model.url) {
                    setupLoader();
	                (host.element as HTMLImageElement).src = _model.url;
				}
            }
		}

        COMPILE::SWF
        public function setupLoader():void
        {
            _loader = new Loader();
            loader.contentLoaderInfo.addEventListener("complete",onComplete);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
                trace(e);
                e.preventDefault();
            });
        }

        COMPILE::JS
		public function setupLoader():void
        {
            var host:IUIBase = _strand as IUIBase;
            (host.element as HTMLImageElement).addEventListener('load',
                loadHandler, false);
            host.addEventListener('sizeChanged',
                sizeChangedHandler);
        }
		
		/**
		 * @private
		 */
        COMPILE::SWF
		private function onComplete(event:Object):void
		{
            var host:UIBase = UIBase(_strand);
			if (bitmap) {
				host.$sprite.removeChild(bitmap);
			}
			
			bitmap = Bitmap(LoaderInfo(event.target).content);
			
			host.$sprite.addChild(bitmap);
			
            if (host.isWidthSizedToContent())
            {
                host.dispatchEvent(new Event("widthChanged"));
                if (host.parent is IEventDispatcher)
                    IEventDispatcher(host.parent).dispatchEvent(new Event("layoutNeeded"));
            }
            else
                bitmap.width = host.width;
                
            if (host.isHeightSizedToContent())
            {
                host.dispatchEvent(new Event("heightChanged"));
                if (host.parent is IEventDispatcher)
                    IEventDispatcher(host.parent).dispatchEvent(new Event("layoutNeeded"));
            }
            else
                bitmap.height = host.height;
                
		}
		
		/**
		 * @private
		 */
        COMPILE::SWF
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
        
        COMPILE::JS
        private function loadHandler(event:Object):void
        {
            var host:UIBase = UIBase(_strand);
            IEventDispatcher(host.parent).dispatchEvent(new Event("layoutNeeded"));
        }
        
        /**
         * @flexjsignorecoercion HTMLElement
         */
        COMPILE::JS
        private function sizeChangedHandler(event:Object):void
        {
            var host:UIBase = _strand as UIBase;
            var s:Object = host.positioner.style;
            var l:Number = NaN;
            var ls:String = s.left;
            if (typeof(ls) === 'string' && ls.length > 0)
                l = parseFloat(ls.substring(0, ls.length - 2));
            var r:Number = NaN;
            var rs:String = s.right;
            if (typeof(rs) === 'string' && rs.length > 0)
                r = parseFloat(rs.substring(0, rs.length - 2));
            if (!isNaN(l) &&
                !isNaN(r)) {
                // if just using size constraints and image will not shrink or grow
                var computedWidth:Number = (host.positioner.offsetParent as HTMLElement).offsetWidth -
                    l - r;
                s.width = computedWidth.toString() + 'px';
            }
            var t:Number = NaN;
            var ts:String = s.top;
            if (typeof(ts) === 'string' && ts.length > 0)
                t = parseFloat(ts.substring(0, ts.length - 2));
            var b:Number = NaN;
            var bs:String = s.right;
            if (typeof(bs) === 'string' && bs.length > 0)
                b = parseFloat(bs.substring(0, bs.length - 2));
            if (!isNaN(t) &&
                !isNaN(b)) {
                // if just using size constraints and image will not shrink or grow
                var computedHeight:Number = (host.positioner.offsetParent as HTMLElement).offsetHeight -
                    t - b;
                s.height = computedHeight.toString() + 'px';
            }
        }
	}
}
