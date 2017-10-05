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

package org.apache.royale.net.beads {
import org.apache.royale.core.IBead;
import org.apache.royale.core.IStrand;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;

    COMPILE::SWF
    public class CORSCredentialsBead {
        public function CORSCredentialsBead(withCredentials:Boolean = false) {
            trace("Only needed for JavaScript HTTP Server calls");
        }
    }

    /**
     *  Bead to allow passing on user authentication information in a XMLHttpRequest request.
     *
     *  If you don't use this bead any cross domain calls that require user authentication
     *  (via say basic authentication or cookies) will fail.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    COMPILE::JS
    public class CORSCredentialsBead implements IBead {

        public function CORSCredentialsBead(withCredentials:Boolean = false) {
            this.withCredentials = withCredentials;
        }

        private var _strand:IStrand;

        /**
         *  Listen for a pre and post send event to modify if user credentials are passed.
         *
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function set strand(value:IStrand):void {
            _strand = value;

            IEventDispatcher(_strand).addEventListener("preSend", preSendHandler);
            IEventDispatcher(_strand).addEventListener("postSend", postSendHandler);
        }

        /**
         *  Modify the HTTP request to pass credentials.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        protected function preSendHandler(event:Event):void {
            (event.target.element as XMLHttpRequest).withCredentials = withCredentials;
        }

        /**
         *  Clean up event listeners.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        protected function postSendHandler(event:Event):void {
            IEventDispatcher(_strand).removeEventListener("preSend", preSendHandler);
            IEventDispatcher(_strand).removeEventListener("postSend", preSendHandler);
        }

        private var _withCredentials:Boolean = false;

        /**
         *  Pass the user credentials or not.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get withCredentials():Boolean {
            return _withCredentials;
        }

        public function set withCredentials(value:Boolean):void {
            _withCredentials = value;
        }
    }
}
