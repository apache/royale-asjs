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

package mx.rpc.mxml
{

/**
 *  Implementing this interface means that an RPC service
 *  can be used in an MXML document by using MXML tags.
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IMXMLSupport
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  concurrency
    //----------------------------------

    [Inspectable(enumeration="multiple,single,last", defaultValue="multiple", category="General")]
    
    /**
     *  The concurrency setting of the RPC operation or HTTPService.
     *  One of "multiple" "last" or "single."
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get concurrency():String;
    
    /**
     *  @private
     */
    function set concurrency(value:String):void;

    //----------------------------------
    //  showBusyCursor
    //----------------------------------

    /**
     *  Indicates whether the RPC operation or HTTPService
     *  should show the busy cursor while it is executing.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
    function get showBusyCursor():Boolean;

    /**
     *  @private
     */
    function set showBusyCursor(value:Boolean):void;
}

}
