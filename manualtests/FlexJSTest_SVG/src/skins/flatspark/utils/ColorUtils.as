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

package skins.flatspark.utils
{
	import mx.states.State;
	
	import skins.flatspark.enums.ButtonColorEnum;
	
	public class ColorUtils
	{	
		public static const Turquoise:uint = 0x1ABC9C;
		public static const GreenSea:uint = 0x16A085;
		public static const Emerald:uint = 0x2ECC71;
		public static const Nephritis:uint = 0x27AE60;
		public static const PeterRiver:uint = 0x3498DB;
		public static const BelizeHole:uint = 0x2980B9;
		public static const Amethyst:uint = 0x9B59B6;
		public static const Wisteria:uint = 0x8E44AD;
		public static const WetAsphalt:uint = 0x34495E;
		public static const MidnightBlue:uint = 0x2C3E50;
		public static const SunFlower:uint = 0xF1C40F;
		public static const Orange:uint = 0xF39C12;
		public static const Carrot:uint = 0xE67E22;
		public static const Pumpkin:uint = 0xD35400;
		public static const Alizarin:uint = 0xE74C3C;
		public static const Pomegranate:uint = 0xC0392B;
		public static const Clouds:uint = 0xECF0F1;
		public static const Silver:uint = 0xBDC3C7;
		public static const Concrete:uint = 0x95A5A6;
		public static const Asbestos:uint = 0x7F8C8D;
		
		public function ColorUtils()
		{
			
		}		
		
		public static function ButtonColor(brand:int, estado:State):uint
		{
			// All the possible colors
			var cores:Array = new Array(
				ButtonColorEnum.PrimaryUp, ButtonColorEnum.PrimaryHover, ButtonColorEnum.PrimaryDown, ButtonColorEnum.PrimaryDisabled,
				ButtonColorEnum.SuccessUp, ButtonColorEnum.SuccessHover, ButtonColorEnum.SuccessDown, ButtonColorEnum.SuccessDisabled,
				ButtonColorEnum.WarningUp, ButtonColorEnum.WarningHover, ButtonColorEnum.WarningDown, ButtonColorEnum.WarningDisabled,
				ButtonColorEnum.InverseUp, ButtonColorEnum.InverseHover, ButtonColorEnum.InverseDown, ButtonColorEnum.InverseDisabled,
				ButtonColorEnum.DefaultUp, ButtonColorEnum.DefaultHover, ButtonColorEnum.DefaultDown, ButtonColorEnum.DefaultDisabled,
				ButtonColorEnum.InfoUp, ButtonColorEnum.InfoHover, ButtonColorEnum.InfoDown, ButtonColorEnum.InfoDisabled,
				ButtonColorEnum.DangerUp, ButtonColorEnum.DangerHover, ButtonColorEnum.DangerDown, ButtonColorEnum.DangerDisabled
				);
			
			// Map all the allowed states
			var numeroEstado:int = 1;
			switch (estado.name)
			{
				case "up":
					numeroEstado = 1;
					break;
				case "over":
					numeroEstado = 2;
					break;
				case "down":
					numeroEstado = 3;
					break;
				case "disabled":
					numeroEstado = 3;
					break;
			}
			
			var posicao:int = 1;
			posicao = 4 * (brand - 1) + (numeroEstado - 1); 
			
			return cores[posicao];
		}
	}
}