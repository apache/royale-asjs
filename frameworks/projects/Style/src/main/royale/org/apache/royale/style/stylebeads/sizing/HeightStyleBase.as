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
	public class HeightStyleBase extends MeasurementStyleBase
	{
		public function HeightStyleBase(selectorBase:String, ruleBase:String)
		{
			super(selectorBase, ruleBase);
		}
		override public function set value(value:*):void
		{
			super.value = value;
			switch("" + value)
			{
				case "screen":
					calculatedRuleValue = "100vh";
					break;
				case "100vh":
					calculatedSelector = "screen";
					break;
				case "dvh":
					calculatedRuleValue = "100dvh";
					break;
				case "100dvh":
					calculatedSelector = "dvh";
					break;
				case "lvh":
					calculatedRuleValue = "100lvh";
					break;
				case "100lvh":
					calculatedSelector = "lvh";
					break;
				case "svh":
					calculatedRuleValue = "100svh";
					break;
				case "100svh":
					calculatedSelector = "svh";
					break;
				case "lh":
					calculatedRuleValue = "100lh";
					break;
				case "100lh":
					calculatedSelector = "lh";
					break;
			}
		}		
	}
}