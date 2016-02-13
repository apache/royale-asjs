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
    
import org.apache.flex.events.IEventDispatcher;

/**
 *  The IStateClient2 interface defines the interface that 
 *  components must implement to support Flex 4 view state
 *  semantics.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IStateClient2 extends IEventDispatcher, IStateClient 
{   
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  states
    //----------------------------------

    [ArrayElementType("mx.states.State")]

    /**
     *  The set of view state objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get states():Array;

    /**
     *  @private
     */
    function set states(value:Array):void;
    
    
    //----------------------------------
    //  transitions
    //----------------------------------
    
    [ArrayElementType("mx.states.Transition")]
    
    /**
     *  The set of view state transitions.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get transitions():Array;

    /**
     *  @private
     */
    function set transitions(value:Array):void;
    
    /**
     *  Determines whether the specified state has been defined on this
     *  UIComponent. 
     *
     *  @param stateName The name of the state being checked. 
     *
     *  @return Whether or not the specified state has been defined 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function hasState(stateName:String):Boolean
    
}

}