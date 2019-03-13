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

/**
 *  The SummaryField2 class represents a single property in a SummaryRow instance.
 *  Each SummaryRow instance specifies one or more SummayField2 instances 
 *  that are used to create a data summary. 
 *
 *  <p><b>Note: </b>In the previous release of Flex, you used the SummaryField class 
 *  to create summary data. 
 *  The SummaryField2 class is new for Flex 4 and provides better performance than SummaryField.</p>
 * 
 *  <p>Use the <code>dataField</code> property to specify the data field used to generate the summary, 
 *  the <code>label</code> property to specify the name of the data field created to hold the summary data, 
 *  and the <code>summaryOperation</code> property to specify how to create the summary for numeric fields. 
 *  You can specify one of the following values:  
 *  <code>SUM</code>, <code>MIN</code>, <code>MAX</code>, <code>AVG</code>, or <code>COUNT</code>.</p>
 *  Or you can specify an ISummaryCalculator implementation to calculate the summaries.
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
 *                  &lt;mx:SummaryField2 dataField=&quot;Actual&quot; 
 *                    label=&quot;Min Actual&quot; summaryOperation=&quot;MIN&quot;/&gt;
 *                  &lt;mx:SummaryField2 dataField=&quot;Actual&quot; 
 *                    label=&quot;Max Actual&quot; summaryOperation=&quot;MAX&quot;/&gt;
 *                &lt;/mx:fields&gt;
 *              &lt;/mx:SummaryRow&gt;
 *            &lt;/mx:summaries&gt;
 *          &lt;/mx:GroupingField&gt;
 *          &lt;mx:GroupingField name=&quot;Territory&quot;&gt;
 *            &lt;mx:summaries&gt;
 *              &lt;mx:SummaryRow summaryPlacement=&quot;group&quot;&gt;
 *                &lt;mx:fields&gt;
 *                  &lt;mx:SummaryField2 dataField=&quot;Actual&quot; 
 *                    label=&quot;Min Actual&quot; summaryOperation=&quot;MIN&quot;/&gt;
 *                  &lt;mx:SummaryField2 dataField=&quot;Actual&quot; 
 *                    label=&quot;Max Actual&quot; summaryOperation=&quot;MAX&quot;/&gt;
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
 *  The <code>&lt;mx.SummaryField2&gt;</code> inherits all the tag attributes of its superclass, 
 *  and defines the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:SummaryField2
 *  <b>Properties </b>
 *    dataField="<i>No default</i>"
 *    label="<i>No default</i>"
 *    summaryOperation="<i>SUM</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.collections.GroupingField
 *  @see mx.collections.SummaryRow
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 *  @royalesuppresspublicvarwarning
 */
public class SummaryField2
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
     *  @param dataField Data field for which the summary is computed.
     *
     *  @param summaryOperation The function that should be performed on the children.
     *  You can specify one of the following values for numeric fields: 
     *  <code>SUM</code>, <code>MIN</code>, <code>MAX</code>, <code>AVG</code>, or <code>COUNT</code>.
     *  Or you can specify an ISummaryCalculator implementation to calculate the summaries. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function SummaryField2(dataField:String = null, summaryOperation:Object = "SUM")
    {
        super();
        
        this.dataField = dataField;
        this.summaryOperation = summaryOperation;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  dataField
    //----------------------------------
    
    /**
     * Data field for which the summary is computed.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var dataField:String;
    
    //----------------------------------
    //  label
    //----------------------------------
    
    /**
     *  The property used inside the summary object, 
     *  an instance of the SummaryObject class, to
     *  hold summary information.
     * 
     *  <p>For example, if you set the <code>label</code> property to "Summary",
     *  then the computed summary is placed in a property named "Summary" 
     *  in the summary object. The property of the SummaryObject instance 
     *  containing the summary data will appear as below:</p>
     *
     *  <pre>{Summary:1000}</pre>
     *
     *  @see mx.collections.SummaryObject
     *  @see mx.collections.SummaryRow#summaryObjectFunction
     *  @see #summaryFunction
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */  
    public var label:String;
     
     /**
      *  The summary performed on the children.
      *  The value of this property can be one of the following:
      *  
      *  <ul>
      *    <li>For numeric fields: <code>SUM</code>, <code>MIN</code>, 
      *       <code>MAX</code>, <code>AVG</code>, or <code>COUNT</code>.</li>
      *    <li>An instance of a class that implements the custom ISummaryCalculator interface 
      *       to calculate a custom summary.</li>
      *  </ul>
      *   
      *  @default SUM
      *  @see mx.collections.ISummaryCalculator
      * 
      *  @langversion 3.0
      *  @playerversion Flash 10
      *  @playerversion AIR 1.5
      *  @productversion Flex 4 
      */  
    public var summaryOperation:Object = "SUM";
}

}
