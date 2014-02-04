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
	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IChrome;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.ValuesManager;

	/**
	 *  The ControlBar class is used within a Panel as a place to position
	 *  additional controls. The ControlBar appears at the bottom of the Panel
	 *  and is not part of the Panel's scrollable content area. The ControlBar
	 *  is a Container and implements the IChrome interface, indicating that is
	 *  outside of the Container's content area. The ControlBar uses the following
	 *  beads:
	 * 
	 *  IBeadModel: the data model for the component.
	 *  IMeasurementBead: helps determine the overlay size of the ControlBar for layout.
	 *  IBorderBead: if present, displays a border around the component.
	 *  IBackgroundBead: if present, displays a solid background below the ControlBar.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ControlBar extends Container implements IContainer, IChrome
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ControlBar()
		{
			super();
			
			className = "ControlBar";
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();	
			
			if( getBeadByType(IBeadLayout) == null ) {
				var layout:IBeadLayout = new (ValuesManager.valuesImpl.getValue(this, "iBeadLayout")) as IBeadLayout;
				addBead(layout);
			}
		}
	}
}