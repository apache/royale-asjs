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
			var swatch:String = original.colorBase;
			var shade:Number = original.colorShade;
			var opacity:Number = original.colorOpacity;
			var dark:Boolean = original.dark;
			var nameVariant:String = swatch+'-contrast';
			if (!CSSLookup.has(nameVariant)) {
				registerContrastVariant(nameVariant,swatch,shade,dark,false);
			}
			return new ColorSwatch(nameVariant,500,opacity,dark);
		}
		
		public function getWeakContrastSwatch(original:ColorSwatch):ColorSwatch{
			var swatch:String = original.colorBase;
			var shade:Number = original.colorShade;
			var opacity:Number = original.colorOpacity;
			var dark:Boolean = original.dark;
			var nameVariant:String = swatch+'-contrast-weak';
			if (!CSSLookup.has(nameVariant)) {
				registerContrastVariant(nameVariant,swatch,shade,dark,true);
			}
			return new ColorSwatch(nameVariant,500,opacity,dark);
		}
		
		private static function registerContrastVariant(nameVariant:String, swatch:String, shade:Number,dark:Boolean, weak:Boolean):void{
			var base:Object = ColorSwatch.getColorValue(swatch) || CSSLookup.getProperty(swatch);
			var baseColor:uint = CSSUtils.toColor(base);
			// Convert from 50,100,200... to 5,10,20... for easier math.
			shade = Math.round(shade/10);
			var colorVals:Array = CSSColor.getVariation(baseColor,shade,dark);
			var oklch:Array = CSSColor.rgb_ToOKLCH(colorVals);
			var L:Number = oklch[0];
			var H:Number = oklch[2];
			var fg:Array;
			
			if (weak) {
				if (L < 0.55)
					fg = [0.80, 0.01, H]; // weak light
				else
					fg = [0.35, 0.02, H]; // weak dark
			} else {
				if (L < 0.55)
					fg = [0.97, 0.02, H]; // light contrast
				else
					fg = [0.18, 0.03, H]; // dark contrast
			}
			
			colorVals = CSSColor.oklch_ToRGB(fg);
			CSSLookup.register(nameVariant,'rgb('+colorVals.join(',')+')');
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