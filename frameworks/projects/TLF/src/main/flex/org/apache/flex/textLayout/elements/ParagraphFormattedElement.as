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
package org.apache.royale.textLayout.elements {

	

	
	/** The ParagraphFormattedElement class is an abstract base class for FlowElement classes that have paragraph properties.
	*
	* <p>You cannot create a ParagraphFormattedElement object directly. Invoking <code>new ParagraphFormattedElement()</code> 
	* throws an error exception.</p> 
	*
	* @playerversion Flash 10
	* @playerversion AIR 1.5
	* @langversion 3.0
	*
	* @see ContainerFormattedElement
	* @see ParagraphElement
	* 
	*/
	public class ParagraphFormattedElement extends FlowGroupElement implements IParagraphFormattedElement
	{
		/** @private TODO: DELETE THIS CLASS */
		public override function shallowCopy(startPos:int = 0, endPos:int = -1):IFlowElement
		{
			return super.shallowCopy(startPos, endPos) as ParagraphFormattedElement;
		}
		override public function get className():String{
			return "ParagraphFormattedElement";
		}

	}
}
