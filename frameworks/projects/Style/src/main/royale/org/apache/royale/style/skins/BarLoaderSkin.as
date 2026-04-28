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
package org.apache.royale.style.skins
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.BarLoader;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.layout.Overflow;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.util.AnimationManager;
	import org.apache.royale.style.stylebeads.anim.Animation;
	
	public class BarLoaderSkin extends StyleSkin implements IBarLoaderSkin
	{
		public function BarLoaderSkin()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.BarLoader
		 */
		private function get host():BarLoader
		{
			return _strand as BarLoader;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			// Manually set. Don't create the default ones.
			if(_styles)
				return;
			processStyles();
		}
		
		override public function update():void{
			processStyles()
		}

		private var _barLoaderStyles:Array;

		public function get barLoaderStyles():Array
		{
			if(!_barLoaderStyles)
				processStyles();
			return _barLoaderStyles;
		}
		
		private function processStyles():void{
			var hostStyles:Array = [
				new HeightStyle(2.5),
				new WidthStyle(56),
				new Overflow('hidden'),
				new BorderRadius("full"),
				new BackgroundColor("slate-200")
			];

			var barLoaderStylesArr:Array = [
				new HeightStyle('full'),
				new WidthStyle('25%'),
				new BorderRadius("full"),
				new BackgroundColor("black")
			];
			
			_barLoaderStyles = barLoaderStylesArr;
			_styles = hostStyles;
			host.setStyles(_styles);
		}
		private var _indeterminateStyles:Array;
		public function get indeterminateStyles():Array
		{
			if(!_indeterminateStyles)
				createIndeterminateStyles();
			return _indeterminateStyles;
		}
		private function createIndeterminateStyles():void
		{
			AnimationManager.registerKeyframes("indeterminateSlide", [
				"0% {transform: translateX(-120%);}",
				"100% {transform: translateX(340%);}"
			]);
			_indeterminateStyles = [
				new Animation("indeterminateSlide 1.2s ease-in-out 0s infinite normal none running")
			];
		}
		public function set value(value:Number):void
		{
			// No value, but we want to trigger the styles to be applied.
			processStyles();
		}
	}
}