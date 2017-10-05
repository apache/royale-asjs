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
package org.apache.royale.text.engine
{
	import org.apache.royale.text.engine.IFontLoader;

	public class FontDescription
	{
		public function FontDescription(fontName:String = "_serif", fontStyle:String = "", fontLoader:IFontLoader=null)
		{
			// this.cffHinting = cffHinting;
			// this.fontLookup = fontLookup;
			this.fontName = fontName;
			this.fontStyle = fontStyle;
			// this.fontPosture = fontPosture;
			// this.fontWeight = fontWeight;
			// this.renderingMode = renderingMode;
			this.fontLoader = fontLoader;
		}
		// public var cffHinting : String;
		// public var fontLookup : String;
		public var fontName : String;
		public var fontPosture : String;
		public var fontWeight : String;
		// public var locked : Boolean;
		// public var renderingMode : String;
		public var fontStyle:String;
		public var fontLoader:IFontLoader;
	
		public function clone():FontDescription
		{
			return new FontDescription(fontName, fontStyle, fontLoader);
		}
		
		//These two methods probably don't make sense
		public static function isDeviceFontCompatible(fontName:String, fontStyle:String):Boolean
		{
			return false;
		}
		public static function isFontCompatible(fontName:String, fontStyle:String):Boolean
		{
			return false;
		}
	}
}
