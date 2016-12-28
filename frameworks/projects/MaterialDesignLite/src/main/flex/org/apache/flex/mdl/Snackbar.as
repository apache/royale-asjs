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
package org.apache.flex.mdl
{
    import org.apache.flex.mdl.beads.models.ISnackbarModel;

    /**
     *  Dispatched when the user click on Snackbar
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="action", type="org.apache.flex.events.Event")]

    COMPILE::SWF
    public class Snackbar extends Toast
    {
        private var _actionText:String;
        
        /**
         *  Text which appears on action button
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get actionText():String
        {
            return _actionText;
        }

        public function set actionText(value:String):void
        {
            _actionText = value;
        }
    }

    COMPILE::JS
    public class Snackbar extends Toast
    {
        public function Snackbar()
        {
            super();
        }

        override public function get message():String
        {
            return ISnackbarModel(model).message;
        }

        override public function set message(value:String):void
        {
            ISnackbarModel(model).message = value;
        }

        override public function get timeout():int
        {
            return ISnackbarModel(model).timeout;
        }

        override public function set timeout(value:int):void
        {
            ISnackbarModel(model).timeout = value;
        }

        public function get actionText():String
        {
            return ISnackbarModel(model).actionText;
        }

        public function set actionText(value:String):void
        {
            ISnackbarModel(model).actionText = value;
        }

        override public function show():void
        {
            if (snackbar)
            {
                var snackbarData:Object = ISnackbarModel(model).snackbarData;
                snackbar.showSnackbar(snackbarData);
            }
        }
    }
}
