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

package mx.managers
{

/**
 *  The IFocusManagerComponent interface defines the interface 
 *  that focusable components must implement in order to
 *  receive focus from the FocusManager.
 *  The base implementations of this interface are in the UIComponent class, 
 *  but UIComponent does not implement the full IFocusManagerComponent interface 
 *  since some UIComponents are not intended to receive focus.
 *  Therefore, to make a UIComponent-derived component be a valid focusable
 *  component, you simply add "implements IFocusManagerComponent" to the class
 *  definition.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IFocusManagerComponent
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  focusEnabled
    //----------------------------------

    /**
     *  A flag that indicates whether the component can receive focus when selected.
     * 
     *  <p>As an optimization, if a child component in your component 
     *  implements the IFocusManagerComponent interface, and you
     *  never want it to receive focus,
     *  you can set <code>focusEnabled</code>
     *  to <code>false</code> before calling <code>addChild()</code>
     *  on the child component.</p>
     * 
     *  <p>This will cause the FocusManager to ignore this component
     *  and not monitor it for changes to the <code>tabFocusEnabled</code>,
     *  <code>hasFocusableChildren</code>, and <code>mouseFocusEnabled</code> properties.
     *  This also means you cannot change this value after
     *  <code>addChild()</code> and expect the FocusManager to notice.</p>
     *
     *  <p>Note: It does not mean that you cannot give this object focus
     *  programmatically in your <code>setFocus()</code> method;
     *  it just tells the FocusManager to ignore this IFocusManagerComponent
     *  component in the Tab and mouse searches.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get focusEnabled():Boolean;
    
    /**
     *  @private
     */
    function set focusEnabled(value:Boolean):void;

    //----------------------------------
    //  hasFocusableChildren
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#hasFocusableChildren
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get hasFocusableChildren():Boolean;
    
    /**
     *  @private
     */
    function set hasFocusableChildren(value:Boolean):void;

    //----------------------------------
    //  mouseFocusEnabled
    //----------------------------------

    /**
     *  A flag that indicates whether the component can receive focus 
     *  when selected with the mouse.
     *  If <code>false</code>, focus will be transferred to
     *  the first parent that is <code>mouseFocusEnabled</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    //function get mouseFocusEnabled():Boolean;

    //----------------------------------
    //  tabFocusEnabled
    //----------------------------------

    /**
     *  A flag that indicates whether pressing the Tab key eventually 
     *  moves focus to this component.
     *  Even if <code>false</code>, you can still be given focus
     *  by being selected with the mouse or via a call to
     *  <code>setFocus()</code>.  This property replaces 
     *  InteractiveObject.tabEnabled which must be set to true
     *  in Flex apps.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get tabFocusEnabled():Boolean;

    //----------------------------------
    //  tabIndex
    //----------------------------------

    /**
     *  If <code>tabFocusEnabled</code>, the order in which the component receives focus.
     *  If -1, then the component receives focus based on z-order.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get tabIndex():int;

    /**
     *  @private
     */
    function set tabIndex(value:int):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Called by the FocusManager when the component receives focus.
     *  The component may in turn set focus to an internal component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function setFocus():void;

    /**
     *  Called by the FocusManager when the component receives focus.
     *  The component should draw or hide a graphic 
     *  that indicates that the component has focus.
     *
     *  @param isFocused If <code>true</code>, draw the focus indicator,
     *  otherwise hide it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    //function drawFocus(isFocused:Boolean):void;
}

}
