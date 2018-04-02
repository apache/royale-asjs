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

package mx.core
{

import org.apache.royale.core.IParent;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.geom.Rectangle;
COMPILE::JS
{
import org.apache.royale.geom.Point;
}
COMPILE::SWF
{
import flash.geom.Point;
}

/**
 *  The IFlexDisplayObject interface defines the interface for skin elements.
 *  At a minimum, a skin must be a DisplayObject and implement this interface.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IFlexDisplayObject extends /*IBitmapDrawable, */IEventDispatcher
{

include "IDisplayObjectInterface.as"

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------


	//----------------------------------
	//  measuredHeight
	//----------------------------------

	/**
	 *  The measured height of this object.
	 *
	 *  <p>This is typically hard-coded for graphical skins
	 *  because this number is simply the number of pixels in the graphic.
	 *  For code skins, it can also be hard-coded
	 *  if you expect to be drawn at a certain size.
	 *  If your size can change based on properties, you may want
	 *  to also be an ILayoutManagerClient so a <code>measure()</code>
	 *  method will be called at an appropriate time,
	 *  giving you an opportunity to compute a <code>measuredHeight</code>.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get measuredHeight():Number;

	//----------------------------------
	//  measuredWidth
	//----------------------------------

	/**
	 *  The measured width of this object.
	 *
	 *  <p>This is typically hard-coded for graphical skins
	 *  because this number is simply the number of pixels in the graphic.
	 *  For code skins, it can also be hard-coded
	 *  if you expect to be drawn at a certain size.
	 *  If your size can change based on properties, you may want
	 *  to also be an ILayoutManagerClient so a <code>measure()</code>
	 *  method will be called at an appropriate time,
	 *  giving you an opportunity to compute a <code>measuredHeight</code>.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get measuredWidth():Number;


	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Moves this object to the specified x and y coordinates.
	 * 
	 *  @param x The new x-position for this object.
	 * 
	 *  @param y The new y-position for this object.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function move(x:Number, y:Number):void;

	/**
	 *  Sets the actual size of this object.
	 *
	 *  <p>This method is mainly for use in implementing the
	 *  <code>updateDisplayList()</code> method, which is where
	 *  you compute this object's actual size based on
	 *  its explicit size, parent-relative (percent) size,
	 *  and measured size.
	 *  You then apply this actual size to the object
	 *  by calling <code>setActualSize()</code>.</p>
	 *
	 *  <p>In other situations, you should be setting properties
	 *  such as <code>width</code>, <code>height</code>,
	 *  <code>percentWidth</code>, or <code>percentHeight</code>
	 *  rather than calling this method.</p>
	 * 
	 *  @param newWidth The new width for this object.
	 * 
	 *  @param newHeight The new height for this object.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function setActualSize(newWidth:Number, newHeight:Number):void;
}

}
