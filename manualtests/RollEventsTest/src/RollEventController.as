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
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.MouseEvent;
	
	[Event("rollEvent")]
	
	public class RollEventController extends EventDispatcher implements IBeadController
	{
		public function RollEventController()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var dispatcher:IEventDispatcher = value as IEventDispatcher;
			
			dispatcher.addEventListener(MouseEvent.MOUSE_OVER, handleOver);
			dispatcher.addEventListener(MouseEvent.MOUSE_OUT, handleOut);
			dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, handleDown);
			dispatcher.addEventListener(MouseEvent.MOUSE_UP, handleUp);
		}
		
		private function handleOver(event:MouseEvent):void
		{
			trace("RolledOver");
			
			dispatchEvent(new RollEvent("rollOver"));
		}
		
		private function handleOut(event:MouseEvent):void
		{
			trace("RolledOut");
			
			dispatchEvent(new RollEvent("rollOut"));
		}
		
		private function handleDown(event:MouseEvent):void
		{
			trace("Detected Down");
			
			dispatchEvent(new RollEvent("mouseDown"));
		}
		
		private function handleUp(event:MouseEvent):void
		{
			trace("Detected Up");
			
			dispatchEvent(new RollEvent("mouseUp"));
		}
	}
}
