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
package org.apache.royale.textLayout.elements
{

	

	
	/** 
	 * <p> TableColGroupElement is an item in a TableElement. It most commonly contains one or more ParagraphElement objects, 
	 * A TableRowElement always appears within a TableElement.</p>
	 *
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 */
	public final class TableColGroupElement extends TableFormattedElement
	{
		override public function get className():String{
			return "TableColGroupElement";
		}
		public var height:Number;
		
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "colgroup"; }
		
		/** @private */
		public override function canOwnFlowElement(elem:IFlowElement):Boolean
		{
			return (elem is ITableColElement);
		}
		
		/** @private if its in a numbered list expand the damage to all list items - causes the numbers to be regenerated */
		public override function modelChanged(changeType:String, elem:IFlowElement, changeStart:int, changeLen:int, needNormalize:Boolean = true, bumpGeneration:Boolean = true):void
		{
			super.modelChanged(changeType,elem,changeStart,changeLen,needNormalize,bumpGeneration);
		}

	}
}
