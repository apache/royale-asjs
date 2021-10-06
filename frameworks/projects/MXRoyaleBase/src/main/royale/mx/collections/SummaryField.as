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
 *  The SummaryField class represents a single property in a SummaryRow instance.
 *  Each SummaryRow instance specifies one or more SummayField instances 
 *  that are used to create a data summary. 
 * 
 *  <p>Use the <code>dataField</code> property to specify the data field used to generate the summary, 
 *  the <code>label</code> property to specify the name of the data field created to hold the summary data, 
 *  and the <code>operation</code> property to specify how to create the summary for numeric fields. 
 *  You can specify one of the following values:  
 *  <code>SUM</code>, <code>MIN</code>, <code>MAX</code>, <code>AVG</code>, or <code>COUNT</code>.</p>
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
 *  <p>This Class has been deprecated and replaced by a new Class
 *  <code>SummaryField2</code>.
 *  Properties <code>operation</code> and <code>summaryFunction</code> are 
 *  not present in the Class <code>SummaryField2</code>. 
 *  A new property <code>summaryOperation</code> is introduced in 
 *  <code>SummaryField2</code>.</p>
 *
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.collections.GroupingField
 *  @see mx.collections.SummaryRow
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 *  @royalesuppresspublicvarwarning
 */
//[Deprecated(replacement="SummaryField2", since="4.0")]

public class SummaryField
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
     *  @param operation The function that should be performed on the children.
     *  You can specify one of the following values for numeric fields: 
     *  <code>SUM</code>, <code>MIN</code>, <code>MAX</code>, <code>AVG</code>, or <code>COUNT</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SummaryField(dataField:String = null, operation:String = "SUM")
    {
        super();
        
        this.dataField = dataField;
        this.operation = operation;
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public var label:String;
    
    //----------------------------------
    //  operation
    //----------------------------------
  
    /**
     *  The function that should be performed on the children.
     * 
     *  You can specify one of the following values for numeric fields: 
     *  <code>SUM</code>, <code>MIN</code>, <code>MAX</code>, <code>AVG</code>, or <code>COUNT</code>.
     * 
     *  @default SUM
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public var operation:String = "SUM";
    
    //----------------------------------
    //  summaryFunction
    //----------------------------------
  
    /**
     *  Specifies a callback function to compute a custom data summary.
     *
     *  <p>You use this property with the <code>SummaryRow.summaryObjectFunction</code> property, 
     *  which defines an instance of the SummaryObject class used  
     *  to collect summary data for display in the  AdvancedDataGrid control.</p>
     * 
     *  <p>The function signature should be as follows:</p>
     *
     *  <pre>
     *  function mySummaryFunction(iterator:IViewCursor, dataField:String, operation:String):Object</pre>
     * 
     *  <p>The built-in summary functions for <code>SUM</code>, <code>MIN</code>, 
     *  <code>MAX</code>, <code>AVG</code>, and <code>COUNT</code> all return a Number containing
     *  the summary data. </p>
     *
     *  @see mx.collections.SummaryObject
     *  @see mx.collections.SummaryRow#summaryObjectFunction
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     public var summaryFunction:Function;
}

}
