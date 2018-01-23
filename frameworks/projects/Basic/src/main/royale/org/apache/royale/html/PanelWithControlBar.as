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
package org.apache.royale.html
{
	import org.apache.royale.core.IPanelModel;

	[Event(name="close", type="org.apache.royale.events.Event")]
	
	/**
	 *  The Panel class is a Container component capable of parenting other
	 *  components. The Panel has a TitleBar and an optional org.apache.royale.html.ControlBar. 
	 *  The Panel uses the following bead types:
	 * 
	 *  org.apache.royale.core.IBeadModel: the data model for the Panel that includes the title and whether
	 *  or not to display the close button.
	 *  org.apache.royale.core.IBeadView: creates the parts of the Panel.
	 *  org.apache.royale.core.IBorderBead: if present, draws a border around the Panel.
	 *  org.apache.royale.core.IBackgroundBead: if present, provides a colored background for the Panel.
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class PanelWithControlBar extends Panel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function PanelWithControlBar()
		{
			super();
		}
		
		/**
		 *  The items in the org.apache.royale.html.ControlBar. Setting this property automatically
		 *  causes the ControlBar to display.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get controlBar():Array
		{
			return IPanelModel(model).controlBar;
		}
		public function set controlBar(value:Array):void
		{
            IPanelModel(model).controlBar = value;
		}
		
	}
}
