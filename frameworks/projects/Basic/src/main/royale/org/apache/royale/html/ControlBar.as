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

	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IChrome;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.utils.loadBeadFromValuesManager;
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

	/**
	 *  The ControlBar class is used within a Panel as a place to position
	 *  additional controls. The ControlBar appears at the bottom of the
	 *  org.apache.royale.html.Panel
	 *  and is not part of the Panel's scrollable content area. The ControlBar
	 *  is a Container and implements the org.apache.royale.core.IChrome interface, indicating that is
	 *  outside of the Container's content area. The ControlBar uses the following
	 *  beads:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model for the component.
	 *  org.apache.royale.core.IMeasurementBead: helps determine the overlay size of the ControlBar for layout.
	 *  org.apache.royale.html.beads.IBorderBead: if present, displays a border around the component.
	 *  org.apache.royale.html.beads.IBackgroundBead: if present, displays a solid background below the ControlBar.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ControlBar extends Group implements IChrome
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ControlBar()
		{
			super();

			typeNames = "ControlBar";
		}

		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this);
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'div');
			typeNames = "ControlBar";

            return element;
        }

	}
}
