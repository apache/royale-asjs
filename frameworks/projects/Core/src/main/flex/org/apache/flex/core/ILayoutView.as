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
     *  The ILayoutView interface is implemented by any component that
	 *  has ILayoutChild children.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
	public interface ILayoutView
	{
		/**
		 * Returns the width of the layout object's content area. This
		 * value may be NaN if the width is unknown.
	     * 
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.8
		 */
		function get width():Number;
		
		/**
		 * Returns the height of the layout object's content area. This
		 * value may be NaN if the height is unknown.
	     * 
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.8
		 */
		function get height():Number;
		
		/**
		 * Returns the number of element children that can be laid out.
	     * 
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.8
		 */
		function get numElements():int;
		
		/**
		 * Returns the element child at the given index.
	     * 
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.8
		 */
		function getElementAt(index:int):IChild;
		
		COMPILE::JS {
			/**
			 * Returns the native element of the layout object itself.
		     * 
		     *  @langversion 3.0
		     *  @playerversion Flash 10.2
		     *  @playerversion AIR 2.6
		     *  @productversion Royale 0.8
			 */
			function get element():WrappedHTMLElement;
		}
	}
}
