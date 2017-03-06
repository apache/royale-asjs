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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	COMPILE::SWF
	{
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
	 *  @productversion FlexJS 0.0
	 */
	
		
	public class BlendBead implements IBead
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
			'color-dodge': 'colordodge',
			'color-burn': 'colorburn',					
			'hard-light': BlendMode.HARDLIGHT,
			'soft-light': 'softlight',
			difference: BlendMode.DIFFERENCE,
			exclusion: BlendMode.DIFFERENCE, // TODO write custom blend
			hue: 'hue',
			saturation: 'saturation',
			color: 'color',
			luminosity: 'luminosity'
		}
		
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			COMPILE::SWF
			{
				var host:IRenderedObject = value as IRenderedObject;
				var blendModeValue:String = ValuesManager.valuesImpl.getValue(IStyleableObject(value), "mix-blend-mode") as String;
				host.$displayObject.blendMode = MAP[blendModeValue];
			}
		}
	}
}
