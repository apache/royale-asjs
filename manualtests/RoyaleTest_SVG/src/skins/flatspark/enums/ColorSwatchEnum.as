/**	
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements.  See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.	
 */

package skins.flatspark.enums
{
	public class ColorSwatchEnum
	{
		public static const Turquoise_GreenSea:int = 1;
		public static const Emerald_Nephritis:int = 2;
		public static const PeterRiver_BelizeHole:int = 3;
		public static const Amethyst_Wisteria:int = 4;
		public static const WetAsphalt_MidnightBlue:int = 5;
		public static const SunFlower_Orange:int = 6;
		public static const Carrot_Pumpkin:int = 7;
		public static const Alizarin_Pomegranate:int = 8;
		public static const Clouds_Silver:int = 9;
		public static const Concrete_Asbestos:int = 10;
		
		
		private var _colorSwatch:int;
		
		public function ColorSwatchEnum(colorSwatch:int = 3) {
			_colorSwatch = colorSwatch;
		}
	}
}
