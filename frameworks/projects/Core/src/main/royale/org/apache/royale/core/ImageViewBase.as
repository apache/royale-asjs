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
package org.apache.royale.core
{
    COMPILE::SWF
    {
        import flash.display.Bitmap;
        import flash.display.Loader;
        import flash.display.LoaderInfo;
        import flash.display.Sprite;
        import flash.events.IOErrorEvent;
        import flash.net.URLRequest;            
    }
    COMPILE::JS
    {
        import goog.events;
        import org.apache.royale.utils.URLUtils;
    }
	
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IImageModel;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.core.IImageView;
	
	/**
	 *  The ImageView class creates the visual elements of the org.apache.royale.html.Image component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ImageViewBase extends BeadViewBase implements IImageView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ImageViewBase()
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
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
         *  @royaleignorecoercion org.apache.royale.core.IImageModel
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
         * @royaleignorecoercion org.apache.royale.core.IImage
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
	                (host as IImage).applyImageData(_model.url);
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

		/**
		*  @royaleignorecoercion org.apache.royale.core.IImage
		*/
		COMPILE::JS
		protected function get imageElement():Element
		{
			return (_strand as IImage).imageElement;
		}
		
        COMPILE::JS
        private var _sizeHandlerSet:Boolean;

        /**
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        COMPILE::JS
		public function setupLoader():void
        {
            var host:IUIBase = _strand as IUIBase;
            imageElement.addEventListener('load', loadHandler);
            //only do this once. We don't want multiple event listeners
            if(!_sizeHandlerSet)
            {
                host.addEventListener('sizeChanged', sizeChangedHandler);
                _sizeHandlerSet = true;
            }
        }
		
		/**
		 * @private
		 */
        COMPILE::SWF
		private function onComplete(event:Object):void
		{
            loader.contentLoaderInfo.removeEventListener("complete",onComplete);
            var host:ILayoutChild = ILayoutChild(_strand);
			var hostSprite:Sprite = (host as IRenderedObject).$displayObject as Sprite;
			
			if (bitmap) {
				hostSprite.removeChild(bitmap);
			}
			
			bitmap = Bitmap(LoaderInfo(event.target).content);
			
			hostSprite.addChild(bitmap);
			
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
            var host:ILayoutChild = ILayoutChild(_strand);
            if (bitmap) {
                if (!isNaN(host.explicitWidth) || !isNaN(host.percentWidth))
	    			bitmap.width = IUIBase(_strand).width;
                if (!isNaN(host.explicitHeight) || !isNaN(host.percentHeight))
    				bitmap.height = IUIBase(_strand).height;
			}
		}
        
        /**
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        COMPILE::JS
        protected function loadHandler(event:Object):void
        {
            imageElement.removeEventListener('load', loadHandler);
            var host:IUIBase = _strand as IUIBase;
			host.dispatchEvent(new Event("layoutNeeded"));
        }
        
        /**
         * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        COMPILE::JS
        protected function sizeChangedHandler(event:Object):void
        {
            var host:IUIBase = _strand as IUIBase;
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
