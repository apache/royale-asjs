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
    import org.apache.royale.html.beads.models.ArrayListSelectionModel;
    import org.apache.royale.events.Event;
    /**
     *  The TabArrayListModel class defines the data associated with an org.apache.royale.mdl.Tabs
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class TabArrayListModel extends ArrayListSelectionModel implements ITabModel
    {
        public function TabArrayListModel()
        {
            super();
        }

        private var _tabIdField:String;

        /**
         *  @copy org.apache.royale.mdl.beads.models.ITabModel#tabIdField
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get tabIdField():String
        {
            return _tabIdField;
        }

        public function set tabIdField(value:String):void
        {
            _tabIdField = value;
        }
    }
}
