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
package org.apache.royale.style.util
{
	/**
	 * @royalesuppressexport
	 */
	public class StyleTheme
	{
		public function StyleTheme(name:String)
		{
			themeName = name;
		}
		public var themeName:String = "default";

		public var spacing:Number = 4;
		public var breakpointSM:String = "40rem";
		public var breakpointMD:String = "48rem";
		public var breakpointLG:String = "64rem";
		public var breakpointXL:String = "80rem";
		public var breakpoint2XL:String = "96rem";
		public var container3XS:String = "16rem";
		public var container2XS:String = "18rem";
		public var containerXS:String = "20rem";
		public var containerSM:String = "24rem";
		public var containerMD:String = "28rem";
		public var containerLG:String = "32rem";
		public var containerXL:String = "36rem";
		public var container2XL:String = "42rem";
		public var container3XL:String = "48rem";
		public var container4XL:String = "56rem";
		public var container5XL:String = "64rem";
		public var container6XL:String = "72rem";
		public var container7XL:String = "80rem";
		public var textXS:String = ".75rem";
		public var lineXS:Number = 1/.75;
		public var textSM:String = ".875rem";
		public var lineSM:Number = 1.25/.875;
		public var textBase:String = "1rem";
		public var lineBase:Number = 1.5/1;
		public var textLG:String = "1.125rem";
		public var lineLG:Number = 1.75/1.125;
		public var textXL:String = "1.25rem";
		public var lineXL:Number = 1.75/1.25;
		public var text2XL:String = "1.5rem";
		public var line2XL:Number = 2/1.5;
		public var text3XL:String = "1.875rem";
		public var line3XL:Number = 2.25/1.875;
		public var text4XL:String = "2.25rem";
		public var line4XL:Number = 2.5/2.25;
		public var text5XL:String = "3rem";
		public var line5XL:Number = 1;
		public var text6XL:String = "3.75rem";
		public var line6XL:Number = 1;
		public var text7XL:String = "4.5rem";
		public var line7XL:Number = 1;
		public var text8XL:String = "6rem";
		public var line8XL:Number = 1;
		public var text9XL:String = "8rem";
		public var line9XL:Number = 1;
		public var fontWeightThin:String = "100";
		public var fontWeightExtraLight:String = "200";
		public var fontWeightLight:String = "300";
		public var fontWeightNormal:String = "400";
		public var fontWeightMedium:String = "500";
		public var fontWeightSemiBold:String = "600";
		public var fontWeightBold:String = "700";
		public var fontWeightExtraBold:String = "800";
		public var fontWeightBlack:String = "900";
		public var trackingTighter:String = "-.05em";
		public var trackingTight:String = "-.025em";
		public var trackingNormal:String = "0";
		public var trackingWide:String = ".025em";
		public var trackingWider:String = ".05em";
		public var trackingWidest:String = ".1em";
		public var leadingTight:String = "1.25";
		public var leadingSnug:String = "1.375";
		public var leadingNormal:String = "1.5";
		public var leadingRelaxed:String = "1.625";
		public var leadingLoose:String = "2";
		public var radiusXS:String = ".125rem";
		public var radiusSM:String = ".25rem";
		public var radiusMD:String = ".375rem";
		public var radiusLG:String = ".5rem";
		public var radiusXL:String = ".75rem";
		public var radius2XL:String = "1rem";
		public var radius3XL:String = "1.5rem";
		public var radius4XL:String = "2rem";
		public var shadow2XS:String = "0 1px #0000000d";
		public var shadowXS:String = "0 1px 2px 0 #0000000d";
		public var shadowSM:String = "0 1px 3px 0 #0000001a,0 1px 2px -1px #0000001a";
		public var shadowMD:String = "0 4px 6px -1px #0000001a,0 2px 4px -2px #0000001a";
		public var shadowLG:String = "0 10px 15px -3px #0000001a,0 4px 6px -4px #0000001a";
		public var shadowXL:String = "0 20px 25px -5px #0000001a,0 10px 10px -5px #0000001a";
		public var shadow2XL:String = "0 25px 50px -12px #0000001a";
		public var insetShadow2XS:String = "inset 0 1px #0000000d";
		public var insetShadowXS:String = "inset 0 1px 1px #0000000d";
		public var insetShadowSM:String = "inset 0 2px 4px #0000000d";
		public var dropShadowXS:String = "0 1px 1px #0000000d";
		public var dropShadowSM:String = "0 1px 2px #00000026";
		public var dropShadowMD:String = "0 3px 3px #0000001f";
		public var dropShadowLG:String = "0 4px 4px #00000026";
		public var dropShadowXL:String = "0 9px 9px #0000001a";
		public var dropShadow2XL:String = "0 25px 25px #00000026";
		public var textShadow2XS:String = "0 1px 0px #00000026";
		public var textShadowXS:String = "0 1px 1px #0003";
		public var textShadowSM:String = "0px 1px 0px #00000013,0px 1px 1px #00000013,0px 2px 2px #00000013";
		public var textShadowMD:String = "0px 1px 1px #0000001a,0px 1px 2px #0000001a,0px 2px 4px #0000001a";
		public var textShadowLG:String = "0px 1px 2px #0000001a,0px 3px 2px #0000001a,0px 4px 8px #0000001a";
		public var easeIn:String = "cubic-bezier(.4,0,1,1)";
		public var easeOut:String = "cubic-bezier(0,0,.2,1)";
		public var easeInOut:String = "cubic-bezier(.4,0,.2,1)";
		
		public function get animateSpin():String
		{
			if(!AnimationManager.has("spin"))
			{
				AnimationManager.registerKeyframes("spin", [
					"to {transform: rotate(360deg);}"
				]);
			}
			return "spin 1s linear infinite";
		}
		public function get animatePing():String
		{
			if(!AnimationManager.has("ping"))
			{
				AnimationManager.registerKeyframes("ping", [
					"75%, 100% {transform: scale(2); opacity: 0;}"
				]);
			}
			return "ping 1s cubic-bezier(0,0,.2,1) infinite";
		}
		

		public function get animatePulse():String
		{
			if(!AnimationManager.has("pulse"))
			{
				AnimationManager.registerKeyframes("pulse", [
					"50% {opacity: 0.5;}"
				]);
			}
			return "pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite";
		}

		public function get animateBounce():String
		{
			if(!AnimationManager.has("bounce"))
			{
				AnimationManager.registerKeyframes("bounce", [
					"0%, 100% {transform: translateY(-25%);animation-timing-function: cubic-bezier(0.8, 0, 1, 1);}",
					"50% {transform: none;animation-timing-function: cubic-bezier(0, 0, 0.2, 1);}"
				]);
			}
			return "bounce 1s infinite";
		}
		
		public var blurXS:String = "4px";
		public var blurSM:String = "8px";
		public var blurMD:String = "12px";
		public var blurLG:String = "16px";
		public var blurXL:String = "24px";
		public var blur2XL:String = "40px";
		public var blur3XL:String = "64px";
		public var perspectiveDramatic:String = "100px";
		public var perspectiveNear:String = "300px";
		public var perspectiveNormal:String = "500px";
		public var perspectiveMidrange:String = "800px";
		public var perspectiveDistant:String = "1200px";
		public var aspectVideo:String = "16/9";
		public var defaultTransitionDuration:String = ".15s";
		public var defaultTransitionTimingFunction:String = "cubic-bezier(.4,0,.2,1)";
		public var defaultSansFamily:String = "ui-sans-serif, system-ui, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'";
		public var defaultSansFeatures:String = '"cv02","cv03","cv04","cv11"';
		public var defaultSerifFamily:String = "ui-serif, Georgia, Cambria, 'Times New Roman', Times, serif";
		public var defaultSerifFeatures:String = '"cv02","cv03","cv04","cv11"';
		public var defaultMonoFontFamily:String = "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace";
		public var defaultMonoFeatures:String = '"ss02","zero"';
		public var fontUbuntuMono:String;
		public var animateFlashCode:String = "flash-code 2s forwards";
	}
}
