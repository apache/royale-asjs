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
	import skins.flatspark.utils.ColorUtils;

	public class ButtonColorEnum
	{
		public static const PrimaryUp:uint = ColorUtils.Turquoise;
		public static const PrimaryHover:uint = 0x48C9B0;
		public static const PrimaryDown:uint = 0x16A085;
		public static const PrimaryDisabled:uint = ColorUtils.Turquoise;
		
		public static const SuccessUp:uint = ColorUtils.Emerald;
		public static const SuccessHover:uint = 0x58D68D;
		public static const SuccessDown:uint = 0x27AD60;
		public static const SuccessDisabled:uint = ColorUtils.Emerald;
		
		public static const WarningUp:uint = ColorUtils.SunFlower;
		public static const WarningHover:uint = 0xF5D313;
		public static const WarningDown:uint = 0xCDA70D;
		public static const WarningDisabled:uint = ColorUtils.SunFlower;
		
		public static const InverseUp:uint = ColorUtils.WetAsphalt;
		public static const InverseHover:uint = 0x415B76;
		public static const InverseDown:uint = 0x2C3E50;
		public static const InverseDisabled:uint = ColorUtils.WetAsphalt;
		
		public static const DefaultUp:uint = ColorUtils.Silver;
		public static const DefaultHover:uint = 0xCACFD2;
		public static const DefaultDown:uint = 0xA1A6A9;
		public static const DefaultDisabled:uint = ColorUtils.Silver;
		
		public static const InfoUp:uint = ColorUtils.PeterRiver;
		public static const InfoHover:uint = 0x5DADE2;
		public static const InfoDown:uint = 0x2C81BA;
		public static const InfoDisabled:uint = ColorUtils.PeterRiver;
		
		public static const DangerUp:uint = ColorUtils.Alizarin;
		public static const DangerHover:uint = 0xEC7063;
		public static const DangerDown:uint = 0xC44133;
		public static const DangerDisabled:uint = ColorUtils.Alizarin;
	}
}
