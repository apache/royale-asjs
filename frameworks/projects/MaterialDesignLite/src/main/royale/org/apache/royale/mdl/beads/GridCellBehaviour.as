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
package org.apache.royale.mdl.beads
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	
	/**
	 *  The GridCellBehaviour bead class is used in MDL Dialog to style other components
	 *  to make it play nicely inside grids instead of use a GridCell component
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class GridCellBehaviour implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function GridCellBehaviour()
		{
		}

		private var _strand:IStrand;

		private var host:UIBase;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS
			{
				host = value as UIBase;
                host.element.classList.add("mdl-cell");

				if(_column != 4)
				{
					host.element.classList.add("mdl-cell--" + _column + "-col");
					host.typeNames = host.element.className;
				}

				if(_columnDesktop)
				{
					host.element.classList.add("mdl-cell--" + _columnDesktop + "-col-desktop");
					host.typeNames = host.element.className;
				}
			}
		}

		protected var _column:Number = 4;
        /**
		 *  A boolean flag to activate "mdl-cell--N-col" effect selector.
		 *  Sets the column size for the cell to N. N is 1-12 inclusive. 
		 *  Defaults to 4. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get column():Number
        {
            return _column;
        }
        public function set column(value:Number):void
        {
			if(value > 0 || value < 13)
			{
				_column = value;
			}
        }

		protected var _columnDesktop:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--N-col-desktop" effect selector.
		 *  Sets the column size for the cell to N in desktop mode only. 
		 *  N is 1-12 inclusive. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get columnDesktop():Number
        {
            return _columnDesktop;
        }
        public function set columnDesktop(value:Number):void
        {
			COMPILE::JS
			{
				if(value > 0 || value < 13)
				{
					_columnDesktop = value;
				}
			} 
        }
	}
}
