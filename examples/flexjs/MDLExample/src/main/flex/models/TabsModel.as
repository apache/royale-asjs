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
package models
{
    import org.apache.flex.collections.ArrayList;

    import vos.TabVO;

    public class TabsModel
    {
        private var _tabs:ArrayList = new ArrayList([
                new TabVO("tab1", "Tab One"),
                new TabVO("tab2", "Tab Two"),
                new TabVO("tab3", "Tab Three")
        ]);

        private var _tabsLayout:ArrayList = new ArrayList([
            new TabVO("starks_panel", "Starks"),
            new TabVO("lannisters_panel", "Lannisters"),
            new TabVO("targaryens_panel", "Targaryens")
        ]);

        public function get tabs():ArrayList
        {
            return _tabs;
        }

        public function get tabsLayout():ArrayList
        {
            return _tabsLayout;
        }
    }
}
