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
package org.apache.royale.style.stylebeads.filters
{
	import org.apache.royale.style.stylebeads.StyleBeadBase;

	abstract public class FilterEffectBase extends StyleBeadBase
	{
		public function FilterEffectBase()
		{
			super();
		}

    private var _blur:String;
		[Inspectable(category="General", enumeration="xs,sm,md,lg,xl,2xl,3xl,none", defaultValue="none")]
    public function get blur():String
    {
    	return _blur;
    }

    public function set blur(value:String):void
    {
    	_blur = value;
    }
    private var _dropShadow:String;

		[Inspectable(category="General", enumeration="xs,sm,md,lg,xl,2xl,none", defaultValue="none")]
    public function get dropShadow():String
    {
    	return _dropShadow;
    }

    public function set dropShadow(value:String):void
    {
    	_dropShadow = value;
    }
    private var _brightness:Number;
		[Inspectable(category="General", defaultValue="100", minValue="0", maxValue="1000")]
    public function get brightness():Number
    {
    	return _brightness;
    }

    public function set brightness(value:Number):void
    {
    	_brightness = value;
    }
    private var _contrast:Number;
		[Inspectable(category="General", defaultValue="100", minValue="0", maxValue="1000")]
    public function get contrast():Number
    {
    	return _contrast;
    }

    public function set contrast(value:Number):void
    {
    	_contrast = value;
    }
    private var _grayscale:Number;
		[Inspectable(category="General", defaultValue="0", minValue="0", maxValue="100")]
    public function get grayscale():Number
    {
    	return _grayscale;
    }

    public function set grayscale(value:Number):void
    {
    	_grayscale = value;
    }
    private var _invert:Number;
		[Inspectable(category="General", defaultValue="0", minValue="0", maxValue="100")]
    public function get invert():Number
    {
    	return _invert;
    }

    public function set invert(value:Number):void
    {
    	_invert = value;
    }
    private var _saturate:Number;

		[Inspectable(category="General", defaultValue="100", minValue="0", maxValue="1000")]
    public function get saturate():Number
    {
    	return _saturate;
    }

    public function set saturate(value:Number):void
    {
    	_saturate = value;
    }
    private var _sepia:Number;
		[Inspectable(category="General", defaultValue="0", minValue="0", maxValue="100")]
    public function get sepia():Number
    {
    	return _sepia;
    }

    public function set sepia(value:Number):void
    {
    	_sepia = value;
    }
    private var _hueRotate:Number;
		[Inspectable(category="General", defaultValue="0", minValue="0", maxValue="360")]
    public function get hueRotate():Number
    {
    	return _hueRotate;
    }

    public function set hueRotate(value:Number):void
    {
    	_hueRotate = value;
    }
	}
}