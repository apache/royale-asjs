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
package org.apache.flex.html.staticControls
{
	import flash.display.DisplayObject;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.beads.layouts.NonVirtualHorizontalLayout;

	public class ControlBar extends Container implements IContainer, IInitSkin
	{
		public function ControlBar()
		{
			super();
			
			className = "ControlBar";
		}
		
		override public function initSkin():void
		{
			super.initSkin();	
			
			if( getBeadByType(NonVirtualHorizontalLayout) == null ) {
				var layout:IBead = new (ValuesManager.valuesImpl.getValue(this, "iLayoutBead")) as IBead;
				addBead(layout);
			}
		}
	}
}