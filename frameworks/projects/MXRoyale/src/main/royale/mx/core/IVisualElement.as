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

/**
 *  The IVisualElement interface defines the minimum properties and methods 
 *  required for a visual element to be laid out and displayed in a Spark container.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface IVisualElement extends ILayoutElement/*, ILayoutDirectionElement*/
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
    function get owner():IUIComponent;
    
    /**
     *  @private
     */
    function set owner(value:IUIComponent):void;
    
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
    [SWFOverride(returns="flash.display.DisplayObjectContainer")]
    function get parent():IParent;
    
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
    
}
}
