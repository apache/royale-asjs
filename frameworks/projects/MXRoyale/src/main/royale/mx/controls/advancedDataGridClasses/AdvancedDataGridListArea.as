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

package mx.controls.advancedDataGridClasses
{

/* import flash.display.DisplayObject;
import flash.events.Event;
 */
import mx.controls.AdvancedDataGrid;

COMPILE::JS
{
import org.apache.royale.core.WrappedHTMLElement;
}
import org.apache.royale.html.beads.DataGridListArea;


/**
 *  The AdvancedDataGridColumnList class represnts a column in an AdvancedDataGrid control.
 *  There is one AdvancedDataGridColumnList per displayable column, even if a column
 *  is hidden or off-screen.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
public class AdvancedDataGridListArea extends DataGridListArea
{
    public function AdvancedDataGridListArea()
    {
        super();
        typeNames += " AdvancedDataGridListArea";
        
    }
    
    COMPILE::JS
    override public function internalChildren():Array
    {
        var arr:Array = super.internalChildren();
        // remove scrolling divs from the list
        // in theory, the only thing that calls this
        // is HorizontalLayout
        var children:Array = [];
        for each (var child:WrappedHTMLElement in children)
        {
            if (child.royale_wrapper)
                children.push(child);
        }
        return children;
    }
}

}
