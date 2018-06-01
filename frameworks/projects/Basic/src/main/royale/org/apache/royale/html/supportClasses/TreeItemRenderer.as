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
	public class TreeItemRenderer extends StringItemRenderer
	{
		/**
		 * Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		public function TreeItemRenderer()
		{
			super();
		}
		
		/**
		 * Sets the data for the itemRenderer instance along with the listData
		 * (TreeListData).
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			
			var treeListData:TreeListData = listData as TreeListData;
			var indentSpace:String = "    ";
			var extraSpace:String = " ";
			
			COMPILE::JS {
				indentSpace = "\u00a0\u00a0\u00a0\u00a0";
				extraSpace = "\u00a0";
			}
				
			var indent:String = "";
			for (var i:int=0; i < treeListData.depth - 1; i++) {
				indent += indentSpace;
			}
			
			indent += (treeListData.hasChildren ? (treeListData.isOpen ? "▼" : "▶") : "") + extraSpace;
			
			this.text = indent + this.text;
		}
	}
}
