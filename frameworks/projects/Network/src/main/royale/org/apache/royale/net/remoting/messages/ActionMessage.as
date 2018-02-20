////////////////////////////////////////////////////////////////////////////////
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

/***
 * AMF JavaScript library by Emil Malinov https://github.com/emilkm/amfjs
 */

package org.apache.royale.net.remoting.messages
{

COMPILE::SWF
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
}

[RemoteClass(alias="flex.messaging.io.amf.ActionMessage")]

/**
 *  The CommandMessage class provides a mechanism for sending commands to the
 *  server infrastructure, such as commands related to publish/subscribe 
 *  messaging scenarios, ping operations, and cluster operations.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 * 
 *  @royalesuppresspublicvarwarning
 */
public class ActionMessage
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Constructs an instance of an ActionMessage with an empty array of bodies
     *  and headers.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function ActionMessage()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------   

    /**
     *  The version of the ActionMessage.  Probably should not be changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public var version:int = 3;

    //--------------------------------------------------------------------------
    //
    // Overridden Methods
    // 
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  bodies
    //----------------------------------
    
    /**
     *  @private
     */
    private var _bodies:Array = [];
    
    /**
     *  The array of MessageBody instances.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get bodies():Array
    {
        return _bodies;
    }
    
    /**
     *  @private
     */
    public function set bodies(value:Array):void
    {
        _bodies = value;
    }   
    
    //----------------------------------
    //  headers
    //----------------------------------
    
    /**
     *  @private
     */
    private var _headers:Array = [];
    
    /**
     *  The array of MessageHeaders
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get headers():Array
    {
        return _headers;
    }
    
    /**
     *  @private
     */
    public function set headers(value:Array):void
    {
        _headers = value;
    }   

  
}

}
