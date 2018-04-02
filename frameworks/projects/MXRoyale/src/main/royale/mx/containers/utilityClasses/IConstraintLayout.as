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

package mx.containers.utilityClasses
{

/**
 *  IConstraintLayout is a marker interface that indicates that a container
 *  supports ConstraintColumn class and ConstraintRow class within its layout. 
 *  Application, Canvas, and Panel containers support ConstraintRow and  
 *  ConstraintColumn classes.
 *  To utilize this type of constraint in these containers,
 *  set the <code>layout</code> property to <code>"absolute"</code>
 *  and create ConstraintColumn and ConstraintRow instances. 
 * 
 *  @see mx.containers.Canvas
 *  @see mx.containers.Panel
 *  @see mx.core.Application
 *  @see mx.containers.utilityClasses.ConstraintColumn
 *  @see mx.containers.utilityClasses.ConstraintRow
 *  @see mx.modules.Module
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IConstraintLayout
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  constraintColumns
    //----------------------------------

    /**
     *  An Array of ConstraintColumn instances that partition this container.
     *  The ConstraintColumn instance at index 0 is the left-most column;
     *  indices increase from left to right. 
     * 
     *  @default []
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get constraintColumns():Array /* of ConstraintColumn */;
    
    /**
     *  @private
     */
    function set constraintColumns(value:Array /* of ConstraintColumn */):void;
    
    //----------------------------------
    //  constraintRows
    //----------------------------------
    
    /**
     *  An Array of ConstraintRow instances that partition this container.
     *  The ConstraintRow instance at index 0 is the top-most row;
     *  indices increase from top to bottom.
     * 
     *  @default []
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get constraintRows():Array /* of ConstraintRow */;
    
    /**
     *  @private
     */
    function set constraintRows(value:Array /* of ConstraintRow */):void;
}

}
