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
package org.apache.flex.graphics.beads
{
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.graphics.utils.shaderClasses.ColorBurnShader;
	import org.apache.flex.graphics.utils.shaderClasses.ColorDodgeShader;
	import org.apache.flex.graphics.utils.shaderClasses.ColorShader;
	import org.apache.flex.graphics.utils.shaderClasses.ExclusionShader;
	import org.apache.flex.graphics.utils.shaderClasses.HueShader;
	import org.apache.flex.graphics.utils.shaderClasses.LuminosityShader;
	import org.apache.flex.graphics.utils.shaderClasses.SaturationShader;
	import org.apache.flex.graphics.utils.shaderClasses.SoftLightShader;

	COMPILE::SWF
	{
		import flash.display.Shader;
		import flash.display.BlendMode;
		import org.apache.flex.core.IRenderedObject;
		import org.apache.flex.core.IStyleableObject;
		import org.apache.flex.core.ValuesManager;
	}
	
	/**
	 *  The BlendBead class translates HTML mixBlendMode CSS values to flash.
	 *  The JS implementation is degenerated and exists only to enable output
	 *  agnostic compilation.
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	
		
	public class BlendBead implements IBead
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function BlendBead()
		{
		}
		
		COMPILE::SWF
		private static var MAP:Object = {
			normal: BlendMode.NORMAL,
			multiply : BlendMode.MULTIPLY,
			screen: BlendMode.SCREEN,
			overlay: BlendMode.OVERLAY,
			darken: BlendMode.DARKEN,
			lighten: BlendMode.LIGHTEN,
			'hard-light': BlendMode.HARDLIGHT,
			difference: BlendMode.DIFFERENCE
		}
		
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			COMPILE::SWF
			{
				var host:IRenderedObject = value as IRenderedObject;
				var blendModeValue:String = ValuesManager.valuesImpl.getValue(IStyleableObject(value), "mix-blend-mode") as String;
				var simpleBlendModeValue:String = MAP[blendModeValue];
				if (!simpleBlendModeValue)
				{
					getBlendMode(blendModeValue, host);
				} else
				{
					host.$displayObject.blendMode = simpleBlendModeValue;
				}
			}
		}
		
		COMPILE::SWF
		private function getBlendMode(blendModeValue:String, host:IRenderedObject):void
		{
			var shader:Shader = null;
			switch (blendModeValue)
			{
				case 'hue':
					shader = new HueShader();
					break;
				case 'saturation':
					shader = new SaturationShader();
					break;
				case 'color':
					shader = new ColorShader();
					break;
				case 'luminosity':
					shader = new LuminosityShader();
					break;
				case 'exclusion':
					shader = new ExclusionShader();
					break;
				case 'color-dodge':
					shader = new ColorDodgeShader();
					break;
				case 'color-burn':
					shader = new ColorBurnShader();
					break;
				case 'soft-light':
					shader = new SoftLightShader();
					break;
			}
			host.$displayObject.blendMode = "normal";
			host.$displayObject.blendShader = shader;
		}
	}
}
