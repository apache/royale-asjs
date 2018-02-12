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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IFactory;
	import org.apache.royale.core.IUIBase;

	public interface IDataGridColumn
	{
		/**
		 *  The itemRenderer class or factory to use to make instances of itemRenderers for
		 *  display of data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		function get itemRenderer():IFactory;
		function set itemRenderer(value:IFactory):void;
		
		/**
		 *  The width of the column (default is 100 pixels).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		function get columnWidth():Number;
		function set columnWidth(value:Number):void;
		
		/**
		 *  The label for the column (appears in the header area).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
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
		 *  @productversion Royale 0.9
		 */
		function get dataField():String;
		function set dataField(value:String):void;
		
		/**
		 * The name of the style class to use for this column. If this is not set
		 * it defaults to DataGridColumnList.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 */
		function get className():String;
		function set className(value:String):void;
		
		/**
		 * Returns a new instance of a UIBase component to be used as the actual
		 * column in the grid.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		function createColumn():IUIBase;
	}
}