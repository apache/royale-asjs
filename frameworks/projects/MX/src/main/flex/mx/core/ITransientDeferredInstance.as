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

/**
 *  The ITransientDeferredInstance interface extends IDeferredInstance and adds 
 *  the ability for the user to reset the deferred instance factory to its
 *  initial state (usually this implies releasing any known references to the
 *  component, such as the setting the owning document property that refers to
 *  the instance to null).
 *
 *  This additional capability is leveraged by the AddItems states override when
 *  the desired behavior is to destroy a state-specific element when a state
 *  no longer applies.
 * 
 *  The Flex compiler uses the same automatic coercion rules as with
 *  IDeferredInstance.
 * 
 *  @see mx.states.AddItems
 *  @see mx.core.IDeferredInstance
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface ITransientDeferredInstance extends IDeferredInstance
{
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Resets the state of our factory to its initial state, clearing any
     *  references to the cached instance.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function reset():void;
}

}