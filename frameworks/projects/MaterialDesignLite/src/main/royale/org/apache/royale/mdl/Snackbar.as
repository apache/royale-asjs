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
package org.apache.royale.mdl
{
    import org.apache.royale.mdl.beads.models.ISnackbarModel;

    
    [Event(name="action", type="org.apache.royale.events.Event")]

    /**
     *  Snackbar are transient popup notifications without actions.
     *  
     *  The Material Design Lite (MDL) snackbar component is a container used to notify
     *  a user of an operation's status. It displays at the bottom of the screen. 
     *  A snackbar may contain an action button to execute a command for the user.
     *  Actions should undo the committed action or retry it if it failed for example. 
     *  Actions should not be to close the snackbar. 
     *  By not providing an action, the snackbar becomes a toast component (see Toast class)
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class Snackbar extends Toast
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function Snackbar()
        {
            super();
        }
        
        /**
         *  Text which appears on action button
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get actionText():String
        {
            return ISnackbarModel(model).actionText;
        }
        /**
         *  @private
         */
        public function set actionText(value:String):void
        {
            ISnackbarModel(model).actionText = value;
        }

        /**
         *  Show the snackbar
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
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
