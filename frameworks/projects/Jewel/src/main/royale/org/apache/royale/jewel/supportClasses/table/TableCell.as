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
package org.apache.royale.jewel.supportClasses.table
{
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.jewel.Group;
	
	/**
	 *  The TableCell class defines a table data cell in the Table component. This element
	 *  may have nearly any type of Royale component as children.
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TableCell extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TableCell()
		{
			super();
			
			typeNames = "jewel tablecell";
		}

		private var _expandColumns:Number = 1;
        /**
         *  The columns this cell will expand to occupy
		 *  notice that you must not define the ocuppied cells
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get expandColumns():Number
		{
            return _expandColumns;
		}
		public function set expandColumns(value:Number):void
		{
			if(_expandColumns != value)
			{
            	_expandColumns = value;

				COMPILE::JS
				{
					element.setAttribute('colspan', _expandColumns);
				}
			}
		}
		
		private var _expandRows:Number = 1;
        /**
         *  The rows this cell will expand to occupy
		 *  notice that you must not define the ocuppied cells
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get expandRows():Number
		{
            return _expandRows;
		}
		public function set expandRows(value:Number):void
		{
			if(_expandRows != value)
			{
            	_expandRows = value;

				COMPILE::JS
				{
					element.setAttribute('rowspan', _expandRows);
				}
			}
		}
		
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		public static const RIGHT:String = "right";

		private var _align:String = "left";
        /**
         *  The align this cell will apply to its content
		 *  can be "left", "center" or "right". defaults to "left"
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function get align():String
		{
            return _align;
		}
		public function set align(value:String):void
		{
			if(_align != value)
			{
            	_align = value;

				COMPILE::JS
				{
					element.setAttribute('align', _align);
				}
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			return addElementToWrapper(this,'td');
		}
    }
}
