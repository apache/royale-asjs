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
package org.apache.royale.mdl.beads.models
{
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.EventDispatcher;

    /**
     *  The ToastModel class defines the data associated with an org.apache.royale.mdl.Toast
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class ToastModel extends EventDispatcher implements IToastModel
    {
        public function ToastModel()
        {
            super();
        }

        private var _message:String = "";
        /**
         *  The message of the toast
         *  
         *  @copy org.apache.royale.mdl.beads.models.IToastModel#message
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get message():String
        {
            return _message;
        }

        public function set message(value:String):void
        {
            _message = value;
        }

        private var _timeout:int = 2750;
        /**
         *  @copy org.apache.royale.mdl.beads.models.IToastModel#timeout
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get timeout():int
        {
            return _timeout;
        }

        public function set timeout(value:int):void
        {
            _timeout = value;
        }

        /**
         *  @copy org.apache.royale.mdl.beads.models.IToastModel#snackbarData
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get snackbarData():Object
        {
            return {
                message: _message,
                timeout: _timeout
            };
        }

        private var _strand:IStrand;
        /**
         *  Set strand for model
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *
         * @param value
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
        }
    }
}
