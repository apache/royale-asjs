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
package spark.core
{
	/*import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;*/
	
	import mx.core.IVisualElement;
	
	/**
	 *  The IGraphicElement is implemented by IVisualElements that
	 *  take advantage of the parent <code>IGraphicElementContainer</code>
	 *  DisplayObject management.
	 *
	 *  <p>One typical use case is DisplayObject sharing.  
	 *  the Group class, which implements <code>IGraphicElementContainer</code>, organizes its
	 *  IGraphicElement children in sequences that share and draw to
	 *  the same DisplayObject.
	 *  The DisplayObject is created by the first element in the
	 *  sequence.</p>
	 *
	 *  <p>Another use case is when an element does not derive from
	 *  DisplayObject but instead maintains, creates and/or destroys
	 *  its own DisplayObject. The <code>IGraphicElementContainer</code> will 
	 *  call the element to create the DisplayObject, add the
	 *  DisplayObject as its child at the correct index, and 
	 *  handle its removal.</p> 
	 *
	 *  <p>Typically, you extend the GraphicElement class
	 *  instead of directly implementing the IGraphciElement
	 *  interface. The GraphicElement class already provides most of the
	 *  required functionality.</p>
	 *
	 *  @see spark.core.IGraphicElementContainer
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public interface IGraphicElement extends IVisualElement
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  displayObject
		//----------------------------------
		
		/**
		 *  The shared DisplayObject where this
		 *  IGraphicElement is drawn.
		 *
		 *  <p>Implementers should not create the DisplayObject
		 *  here, but in the <code>createDisplayObject()</code> method.</p>
		 *
		 *  @see #createDisplayObject
		 *  @see #validateDisplayList
		 *  @see #displayObjectSharingMode
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		// function get displayObject():DisplayObject;
		
		//----------------------------------
		//  displayObjectSharingMode
		//----------------------------------
		
		/**
		 *  Indicates the association between this IGraphicElement and its
		 *  display objects. The <code>IGraphicElementContainer</code> manages this 
		 *  property and the values are one of the DisplayObjectSharingMode enum class.
		 *
		 *  <ul> 
		 *    <li>A value of <code>DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT</code>
		 *    indicates that the IGraphicElement owns exclusively the
		 *    DisplayObject corresponding to its <code>displayObject</code>
		 *    property.</li>
		 * 
		 *    <li>A value of <code>DisplayObjectSharingMode.OWNS_SHARED_OBJECT</code>
		 *    indicates taht the IGraphicElement owns the DisplayObject 
		 *    corresponding to its <code>displayObject</code> property but
		 *    other IGraphicElements are using/drawing to that display object as well.
		 *    Depending on the specific implementation, the IGraphicElement may perform
		 *    certain management of the display object.
		 *    For example the base class GraphicElement 
		 *    clears the transform of the display object, reset its visibility, alpha,
		 *    etc. properties to their default values and additionally clear the
		 *    graphics on every <code>validateDisplayList()</code> call.</li>
		 * 
		 *    <li>A value of <code>DisplayObjectSharingMode.USES_SHARED_OBJECT</code>
		 *    indicates that the IGraphicElement draws into the
		 *    DisplayObject corresponding to its <code>displayObject</code>
		 *    property. There are one or more IGraphicElements that draw
		 *    into that same displayObject, and the first element that draws
		 *    has its mode set to <code>DisplayObjectMode.OWNS_SHARED_OBJECT</code></li>
		 *  </ul>
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		function get displayObjectSharingMode():String;
		
		/**
		 *  @private 
		 */
		function set displayObjectSharingMode(value:String):void;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Creates a new DisplayObject where this IGraphicElement
		 *  is drawn.
		 *  
		 *  <p>Subsequent calls to the getter of the <code>displayObject</code> property must
		 *  return the same display object.</p>
		 *
		 *  <p>After the DisplayObject is created, the parent <code>IGraphicElementContainer</code>
		 *  will pass along the display objects to the rest of the elements in the sequence.</p>
		 *
		 *  <p>The <code>IGraphicElementContainer</code> ensures that this method is called only when needed.</p>
		 *
		 *  <p>If the element wants to participate in the DisplayObject
		 *  sharing, then the new DisplayObject must implement IShareableDisplayObject.
		 *  This interface is being used by the <code>IGraphicElementContainer</code> to manage invalidation and
		 *  redrawing of the graphic element sequence and typically is not directly
		 *  used by the developer.</p>
		 *
		 *  <p>To reevaluate the shared sequences, call the 
		 *  <code>invalidateGraphicElementSharing()</code> method
		 *  on the <code>IGraphicElementContainer</code>.</p>
		 *
		 *  <p>To force the <code>IGraphicElementContainer</code> to remove the element's current
		 *  DisplayObject from its display list and recalculate the
		 *  display object sharing, call the
		 *  <code>discardDisplayObject()</code> method on the <code>IGraphicElementContainer</code>.</p>
		 *
		 *  @return The display object created.
		 * 
		 *  @see #displayObject
		 *  @see spark.core.IGraphicElementContainer#invalidateGraphicElementSharing
		 *  @see spark.core.IGraphicElementContainer#discardDisplayObject
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		// function createDisplayObject():DisplayObject;
		
		/**
		 *  Determines whether this element can draw itself to the
		 *  <code>sharedDisplayObject</code> of the sequence.
		 * 
		 *  <p>Typically implementers return <code>true</code> when this
		 *  IGraphicElement can cumulatively draw in the shared
		 *  DisplayObject <code>graphics</code> property.
		 *  In all cases where this IGraphicElement needs to set
		 *  properties on the DisplayObjects that don't apply to the
		 *  rest of the elements in the sequence, this method must return <code>false</code>.
		 *  Examples for such properties are rotation, scale, transform,
		 *  mask, alpha, filters, color transform, 3D, and layer.</p>
		 *
		 *  <p>When this method returns <code>true</code>, subsequent calls to the getter of the
		 *  <code>displayObject</code> property must return the same display object.</p>
		 *
		 *  <p>In certain cases, the <code>sharedDisplayObject</code> property might be
		 *  the <code>IGraphicElementContainer</code> itself. In the rest of the cases, the
		 *  DisplayObject is created by the first element in the sequence.</p> 
		 *  
		 *  <p>When this IGraphicElement needs to rebuild its sequence,
		 *  it notifies the <code>IGraphicElementContainer</code> by calling its
		 *  <code>invalidateGraphicElementSharing()</code> method.</p>
		 *
		 *  @param sharedDisplayObject The shared DisplayObject.
		 * 
		 *  @return Returns <code>true</code> when this IGraphicElement can draw itself
		 *  to the shared DisplayObject of the sequence.
		 *
		 *  @see #canShareWithPrevious
		 *  @see #canShareWithNext
		 *  @see spark.core.IGraphicElementContainer#invalidateGraphicElementSharing
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		// function setSharedDisplayObject(sharedDisplayObject:DisplayObject):Boolean;
		
		/**
		 *  Returns <code>true</code> if this IGraphicElement is compatible and can
		 *  share display objects with the previous IGraphicElement
		 *  in the sequence.
		 * 
		 *  <p>In certain cases the element might be passed to the <code>IGraphicElementContainer</code>
		 *  in a call to the <code>setSharedDisplayObject()</code> method.
		 *  In those cases, this method is not called.</p>
		 * 
		 *  @param element The element that comes before this element in the sequence.
		 *  
		 *  @return Returns <code>true</code> when this element is compatible with the previous
		 *  element in the sequence.
		 * 
		 *  @see #canShareWithNext
		 *  @see #setSharedDisplayObject 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function canShareWithPrevious(element:IGraphicElement):Boolean;
		
		/**
		 *  Returns <code>true</code> if this IGraphicElement is compatible and can
		 *  share display objects with the next IGraphicElement
		 *  in the sequence.
		 * 
		 *  @param element The element that comes after this element in the sequence.
		 * 
		 *  @return Returns <code>true</code> when this element is compatible with the previous
		 *  element in the sequence.
		 * 
		 *  @see #canShareWithPrevious
		 *  @see #setSharedDisplayObject 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function canShareWithNext(element:IGraphicElement):Boolean;
		
		/**
		 *  Called by <code>IGraphicElementContainer</code> when an IGraphicElement
		 *  is added to or removed from the host component.
		 *  <p>You typically never need to call this method.</p>
		 *
		 *  @param parent The <code>IGraphicElementContainer</code> of this <code>IGraphicElement</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function parentChanged(parent:IGraphicElementContainer):void;
		
		/**
		 *  Called by the <code>IGraphicElementContainer</code> to validate the properties of
		 *  this element.
		 * 
		 *  <p>To ensure that this method is called, notify the <code>IGraphicElementContainer</code>
		 *  by calling its <code>invalidateGraphicElementProperties()</code> method.</p>  
		 * 
		 *  <p>This method might be called even if this element has not
		 *  notified the <code>IGraphicElementContainer</code>.</p>
		 * 
		 *  @see #validateSize
		 *  @see #validateDisplayList
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function validateProperties():void;
		
		/**
		 *  Called by the <code>IGraphicElementContainer</code> to validate the size of
		 *  this element.
		 * 
		 *  <p>When the size of the element changes and is going to affect the
		 *  <code>IGraphicElementContainer</code> layout, the implementer is responsible
		 *  for invalidating the parent's size and display list.</p>
		 * 
		 *  <p>To ensure that this method is called, notify the <code>IGraphicElementContainer</code>
		 *  by calling its <code>invalidateGraphicElementSize()</code> method.</p>
		 * 
		 *  <p>This method might be called even if this element has not
		 *  notified the <code>IGraphicElementContainer</code>.</p>
		 * 
		 *  @see #validateProperties
		 *  @see #validateDisplayList
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function validateSize():void;
		
		/**
		 *  Called by the <code>IGraphicElementContainer</code> to redraw this element
		 *  in its <code>displayObject</code> property.
		 *
		 *  <p>If the element is the first in the sequence (<code>displayObjectSharingMode</code>
		 *  is set to <code>DisplayObjectSharingMode.OWNS_SHARED_OBJECT</code>)
		 *  then it must clear the <code>displayObject</code>
		 *  graphics and set it up as necessary for drawing the rest of the elements.</p>
		 *
		 *  <p>The element must alway redraw even if it itself has not changed
		 *  since the last time the <code>validateDisplayList()</code> method was called.
		 *  The parent <code>IGraphicElementContainer</code> will redraw the whole sequence
		 *  if any of its elements need to be redrawn.</p>
		 * 
		 *  <p>To ensure this method is called, notify the <code>IGraphicElementContainer</code>
		 *  by calling its <code>invalidateGraphicElementSize()</code> method.</p>  
		 * 
		 *  <p>This method might be called even if this element has not
		 *  notified the <code>IGraphicElementContainer</code>.</p>
		 * 
		 *  @see #displayObject
		 *  @see #validateProperties
		 *  @see #validateSize
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function validateDisplayList():void;
	}
}
