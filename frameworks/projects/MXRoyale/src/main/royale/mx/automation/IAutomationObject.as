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

package mx.automation
{

import mx.core.UIComponent;
import mx.core.UIComponent;
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;

/**
 * The IAutomationObject interface defines the interface 
 * for a delegate object that implements automation
 * for a component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IAutomationObject 
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  automationDelegate
    //----------------------------------

    /**
     *  The delegate object that is handling the automation-related functionality.
     *  Automation sets this when it creates the delegate object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get automationDelegate():Object;

    /**
     *  @private
     */
    function set automationDelegate(delegate:Object):void;

    //----------------------------------
    //  automationName
    //----------------------------------

    /**
     *  Name that can be used as an identifier for this object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get automationName():String;

    /**
     *  @private
     */
    function set automationName(name:String):void;

    //----------------------------------
    //  automationValue
    //----------------------------------

    /**
     *  This value generally corresponds to the rendered appearance of the 
     *  object and should be usable for correlating the identifier with
     *  the object as it appears visually within the application.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get automationValue():Array;
    
    /**
     *  The number of automation children this container has.
     *  This sum should not include any composite children, though
     *  it does include those children not significant within the
     *  automation hierarchy.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get numAutomationChildren():int;

    /** 
     *  A flag that determines if an automation object
     *  shows in the automation hierarchy.
     *  Children of containers that are not visible in the hierarchy
     *  appear as children of the next highest visible parent.
     *  Typically containers used for layout, such as boxes and Canvas,
     *  do not appear in the hierarchy.
     *
     *  <p>Some controls force their children to appear
     *  in the hierarchy when appropriate.
     *  For example a List will always force item renderers,
     *  including boxes, to appear in the hierarchy.
     *  Implementers must support setting this property
     *  to <code>true</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get showInAutomationHierarchy():Boolean;

    /**
     *  @private
     */
    function set showInAutomationHierarchy(value:Boolean):void;
   
    /**
     *  An implementation of the <code>IAutomationTabularData</code> interface, which 
     *  can be used to retrieve the data.
     * 
     *  @return An implementation of the <code>IAutomationTabularData</code> interface.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get automationTabularData():Object;
    
    /**
     *  The owner of this component for automation purposes.
     * 
     *  @see mx.core.IVisualElement#owner
     * 
     *  @return The owner of this component
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    function get automationOwner():UIComponent;
    
    /**
     *  The parent of this component for automation purposes.
     * 
     *  @see mx.core.IVisualElement#parent
     * 
     *  @return The parent of this component
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    function get automationParent():UIComponent;
    
    /**
     *  True if this component is enabled for automation, false
     *  otherwise.
     * 
     *  @see mx.core.IUIComponent#enabled
     * 
     *  @return <code>true</code> if this component is enabled for automation,
     *          <code>false</code> otherwise.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    function get automationEnabled():Boolean;
    
    /**
     *  True if this component is visible for automation, false
     *  otherwise.
     * 
     *  @see mx.core.UIComponent#visible
     * 
     *  @return <code>true</code> if this component is visible for automation,
     *          <code>false</code> otherwise.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    function get automationVisible():Boolean;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
 
    /**
     *  Returns a set of properties that identify the child within 
     *  this container.  These values should not change during the
     *  lifespan of the application.
     *  
     *  @param child Child for which to provide the id.
     * 
     *  @return Sets of properties describing the child which can
     *          later be used to resolve the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function createAutomationIDPart(child:IAutomationObject):Object;
    
    /**
     *  Returns a set of properties as automation IDs that identify the child within
     *  this container.  These values should not change during the
     *  lifespan of the application
     * 
     *  @param child Child for which to provide the id.
     * 
     *  @param properties which needs to be considered for forming the Id.
     *
     *  @return Sets of properties describing the child which can
     *          later be used to resolve the component.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function createAutomationIDPartWithRequiredProperties(child:IAutomationObject, properties:Array):Object;

    /**
     *  Resolves a child by using the id provided. The id is a set 
     *  of properties as provided by the <code>createAutomationIDPart()</code> method.
     *
     *  @param criteria Set of properties describing the child.
     *         The criteria can contain regular expression values
     *         resulting in multiple children being matched.
     *  @return Array of children that matched the criteria
     *          or <code>null</code> if no children could not be resolved.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function resolveAutomationIDPart(criteria:Object):Array;

    /** 
     *  Provides the automation object at the specified index.  This list
     *  should not include any children that are composites.
     *
     *  @param index The index of the child to return
     * 
     *  @return The child at the specified index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getAutomationChildAt(index:int):IAutomationObject;
    
    /**
     *  Provides the automation object list .  This list
     *  does not include any children that are composites.
     *
     *  @return the automation children.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getAutomationChildren():Array;

    /**
     *  Replays the specified event.  A component author should probably call 
     *  super.replayAutomatableEvent in case default replay behavior has been defined 
     *  in a superclass.
     *
     *  @param event The event to replay.
     *
     *  @return <code>true</code> if a replay was successful.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function replayAutomatableEvent(event:Event):Boolean;
    
}

}
