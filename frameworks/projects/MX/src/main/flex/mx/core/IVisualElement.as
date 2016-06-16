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
COMPILE::SWF
{
	import flash.display.DisplayObjectContainer;		
}
COMPILE::JS
{
	import flex.display.DisplayObjectContainer;		
}
COMPILE::LATER
{
import mx.geom.TransformOffsets;
}

/**
 *  The IVisualElement interface defines the minimum properties and methods 
 *  required for a visual element to be laid out and displayed in a Spark container.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface IVisualElement extends ILayoutElement, ILayoutDirectionElement
{

    /**
     *  The owner of this IVisualElement object. 
     *  By default, it is the parent of this IVisualElement object.
     *  However, if this IVisualElement object is a child component that is
     *  popped up by its parent, such as the drop-down list of a ComboBox control,
     *  the owner is the component that popped up this IVisualElement object.
     *
     *  <p>This property is not managed by Flex, but by each component.
     *  Therefore, if you use the <code>PopUpManger.createPopUp()</code> or
     *  <code>PopUpManger.addPopUp()</code> method to pop up a child component,
     *  you should set the <code>owner</code> property of the child component
     *  to the component that popped it up.</p>
     *
     *  <p>The default value is the value of the <code>parent</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get owner():DisplayObjectContainer;
    
    /**
     *  @private
     */
    function set owner(value:DisplayObjectContainer):void;
    
    /**
     *  The parent container or component for this component.
     *  Only visual elements should have a <code>parent</code> property.
     *  Non-visual items should use another property to reference
     *  the object to which they belong.
     *  By convention, non-visual objects use an <code>owner</code>
     *  property to reference the object to which they belong.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get parent():DisplayObjectContainer;
    
    /**
     *  Determines the order in which items inside of containers
     *  are rendered. 
     *  Spark containers order their items based on their 
     *  <code>depth</code> property, with the lowest depth in the back, 
     *  and the higher in the front.  
     *  Items with the same depth value appear in the order
     *  they are added to the container.
     * 
     *  @default 0
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get depth():Number;
    
    /**
     *  @private
     */
    function set depth(value:Number):void;

    /**
     *  Controls the visibility of this visual element. 
     *  If <code>true</code>, the object is visible.
     * 
     *  <p>If an object is not visible, but the <code>includeInLayout</code> 
     *  property is set to <code>true</code>, then the object 
     *  takes up space in the container, but is invisible.</p>
     * 
     *  <p>If <code>visible</code> is set to <code>true</code>, the object may not
     *  necessarily be visible due to its size and whether container clipping 
     *  is enabled.</p>
     * 
     *  <p>Setting <code>visible</code> to <code>false</code>, 
     *  prevents the component from getting focus.</p>
     * 
     *  @default true
     *  @see ILayoutElement#includeInLayout
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get visible():Boolean;
    
    /**
     *  @private
     */
    function set visible(value:Boolean):void;
    
    /**
     *  @copy flash.display.DisplayObject#alpha
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get alpha():Number;
    
    /**
     *  @private
     */
    function set alpha(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#width
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get width():Number;
    
    /**
     *  @private
     */
    function set width(value:Number):void;

    /**
     *  @copy flash.display.DisplayObject#height
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get height():Number;
    
    /**
     *  @private
     */
    function set height(value:Number):void;

    /**
     *  @copy flash.display.DisplayObject#x
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get x():Number;
    
    /**
     *  @private
     */
    function set x(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#y
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get y():Number;
    
    /**
     *  @private
     */
    function set y(value:Number):void;
    
    /**
     *  Specifies the optional DesignLayer instance associated with this visual 
     *  element.  
     *
     *  <p>When a DesignLayer is assigned, a visual element must consider the  
     *  visibility and alpha of its parent layer when ultimately committing its  
     *  own effective visibility or alpha to its backing DisplayObject 
     *  (if applicable).</p>
     *
     *  <p>A visual element must listen for <code>layerPropertyChange</code>
     *  notifications from the associated layer parent.  When the 
     *  <code>effectiveAlpha</code> or <code>effectiveVisibility</code> of the 
     *  layer changes, the element must then compute its own effective visibility 
     *  (or alpha) and apply it accordingly.</p>
     *
     *  <p>This property should not be set within MXML directly.</p>
     *  
     *  <p>The <code>designLayer</code> property is not used for z-order control, 
     *  please see <code>depth</code>.</p>
     *
     *  @see #depth
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
	COMPILE::LATER
    function get designLayer():DesignLayer;
    
    /**
     *  @private
     */
	COMPILE::LATER
    function set designLayer(value:DesignLayer):void;

    /**
     *  Defines a set of adjustments that can be applied to the object's 
     *  transform in a way that is invisible to its parent's layout. 
     *  
     *  <p>For example, if you want a layout to adjust for an object 
     *  that is rotated 90 degrees, set the object's 
     *  <code>rotation</code> property. If you want the layout to <i>not</i> 
     *  adjust for the object being rotated, 
     *  set its <code>postLayoutTransformOffsets.rotationZ</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
	COMPILE::LATER
    function get postLayoutTransformOffsets():TransformOffsets;
    
    /**
     *  @private
     */
	COMPILE::LATER
    function set postLayoutTransformOffsets(value:TransformOffsets):void;
	    
    /**
     *  Contains <code>true</code> when the element is in 3D. 
     *  The element can be in 3D either because
     *  it has 3D transform properties or it has 3D post layout transform offsets or both.
     *
     *  @see #postLayoutTransformOffsets
     *  @see mx.core.ILayoutElement#hasLayoutMatrix3D
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get is3D():Boolean;
}
}
