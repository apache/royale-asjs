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
//import flash.events.Event;
import org.apache.royale.events.Event;

[DefaultProperty("children")]

/**
 *  Use the AdvancedDataGridColumnGroup class to specify column groups for
 *  the AdvancedDataGrid control. 
 *  You can specify one or more AdvancedDataGridColumn classes as children of 
 *  the AdvancedDataGridColumnGroup class, or nest AdvancedDataGridColumnGroup classes
 *  to create nested column groups.
 *  The <code>AdvancedDataGrid.columnGroup</code> property 
 *  takes an Array of AdvancedDataGridColumnGroup instances to specify the column groups. 
 *
 *  <p>The following example uses the AdvancedDataGridColumnGroup class to define
 *  a column group named Revenues that contains two columns: Actual and Estimate.</p>
 *
 *  <pre>
 *  &lt;mx:AdvancedDataGrid id="myADG"
 *       dataProvider="{dpFlat}"
 *       width="100%" height="100%"&gt;
 *       &lt;mx:groupedColumns&gt;
 *           &lt;mx:AdvancedDataGridColumn dataField="Region"/&gt;
 *           &lt;mx:AdvancedDataGridColumn dataField="Territory"/&gt;
 *           &lt;mx:AdvancedDataGridColumn dataField="Territory_Rep"
 *               headerText="Territory Rep"/&gt;
 *           &lt;mx:AdvancedDataGridColumnGroup headerText="Revenues"&gt;    
 *               &lt;mx:AdvancedDataGridColumn dataField="Actual"/&gt;
 *               &lt;mx:AdvancedDataGridColumn dataField="Estimate"/&gt;
 *           &lt;/mx:AdvancedDataGridColumnGroup&gt;    
 *       &lt;/mx:groupedColumns&gt;
 *  &lt;/mx:AdvancedDataGrid&gt;</pre>
 *
 *  @mxml
 *
 *  <p>You use the <code>&lt;mx.AdvancedDataGridColumnGroup&gt;</code> tag to configure a column
 *  group of a AdvancedDataGrid control.
 *  You specify the <code>&lt;mx.AdvancedDataGridColumnGroup&gt;</code> tag as a child
 *  of the <code>groupedColumns</code> property in MXML.
 *  The <code>&lt;mx.AdvancedDataGridcolumn&gt;</code> tag defines the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:AdvancedDataGridColumn
 *  <b>Properties </b>
 *    children="<i>No default</i>"
 *    childrenDragEnabled="true|false"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.controls.AdvancedDataGrid#columnGroup
 *  
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.3
*  @royalesuppresspublicvarwarning
*/
public class AdvancedDataGridColumnGroup extends AdvancedDataGridColumn
{ 


    //include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     * 
     *  @param columnName The name of the field in the data provider 
     *  associated with the column group, and the text for the header cell of this 
     *  column.  This is equivalent to setting the <code>dataField</code>
     *  and <code>headerText</code> properties.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function AdvancedDataGridColumnGroup(columnName:String = null)
    {
        super(columnName);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------   
    
    //----------------------------------
    // children
    //----------------------------------
    
    /**
     *  An Array of AdvancedDataGridColumn instances that define the columns 
     *  of the column group.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var children:Array = [];
    
    //----------------------------------
    // childrenDragEnabled
    //----------------------------------
    
    /**
     *  Specifies whether the child columns can be dragged to reposition them in the group.
     *  If <code>false</code>, child columns cannot be reordered even if 
     *  the <code>AdvancedDataGridColumn.dragEnabled</code> property is set 
     *  to <code>true</code> for a child column.
     *  
     *  @default true                                                                                                                                                     
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public var childrenDragEnabled:Boolean = true;
    
    //----------------------------------
    // width
    //----------------------------------
    
   // private var _width:Number = 100;

    /**
     *  @private
     */
   /*  override public function get width():Number
    {
        if(this.children && this.children.length > 0)
            return _width;
        else
            return super.width;
    }
	*/
    /**
     *  @private
     */
    /* override public function set width(value:Number):void
    {
        if(this.children && this.children.length > 0)
        {
            _width = value;
            dispatchEvent(new Event("widthChanged"));
        }
        else
        {
            super.width = value;
        }
    } */
    //--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    /* override protected function copyProperties(col:AdvancedDataGridColumn):void
    {
    	super.copyProperties(col);
    	
    	// copy the remaining properties
    	AdvancedDataGridColumnGroup(col).childrenDragEnabled = childrenDragEnabled;
    } */
    
    /**
     *  @private
     */
    /* override public function clone():AdvancedDataGridColumn
    {
    	// make a new column group
    	var col:AdvancedDataGridColumnGroup = new AdvancedDataGridColumnGroup();
    	
    	// copy the properties
    	copyProperties(col);
    	
    	// check the children property and clone the columns and column groups
    	var n:int = children.length;
    	for (var i:int = 0; i < n; i++)
    	{
    		col.children[i] = children[i].clone();
    	}
    	return col;
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Returns the data from the data provider for the specified Object.
     * 
     *  <p>This method is useful when the data for a row contains nested Objects. 
     *  For example, a row is defined by the following data in the data provider:</p>
     *  <pre>
     *  row = { name:"Adobe", address : {
     *                                    street  : "345 Park Avenue", 
     *                                    city    : "San Jose",
     *                                    state   : "CA 95110",
     *                                    country : "USA"
     *                                  }
     *                   }</pre>
     *
     *  <p>You then assign the "address" field to the <code>dataField</code> property
     *  of the AdvancedDataGridColumnGroup instance. A call to  <code>itemToData(row)</code>
     *  then returns the address object. </p>
     *
     *  <p>This method is similar to the 
     *  <code>AdvancedDataGridColumn.itemToLabel()</code> method. </p>
     *
     *  @param data The data provider element.
     *
     *  @return The data from the data provider for the specified Object.
     *
     *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridColumn
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    /* public function itemToData(data:Object):*
    {
       if (!data)
          return null;
       
       if (labelFunction != null)
       {
          data = labelFunction(data, this);
          return data;
       }
       if (typeof(data) == "object" || typeof(data) == "xml")
       {
            if (dataField != null)
			{
				if (dataField != null && dataField in data)
                	data = data[dataField];
				else
					data = null;
			}
       }
       return data;
    } */
}

}