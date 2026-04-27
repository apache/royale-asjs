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
package org.apache.royale.style.colors
{
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.utils.CSSUtils;
	import org.apache.royale.debugging.assert;

	public class ThemeColorSet
	{
		
		public static const BASE:String = 'base';
		public static const PRIMARY:String = 'primary';
		public static const SECONDARY:String = 'secondary';
		public static const ACCENT:String = 'accent';
		public static const INFO:String = 'info';
		public static const SUCCESS:String = 'success';
		public static const WARNING:String = 'warning';
		public static const ERROR:String = 'error';
		public static const NEUTRAL:String = 'neutral';
		
		
		
		private static const _fieldNames:Array = [
			BASE,
			PRIMARY,
			SECONDARY,
			ACCENT,
			INFO,
			SUCCESS,
			WARNING,
			ERROR,
			NEUTRAL
		]
		
		public static function get validFieldNames():Array{
			return _fieldNames.slice();
		} 

		COMPILE::JS
		private const storage:Map = new Map();
		
		private const lchLookups:Object = {init:false};
		private function getLCHLookups():Object{
			if (lchLookups.init === false) {
				delete lchLookups.init;
				var key:String;
				for each(key in _fieldNames) {
					var baseColor:String = getThemeBaseColor(key);
					if (baseColor) {
						var col:uint =ColorSwatch.getColorValue(baseColor);
						lchLookups[baseColor] = ColorUtils.rgb_ToOKLCH([(col>>16)&0xff,(col>>8)&0xff,col&0xff])
					}
				}
			}
			return lchLookups;
		}

		/**
		 * Subclasses must specify colorBase before calling this constructor.
		 */
		public function ThemeColorSet(config:Object = null)
		{
			if (config) fromJSON(config);
		}
		
		public function setThemeColor(key:String, value:String):void{
			assert(_fieldNames.indexOf(key) != -1, 'unknown key "'+key+'" - must be one of :"'+_fieldNames.join('","')+'"')
			if (value) {
				// do we need to validate value?
				assert(ColorSwatch.isExceptionValue(value) || ColorSwatch.isColorName(value), 'unsupported base color:'+value)
			//	var valueToSet:Object = exceptions.indexOf(value) == -1 ? ColorSwatch.fromSpecifier(value) : value;
				COMPILE::JS {
					storage.set(key,value);
				}
			} else {
				COMPILE::JS {
					if (storage.has(key)) storage.delete(key);
				}
			}
		}
		
		public function getThemeBaseColor(key:String):String{
			assert(_fieldNames.indexOf(key) != -1, 'unknown key "'+key+'" - must be one of :"'+_fieldNames.join('","')+'"');
			COMPILE::JS{
				//Q: should there always be a neutral default if no lookup is registered for a specific set?
				if (!storage.has(key)) {
					//do something?
					storage.set(key,ColorSwatch.NEUTRAL);
				}
				return storage.get(key)
			}
			COMPILE::SWF{
				return null;
			}
		}
		COMPILE::JS
		private var swatchStore:Map = new Map();
		COMPILE::SWF
		private var swatchStore:Object = {};
		
		public function getSwatch(key:String,shade:Number=500,opacity:Number=100,dark:Boolean=false):ColorSwatch{
			const lookupVal:String = getThemeBaseColor(key);
			assert(!ColorSwatch.isExceptionValue(lookupVal), 'no swatch or variation for '+key+":"+lookupVal);
			var specifier:String = lookupVal + "-" + shade + '/' + opacity;
			//trace(key,specifier);
			var lookupKey:String = key +':'+ specifier;
			var swatch:ColorSwatch;
			var swatchStoreMap:Object;
			COMPILE::JS {
				swatchStoreMap = swatchStore.get(lookupKey);
				if (!swatchStoreMap) {
					swatchStoreMap = {light:null,dark:null};
					swatchStore.set(lookupKey,swatchStoreMap);
				}
			}
			COMPILE::SWF {
				swatchStoreMap = swatchStore[lookupKey];
				if (!swatchStoreMap) {
					swatchStoreMap = {light:null,dark:null};
					swatchStore[lookupKey] = swatchStoreMap;
				}
			}
			swatch = dark ? swatchStoreMap.dark : swatchStoreMap.light;
			if (!swatch) {
				swatch = ColorSwatch.fromSpecifier(specifier,dark);
				if (dark) {
					swatchStoreMap.dark = swatch;
				} else {
					swatchStoreMap.light = swatch;
				}
			}
			//trace(swatch);
			return swatch;
		}
		
		private var _baseContent:String;
		public function get baseContent():ColorSwatch{
			return ColorSwatch.fromSpecifier(_baseContent,false)
		}
		
		private var _baseContentWeak:String;
		public function get baseContentWeak():ColorSwatch{
			return ColorSwatch.fromSpecifier(_baseContentWeak,false)
		}
		
		public function getContrastSwatch(original:ColorSwatch):ColorSwatch{
			var result:ColorSwatch = findContrastVariant(original.colorBase,original.colorShade,original.dark,false, true);
			if (original.colorOpacity != 100) {
				result = result.getVariant(NaN,original.colorOpacity);
			}
			return result
		}
		
		public function getWeakContrastSwatch(original:ColorSwatch):ColorSwatch{
			var result:ColorSwatch = findContrastVariant(original.colorBase,original.colorShade,original.dark,true, true);
			if (original.colorOpacity != 100) {
				result = result.getVariant(NaN,original.colorOpacity);
			}
			return result;
		}
		
		private var contrastLookupSpecifiers:Object = {};
		
		/**
         * Finds a contrast variant ColorSwatch based on the pararmeters passed in
         * @param swatch the name of a color swatch (can be outside this set)
         * @param shade the shade 50 - 900
         * @param dark tbd
         * @param weak if true then a weak contrast is returned, otherwise a strong contrast
         * @param limitRange if true then limit lookups to this color set only
         * @return
         */
		public function findContrastVariant(swatch:String, shade:Number,dark:Boolean, weak:Boolean, limitRange:Boolean=false):ColorSwatch{
			const lookupKey:String = swatch+'$$'+shade+'$$'+dark+'$$'+weak+'$$';

			var existing:String = contrastLookupSpecifiers[lookupKey];
			if (existing) {
				
				return ColorSwatch.fromSpecifier(existing);
			}
			var base:Object = ColorSwatch.getColorValue(swatch) || CSSLookup.getProperty(swatch);
			var baseColor:uint = CSSUtils.toColor(base);
			shade = Math.round(shade/10);
			var colorVals:Array = ColorUtils.getVariation(baseColor,shade,dark);
			var bgLch:Array = ColorUtils.rgb_ToOKLCH(colorVals);
			var L:Number = bgLch[0];

		//	var wantLight:Boolean = (ColorUtils.contrast([255,255,255], colorVals) < ColorUtils.contrast([0,0,0], colorVals));
			var wantLight:Boolean = (L < .62);
			
			// Strong or weak contrast?
			var targetLch:Array = ColorUtils.generateContrastLCH(bgLch, wantLight);
			if (weak) {
				// Weak contrast = reduce chroma + move L slightly toward bg
				targetLch[1] *= 0.4;     // reduce chroma
				targetLch[0] = (targetLch[0] + L) * 0.5; // blend toward background
			}
			
			var fg:Array = targetLch;
			colorVals = ColorUtils.oklch_ToRGB(fg);
			var lookups:Object = limitRange ? getLCHLookups() : null;
			var ret:ColorSwatch = ColorSwatch.estimateFromRGB(colorVals,lookups);
			contrastLookupSpecifiers[lookupKey] = ret.toString()

			return ret;
		}
		
		public function fromJSON(obj:Object):void{
			if (typeof obj == 'string') obj = JSON.parse(obj as String);
			for (var key:String in obj) {
				switch(key) {
					case '_baseContent':
						_baseContent = obj[key];
						break;
					case '_baseContentWeak':
						_baseContentWeak = obj[key];
						break;
					default:
						setThemeColor(key,obj[key]);
				}
				
			}
		}
		
		public function toJSON():Object{
			const obj:Object = {};
			COMPILE::JS{
				var keys:Array = Object.keys(storage);
				for each(var key:String in keys) {
					var color:String = storage.get(key);
					obj[key] = color;
				}
				obj['_baseContent'] = _baseContent;
				obj['_baseContentWeak'] = _baseContentWeak;
			}
			return obj;
		}
		
	}
}