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
package org.apache.royale.core
{
	/**
     *  The ILabelFunction interface is the interface used at Item Renderer level to detect if there's a bead 
	 *  on the strand that wants to use an external label function to format labels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.10.0
     */
	public interface ILabelFunction extends IBead
	{
		/**
         *  A user-supplied function to run on each item to determine its label.  
         *  By default, the list looks for a property named <code>label</code> 
         *  on each data provider item and displays it.
         *  However, some data sets do not have a <code>label</code> property
         *  nor do they have another property that can be used for displaying.
         *  An example is a data set that has lastName and firstName fields
         *  but you want to display full names.
         *
         *  <p>You can supply a <code>labelFunction</code> that finds the 
         *  appropriate fields and returns a displayable string. The 
         *  <code>labelFunction</code> is also good for handling formatting and 
         *  localization. </p>
         *
         *  <p>For most components, the label function takes a single argument
         *  which is the item in the data provider and returns a String.</p>
         *  <pre>
         *  myLabelFunction(item:Object):String</pre>
         *
         *  <p>The method signature for the data grid classes is:</p>
         *  <pre>
         *  myLabelFunction(item:Object, column:DataGridColumn):String</pre>
         * 
         *  <p>where <code>item</code> contains the DataGrid item object, and
         *  <code>column</code> specifies the DataGrid column.</p>
         *
         *  @default null
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.10.0
         */
		function get labelFunction():Function;
		function set labelFunction(value:Function):void;
	}
}
