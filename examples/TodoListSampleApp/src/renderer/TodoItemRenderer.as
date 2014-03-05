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
package renderer {
    import org.apache.flex.html.staticControls.Button;
    import org.apache.flex.html.staticControls.CheckBox;
    import org.apache.flex.html.staticControls.Label;
    import org.apache.flex.html.staticControls.supportClasses.DataItemRenderer;

    public class TodoItemRenderer extends DataItemRenderer {
        public function TodoItemRenderer() {
            super();
        }

        private var checkbox:CheckBox;
        private var title:Label;
        private var removeButton:Button;

        override public function addedToParent():void {
            super.addedToParent();

            checkbox = new CheckBox();
            addElement(checkbox);

            title = new Label();
            addElement(title);

            removeButton = new Button();
            addElement(removeButton);
        }

        override public function set data(value:Object):void {
            super.data = value;

            checkbox.selected = data.selected;
            title.text = data.title;
        }

        override public function adjustSize():void {
            var cy:Number = this.height / 2;

            checkbox.x = 10;
            checkbox.y = cy;

            title.x = 60;
            title.y = cy;

            removeButton.x = 300;
            removeButton.y = cy;

            updateRenderer();
        }
    }
}