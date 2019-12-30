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
	import org.apache.royale.core.IFactory;

	/**
	 *  Jewel ITableColumn is the interface used by Jewel TableColumn in the Jewel Table.
	 * 
	 *  Define which renderer to use for each cell in the table, and other optional data like
	 *  the width, the label (used in header), and the name of the field in the data containing the value to display 
	 *  in the column (for the simplest ItemRenderer).
	 */
	public interface ITableColumn
	{
		/**
		 *  The ItemRenderer class or factory to use to make instances of itemRenderers for
		 *  display of data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		function get itemRenderer():IFactory;
		function set itemRenderer(value:IFactory):void;
		
		/**
		 *  The width of the column.
		 *  DataGrid defaults to "numColumns/n %", where n is the number of columns
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		function get columnWidth():Number;
		function set columnWidth(value:Number):void;
		
		/**
		 *  The label for the column (appears in the header area).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		function get label():String;
		function set label(value:String):void;
		
		/**
		 *  The name of the field containing the data value presented by the column. This value is used
		 *  by the itemRenderer is select the property from the data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		function get dataField():String;
		function set dataField(value:String):void;
		
		/**
		 *  The name of the style class to use for this column.
		 *  DataGrid uses ".jewel.list.column"
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		function get className():String;
		function set className(value:String):void;
		
		/**
		 * The name of the style class to use for this column.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		function get align():String;
		function set align(value:String):void;

		/**
		 *  How column label text align in the header
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		function get columnLabelAlign():String;
		function set columnLabelAlign(value:String):void;
	}
}