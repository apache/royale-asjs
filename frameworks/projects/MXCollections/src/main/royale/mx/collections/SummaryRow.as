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

package mx.collections
{

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultProperty("fields")]

/**
 *  The SummaryRow class represents a summary row of the AdvancedDataGrid. 
 *  You create summary data about your data groups by using the <code>summaries</code> property 
 *  of the GroupingField or GroupingCollection class. 
 *  You display the summary data in an existing row of the AdvancedDataGrid control, 
 *  or display it in a separate row.
 *
 *  <p>The <code>summaries</code> property of the GroupingField or GroupingCollection class takes an 
 *  instance of the SummaryRow class. You then use the <code>fields</code> property 
 *  of the SummaryRow class to specify an Array of one or more SummaryField/SummaryField2 instances
 *  that define the fields of the data used to create the summary.
 *  <code>SummaryField2</code> needs to be used when using <code>GroupingCollection2</code>.</p>
 *
 *  <p>The following example creates summary rows based on two fields of the data provider
 *  of the AdvancedDataGrid control:</p>
 *
 *  <pre>
 *  &lt;mx:AdvancedDataGrid id=&quot;myADG&quot; 
 *    initialize=&quot;gc.refresh();&quot;&gt; 
 *    &lt;mx:dataProvider&gt;
 *      &lt;mx:GroupingCollection id=&quot;gc&quot; source=&quot;{dpFlat}&quot;&gt;
 *        &lt;mx:Grouping&gt;
 *          &lt;mx:GroupingField name=&quot;Region&quot;&gt;
 *            &lt;mx:summaries&gt;
 *              &lt;mx:SummaryRow summaryPlacement=&quot;group&quot;&gt;
 *                &lt;mx:fields&gt;
 *                  &lt;mx:SummaryField dataField=&quot;Actual&quot; 
 *                    label=&quot;Min Actual&quot; operation=&quot;MIN&quot;/&gt;
 *                  &lt;mx:SummaryField dataField=&quot;Actual&quot; 
 *                    label=&quot;Max Actual&quot; operation=&quot;MAX&quot;/&gt;
 *                &lt;/mx:fields&gt;
 *              &lt;/mx:SummaryRow&gt;
 *            &lt;/mx:summaries&gt;
 *          &lt;/mx:GroupingField&gt;
 *          &lt;mx:GroupingField name=&quot;Territory&quot;&gt;
 *            &lt;mx:summaries&gt;
 *              &lt;mx:SummaryRow summaryPlacement=&quot;group&quot;&gt;
 *                &lt;mx:fields&gt;
 *                  &lt;mx:SummaryField dataField=&quot;Actual&quot; 
 *                    label=&quot;Min Actual&quot; operation=&quot;MIN&quot;/&gt;
 *                  &lt;mx:SummaryField dataField=&quot;Actual&quot; 
 *                    label=&quot;Max Actual&quot; operation=&quot;MAX&quot;/&gt;
 *                &lt;/mx:fields&gt;
 *              &lt;/mx:SummaryRow&gt;
 *            &lt;/mx:summaries&gt;
 *          &lt;/mx:GroupingField&gt;
 *        &lt;/mx:Grouping&gt;
 *      &lt;/mx:GroupingCollection&gt;
 *    &lt;/mx:dataProvider&gt; 
 * 
 *    &lt;mx:columns&gt;
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Region&quot;/&gt;
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Territory_Rep&quot;
 *        headerText=&quot;Territory Rep&quot;/&gt;
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Actual&quot;/&gt;
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Estimate&quot;/&gt;
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Min Actual&quot;/&gt;
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Max Actual&quot;/&gt;
 *    &lt;/mx:columns&gt;
 *  &lt;/mx:AdvancedDataGrid&gt;
 *  </pre>
 *
 *  @mxml
 *
 *  The <code>&lt;mx.SummaryRow&gt;</code> tag defines the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:SummaryRow
 *  <b>Properties </b>
 *    fields="<i>No default</i>"
 *    summaryObjectFunction="<i>No default</i>"
 *    summaryPlacement="<i>last</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.collections.GroupingField
 *  @see mx.collections.SummaryField
 *  @see mx.collections.SummaryField2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 *  @royalesuppresspublicvarwarning
 */
public class SummaryRow
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SummaryRow()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  fields
    //----------------------------------
    
    /**
     *  Array of SummaryField/SummaryField2 instances that define the characteristics of the
     *  data fields used to create the summary.
     *
     *  @see mx.collections.SummaryField
	 *  @see mx.collections.SummaryField2
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public var fields:Array;
    
    //----------------------------------
    //  summaryPlacement
    //----------------------------------

    /** 
     *  Specifies where the summary row appears in the AdvancedDataGrid control.
     *  Possible values are:
     *
     *  <ul>
     *    <li><code>"first"</code> - Create a summary row as the first row in the group.</li>
     *    <li><code>"last"</code> - Create a summary row as the last row in the group.</li>
     *    <li><code>"group"</code> - Add the summary data to the row corresponding to the group.</li>
     *  </ul>
     *
     *  <p>You can specify multiple values, separated by a space. 
     *  For example, a value of <code>"last group"</code>  shows the same summary row
     *  at the group level and in the last row of the children.</p>
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public var summaryPlacement:String = "last";
    
    //----------------------------------
    //  summaryObjectFunction
    //----------------------------------
    
    /**
     *  Specifies a callback function that defines the summary object, 
     *  which is an instance of the SummaryObject class. 
     *  The SummaryObject instance collects summary data for display in the 
     *  AdvancedDataGrid control. 
     *  The AdvancedDataGrid control adds the SummaryObject instance to the 
     *  data provider to display the summary data in the control. 
     *  Therefore, define within the SummaryObject instance the properties that you want to display.
     *
     *  <p>You use this property with the <code>SummaryField.summaryFunction</code> property, 
     *  which defines a callback function to perform the summary calculation.</p>
     * 
     *  <p>The GroupingCollection class adds a property called <code>children</code> to the Object.</p>
     *
     *  <p>The callback function must have the following signature:</p>
     *
     *  <pre>function mySumObjFunc():SummaryObject {}</pre>
     *
     *  @see mx.collections.SummaryObject
     *  @see mx.collections.SummaryField#summaryFunction
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public var summaryObjectFunction:Function;
}

}
