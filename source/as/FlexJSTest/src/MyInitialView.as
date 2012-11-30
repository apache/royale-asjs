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
package 
{
	import flash.events.Event;
	
	import org.apache.flex.core.ViewBase;
	import org.apache.flex.html.staticControls.TextButton;
	import org.apache.flex.html.staticControls.Label;
	import org.apache.flex.html.staticControls.beads.models.TextModel;
	
	public class MyInitialView extends ViewBase
	{
		public function MyInitialView()
		{
			super();
		}
		
		override public function get uiDescriptors():Array
		{
			return [
				Label,
				null,
				"lbl",
				2,
				"x", 100,
				"y", 25,
				0,
				0,
				1, 
				"text", 0, "model", "labelText", "labelTextChanged",
				TextButton,
				null,
				null,
				3,
				"text", "OK",
				"x", 100,
				"y", 75,
				0,
				1,
				"click", clickHandler,
				0
				];
		}
		
		public var lbl:Label;
		
		private function clickHandler(event:Event):void
		{
			dispatchEvent(new Event("buttonClicked"));
		}
	}
}