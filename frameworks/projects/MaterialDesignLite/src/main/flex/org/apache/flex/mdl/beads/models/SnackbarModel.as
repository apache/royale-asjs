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
    import org.apache.flex.core.UIBase;
    import org.apache.flex.events.Event;

    public class SnackbarModel extends ToastModel implements ISnackbarModel
    {
        private var _actionText:String = "";

        private var _strand:IStrand;

        public function SnackbarModel()
        {
            super();
        }
        
        public function get actionText():String
        {
            return _actionText;
        }

        public function set actionText(value:String):void
        {
            _actionText = value;
        }

        override public function get snackbarData():Object
        {
            return {
                message: message,
                timeout: timeout,
                actionHandler: onActionHandler,
                actionText: _actionText
            };
        }

        override public function set strand(value:IStrand):void
        {
            _strand = value;
        }

        private function onActionHandler(event:Event):void
        {
            (UIBase)(_strand).dispatchEvent(new Event("action"));
        }
    }
}
