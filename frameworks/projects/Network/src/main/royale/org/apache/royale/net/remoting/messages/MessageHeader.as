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

    [RemoteClass(alias="flex.messaging.io.amf.MessageHeader")]

    /**
     *  The MessageHeader for an ActionMessage
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     * 
     *  @royalesuppresspublicvarwarning
     */
    public class MessageHeader
    {
        //--------------------------------------------------------------------------
        //
        // Constructor
        // 
        //--------------------------------------------------------------------------
        
        /**
         *  Constructs an instance of a MessageHeader
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3 
         */
        public function MessageHeader()
        {
            super();
        }

        //--------------------------------------------------------------------------
        //
        // Variables
        // 
        //--------------------------------------------------------------------------   

        /**
         *  The header name.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3 
         */
        public var name:String = "";

        /**
         *  Whether the receipient must understand the header
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3 
         */
        public var mustUnderstand:Boolean;
        
        //--------------------------------------------------------------------------
        //
        // Properties
        // 
        //--------------------------------------------------------------------------
        
        //----------------------------------
        //  data
        //----------------------------------
        
        /**
         *  @private
         */
        private var _data:Object;
        
        /**
         *  The data to be sent.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3 
         */
        public function get data():Object
        {
            return _data;
        }
        
        /**
         *  @private
         */
        public function set data(value:Object):void
        {
            _data = value;
        }   
    }
}
