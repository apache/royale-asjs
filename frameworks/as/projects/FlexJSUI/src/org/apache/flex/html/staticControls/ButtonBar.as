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
	/**
	 *  The ButtonBar class is a component that displays a set of Buttons. The ButtonBar
	 *  is actually a List with a default horizontal layout and an itemRenderer that 
	 *  produces Buttons. The ButtonBar uses the following beads:
	 * 
	 *  IBeadModel: the data model for the ButtonBar, including the dataProvider.
	 *  IBeadView: constructs the parts of the component.
	 *  IBeadController: handles input events.
	 *  IBeadLayout: sizes and positions the component parts.
	 *  IDataProviderItemRendererMapper: produces itemRenderers.
	 *  IItemRenderer: the class or class factory to use.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ButtonBar extends List
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ButtonBar()
		{
			super();
		}
	}
}