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

package mx.controls.dataGridClasses
{
    //import mx.core.Container;
    import mx.controls.DataGrid;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }
    import org.apache.royale.html.beads.DataGridListArea;
    import org.apache.royale.html.supportClasses.IDataGridColumnList;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.UIBase;


    public class DataGridListArea extends org.apache.royale.html.beads.DataGridListArea
    {
        public function DataGridListArea()
        {
            super();
        }


        COMPILE::JS
        private var _userOnetimeSuperInternalChildren:Boolean;
        COMPILE::JS
        override public function internalChildren():Array
        {
            var arr:Array = super.internalChildren();
            if (_userOnetimeSuperInternalChildren) {
                _userOnetimeSuperInternalChildren = false;
                return arr;
            }
            // remove scrolling divs from the list
            // in theory, the only thing that calls this
            // is HorizontalLayout
            var children:Array = [];
            for each (var child:WrappedHTMLElement in arr)
            {
                if (child.royale_wrapper)
                    children.push(child);
            }
            return children;
        }

        private var _listCount:int=0;

        COMPILE::JS
        override public function addElement(c:IChild, dispatchEvent:Boolean = true):void{
            if (c is IDataGridColumnList) {
                _userOnetimeSuperInternalChildren = true;
                addElementAt(c, _listCount, dispatchEvent);
                _listCount++;
            } else super.addElement(c, dispatchEvent);
        }

        public function resetEmpty():void{
            _listCount = 0;
        }


        COMPILE::JS
        public function contains(other:UIBase):Boolean{
            return this.element.contains(other.element);
        }
    }

}
