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
package org.apache.royale.svg
{
	
	/**
	 *  DarkenedBevelFilter extends BevelFilter to and darkens it somewhat in an attempt to retain the original colors in its the graphics core.
	 *  This is an exprimental component designed to emulate PhotoShop's behavior.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.5
	 */
	public class DarkenedBevelFilter extends BevelFilter
	{
		

		public function DarkenedBevelFilter()
		{
		}
		
		override public function build():void
		{
			super.build();
			var lastFilterElement:FilterElement = children[children.length - 1] as FilterElement;
			lastFilterElement.result = "FirstBevel";
			if (result)
			{
				lastFilterElement.result += "_" + result;
			}
			var offsetFilterElement:OffsetFilterElement = new OffsetFilterElement();
			offsetFilterElement.height = 4;
			offsetFilterElement.width = 4;
			offsetFilterElement.y = 40;
			offsetFilterElement.x = 40;
			children.push(offsetFilterElement);
			var tileFilterElement:TileFilterElement = new TileFilterElement();
			children.push(tileFilterElement);
			var blurFilterElement:BlurFilterElement = new BlurFilterElement();
			blurFilterElement.stdDeviation = 5;
			children.push(blurFilterElement);
			var compositeFilterElement:CompositeFilterElement = new CompositeFilterElement();
			compositeFilterElement.in2 = "SourceGraphic";
			compositeFilterElement.operator = "in";
			children.push(compositeFilterElement);
			var blendFilterElement:BlendFilterElement = new BlendFilterElement();
			blendFilterElement.result = "difference";
			if (result)
			{
				blendFilterElement.result += "_" + result;
			}
			blendFilterElement.in2 = "SourceGraphic";
			blendFilterElement.mode = "difference";
			children.push(blendFilterElement);
			var blendFilterElement2:BlendFilterElement = new BlendFilterElement();
			blendFilterElement2.in2 = "difference";
			blendFilterElement2.in = "FirstBevel";
			blendFilterElement2.mode = "difference";
			children.push(blendFilterElement2);
		}
	}
}

