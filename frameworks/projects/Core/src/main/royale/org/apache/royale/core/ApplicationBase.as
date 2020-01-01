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
    COMPILE::SWF {
        import flash.display.Sprite;
        import flash.system.ApplicationDomain;
        import flash.utils.getQualifiedClassName;
    }
    COMPILE::JS
    {
        import org.apache.royale.utils.CSSUtils;
        import org.apache.royale.events.Event;
        import org.apache.royale.utils.html.getStyle;
        import org.apache.royale.utils.sendEvent;
        import org.apache.royale.utils.sendEvent;
        import org.apache.royale.utils.sendEvent;
        import org.apache.royale.utils.sendEvent;
        import org.apache.royale.utils.sendEvent;
        import org.apache.royale.utils.sendEvent;
    }

    [DefaultProperty("beads")]
    
    /**
     *  This is a platform-dependent base class
     *  for Application
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
	public class ApplicationBase extends Sprite implements IFlexInfo
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ApplicationBase()
		{
			super();
		}
        
        private var _info:Object;
        
        /**
         *  An Object containing information generated
         *  by the compiler that is useful at startup time.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function info():Object
        {
            if (!_info)
            {
                var mainClassName:String = getQualifiedClassName(this);
                var initClassName:String = "_" + mainClassName + "_FlexInit";
                var c:Class = ApplicationDomain.currentDomain.getDefinition(initClassName) as Class;
                _info = c.info();
            }
            return _info;
        }
   	}
    
    [DefaultProperty("beads")]
    
    COMPILE::JS
    public class ApplicationBase extends HTMLElementWrapper implements IFlexInfo
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function ApplicationBase()
        {
            super();
        }
        
        private var _info:Object;
        
        /**
         *  An Object containing information generated
         *  by the compiler that is useful at startup time.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function info():Object
        {
            return _info;
        }
        
        private var _width:Number;
        
        [Bindable("widthChanged")]
        [PercentProxy("percentWidth")]
        /**
         * @royaleignorecoercion String
         */
        public function get width():Number
        {
            var pixels:Number;
            var strpixels:String = getStyle(this).width as String;
            if(strpixels == null)
                pixels = NaN;
            else
                pixels = CSSUtils.toNumber(strpixels,NaN);
            if (isNaN(pixels)) {
                pixels = element.offsetWidth;
                if (pixels === 0 && element.scrollWidth !== 0) {
                    // invisible child elements cause offsetWidth to be 0.
                    pixels = element.scrollWidth;
                }
            }
            return pixels;
        }
        
        /**
         *  @private
         */
        public function set width(value:Number):void
        {
            if (explicitWidth != value)
            {
                explicitWidth = value;
            }
            
            setWidth(value);
        }
        
        private var _height:Number;
        
        [Bindable("heightChanged")]
        [PercentProxy("percentHeight")]
        /**
         * @royaleignorecoercion String
         */
        public function get height():Number
        {
            var pixels:Number;
            var strpixels:String = getStyle(this).height as String;
            if(strpixels == null)
                pixels = NaN;
            else
                pixels = CSSUtils.toNumber(strpixels,NaN);
            if (isNaN(pixels)) {
                pixels = element.offsetHeight;
                if (pixels === 0 && element.scrollHeight !== 0) {
                    // invisible child elements cause offsetHeight to be 0.
                    pixels = element.scrollHeight;
                }
            }
            return pixels;
        }
        
        /**
         *  @private
         */
        public function set height(value:Number):void
        {
            if (explicitHeight != value)
            {
                explicitHeight = value;
            }
            
            setHeight(value);
        }
        
        /**
         *  @copy org.apache.royale.core.ILayoutChild#setHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setHeight(value:Number, noEvent:Boolean = false):void
        {
            if (_height != value)
            {
                _height = value;
                getStyle(this).height = value.toString() + 'px';        
                if (!noEvent)
                    sendEvent(this,"heightChanged");
            }            
        }
        
        /**
         *  @copy org.apache.royale.core.ILayoutChild#setWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setWidth(value:Number, noEvent:Boolean = false):void
        {
            if (_width != value)
            {
                _width = value;
                getStyle(this).width = value.toString() + 'px';        
                if (!noEvent)
                    sendEvent(this,"widthChanged");
            }
        }
        
        private var _explicitWidth:Number;
        
        /**
         *  The explicitly set width (as opposed to measured width
         *  or percentage width).
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get explicitWidth():Number
        {
            return _explicitWidth;
        }
        
        /**
         *  @private
         */
        public function set explicitWidth(value:Number):void
        {
            if (_explicitWidth == value)
                return;
            
            // width can be pixel or percent not both
            if (!isNaN(value))
                _percentWidth = NaN;
            
            _explicitWidth = value;
            sendEvent(this,"explicitWidthChanged");
        }
        
        private var _explicitHeight:Number;
        
        /**
         *  The explicitly set width (as opposed to measured width
         *  or percentage width).
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get explicitHeight():Number
        {
            return _explicitHeight;
        }
        
        /**
         *  @private
         */
        public function set explicitHeight(value:Number):void
        {
            if (_explicitHeight == value)
                return;
            
            // height can be pixel or percent not both
            if (!isNaN(value))
                _percentHeight = NaN;
            
            _explicitHeight = value;
            sendEvent(this,"explicitHeightChanged");
        }
        
        private var _percentWidth:Number;
        
        /**
         *  The requested percentage width this component
         *  should have in the parent container.  Note that
         *  the actual percentage may be different if the 
         *  total is more than 100% or if there are other
         *  components with explicitly set widths.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get percentWidth():Number
        {
            return _percentWidth;
        }
        
        /**
         *  @private
         */
        public function set percentWidth(value:Number):void
        {
            this._percentWidth = value;
            getStyle(this).width = value.toString() + '%';
            if (!isNaN(value))
                this._explicitWidth = NaN;
            sendEvent(this,"percentWidthChanged");
        }
        
        private var _percentHeight:Number;
        
        /**
         *  The requested percentage height this component
         *  should have in the parent container.  Note that
         *  the actual percentage may be different if the 
         *  total is more than 100% or if there are other
         *  components with explicitly set heights.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get percentHeight():Number
        {
            return _percentHeight;
        }
        
        /**
         *  @private
         */
        public function set percentHeight(value:Number):void
        {
            this._percentHeight = value;
            getStyle(this).height = value.toString() + '%';
            if (!isNaN(value))
                this._explicitHeight = NaN;
            sendEvent(this,"percentHeightChanged");
        }


    }
}
