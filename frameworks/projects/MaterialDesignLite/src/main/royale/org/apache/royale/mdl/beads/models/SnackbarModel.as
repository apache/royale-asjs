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
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;

    /**
     *  The SnackbarModel class defines the data associated with an org.apache.royale.mdl.Snackbar
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class SnackbarModel extends ToastModel implements ISnackbarModel
    {
        public function SnackbarModel()
        {
            super();
        }

        private var _actionText:String = "";
        /**
         *  @copy org.apache.royale.mdl.beads.models.ISnackbarModel#actionText
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get actionText():String
        {
            return _actionText;
        }

        public function set actionText(value:String):void
        {
            _actionText = value;
        }

        /**
         *  @copy org.apache.royale.mdl.beads.models.IToastModel#snackbarData
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        override public function get snackbarData():Object
        {
            return {
                message: message,
                timeout: timeout,
                actionHandler: onActionHandler,
                actionText: _actionText
            };
        }

        private var _strand:IStrand;
        /**
         *  @copy org.apache.royale.mdl.beads.models.IToastModel#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
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
