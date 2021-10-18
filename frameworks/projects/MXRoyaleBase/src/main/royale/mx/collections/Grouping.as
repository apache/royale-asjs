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
 *  The Grouping class defines the fields in the data provider of 
 *  the AdvancedDataGrid control used to group data. You use this 
 *  class to create groups when the input data to the AdvancedDataGrid control 
 *  has a flat structure.
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
 *  The <code>&lt;mx.Grouping&gt;</code> tag defines the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Grouping
 *  <b>Properties </b>
 *    compareFunction="<i>No default</i>"
 *    fields="null"
 *    groupingObjectFunction="<i>No default</i>"
 *    label="GroupLabel"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.collections.GroupingCollection
 *  @see mx.collections.GroupingField
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 *  @royalesuppresspublicvarwarning
 */
public class Grouping
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
    public function Grouping():void
    {
        super();
    }    
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //---------------------------------
    //  label
    //---------------------------------
    
    /**
     *  The name of the field added to the flat data 
     *  to create the hierarchy.
     *  The value of the top nodes (nodes representing the group fields)
     *  in every group will be represented 
     *  by this property.
     *  Use this property to specify a different name.
     * 
     *  @default GroupLabel
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public var label:String = "GroupLabel";
    
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
     *  The method used to compare items when sorting.
     *  If you specify this property, Flex ignores any <code>compareFunction</code> 
     *  properties that you specify in the SortField objects that you
     *  use in this class.
     * 
     *  <p>The compare function must have the following signature:</p>
     *  <pre>
     *     function [name](a:Object, b:Object, fields:Array=null):int</pre>
     * 
     *  <p>This function must return the following:</p>
     *  <ul>
     *        <li>-1, if <code>a</code> should appear before <code>b</code> in
     *        the sorted sequence.</li>
     *        <li>0, if <code>a</code> equals <code>b</code>.</li>
     *        <li>1, if <code>a</code> should appear after <code>b</code> in the
     *        sorted sequence.</li>
     *  </ul>
     * 
     *  <p>To return to the internal comparison function, set this value to
     *  <code>null</code>.</p>
     *
     * <p>The <code>fields</code> Array specifies the object fields
     *  to compare.
     *  Typically, the algorithm will compare properties until the field list is
     *  exhausted or a non-zero value can be returned.
     *  For example:</p>
     * 
     *  <pre>
     *    function myCompare(a:Object, b:Object, fields:Array=null):int
     *    {
     *        var result:int = 0;
     *        var i:int = 0;
     *        var propList:Array = fields ? fields : internalPropList;
     *        var len:int = propList.length;
     *        var propName:String;
     *        while (result == 0 &amp;&amp; (i &lt; len))
     *        {
     *            propName = propList[i];
     *            result = compareValues(a[propName], b[propName]);
     *            i++;
     *        }
     *        return result;
     *    }
     *
     *    function compareValues(a:Object, b:Object):int
     *    {
     *        if (a == null &amp;&amp; b == null)
     *            return 0;
     *
     *        if (a == null)
     *          return 1;
     *
     *        if (b == null)
     *           return -1;
     *
     *        if (a &lt; b)
     *            return -1;
     *
     *        if (a &gt; b)
     *            return 1;
     *
     *        return 0;
     *    }</pre>
     *
     *  <p>The default value is an internal compare function that can perform 
     *  a string, numeric, or date comparison in ascending or descending order, 
     *  with case-sensitive or case-insensitive string comparisons.
     *  Specify your own function only if you need a custom comparison algorithm.
     *  This is normally only the case if a calculated field is used in a display.</p>
     * 
     *  <p>Alternatively, you can specify separate compare functions for each sort
     *  field by using the SortField class <code>compare</code> property.
     *  This way you can use the default comparison for some fields and a custom
     *  comparison for others.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get compareFunction():Function
    {
        return _compareFunction;
    }

    /**
     *  @private
     */
    public function set compareFunction(value:Function):void
    {
        _compareFunction = value;
    }

    //----------------------------------
    //  fields
    //----------------------------------

    /**
     *  @private
     *  Storage for the fields property.
     */
    private var _fields:Array;
    
    [Inspectable(category="General", arrayType="mx.collections.GroupingField")]
    
    /**
     *  An Array of GroupingField objects that specifies the fields 
     *  used to group the data.
     *  The order of the GroupingField objects in the Array determines
     *  field priority order when sorting.
     *
     *  @default null
     * 
     *  @see GroupingField
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get fields():Array
    {
        return _fields;
    }

    /**
     *  @private
     */
    public function set fields(value:Array):void
    {
        _fields = value;
    }
    
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
     *  The function returns an Object which will be used for group nodes. </p>
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
     *  @productversion Flex 3
     */
    public var groupingObjectFunction:Function;
}


}
