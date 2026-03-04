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
package org.apache.royale.style.stylebeads.sizing
{
	public class WidthStyleBase extends MeasurementStyleBase
	{
		public function WidthStyleBase(selectorBase:String, ruleBase:String)
		{
			super(selectorBase, ruleBase);
		}
		override public function set value(value:*):void
		{
			super.value = value;
			switch("" + value)
			{
				case "screen":
					calculatedRuleValue = "100vw";
					break;
				case "100vw":
					calculatedSelector = "screen";
					break;
				case "dvw":
					calculatedRuleValue = "100dvw";
					break;
				case "100dvw":
					calculatedSelector = "dvw";
					break;
				case "lvw":
					calculatedRuleValue = "100lvw";
					break;
				case "100lvw":
					calculatedSelector = "lvw";
					break;
				case "svw":
					calculatedRuleValue = "100svw";
					break;
				case "100svw":
					calculatedSelector = "svw";
					break;
				case "lw":
					calculatedRuleValue = "100lw";
					break;
				case "100lw":
					calculatedSelector = "lw";
					break;
			}
		}
	}
}