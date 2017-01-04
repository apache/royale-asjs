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
package org.apache.flex.mdl.beads.models
{
    import org.apache.flex.core.IStrand;
    import org.apache.flex.events.EventDispatcher;

    public class ToastModel extends EventDispatcher implements IToastModel
    {
        private var _message:String = "";
        private var _timeout:int = 2750;

        private var _strand:IStrand;

        public function ToastModel()
        {
            super();
        }

        public function get message():String
        {
            return _message;
        }

        public function set message(value:String):void
        {
            _message = value;
        }

        public function get timeout():int
        {
            return _timeout;
        }

        public function set timeout(value:int):void
        {
            _timeout = value;
        }

        public function get snackbarData():Object
        {
            return {
                message: _message,
                timeout: _timeout
            };
        }

        public function set strand(value:IStrand):void
        {
            _strand = value;
        }
    }
}
