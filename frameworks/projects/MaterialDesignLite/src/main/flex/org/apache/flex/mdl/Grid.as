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
package org.apache.flex.mdl
{
	import org.apache.flex.core.ContainerBase;
    
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The Material Design Lite (MDL) grid component is a simplified method for
	 *  laying out content for multiple screen sizes. It reduces the usual coding burden
	 *  required to correctly display blocks of content in a variety of display conditions.
	 *
	 *  The MDL grid is defined and enclosed by a container element. A grid has 12 columns in
	 *  the desktop screen size, 8 in the tablet size, and 4 in the phone size, each size having
	 *  predefined margins and gutters. Cells are laid out sequentially in a row, in the order 
	 *  they are defined, with some exceptions:
	 *  
	 *  If a cell doesn't fit in the row in one of the screen sizes, it flows into the following line.
	 *  If a cell has a specified column size equal to or larger than the number of columns for the
	 *  current screen size, it takes up the entirety of its row.
	 *  
	 *  You can set a maximum grid width, after which the grid stays centered with padding on either
	 *  side, by setting its max-width CSS property.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class Grid extends ContainerBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function Grid()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-grid";

            element = document.createElement('div') as WrappedHTMLElement;
            
			positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }

		protected var _nospacing:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-grid--no-spacing" effect selector.
		 *  Optional. Modifies the grid cells to have no margin between them.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function get nospacing():Boolean
        {
            return _nospacing;
        }
        public function set nospacing(value:Boolean):void
        {
            _nospacing = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-grid--no-spacing", _nospacing);
				typeNames = element.className;
            }
        }
	}
}
