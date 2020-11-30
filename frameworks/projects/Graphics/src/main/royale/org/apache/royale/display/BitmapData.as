/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 package org.apache.royale.display
{
    import org.apache.royale.display.js.JSRuntimeGraphicsStore;
    import org.apache.royale.display.js.nonNullParamError;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.geom.Point;
    import org.apache.royale.geom.Matrix;
    import org.apache.royale.utils.BinaryData;
    
    COMPILE::JS
    public class BitmapData
    {
        
        private var _canvas:HTMLCanvasElement;
        private var _ctx:CanvasRenderingContext2D;
        private var _lockedData:ImageData;
        private static var _instIdx:uint = 0;
        
        
    
        /**
         *
         * @param width
         * @param height
         * @param transparent
         * @param fillColor
         *
         * @royaleignorecoercion HTMLCanvasElement
         * @royaleignorecoercion CanvasRenderingContext2D
         */
        public function BitmapData(width:uint, height:uint, transparent:Boolean = true, fillColor:uint = 0xffffffff)
        {
            if ((width<0 || width > 8191)|| (height<0 || height>8191) || (width * height > 16777215)) throw new Error('width and/or height exceed the maximum dimensions');
            this._transparent = transparent;
            if (width && height) {
                _canvas = document.createElement('canvas') as HTMLCanvasElement;
                _canvas.width = _width = width;
                _canvas.height = _height = height;
                _id = 'royale-bitmapdata-' + _instIdx++;
                _canvas.setAttributeNS(null,'id', _id);
                
                _ctx = _canvas.getContext('2d') as CanvasRenderingContext2D;
                if (fillColor || !transparent) { //do nothing for transparent black, it is the default
                    _ctx.fillStyle = convertColorValToStyle(fillColor);
                    _ctx.fillRect(0, 0, width, height);
                }
                _svgTarget = JSRuntimeGraphicsStore.getInstance().addBitmapDataImpl(_canvas);
                requestAnimationFrame(onRenderUpdate);
                
            } else throw new Error('ArgumentError: Error #2015: Invalid BitmapData.');
           
        }
        
        private var _id:String;
        internal function getID():String{
            return _id;
        }
        
        
        private var _dirty:Boolean = true; //at startup, it is always dirty, because the _svgTarget is not yet initialized with data
        private var _svgTarget:SVGImageElement;
        

        private static var _checked:Boolean;
        private static var _safariDT:Boolean;
        
        //this seems necessary for now, but hopefully a better way can be found.
        private function get isSafariDesktop():Boolean {
            if (_checked) return _safariDT;
            var isSafariDT:Boolean;
            if (window['safari']) {
                var ua:String = window['navigator']['userAgent'];
                if (ua.search(/version\/[\d\.]/i) > -1) {
                    isSafariDT = ua.search(/iPad|iPhone|iPod/) == -1
                }
            }
            //var altName:String = goog.reflect.objectProperty('isSafariDesktop', this);
            //BitmapData.prototype[altName] = isSafariDT
            _safariDT = isSafariDT;
            _checked = true;
            console.log('safari Desktop?', isSafariDT);
            return isSafariDT;
        }
    
        /**
         *
         * @royaleignorecoercion SVGElement
         */
        private function onRenderUpdate(timeStamp:Number):void{
            if (_canvas && _svgTarget) {
                var img_dataurl:String = _canvas.toDataURL("image/png");
                _svgTarget.setAttributeNS("http://www.w3.org/1999/xlink", "xlink:href", img_dataurl);
                if (isSafariDesktop) {
                    //hack to trigger update of use nodes, seems necessary on Safari
                    var parentNode:SVGElement = _svgTarget.parentNode as SVGElement;
                    parentNode.appendChild(parentNode.removeChild(_svgTarget));
                }
            }
            _dirty = false;
        }
        
        private function convertColorValToStyle(val:uint):String{
            //use transparency rules
            if (_transparent) {
                if (val < 0x01000000) return 'rgba(0,0,0,0)';
                else return 'rgba('+((val & 0xff0000)>>16)+','+((val & 0xff00)>>8)+','+(val & 0xff)+','+(((val & 0xff000000)>>>24)/255)+')';
            } else {
                val = val & 0xffffff;
                return 'rgb('+((val & 0xff0000)>>16)+','+((val & 0xff00)>>8)+','+(val & 0xff)+')'
            }
        }
        
        
        private var _width:uint;
        public function get width():uint{
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            return _width;
        }
    
        private var _height:uint;
        public function get height():uint{
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            return _height;
        }
    
        private var _transparent:Boolean;
        public function get transparent():Boolean{
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            return _transparent;
        }
    
        /**
         * Compresses this BitmapData object using the selected compressor algorithm and returns a new ByteArray object.
         * @param rect
         * @param compressor
         * @param byteArray
         * @return
         */
        public function encode(rect:Rectangle, compressor:Object, byteArray:BinaryData = null):BinaryData{
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            if (!rect) throw new TypeError(nonNullParamError('rect'));
            if (!compressor) throw new TypeError(nonNullParamError('compressor'));
            //observed in swf testing... this appears to unlock first
            var wasLocked:Boolean = _lockedData;
            if (wasLocked) unlock();
            var dataString:String;
            switch(compressor.constructor) {
                case JPEGEncoderOptions :
                    var q:uint = JPEGEncoderOptions(compressor).quality;
                    if (q > 100) throw new RangeError('Error #2006: The supplied index is out of bounds.');
                    dataString = _canvas.toDataURL('image/jpeg',q/100);
                    break;
                //we don't have JPEGXR in js (yet, maybe never)
                case PNGEncoderOptions :
                    dataString = _canvas.toDataURL();
                    break;
                default:
                    throw new Error('ArgumentError: Error #2004: One of the parameters is invalid.');
                    break;
            }
            const decodedData:String = window['atob'](dataString);
            const l:uint = decodedData.length;
            var bytes:Uint8Array = new Uint8Array(l);
            for (var i:int = 0; i < l; i++) {
                bytes[i] = decodedData.charCodeAt(i);
            }
            var output:BinaryData = new BinaryData(bytes.buffer);
            
            if (byteArray) {
                byteArray.writeBinaryData(output);
            }
            
            if (wasLocked) lock();
            return output;
        }
    
    
        /**
         * Sets a single pixel of a BitmapData object.
         * @param x
         * @param y
         * @param color
         */
        public function setPixel(x:int, y:int, color:uint):void {
            setPixel32(x,y,0xff000000 | color);
        }
    
        /**
         * Sets the color and alpha transparency values of a single pixel of a BitmapData object.
         * @param x
         * @param y
         * @param color
         */

        public function setPixel32(x:int, y:int, color:uint):void {
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            var pixel:ImageData;
            var alpha:uint;
            var idx:uint = 0;
            if (_transparent) {
                if (_lockedData) {
                    //get it from the lockedData
                    idx = (_width * 4) * y + x * 4;
                    pixel = _lockedData
                } else {
                    //direct query
                    pixel = _ctx.getImageData(x,y,1,1);
                }
                alpha = pixel.data[idx+3];
                if (alpha == 0) color = 0;
                else alpha = (color>>24) & 0xff;
        
            } else {
                alpha = 0xff;//alpha is always 255. We don't have 24bit option
                pixel = _ctx.createImageData(1, 1); //? @todo check this..
            }
    
            pixel.data[idx++] = (color >> 16) & 0xff;
            pixel.data[idx++] = (color >>8) & 0xff;
            pixel.data[idx++] = (color & 0xff);
            pixel.data[idx] = alpha;
            if (!_lockedData) {
                //direct update
                _ctx.putImageData(pixel, x,y);
                if (!_dirty) {
                    _dirty = true;
                    requestAnimationFrame(onRenderUpdate);
                }
            }
        }
        
        public function lock():void{
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            if (!_lockedData) {
                _lockedData = _ctx.getImageData(0,0,_width, _height);
            }
        }
        
        public function unlock():void{
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            if (_lockedData) {
                //update the view
                _ctx.putImageData(_lockedData, 0,0);
                _lockedData = null;
                if (!_dirty) {
                    _dirty = true;
                    requestAnimationFrame(onRenderUpdate);
                }
            }
        }
    
        public function getPixel(x:int,y:int):uint{
            return 0xffffff & getPixel32(x,y);
        }
        
        public function getPixel32(x:int,y:int):uint{
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            var pixel:ImageData;
            var alpha:uint;
            var idx:uint = 0;
            if (_transparent) {
                if (_lockedData) {
                    //get it from the lockedData
                    idx = (_width * 4) * y + x * 4;
                    pixel = _lockedData
                } else {
                    //direct query
                    pixel = _ctx.getImageData(x,y,1,1);
                }
                alpha = pixel.data[3];
        
            } else {
                alpha = 0xff;//alpha is always 255. We don't have 24bit option for native storage
                pixel = _ctx.getImageData(x,y,1,1);
            }
            return (alpha<<24) | (pixel.data[idx++] <<16) | (pixel.data[idx++] <<8) | pixel.data[idx];
        }
        
        public function clone():BitmapData{
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            //avoid the constructor fillRect code in all cases by using transparent black
            var c:BitmapData = new BitmapData(_width, _height,true,0);
            //now clone 'transparent' after constructor code has run.
            c._transparent = _transparent;
            //copy the underlying data from this instance to the clone
            c._ctx.putImageData(_ctx.getImageData(0 , 0, _width, _height), 0, 0);
            return c;
        }
    
        /**
         *  Fills a rectangular area of pixels with a specified ARGB color
         * @param rect
         * @param color
         */
        public function fillRect(rect:Rectangle, color:uint):void {
            if (!rect) throw new TypeError('TypeError: Error #2007: Parameter rect must be non-null');
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            if (_lockedData) {
                var wideData:Uint32Array = new Uint32Array(_lockedData.data.buffer);
                if (!_transparent) color = 0xff000000 & color;
                //ARGB -> RGBA
                color = (((color<<8)>>>0) | color>>>24) >>>0;
                //set values in the wideData
                const yEnd:uint = rect.bottom;
                const xStart:uint =  rect.x;
                const xEnd:uint =  rect.right;
                for (var y:uint = rect.y;y < yEnd;y++) {
                    var yOffset:uint = _width * y;
                    for (var x:uint = xStart; x < xEnd; x++) {
                        var idx:uint = yOffset + x ;
                        wideData[idx] = color;
                    }
                }
            } else {
                _ctx.fillStyle = convertColorValToStyle(color);
                _ctx.fillRect(rect.x, rect.y, rect.width, rect.height);
                if (!_dirty) {
                    _dirty = true;
                    requestAnimationFrame(onRenderUpdate);
                }
            }
        }
       
        
        public function get rect():Rectangle{
            if (!_canvas) throw new Error('ArgumentError: Error #2015: Invalid BitmapData');
            return new Rectangle(0, 0, _width, _height);
        }
    
        public function dispose():void{
            if (_canvas) {
                _ctx= null;
                JSRuntimeGraphicsStore.getInstance().removeBitmapDataImpl(_canvas, _svgTarget);
                _canvas = null;
                _svgTarget = null;
                _lockedData = null;
            }
        }

	// not implemented
	public function draw(source:Object, matrix:Object = null, colorTransform:Object = null, blendMode:String = null, clipRect:Object = null, smoothing:Boolean = false):void
	    {}
        
    }
}
