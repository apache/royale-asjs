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

package mx.styles
{

/**
 *  This interface describes the advanced properties that a component must
 *  implement to fully participate in the advanced style subsystem.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface IAdvancedStyleClient extends IStyleClient
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  id
    //----------------------------------

    /**
     *  The identity of the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    function get id():String;

    //----------------------------------
    //  styleParent
    //----------------------------------

    /**
     *  The parent of this <code>IAdvancedStyleClient</code>..
     *
     *  Typically, you do not assign this property directly.
     *  It is set by the <code>addChild, addChildAt, removeChild, and
     *  removeChildAt</code> methods of the
     *  <code>flash.display.DisplayObjectContainer</code> and  the
     *  <code>mx.core.UIComponent.addStyleClient()</code>  and
     *  the <code>mx.core.UIComponent.removeStyleClient()</code> methods.
     *
     *  If it is assigned a value directly, without calling one of the
     *  above mentioned methods the instance of the class that implements this
     *  interface will not inherit styles from the UIComponent or DisplayObject.
     *  Also if assigned a value directly without, first removing the
     *  object from the current parent with the remove methods listed above,
     *  a memory leak could occur.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    function get styleParent():IAdvancedStyleClient;
    function set styleParent(parent:IAdvancedStyleClient):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Flex calls the <code>stylesInitialized()</code> method when
     *  the styles for a component are first initialized.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function stylesInitialized():void
        
    /**
     *  Returns <code>true</code> if <code>cssState</code> matches <code>currentCSSState</code>.
     *  Typically, you do not call this method directly. 
     *  It is called by the <code>mx.styles.CSSCondition.matchesStyleClient()</code> method.
     *
     *  <p>Note Spark components use their skin state as the pseudo state.
     *  Halo components use the <code>currentState</code> property.</p>
     *
     *  @param cssState A possible value of <code>CSSCondition.value</code>.
     *  It represents the current state of this component used to match CSS pseudo-selectors.
     *
     *  @return <code>true</code> if <code>cssState</code> matches <code>currentCSSState</code>. 
     *  By default, <code>currentCSSState</code> is the same as <code>currentState</code>.
     *  If no state exists, return null.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function matchesCSSState(cssState:String):Boolean;

    /**
     *  Determines whether this instance is the same as, or is a subclass of,
     *  the given type.
     *  Typically, you do not call this method directly. 
     *  It is called by the <code>mx.styles.CSSCondition.matchesStyleClient()</code> method.
     *
     *  @param cssType A CSSSelector object.
     *
     *  @return <code>true</code> if <code>cssType</code> is in the hierarchy of qualified type selectors.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    function matchesCSSType(cssType:String):Boolean;


    /**
     *  Returns <code>true</code> if <code>currentCSSState</code> is not <code>null</code>.
     *  Typically, you do not call this method directly. 
     *  It is called by the <code>mx.styles.CSSCondition.matchesStyleClient()</code> method.
     *
     *  <p>Note Spark components use their skin state as the pseudo state.
     *  Halo components use the <code>currentState</code> property.</p>
     *
     *  @return <code>true</code> if <code>currentCSSState</code> is not <code>null</code>. 
     *  By default, <code>currentCSSState</code> is the same as <code>currentState</code>.
     *  If no state exists, return false.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.6
     */
    function hasCSSState():Boolean;
    
}

}
