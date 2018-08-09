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
package org.apache.royale.net.remoting.messages
{
    import org.apache.royale.events.EventDispatcher;
   
    /**
     *  Dispatched when a property of the RoyaleClient singleton changes.
     *  Listeners must be added via RoyaleClient.getInstance().addEventListener(...).
     * 
     *  @eventType mx.events.PropertyChangeEvent.PROPERTY_CHANGE
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    //[Event(name="propertyChange", type="mx.events.PropertyChangeEvent")]    
        
    /**
     *  Singleton class that stores the global Id for this instance that is 
     *  server assigned when the client makes its initial connection to the server.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public class RoyaleClient extends EventDispatcher
    {
        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------

        /**
         *  @private
         *  This value is passed to the server in an initial client connect to
         *  indicate that the client needs a server-assigned RoyaleClient Id.
         */
        public static const NULL_ROYALECLIENT_ID:String = "nil";

        //--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------

        /**
         *  @private
         *  The sole instance of this singleton class.
         */
        private static var _instance:RoyaleClient;
        
        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------

        /**
         *  Returns the sole instance of this singleton class,
         *  creating it if it does not already exist.
         *
         *  @return Returns the sole instance of this singleton class,
         *  creating it if it does not already exist.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3 
         */
        public static function getInstance():RoyaleClient
        {
            if (_instance == null){
                _instance = new RoyaleClient();
            }

            return _instance;
        }

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         *  @private
         *  Constructor.
         */
        public function RoyaleClient()
        {
            super();
        }    
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  id
        //----------------------------------

        /**
         *  @private
         *  Storage for the global RoyaleClient Id for the this instance. 
         *  This value is server assigned and is set as part of the Channel connect process.
         */	
        private var _id:String = null;
        
        //[Bindable(event="propertyChange")]
        /**
         *  The global RoyaleClient Id for this this instance.
         *  This value is server assigned and is set as part of the Channel connect process.
         *  Once set, it will not change for the duration of the instance's lifespan.
         *  If no Channel has connected to a server this value is null.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3 
         */
        public function get id():String
        {
            return _id;
        } 
            
        /**
         *  @private
         */
        public function set id(value:String):void
        {
            if (_id != value)
            {
                //var event:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "id", _id, value);
                _id = value;
                //dispatchEvent(event);
            }        
        }
        
        //----------------------------------
        //  waitForRoyaleClientId
        //----------------------------------
                
        /**
         *  @private
         */
        //private var _waitForRoyaleClientId:Boolean = false; // Initialize to false so the first Channel that checks this can attempt to connect.
        
        //[Bindable(event="propertyChange")]
        /**
         *  @private 
         *  Guard condition that Channel instances use to coordinate their connect attempts during application startup
         *  when a RoyaleClient Id has not yet been returned by the server.
         *  The initial Channel connect process must be serialized.
         *  Once a RoyaleClient Id is set further Channel connects and disconnects do not require synchronization.
         */
        /*private function get waitForRoyaleClientId():Boolean
        {
            return _waitForRoyaleClientId;
        }*/
        
        /**
         *  @private
         */
        /*private function set waitForRoyaleClientId(value:Boolean):void
        {
            if (_waitForRoyaleClientId != value)
            {
                //var event:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "waitForFlexClientId", _waitForRoyaleClientId, value);
                _waitForRoyaleClientId = value;
                //dispatchEvent(event);
            }
        }*/
    }
}
