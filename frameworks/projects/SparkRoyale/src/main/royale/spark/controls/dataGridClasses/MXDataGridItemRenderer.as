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

package spark.controls.dataGridClasses
{
import spark.controls.listClasses.MXItemRenderer;
import mx.controls.dataGridClasses.DataGridListData;

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="listData", kind="property")]

/**
 *  The MXDataGridItemRenderer class defines the Spark item renderer class 
 *  for use with the MX DataGrid control.
 *  This class lets you use the Spark item renderer architecture with the 
 *  MX DataGrid control. 
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;s:MXDataGridItemRenderer&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:MXItemRenderer
 *    <strong>Properties</strong>
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.controls.DataGrid
 *  @includeExample examples/MXDataGridItemRenderer.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class MXDataGridItemRenderer extends MXItemRenderer
{    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function MXDataGridItemRenderer()
    {
        super();
    }
    
    //----------------------------------
    //  dataGridListData
    //----------------------------------

    [Bindable("dataChange")]
    
    /**
     *  The implementation of the <code>listData</code> property
     *  as defined by the IDropInListItemRenderer interface.
     *  Use this property to access information about the 
     *  data item displayed by the item renderer.     
     *
     *  @see mx.controls.listClasses.IDropInListItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dataGridListData():DataGridListData
    {
        return listData as DataGridListData;
    }


}
}