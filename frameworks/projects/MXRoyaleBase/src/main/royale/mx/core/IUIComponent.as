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
import org.apache.royale.core.IChild;
import org.apache.royale.core.IUIBase;
import org.apache.royale.geom.Rectangle;
import mx.managers.ISystemManager;
import mx.core.IChildList;

/**
 *  The IUIComponent interface defines the basic set of APIs
 *  that you must implement to create a child of a Flex container or list.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IUIComponent extends IFlexDisplayObject, IChild, IUIBase, IChildList
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  component (was 'document' in Flex)
    //----------------------------------

    /**
     *  A reference to the document object associated with this component. 
     *  A document object is an Object at the top of the hierarchy
     *  of a Flex application, MXML component, or ActionScript component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get mxmlDocument():Object

    /**
     *  @private
     */
    function set mxmlDocument(value:Object):void

    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  Whether the component can accept user interaction. After setting the <code>enabled</code>
     *  property to <code>false</code>, some components still respond to mouse interactions such 
     *  as mouseOver. As a result, to fully disable UIComponents,
     *  you should also set the value of the <code>mouseEnabled</code> property to <code>false</code>.
     *  If you set the <code>enabled</code> property to <code>false</code>
     *  for a container, Flex dims the color of the container and of all
     *  of its children, and blocks user input to the container
     *  and to all of its children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get enabled():Boolean;

    /**
     *  @private
     */
    function set enabled(value:Boolean):void;

    //----------------------------------
    //  explicitHeight
    //----------------------------------

    /**
     *  The explicitly specified height for the component, 
     *  in pixels, as the component's coordinates.
     *  If no height is explicitly specified, the value is <code>NaN</code>.
     *
     *  @see mx.core.UIComponent#explicitHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get explicitHeight():Number;

    /**
     *  @private
     */
    function set explicitHeight(value:Number):void;

    //----------------------------------
    //  explicitMaxHeight
    //----------------------------------

    /**
     *  Number that specifies the maximum height of the component, 
     *  in pixels, as the component's coordinates. 
     *
     *  @see mx.core.UIComponent#explicitMaxHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get explicitMaxHeight():Number;

    //----------------------------------
    //  explicitMaxWidth
    //----------------------------------

    /**
     *  Number that specifies the maximum width of the component, 
     *  in pixels, as the component's coordinates. 
     *
     *  @see mx.core.UIComponent#explicitMaxWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get explicitMaxWidth():Number;

    //----------------------------------
    //  explicitMinHeight
    //----------------------------------

    /**
     *  Number that specifies the minimum height of the component, 
     *  in pixels, as the component's coordinates. 
     *
     *  @see mx.core.UIComponent#explicitMinHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get explicitMinHeight():Number;

    //----------------------------------
    //  explicitMinWidth
    //----------------------------------

    /**
     *  Number that specifies the minimum width of the component, 
     *  in pixels, as the component's coordinates. 
     *
     *  @see mx.core.UIComponent#explicitMinWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get explicitMinWidth():Number;

    //----------------------------------
    //  explicitWidth
    //----------------------------------

    /**
     *  The explicitly specified width for the component, 
     *  in pixels, as the component's coordinates.
     *  If no width is explicitly specified, the value is <code>NaN</code>.
     *
     *  @see mx.core.UIComponent#explicitWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get explicitWidth():Number;

    /**
     *  @private
     */
    function set explicitWidth(value:Number):void;

    //----------------------------------
    //  includeInLayout
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#includeInLayout
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get includeInLayout():Boolean;

    /**
     *  @private
     */
    function set includeInLayout(value:Boolean):void;

    //----------------------------------
    //  isPopUp
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#isPopUp
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get isPopUp():Boolean;

    /**
     *  @private
     */
    function set isPopUp(value:Boolean):void;

    //----------------------------------
    //  maxHeight
    //----------------------------------

    /**
     *  Number that specifies the maximum height of the component, 
     *  in pixels, as the component's coordinates.
     *
     *  @see mx.core.UIComponent#maxHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get maxHeight():Number;

    //----------------------------------
    //  maxWidth
    //----------------------------------

    /**
     *  Number that specifies the maximum width of the component, 
     *  in pixels, as the component's coordinates.
     *
     *  @see mx.core.UIComponent#maxWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get maxWidth():Number;

    //----------------------------------
    //  measuredMinHeight
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#measuredMinHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get measuredMinHeight():Number;

    /**
     *  @private
     */
    function set measuredMinHeight(value:Number):void;

    //----------------------------------
    //  measuredMinWidth
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#measuredMinWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get measuredMinWidth():Number;

    /**
     *  @private
     */
    function set measuredMinWidth(value:Number):void;

    //----------------------------------
    //  minHeight
    //----------------------------------

    /**
     *  Number that specifies the minimum height of the component, 
     *  in pixels, as the component's coordinates. 
     *
     *  @see mx.core.UIComponent#minHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get minHeight():Number;

    //----------------------------------
    //  minWidth
    //----------------------------------

    /**
     *  Number that specifies the minimum width of the component, 
     *  in pixels, as the component's coordinates. 
     *
     *  @see mx.core.UIComponent#minWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get minWidth():Number;

    //----------------------------------
    //  owner
    //----------------------------------

    /**
     *  @copy mx.core.IVisualElement#owner
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get owner():IUIComponent;

    /**
     *  @private
     */
    function set owner(value:IUIComponent):void;

    //----------------------------------
    //  percentHeight
    //----------------------------------

    /**
     *  Number that specifies the height of a component as a 
     *  percentage of its parent's size.
     *  Allowed values are 0 to 100.     
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get percentHeight():Number;

    /**
     *  @private
     */
    function set percentHeight(value:Number):void;

    //----------------------------------
    //  percentWidth
    //----------------------------------

    /**
     *  Number that specifies the width of a component as a 
     *  percentage of its parent's size.
     *  Allowed values are 0 to 100.     
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get percentWidth():Number;

    /**
     *  @private
     */
    function set percentWidth(value:Number):void;
	
	function get scaleX():Number;
	function set scaleX(value:Number):void;
	
	function get scaleY():Number;
	function set scaleY(value:Number):void;

    //----------------------------------
    //  systemManager
    //----------------------------------

    /**
     *  A reference to the SystemManager object for this component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get systemManager():ISystemManager;

    /**
     *  @private
     */
    function set systemManager(value:ISystemManager):void;
    
    function get rotation():Number
    
    function set rotation(value:Number):void
    
    function get styleName():Object;
    
    function set styleName(value:Object):void
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Initialize the object.
     *
     *  @see mx.core.UIComponent#initialize()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function initialize():void;
    
    /**
     *  @copy mx.core.UIComponent#getExplicitOrMeasuredWidth()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getExplicitOrMeasuredWidth():Number;

    /**
     *  @copy mx.core.UIComponent#getExplicitOrMeasuredHeight()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getExplicitOrMeasuredHeight():Number;
    
    /**
     *  @copy mx.core.UIComponent#owns() 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function owns(displayObject:IUIBase):Boolean;
}

}
