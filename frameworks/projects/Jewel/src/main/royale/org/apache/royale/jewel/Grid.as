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
package org.apache.royale.jewel
{
	import org.apache.royale.jewel.Group;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.jewel.beads.layouts.GridLayout;

	/**
	 *  The Grid class is a container that uses Grid Layout.
	 *  Grid Layout need other inmediate children to work as cells
	 *  to host cell content.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class Grid extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function Grid()
		{
			super();

            typeNames = "jewel";

			layout = new GridLayout();
			addBead(layout);
		}

		protected var layout:GridLayout;

		protected var _gap:Number = 0;
        /**
		 *  Assigns variable gap to grid from 1 to 20
		 *  Activate "gap-Xdp" effect selector to set a numeric gap 
		 *  between grid cells
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
        public function get gap():Number
        {
            return _gap;
        }

        public function set gap(value:Number):void
        {
			if (_gap != value)
            {
                COMPILE::JS
                {
					if (value > 0 && value < 20)
                    {
						layout.gap = value;
					} else
						throw new Error("Grid gap needs to be between 0 and 20");
                }
            }
        }
	}
}