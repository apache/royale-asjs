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
package org.apache.royale.html.beads.layouts
{	
	import org.apache.royale.core.IBeadLayout;
	
	/**
	 * ITileLayout creates a tile layout. You can define the dimensions of each cell.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 9.6
	 */
	public interface ITileLayout extends IBeadLayout
	{
		/**
		 *  The width of each column, in pixels. If left unspecified, the
		 *  columnWidth is determined by dividing the numColumns into the
		 *  strand's bounding box width.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		function get columnWidth():Number;
		function set columnWidth(value:Number):void;
		/**
		 *  The height of each row, in pixels. If left unspecified, the
		 *  rowHeight is determine by dividing the possible number of rows
		 *  into the strand's bounding box height.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		function get rowHeight():Number;
		function set rowHeight(value:Number):void;
		/**
		 *  The number of tiles to fit horizontally into the layout.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		function get numColumns():Number;
		function set numColumns(value:Number):void;
	}
}
