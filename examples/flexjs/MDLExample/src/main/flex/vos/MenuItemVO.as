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
package vos
{
    public class MenuItemVO
    {
        private var _label:String;
        private var _disabled:Boolean;
        private var _hasDivider:Boolean;

        public function MenuItemVO(label:String, hasDivider:Boolean = false, disabled:Boolean = false)
        {
           this.label = label;
           this.hasDivider = hasDivider;
           this.disabled = disabled;
        }

        public function get label():String
        {
            return _label;
        }

        public function set label(value:String):void
        {
            _label = value;
        }

        public function get disabled():Boolean
        {
            return _disabled;
        }

        public function set disabled(value:Boolean):void
        {
            _disabled = value;
        }

        public function get hasDivider():Boolean
        {
            return _hasDivider;
        }

        public function set hasDivider(value:Boolean):void
        {
            _hasDivider = value;
        }
    }
}
