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

[DefaultProperty("summaries")]

/**
 *  The GroupingField class represents individual data fields 
 *  that you use to group flat data for display by the AdvancedDataGrid control. 
 *
 *  <p>To populate the AdvancedDataGrid control with grouped data, 
 *  you create an instance of the GroupingCollection class from your flat data, 
 *  and then pass that GroupingCollection instance to the data provider 
 *  of the AdvancedDataGrid control. 
 *  To specify the grouping fields of your flat data, 
 *  you pass a Grouping instance to 
 *  the <code>GroupingCollection.grouping</code> property. 
 *  The Grouping instance contains an Array of GroupingField instances, 
 *  one per grouping field. </p>
 *
 *  <p>The following example uses the Grouping class to define
 *  two grouping fields: Region and Territory.</p>
 *
 *  <pre>
 *  &lt;mx:AdvancedDataGrid id=&quot;myADG&quot;    
 *    &lt;mx:dataProvider&gt; 
 *      &lt;mx:GroupingCollection id=&quot;gc&quot; source=&quot;{dpFlat}&quot;&gt; 
 *        &lt;mx:grouping&gt; 
 *          &lt;mx:Grouping&gt; 
 *            &lt;mx:GroupingField name=&quot;Region&quot;/&gt; 
 *            &lt;mx:GroupingField name=&quot;Territory&quot;/&gt; 
 *          &lt;/mx:Grouping&gt; 
 *        &lt;/mx:grouping&gt; 
 *      &lt;/mx:GroupingCollection&gt; 
 *    &lt;/mx:dataProvider&gt;  
 *     
 *    &lt;mx:columns&gt; 
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Region&quot;/&gt; 
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Territory&quot;/&gt; 
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Territory_Rep&quot;/&gt; 
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Actual&quot;/&gt; 
 *      &lt;mx:AdvancedDataGridColumn dataField=&quot;Estimate&quot;/&gt; 
 *    &lt;/mx:columns&gt; 
 *  &lt;/mx:AdvancedDataGrid&gt;
 *  </pre>
 *
 *  @mxml
 *
 *  The <code>&lt;mx.GroupingField&gt;</code> inherits all the tag attributes of its superclass, 
 *  and defines the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:GroupingField
 *  <b>Properties </b>
 *    caseInsensitive="false|true"
 *    compareFunction="<i>No default</i>"
 *    descending="false|true"
 *    groupingFunction="<i>No default</i>"
 *    groupingObjectFunction="<i>No default</i>"
 *    name="null"
 *    numeric="false|true"
 *    summaries="<i>No default</i>"
 *  /&gt;
 *  </pre>
 * 
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.collections.GroupingCollection
 *  @see mx.collections.Grouping
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
public class GroupingField
{
/*     include "../core/Version.as";
 */
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param name The name of the property that this field uses for
     *              comparison.
     *              If the object is a simple type, pass <code>null</code>.
     *  @param caseInsensitive When sorting strings, tells the comparitor
     *              whether to ignore the case of the values.
     *  @param descending Tells the comparator whether to arrange items in
     *              descending order.
     *  @param numeric Tells the comparitor whether to compare sort items as
     *              numbers, instead of alphabetically.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function GroupingField(name:String=null,
                                caseInsensitive:Boolean=false,
                                descending:Boolean=false,
                                numeric:Boolean=false)
    {
        super();

        _name = name;
        _caseInsensitive = caseInsensitive;
        _descending = descending;
        _numeric = numeric;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //---------------------------------
    //  caseInsensitive
    //---------------------------------

    /**
     *  @private
     *  Storage for the caseInsensitive property.
     */
    private var _caseInsensitive:Boolean;

    [Inspectable(category="General")]
    /**
     *  Set to <code>true</code> if the sort for this field should be case-insensitive.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get caseInsensitive():Boolean
    {
        return _caseInsensitive;
    }

    /**
     *  @private
     */
    public function set caseInsensitive(value:Boolean):void
    {
        if (value != _caseInsensitive)
        {
            _caseInsensitive = value;
        }
    }

    //---------------------------------
    //  compareFunction
    //---------------------------------

    /**
     *  @private
     *  Storage for the compareFunction property.
     */
    private var _compareFunction:Function;

    [Inspectable(category="General")]
    /**
     *  The function that compares two items during a sort of items for the
     *  associated collection. If you specify a <code>compareFunction</code>
     *  property in a Grouping object, Flex ignores any <code>compareFunction</code>
     *  properties of the GroupingField objects.
     *
     *  <p>The compare function must have the following signature:</p>
     *
     *  <pre>function myCompare(a:Object, b:Object):int</pre>
     *
     *  <p>This function must return the following values:</p>
     *   <ul>
     *        <li>-1, if <code>a</code> should appear before <code>b</code> in
     *        the sorted sequence.</li>
     *        <li>0, if <code>a</code> equals <code>b</code>.</li>
     *        <li>1, if <code>a</code> should appear after <code>b</code> in the
     *        sorted sequence.</li>
     *  </ul>
     *
     *  <p>The default value is an internal compare function that can perform 
     *  a string, numeric, or date comparison in ascending or descending order, 
     *  with case-sensitive or case-insensitive string comparisons.
     *  Specify your own function only if you need a custom comparison algorithm.
     *  This is normally only the case if a calculated field is used in a display.</p>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get compareFunction():Function
    {
        return _compareFunction;
    }

    /**
     *  @private
     */
    public function set compareFunction(c:Function):void
    {
        _compareFunction = c;
    }
    
    //---------------------------------
    //  descending
    //---------------------------------
    
    /**
     *  @private
     *  Storage for the descending property.
     */
    private var _descending:Boolean;

    [Inspectable(category="General")]

    /**
     *  Set to <code>true</code> if the sort for this field should be 
     *  in descending order.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get descending():Boolean
    {
        return _descending;
    }

    /**
     *  @private
     */
    public function set descending(value:Boolean):void
    {
        if (_descending != value)
        {
            _descending = value;
        }
    }

    //---------------------------------
    //  name
    //---------------------------------

    /**
     *  @private
     *  Storage for the name property.
     */
    private var _name:String;

    [Inspectable(category="General")]

    /**
     *  The name of the field to be sorted.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get name():String
    {
        return _name;
    }

    /**
     *  @private
     */
    public function set name(n:String):void
    {
        _name = n;
    }

    //---------------------------------
    //  numeric
    //---------------------------------

    /**
     *  @private
     *  Storage for the numeric property.
     */
    private var _numeric:Boolean;

    [Inspectable(category="General")]
    /**
     *  Specifies that if the field being sorted contains numeric
     *  (Number/int/uint) values, or String representations of numeric values, 
     *  the comparitor uses a numeric comparison.
     *  If this property is <code>false</code>, fields with String representations
     *  of numbers are sorted using String comparison, so 100 precedes 99, 
     *  because "1" is a lower string value than "9".
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get numeric():Boolean
    {
        return _numeric;
    }
    
    /**
     *  @private
     */
    public function set numeric(value:Boolean):void
    {
        if (_numeric != value)
        {
            _numeric = value;
        }
    }
    
    //---------------------------------
    //  groupingFunction
    //---------------------------------
    
    /**
     *  A function that determines the label for this group.  
     *  By default,
     *  the group displays the text for the field in the data that matches the
     *  filed specified by the <code>name</code> property.  
     *  However, sometimes you want to group the items based on
     *  more than one field in the data, or group based on something that is
     *  not a simple String field.
     *  In such a case, you specify a callback function by using 
     *  the <code>groupingFunction</code> property.
     *
     *  <p>A callback function might convert a number for the month into 
     *  the String for the month, or group multiple items into a single group
     *  based on some criteria other than the actual value of the field.</p>
     *
     *  <p>For the GroupField, the method signature has the following form:</p>
     *
     *  <pre>groupingFunction(item:Object, field:GroupField):String</pre>
     *
     *  <p>Where <code>item</code> contains the data item object, and
     *  <code>field</code> contains the GroupField object.</p>
     * 
     *  For example, a <code>groupingFunction</code> which returns the
     *  first character as the group name can be written as - 
     *  <pre>
     *  private function groupFunc(item:Object, field:GroupingField):String
     *  {
     *      return item[field.name].toString().substr(0, 1);
     *  }
     *  </pre>
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var groupingFunction:Function;
    
    //---------------------------------
    //  groupingObjectFunction
    //---------------------------------
    
    /**
     *  A callback function to run on each group node to determine the 
     *  grouping object.  
     *  By default, a new Object will be created for group nodes.
     *
     *  <p>You can supply a <code>groupingObjectFunction</code> that provides the 
     *  appropriate Object for group nodes.</p>
     *
     *  <p>The method signature is:</p>
     *  <pre>
     *  myGroupObjectFunction(label:String):Object</pre>
     * 
     *  <p>Where <code>label</code> contains the value that will be
     *  shown for that group node. 
     *  The function returns an Object that will be used for group nodes. </p>
     * 
     *  For example, a <code>groupingObjectFunction</code> which returns an Object
     *  containing a "name" property with value as "Bob" can be written as - 
     *  <pre>
     *  private function groupObjFunction(label:String):Object
     *  {
     *      var obj:Object = {};
     *      obj.name = "Bob";
     *
     *      return obj;
     *  }
     *  </pre>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var groupingObjectFunction:Function;
    
    //---------------------------------
    //  summaries
    //---------------------------------
    
    /**
     *  Array of SummaryRow instances that define the group-level summaries.
     *  Specify one or more SummaryRow instances to define the data summaries, 
     *  as the following example shows:
     *
     *  <pre>
     *  &lt;mx:AdvancedDataGrid id="myADG" 
     *     width="100%" height="100%" 
     *     initialize="gc.refresh();"&gt;        
     *     &lt;mx:dataProvider&gt;
     *         &lt;mx:GroupingCollection id="gc" source="{dpFlat}"&gt;
     *             &lt;mx:Grouping&gt;
     *                 &lt;mx:GroupingField name="Region"&gt;
     *                   &lt;mx:summaries&gt;
     *                       &lt;mx:SummaryRow summaryPlacement="group"&gt;
     *                         &lt;mx:fields&gt;
     *                             &lt;mx:SummaryField dataField="Actual" 
     *                                 label="Min Actual" operation="MIN"/&gt;
     *                             &lt;mx:SummaryField dataField="Actual" 
     *                                 label="Max Actual" operation="MAX"/&gt;
     *                         &lt;/mx:fields&gt;
     *                       &lt;/mx:SummaryRow&gt;
     *                     &lt;/mx:summaries&gt;
     *                 &lt;/mx:GroupingField&gt;
     *             &lt;/mx:Grouping&gt;
     *         &lt;/mx:GroupingCollection&gt;
     *     &lt;/mx:dataProvider&gt;        
     *     
     *     &lt;mx:columns&gt;
     *         &lt;mx:AdvancedDataGridColumn dataField="Region"/&gt;
     *         &lt;mx:AdvancedDataGridColumn dataField="Territory_Rep"
     *             headerText="Territory Rep"/&gt;
     *         &lt;mx:AdvancedDataGridColumn dataField="Actual"/&gt;
     *         &lt;mx:AdvancedDataGridColumn dataField="Estimate"/&gt;
     *         &lt;mx:AdvancedDataGridColumn dataField="Min Actual"/&gt;
     *         &lt;mx:AdvancedDataGridColumn dataField="Max Actual"/&gt;
     *     &lt;/mx:columns&gt;
     *  &lt;/mx:AdvancedDataGrid&gt;  
     *  </pre>
     *
     *  @see mx.collections.SummaryRow
     *  @see mx.collections.SummaryField
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var summaries:Array;
}

}
