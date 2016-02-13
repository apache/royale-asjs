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
 *  The IConstraintClient interface defines the interface for components that
 *  support layout constraints. This interface is only used by implementations
 *  of constraint-based layout. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */

public interface IConstraintClient
{
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  getConstraintValue
    //----------------------------------

    /**
     *  Returns the specified constraint value.
     *
     *  @param constraintName name of the constraint value. Constraint parameters are
     *  "<code>baseline</code>", "<code>bottom</code>", "<code>horizontalCenter</code>", 
     *  "<code>left</code>", "<code>right</code>", "<code>top</code>", and 
     *  "<code>verticalCenter</code>".
     *
     *  <p>For more information about these parameters, see the Canvas and Panel containers and 
     *  Styles Metadata AnchorStyles.</p>
     *
     *  @return The constraint value, or null if it is not defined.
     *
     *  @see mx.containers.Canvas
     *  @see mx.containers.Panel
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getConstraintValue(constraintName:String):*;

    //----------------------------------
    //  setConstraintValue
    //----------------------------------

    /**
     *  Sets the specified constraint value.
     *
     *  @param constraintName name of the constraint value. Constraint parameters are
     *  "<code>baseline</code>", "<code>bottom</code>", "<code>horizontalCenter</code>", 
     *  "<code>left</code>", "<code>right</code>", "<code>top</code>", and 
     *  "<code>verticalCenter</code>".
     *
     *  <p>For more information about these parameters, see the Canvas and Panel containers and 
     *  Styles Metadata AnchorStyles.</p>
     *
     *  @param value The new value for the constraint.
     *
     *  @see mx.containers.Canvas
     *  @see mx.containers.Panel
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function setConstraintValue(constraintName:String, value:*):void;
}
}