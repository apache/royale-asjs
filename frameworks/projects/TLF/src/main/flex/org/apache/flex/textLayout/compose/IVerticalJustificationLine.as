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
package org.apache.royale.textLayout.compose
{
	/** 
	 * The IVerticalJustificationLine interface defines the methods and properties required to allow
	 * the vertical justification of text lines.
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public interface IVerticalJustificationLine
	{
		/** 
		 * The horizontal position of the line relative to its container, expressed as the offset in pixels from the 
		 * left of the container.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #y
		 */
		function get x():Number;

		/** Set X location for the line.  Used only during vertical justification. @private */
		function set x(val:Number):void;

		/** 
		 * The vertical position of the line relative to its container, expressed as the offset in pixels from the top 
		 * of the container.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see #x
		 */
		function get y():Number;

		/** Set Y location for the line.  Used only during vertical justification. @private */
		function set y(val:Number):void;

		/** 
		 * @copy org.apache.royale.text.engine.TextLine#ascent
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function get ascent():Number;

		/** 
		 * @copy org.apache.royale.text.engine.TextLine#descent
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function get descent():Number;

		/** The height of the line in pixels.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		function get height():Number;

		// TODO for TextFlowTableBloack
		function set height(value:Number):void;
	}
}
