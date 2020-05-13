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
    import org.apache.royale.display.GraphicsBitmapFill;
    import org.apache.royale.display.js.JSRuntimeGraphicsStore;
    
    COMPILE::JS{
        import org.apache.royale.geom.Matrix;
        import org.apache.royale.display.js.createGraphicsSVG;
    }
    
    COMPILE::SWF{
        import flash.geom.Matrix;
        import flash.utils.Dictionary;
        import flash.display.BitmapData;
    }
    
    //todo: consider opt-in bounds updates, specific to graphics, dispatched as 'graphicsUpdate' on target,
    // and available as 'current'/accurate from this graphics context at the time of the event. They would only
    // represent the bounds of the Graphics content itself and exclude other potential children of the render target
    
    /**
     * @royalesuppressexport
     */
    public class Graphics
    {
        
        private static var unlocked:Boolean;
        
        COMPILE::JS
        private static var instanceMap:WeakMap;
        
        COMPILE::SWF
        private static var instanceMap:Dictionary;
        
        
        public static function getInstanceFor(target:IGraphicsTarget):Graphics{
            if (!target) return null;
            var graphicsInst:Graphics;
            COMPILE::JS{
                if (!instanceMap) {
                    instanceMap = new WeakMap();
                } else {
                    graphicsInst = instanceMap.get(target);
                }
                if (!graphicsInst) {
                    unlocked = true;
                    instanceMap.set(target, (graphicsInst = new Graphics(target)));
                    unlocked = false;
                }
            }
            COMPILE::SWF{
                if (!instanceMap) {
                    instanceMap = new Dictionary(true);
                } else {
                    graphicsInst = instanceMap[target];
                }
                if (!graphicsInst) {
                    unlocked = true;
                    graphicsInst =  instanceMap[target] = new Graphics(target);
                    unlocked = false;
                }
            }
            return graphicsInst;
        }
        
        /**
         * This provides explicit support for reflection if needed. Otherwise this class can be assumed to be unreflectable by normal means (across targets)
         * @param instance - the instance of the Graphics class to be reflected against
         * @return an object that is reflectable via string method names which map to runtime method references
         *
         */
        public static function getReflectionMap(instance:Graphics):Object{
            COMPILE::SWF{
                return instance
            }
            COMPILE::JS{
                if (!instance) return null;
                return {
                    'clear': instance.clear,
                    'beginFill': instance.beginFill,
                    'endFill': instance.endFill,
                    'beginGradientFill': instance.beginGradientFill,
                    'beginBitmapFill': instance.beginBitmapFill,
                    'lineGradientStyle': instance.lineGradientStyle,
                    'lineBitmapStyle': instance.lineBitmapStyle,
                    'lineStyle': instance.lineStyle,
                    'moveTo': instance.moveTo,
                    'lineTo': instance.lineTo,
                    'curveTo': instance.curveTo,
                    'cubicCurveTo': instance.cubicCurveTo,
                    'drawEllipse': instance.drawEllipse,
                    'drawRoundRect': instance.drawRoundRect,
                    'drawRoundRectComplex': instance.drawRoundRectComplex,
                    'drawRect': instance.drawRect,
                    'drawCircle': instance.drawCircle
                }
            }
        }
        
        
        public function Graphics(target:IGraphicsTarget)
        {
            super();
            if (!unlocked) throw new Error('Constructor call not permitted, use static getInstanceFor method');
            this.graphicsTarget = target;
            COMPILE::JS
            {
                //increment the Graphics instance index
                _instIdx ++;
            }
        }
        
        private var graphicsTarget:IGraphicsTarget;
        
        /**
         * @royaleignorecoercion HTMLElement
         */
        public function clear():void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.clear();
            }
            COMPILE::JS
            {
                var svg:SVGElement = graphicsTarget.graphicsRenderTarget;
                while (svg.firstChild) {
                    svg.removeChild(svg.firstChild);
                }
                _defs = null;
                defsIdx = 0;
                currentFill = null;
                currentStroke = new GraphicsStroke();
                _pathData = null;
                _currentPath = null;
                _currentStrokePath = null;
                _strokePathData = null;
                _nonZeroFill = false;
                _lastPoint = _lastStartPoint = null;
                _moveTo = null;
                _strokeMove = false;
                
            }
        }
        
        
        COMPILE::JS{
            
            private static var _instIdx:uint = 0;
            private var defsIdx:uint = 0;
            private var _nonZeroFill:Boolean;
            private var _defs:SVGDefsElement;
            
            private function get svg():SVGElement{
                return graphicsTarget.graphicsRenderTarget;
            }
            
            /**
             * @royaleignorecoercion SVGDefsElement
             */
            private function get defs():SVGDefsElement{
                if (!_defs) {
                    _defs = createGraphicsSVG('defs', false) as SVGDefsElement;
                    var svgNode:SVGElement = svg;
                    if (svgNode.childNodes.length) {
                        svgNode.insertBefore(_defs, svgNode.childNodes[0]);
                    } else svgNode.appendChild(_defs);
                }
                return _defs;
            }
            
            private var _pathData:Attr;
            private function getPathData():Attr{
                if (!_pathData) {
                    getCurrentPath();
                }
                return _pathData;
            }
            
            private var currentFill:IGraphicsFill;
            private var currentStroke:GraphicsStroke = new GraphicsStroke();
            
            private var _currentPath:SVGPathElement;
            private var _currentStrokePath:SVGPathElement;
            
            /**
             * @royaleignorecoercion SVGPathElement
             * @royaleignorecoercion SVGElement
             */
            private function getCurrentPath():SVGPathElement{
                if (!_currentPath) {
                    _currentPath = createGraphicsSVG('path') as SVGPathElement;
                    _currentStrokePath = _currentPath;
                    _currentPath.setAttributeNS(null, 'd','');
                    _pathData = _currentPath.getAttributeNodeNS(null,'d');
                    
                    if (currentFill) {
                        currentFill.apply(this, _currentPath );
                        if (!_nonZeroFill) {
                            //nonzero is default in svg, evenodd is default in swf
                            _currentPath.setAttributeNS(null, 'fill-rule', 'evenodd');
                        } else {
                            //set it to false for next time. This can only be set to true via GraphicsPath processing.
                            _nonZeroFill = false;
                        }
                    }
                    else setNoFill(_currentPath);
                    svg.appendChild(_currentPath);
                    //apply the current stroke now, spawning stroke paths if necessary as determined by stroke implementation
                    currentStroke.apply(this, _currentPath);
                }
                return _currentPath;
            }
            
            private var _strokePathData:Attr;
            private var _lastStartPoint:String;
            private var _moveTo:String;
            private var _lastPoint:String; //'{x} {y}' for last point
            private var _strokeMove:Boolean;
            private function appendPathData(value:String, lastPoint:String):void{
                _lastPoint = lastPoint;
                if (_moveTo) {
                    value = _moveTo + value;
                    _moveTo = null;
                } else if (!_pathData && value.charAt(0) !== 'M') {
                    value = 'M0 0' + value;
                }
                getPathData().value += value;
                if (_currentStrokePath !== _currentPath) {
                    //we have a spawned stroke
                    if (_strokeMove && value.charAt(0) === 'M') {
                        _strokePathData.value = value;
                    } else {
                        _strokePathData.value += value;
                    }
                    _strokeMove = false;
                }
            }
            
            /**
             * support for linestyle changes that occur 'during' a path
             * also supports special cases where filters are used to support certain effects in svg
             *
             * @royaleignorecoercion SVGPathElement
             */
            internal function spawnStroke(fromPaint:Boolean):SVGPathElement{
                
                if (!_strokePathData) {
                    //retain the original for fill,
                    //if we had no stroke, then no need to create the original, just continue after
                    if (getCurrentPath().getAttributeNS(null, 'stroke') !== 'none') {
                        //otherwise set current path stroke to none, transfer previous stroke attributes to new sub path
                        _currentStrokePath = createGraphicsSVG('path') as SVGPathElement;
                        _currentStrokePath.setAttributeNS(null, 'd', getPathData().value);
                        _currentStrokePath.setAttributeNS(null, 'fill', 'none');
                        currentStroke.apply(this,_currentStrokePath);
                        getCurrentPath().setAttributeNS(null, 'stroke', 'none');
                        svg.appendChild(_currentStrokePath);
                        if (fromPaint) {
                            _strokePathData = _currentStrokePath.getAttributeNodeNS(null, 'd');
                            return _currentStrokePath;
                        }
                    }
                }
                
                _currentStrokePath = createGraphicsSVG('path') as SVGPathElement;
                //then create the new stroke target
                _strokeMove = true;
                _currentStrokePath.setAttributeNS(null, 'd', 'M' + _lastPoint);
                _currentStrokePath.setAttributeNS(null, 'fill', 'none');
                _strokePathData = _currentStrokePath.getAttributeNodeNS(null, 'd');
                svg.appendChild(_currentStrokePath);
                _lastPoint = null;
                return _currentStrokePath;
            }
            
            private const STROKE_SOLID_FILL:GraphicsSolidFill = new GraphicsSolidFill();
            private const STROKE_GRADIENT_FILL:GraphicsGradientFill = new GraphicsGradientFill();
            private const STROKE_BITMAP_FILL:GraphicsBitmapFill = new GraphicsBitmapFill();
            private const SOLID_FILL:GraphicsSolidFill = new GraphicsSolidFill();
            private const GRADIENT_FILL:GraphicsGradientFill = new GraphicsGradientFill();
            private const BITMAP_FILL:GraphicsBitmapFill = new GraphicsBitmapFill();
    
            
          
            /**
             *
             * @royaleignorecoercion SVGPatternElement
             * @royaleignorecoercion SVGUseElement
             */
            internal function makeBitmapPaint(bitmapData:BitmapData, smooth:Boolean):SVGPatternElement{
                var patternElement:SVGPatternElement = createGraphicsSVG('pattern', false) as SVGPatternElement;
                patternElement.setAttributeNS(null, 'patternUnits', 'userSpaceOnUse');
                var imageUse:SVGUseElement = createGraphicsSVG('use', false) as SVGUseElement;
                var id:String = bitmapData.getID();
                if (!defs.hasAttribute('xmlns:xlink')) {
                    defs.setAttribute('xmlns:xlink', 'http://www.w3.org/1999/xlink');
                }
                imageUse.setAttributeNS( "http://www.w3.org/1999/xlink", "href", '#impl-'+ id);
               
                if (!smooth) { //we will assume that 'auto' default is always smooth (until evidence suggests otherwise, the specs do say that quality should be emphasized by default)
                    //this is not supported on all browsers, but it does work for Chrome, Opera, Firefox, and also creates svg content that renders more accurately in Inkscape from testing
                    imageUse.setAttributeNS(null, 'style', 'image-rendering: optimizeSpeed; image-rendering: pixelated;')
                }
                
                patternElement.appendChild(imageUse);

                defs.appendChild(patternElement);
                patternElement.setAttribute('id', 'royale-bitmapfill-' + _instIdx + '-' + defsIdx);
                defsIdx++;
                return patternElement;
            }
            
            
            /**
             *
             * @royaleignorecoercion SVGGradientElement
             */
            internal function makeGradient(elementType:String):SVGGradientElement{
                var gradientElement:SVGGradientElement = createGraphicsSVG(elementType, false) as SVGGradientElement;
                gradientElement.setAttributeNS(null, 'gradientUnits', 'userSpaceOnUse');
                defs.appendChild(gradientElement);
                gradientElement.setAttribute('id', 'royale-gradient-' + _instIdx + '-' + defsIdx);
                defsIdx++;
                return gradientElement;
            }
            
            /**
             * @royaleignorecoercion SVGStopElement
             */
            internal function makeGradientStop():SVGStopElement{
                var stopElement:SVGStopElement = createGraphicsSVG('stop', false) as SVGStopElement;
                return stopElement;
            }
            
            private static var _linearRGBfilter:SVGFilterElement;
            /**
             * This is used to allow emulation of 'linearRGB' interpolationMethod in gradients
             * @royaleignorecoercion SVGFilterElement
             * @royaleignorecoercion SVGElement
             */
            internal function getLinearRGBfilter():String{
                var id:String = 'royale-linearRGB-filter';
                if (_linearRGBfilter) {
                    return 'url(#' +id+ ')';
                    //return 'url(\'#' +_filter.getAttribute('id')+ '\')';
                }
                //var id:String = 'royale-linearRGB-filter' + _instIdx;
                var filter:SVGFilterElement= createGraphicsSVG('filter', false) as SVGFilterElement;
                filter.setAttribute('id', id);
                filter.setAttributeNS(null, 'filterUnits', 'objectBoundingBox');
                //The silent defaults for the filter region are: x="-10%" y="-10%" width="120%"
                //generally that should accommodate most stroke sizes, but may clip some wide strokes.
                //if clipping occurs and these need to be spawned to accommodate specifc cases, a stroke-width argument could be
                //passed to this method and adjusted accordingly.
                //likewise, for any paths that are horizontal or vertical likes only (one dimension is zero), objectBoundingBox units will not work
                //nothing is attempted to deal with this at this point... it could however be addressed if there is demand.
                //both of the above scenarios are assumed to be 'rare'
                var arr:Array = ['R','G','B','A'];
                arr = arr.map(function(col:String):String{return '<feFunc' + col +' type="gamma" amplitude="1" exponent="0.454545454545" offset="0"/>'});
                filter.innerHTML = '<feComponentTransfer color-interpolation-filters="sRGB">' + arr.join('') + '</feComponentTransfer>';
                _linearRGBfilter = filter;
                JSRuntimeGraphicsStore.getInstance().addGraphicsImpl(filter as SVGElement);
             //   defs.appendChild(filter);
                //return 'url(\'#' + id + '\')';
                return 'url(#' + id + ')';
            }
        }
        
        public function beginFill(color:uint, alpha:Number = 1.0):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.beginFill(color, alpha);
            }
            COMPILE::JS
            {
                if (_currentPath)  endCurrentPath();
                SOLID_FILL.color = color;
                SOLID_FILL.alpha = alpha;
                currentFill = SOLID_FILL;
            }
        }
        
        
        public function endFill(): void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.endFill();
            }
            COMPILE::JS
            {
                endCurrentPath();
            }
        }
        
        
        
        public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = 'pad', interpolationMethod:String = 'rgb', focalPointRatio:Number = 0):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
            }
            COMPILE::JS
            {
                if (_currentPath)  endCurrentPath();
                //validate the colors/alphas/ratios
                if (colors == null || !colors.length) {
                    currentFill = null;
                    return
                }
                if (type !== 'linear' && type !== 'radial') throw new Error('Error #2008: Parameter type must be one of the accepted values.');
                var gradientFill:GraphicsGradientFill = GRADIENT_FILL;
                gradientFill.type = type;
                gradientFill.colors = colors ? colors.slice(): null;
                gradientFill.alphas = alphas ? alphas.slice(): null;
                gradientFill.ratios = ratios ? ratios.slice(): null;
                gradientFill.matrix = matrix ? matrix.clone() /*as Matrix*/: null;
                gradientFill.spreadMethod = spreadMethod;
                gradientFill.interpolationMethod = interpolationMethod;
                gradientFill.focalPointRatio = focalPointRatio;
                currentFill = gradientFill;
            }
        }
        
        /*COMPILE::JS
        private var _bitmapDatas:Array;
        internal function usedBitmapData(bitmap:BitmapData):void{
            var bdatas:Array = _bitmapDatas || (_bitmapDatas = []);
            if (bdatas.indexOf(bitmap) == -1) {
                bdatas.push(bitmap);
            }
        }
        */
        public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void{
            COMPILE::SWF{
                graphicsTarget.graphicsRenderTarget.beginBitmapFill(bitmap, matrix, repeat, smooth);
            }
            COMPILE::JS
            {
                if (_currentPath)  endCurrentPath();
                //validate the btimapData
                if (bitmap == null) {
                    throw new TypeError('Error #2007: Parameter bitmap must be non-null.')
                }

                var bitmapFill:GraphicsBitmapFill = BITMAP_FILL;
                bitmapFill.bitmapData = bitmap;
                bitmapFill.matrix = matrix ? matrix.clone()/* as Matrix*/: null;;
                bitmapFill.repeat = repeat;
                bitmapFill.smooth = smooth;
                currentFill = bitmapFill;
            }
        }
    
    
        public function lineBitmapStyle(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void{
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.lineBitmapStyle(bitmap, matrix, repeat, smooth);
            }
            COMPILE::JS
            {
                //validate the btimapData
                if (bitmap == null) {
                    throw new TypeError('Error #2007: Parameter bitmap must be non-null.')
                }
    
                var bitmapFill:GraphicsBitmapFill = STROKE_BITMAP_FILL;
                bitmapFill.bitmapData = bitmap;
                bitmapFill.matrix = matrix ? matrix.clone()/* as Matrix*/: null;
                bitmapFill.repeat = repeat;
                bitmapFill.smooth = smooth;
                currentStroke.fill = bitmapFill;
                if (_currentStrokePath) {
                    currentStroke.apply(this, _currentStrokePath);
                }
            }
        }
        
        
        public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void{
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
            }
            COMPILE::JS
            {
                //validate the colors/alphas/ratios
                if (colors == null || !colors.length) {
                    currentStroke.thickness = NaN;
                    return
                }
                if (type !== 'linear' && type !== 'radial') throw new Error('Error #2008: Parameter type must be one of the accepted values.');
                var gradientFill:GraphicsGradientFill = STROKE_GRADIENT_FILL;
                gradientFill.type = type;
                gradientFill.colors = colors ? colors.slice(): null;
                gradientFill.alphas = alphas ? alphas.slice(): null;
                gradientFill.ratios = ratios ? ratios.slice(): null;
                gradientFill.matrix = matrix ? matrix.clone() /*as Matrix*/: null;
                gradientFill.spreadMethod = spreadMethod;
                gradientFill.interpolationMethod = interpolationMethod;
                gradientFill.focalPointRatio = focalPointRatio;
                currentStroke.fill = gradientFill;
                if (_currentStrokePath) {
                    currentStroke.apply(this, _currentStrokePath);
                }
            }
        }
        
        
        public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = 'normal', caps:String = null, joints:String = null, miterLimit:Number = 3):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
            }
            COMPILE::JS
            {
                var checkForSpawn:Boolean = _currentPath;
                var strokeBase:GraphicsStroke = currentStroke;
                
                caps = caps ? caps: CapsStyle.ROUND;
                joints = joints ? joints: JointStyle.ROUND;
                if (checkForSpawn && _lastPoint) {
                    if (strokeBase.thickness !== thickness
                            || strokeBase.fill !== STROKE_SOLID_FILL || color !== STROKE_SOLID_FILL.color || alpha !== STROKE_SOLID_FILL.alpha
                            //    || strokeBase.pixelHinting !== pixelHinting
                            || strokeBase.scaleMode !== scaleMode
                            || strokeBase.caps !== caps
                            || strokeBase.joints !== joints
                            || strokeBase.miterLimit !== miterLimit)
                    {
                        spawnStroke(false);
                    }
                }
                
                STROKE_SOLID_FILL.color = color;
                STROKE_SOLID_FILL.alpha = alpha;
                
                strokeBase.thickness = thickness;
                strokeBase.fill = STROKE_SOLID_FILL;
                strokeBase.pixelHinting = pixelHinting;
                strokeBase.scaleMode = scaleMode;
                strokeBase.caps = caps ? caps: CapsStyle.ROUND;
                strokeBase.joints = joints;
                strokeBase.miterLimit = miterLimit;
                
                if (_currentStrokePath) {
                    strokeBase.apply(this, _currentStrokePath);
                }
            }
        }
        
        
        COMPILE::JS
        private function endCurrentPath():void{
            if (!isNaN(currentStroke.thickness)) {
                
                if (_pathData && _pathData.value) {
                    var lastChar:String = _pathData.value.substr(_pathData.value.length-1);
                    if (lastChar.toUpperCase() != 'Z') {
                        _pathData.value += 'Z';
                    }
                    
                    if (_currentStrokePath !== _currentPath) {
                        _strokePathData.value += 'L' + _lastStartPoint;
                    }
                }
            }
            
            _currentPath = null;
            _currentStrokePath = null;
            _pathData = null;
            _strokePathData = null;
            _lastStartPoint = null;
            _lastPoint = null;
            currentFill = null;
        }
        
        public function moveTo(x:Number, y:Number):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.moveTo(x, y);
            }
            COMPILE::JS
            {
                var lp:String = x + ' ' + y;
                /*if (!_lastStartPoint)*/ _lastStartPoint = lp;
                _moveTo = 'M' + lp;
                //appendPathData('M' + lp, lp);
            }
        }
        
        public function lineTo(x:Number, y:Number):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.lineTo(x, y);
            }
            COMPILE::JS
            {
                var lp:String = x + ' ' + y;
                if (!_lastStartPoint) _lastStartPoint = '0 0';
                appendPathData('L' + lp, lp);
            }
        }
        
        public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.curveTo(controlX, controlY, anchorX, anchorY);
            }
            COMPILE::JS
            {
                var lp:String = anchorX + ' ' + anchorY;
                if (!_lastStartPoint) _lastStartPoint = '0 0';
                appendPathData('Q' + controlX + ' ' + controlY + ' ' + lp, lp);
            }
        }
        
        public function cubicCurveTo(controlX1:Number, controlY1:Number, controlX2:Number, controlY2:Number, anchorX:Number, anchorY:Number):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
            }
            COMPILE::JS
            {
                var lp:String = anchorX + ' ' + anchorY;
                if (!_lastStartPoint) _lastStartPoint = '0 0';
                appendPathData('C' + controlX1 + ' ' + controlY1 + ' ' + controlX2 + ' ' + controlY2 + ' ' + lp, lp);
            }
        }
        
        
        public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.drawEllipse(x, y, width, height);
            }
            COMPILE::JS
            {
                //match flash api for NaNs:
                if (isNaN(width) || isNaN(height)) {
                    throw new Error('Error #2004: One of the parameters is invalid.')
                }
                if (isNaN(y)) y = 0;
                if (isNaN(x)) x = 0;
                
                var d:String;
                var rx:Number = width/2;
                var ry:Number = height/2;
                var centerY:String = ' ' + (y + ry);
                var startPoint:String = (x + width) + centerY;
                if (rx == 0 || ry == 0) {
                    //draw a back/forth line either vertical or horizontal
                    if (rx == 0) {
                        d = 'M' + x + ' ' + (y + height);
                    } else {
                        d = 'M' + startPoint;
                    }
                    
                    if (rx || ry) {
                        if (rx)
                            d += 'L' + x + centerY + 'Z';
                        else {
                            d += 'L' + x + ' ' + y + 'Z';
                        }
                    }
                    
                } else {
                    var arcTo:String = 'A' + rx + ' ' + ry + ' 0 0 0 ';
                    d = 'M' + startPoint
                            + arcTo + x + centerY
                            + arcTo + startPoint;
                }
                _lastStartPoint = null;
                appendPathData(d, startPoint);
            }
        }
        
        
        public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
            }
            COMPILE::JS
            {
                //match flash api for NaNs:
                if (isNaN(width) || isNaN(height) || isNaN(ellipseWidth)) {
                    throw new Error('Error #2004: One of the parameters is invalid.')
                }
                if (isNaN(y)) y = 0;
                if (isNaN(x)) x = 0;
                
                var rX:Number = Math.min(ellipseWidth/2, width/2);
                if (isNaN(ellipseHeight)) {
                    ellipseHeight = ellipseWidth;
                }
                var rY:Number = Math.min(ellipseHeight /2, height/2);
                if (rX == 0 || rY ==0)
                {
                    //no rounded corners
                    _drawRect(x, y, width, height);
                    return;
                }
                
                //the following correctly emulates flash api behavior with -ve radius values, or -ve width and height
                var xw:Number = x + width;
                var yh:Number = y + height;
                var sweep:String = rX * rY < 0 ? '0 ' : '1 ';
                var arcBase:String = 'A' + rX + ' ' + rY +' 0 0 ' + sweep;
                var startPoint:String = xw + ' ' + (yh - rY);
                var d:String = 'M' + startPoint //xw +' ' + (yh - rY)
                        + arcBase + (xw - rX) +' ' + yh
                        + 'L' + (x + rX) +' ' + yh
                        + arcBase + x + ' ' + (yh - rY)
                        + 'L' + x +' ' + (y + rY)
                        + arcBase + (x + rX) + ' ' + y
                        + 'L' + (xw - rX) +' ' + y
                        + arcBase + xw + ' ' + (y + rY)
                        + 'Z'; //'L' + startPoint; //xw  +' ' + (yh - rY); consider swapping this last one for 'Z'
                
                _lastStartPoint = null;
                appendPathData(d, startPoint);
            }
        }
        
        
        public function drawRoundRectComplex(x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.drawRoundRectComplex(x, y, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
            }
            COMPILE::JS
            {
                if (isNaN(width) || isNaN(height) || isNaN(topLeftRadius) || isNaN(topRightRadius) || isNaN(bottomLeftRadius) || isNaN(bottomRightRadius)) {
                    throw new Error('Error #2004: One of the parameters is invalid.')
                }
                if (isNaN(y)) y = 0;
                if (isNaN(x)) x = 0;
                
                var d:String;
                var rectOnly:Boolean = (height > 0 && width > 0) && (topLeftRadius==0 && topRightRadius==0 && bottomLeftRadius==0 && bottomRightRadius==0);
                if (!rectOnly) {
                    rectOnly = (width == 0 || height ==0) && (topLeftRadius>=0 && topRightRadius>=0 && bottomLeftRadius>=0 && bottomRightRadius>=0 )
                }
                if(rectOnly){
                    _drawRect(x, y, width, height);
                    return;
                }
                //the following appears to emulate flash api behavior with -ve radius values, or -ve width and height
                var xw:Number = x + width;
                var yh:Number = y + height;
                
                var maxSize:Number = width < height ? width / 2 : height / 2;
                //observed behavior:
                
                if (topRightRadius + bottomRightRadius > height) {
                    topRightRadius = bottomRightRadius = maxSize;
                }
                
                if (height < width) {
                    if (topLeftRadius + bottomLeftRadius > height) topLeftRadius  = bottomLeftRadius = maxSize;
                    if (topRightRadius + bottomRightRadius > height) topRightRadius  = bottomRightRadius = maxSize;
                } else {
                    if (topLeftRadius + topRightRadius  > width) topLeftRadius  = topRightRadius = maxSize;
                    if (bottomLeftRadius + bottomRightRadius > width) bottomLeftRadius  = bottomRightRadius = maxSize;
                }
                /*topLeftRadius = topLeftRadius > maxSize ?  maxSize : topLeftRadius;
                topRightRadius = topRightRadius > maxSize ?  maxSize : topRightRadius;
                bottomLeftRadius = bottomLeftRadius > maxSize ?  maxSize : bottomLeftRadius;
                bottomRightRadius = bottomRightRadius > maxSize ? maxSize : bottomRightRadius;*/
                var startPoint:String = xw + ' ' + (yh - bottomRightRadius);
                // bottom-right corner
                if (bottomRightRadius){
                    d = 'M' + startPoint //xw + ' ' + (yh - bottomRightRadius)
                            + 'A' +bottomRightRadius + ' ' + bottomRightRadius + ' 0 0 1 ' + (xw-bottomRightRadius) + ' ' + yh;
                } else {
                    d = 'M' + startPoint; //xw + ' ' + yh ;
                }
                
                // bottom-left corner
                if (bottomLeftRadius) {
                    d += 'L' + (x + bottomLeftRadius) +' ' + yh
                            + 'A' +bottomLeftRadius + ' ' + bottomLeftRadius + ' 0 0 1 ' + x + ' ' + (yh - bottomLeftRadius);
                } else {
                    d += 'L' + x + ' ' + yh
                }
                
                // top-left corner
                if (topLeftRadius) {
                    d += 'L' + x + ' ' + (y + topLeftRadius)
                            + 'A' + topLeftRadius + ' ' + topLeftRadius + ' 0 0 1 ' + (x + topLeftRadius) + ' ' + y;
                } else {
                    d += 'L' + x + ' ' + y;
                }
                
                // top-right corner
                if (topRightRadius) {
                    d += 'L' + (xw - topRightRadius) +' ' + y
                            + 'A' + topRightRadius + ' ' + topRightRadius + ' 0 0 1 ' + xw + ' ' + (y + topRightRadius)
                            + 'Z'; //'L' + startPoint; //xw + ' ' + (yh - bottomRightRadius); //check swapping this last one for 'Z'
                } else {
                    d += 'L' + xw  + ' ' + y
                            + 'Z'; //'L' + startPoint; //xw + ' ' + (yh - bottomRightRadius);//check swapping this last one for 'Z'
                }
                
                //_lastStartPoint = null;
                appendPathData(d, startPoint);
            }
        }
        
        public function drawRect(x:Number, y:Number, width:Number, height:Number):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.drawRect(x, y, width, height);
            }
            COMPILE::JS
            {
                if (isNaN(width) || isNaN(height)) {
                    throw new Error('Error #2004: One of the parameters is invalid.');
                }
                if (isNaN(x)) x = 0;
                if (isNaN(y)) y = 0;
                
                var w:Boolean = !!width;
                var h:Boolean = !!height;
                var startPoint:String = x + ' ' + y;
                var d:String = 'M' + startPoint; //x + ' ' + y;
                if (w) d += 'h' + width;
                if (h) d += 'v' + height;
                if (w) d += 'h' + -width;
                if (w || h)  d += 'Z';
                
                _lastStartPoint = null;
                appendPathData(d, startPoint);
            }
        }
        
        COMPILE::JS
        private function _drawRect(x:Number, y:Number, width:Number, height:Number):void{
            //end point is bottom right (un-rounded form of rounded rectangle)
            if (isNaN(width) || isNaN(height)) {
                throw new Error('Error #2004: One of the parameters is invalid.');
            }
            if (isNaN(x)) x = 0;
            if (isNaN(y)) y = 0;
            
            var w:Boolean = !!width;
            var h:Boolean = !!height;
            var startPoint:String = (x + width) + ' ' + (y + height);
            var d:String = 'M' + startPoint; //x+width + ' ' + y+ height;
            if (w) d += 'h' + -width;
            if (h) d += 'v' + -height;
            if (w) d += 'h' + width;
            if (w || h)  d += 'Z';
            
            appendPathData(d, startPoint);
        }
        
        
        public function drawCircle(x:Number, y:Number, radius:Number):void
        {
            COMPILE::SWF
            {
                graphicsTarget.graphicsRenderTarget.drawCircle(x, y, radius);
            }
            COMPILE::JS
            {
                if (isNaN(radius)) {
                    throw new Error('Error #2004: One of the parameters is invalid.');
                }
                //observed flash api behavior:
                if (isNaN(x)) x = radius;
                if (isNaN(y)) y = radius;
                var startPoint:String;
                var d:String;
                if (radius) {
                    var arcBase:String = 'A'+ radius + ' ' + radius + ' 0 0 0 ';
                    var yS:String = ' ' + y;
                    startPoint = (x + radius) + yS;
                    d = 'M' + startPoint
                            + arcBase + (x - radius) + yS
                            + arcBase + startPoint;
                } else {
                    startPoint = x + ' ' + y;
                    d = 'M' + startPoint;
                }
                
                _lastStartPoint = null;
                appendPathData(d, startPoint);
            }
        }
    }
}



COMPILE::JS
function setNoFill(element:SVGPathElement):void {
    element.setAttributeNS(null, 'fill', 'none');
}
