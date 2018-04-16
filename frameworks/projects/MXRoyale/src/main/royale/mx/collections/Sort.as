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

  /* 
    import flash.events.Event;
    import flash.events.EventDispatcher; */
	
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

    import mx.collections.errors.SortError;
    import mx.core.mx_internal;
  /*   import mx.resources.IResourceManager;
    import mx.resources.ResourceManager */;
    import mx.utils.ObjectUtil;

    use namespace mx_internal;
 
    [DefaultProperty("fields")]
[ResourceBundle("collections")] 
/* [Alternative(replacement="spark.collections.Sort", since="4.5")]
 */
/**
 *  Provides the sorting information required to establish a sort on an
 *  existing view (<code>ICollectionView</code> interface or class that
 *  implements the interface). After you assign a <code>Sort</code> instance to the view's
 *  <code>sort</code> property, you must call the view's
 *  <code>refresh()</code> method to apply the sort criteria.
 *
 *  <p>Typically the sort is defined for collections of complex items, that is
 *  collections in which the sort is performed on one or more properties of 
 *  the objects in the collection.
 *  The following example shows this use:</p>
 *  <pre><code>
 *     var col:ICollectionView = new ArrayCollection();
 *     // In the real world, the collection would have more than one item.
 *     col.addItem({first:"Anders", last:"Dickerson"});
 *
 *     // Create the Sort instance.
 *     var sort:ISort = new Sort();
 *
 *     // Set the sort field; sort on the last name first, first name second.
 *     // Both fields are case-insensitive.
 *     sort.fields = [new SortField("last",true), new SortField("first",true)];
 *       // Assign the Sort object to the view.
 *     col.sort = sort;
 *
 *     // Apply the sort to the collection.
 *     col.refresh();
 *  </code></pre>
 *
 *  <p>There are situations in which the collection contains simple items, 
 *  like <code>String</code>, <code>Date</code>, <code>Boolean</code>, etc.
 *  In this case, apply the sort to the simple type directly.
 *  When constructing a sort for simple items, use a single sort field,
 *  and specify a <code>null</code> <code>name</code> (first) parameter
 *  in the SortField object constructor.
 *  For example:
 *  <pre><code>
 *     var col:ICollectionView = new ArrayCollection();
 *     col.addItem("California");
 *     col.addItem("Arizona");
 *     var sort:Sort = new Sort();
 *
 *     // There is only one sort field, so use a <code>null</code>
 *     // first parameter.
 *     sort.fields = [new SortField(null, true)];
 *     col.sort = sort;
 *     col.refresh();
 *  </code></pre>
 *  </p>
 *
 *  <p>The Flex implementations of the <code>ICollectionView</code> interface
 *  retrieve all items from a remote location before executing a sort.
 *  If you use paging with a sorted list, apply the sort to the remote
 *  collection before you retrieve the data.
 *  </p>
 *
 *  <p>By default this Sort class does not provide correct language specific
 *  sorting for strings.  For this type of sorting please see the 
 *  <code>spark.collections.Sort</code> and 
 *  <code>spark.collections.SortField</code> classes.</p>
 *
 *  Note: to prevent problems like
 *  <a href="https://issues.apache.org/jira/browse/FLEX-34853">FLEX-34853</a>
 *  it is recommended to use SortField
 *  instances as immutable objects (by not changing their state).
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Sort&gt;</code> tag has the following attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Sort
 *  <b>Properties</b>
 *  compareFunction="<em>Internal compare function</em>"
 *  fields="null"
 *  unique="false | true"
 *  /&gt;
 *  </pre>
 *
 *  <p>In case items have inconsistent data types or items have complex data 
 *  types, the use of the default built-in compare functions is not recommended.
 *  Inconsistent sorting results may occur in such cases. To avoid such problem,
 *  provide a custom compare function and/or make the item types consistent.</p>
 *
 *  <p>Just like any other <code>AdvancedStyleClient</code>-based classes, 
 *  the <code>Sort</code> and <code>SortField</code> classes do not have a 
 *  parent-child relationship in terms of event handling. Locale changes in a 
 *  <code>Sort</code> instance are not dispatched to its <code>SortField</code> 
 *  instances automatically. The only exceptional case is the internal default 
 *  <code>SortField</code> instance used when no explicit fields are provided.
 *  In this case, the internal default <code>SortField</code> instance follows 
 *  the locale style that the owner <code>Sort</code> instance has.</p>
 *
 *  @see mx.collections.ICollectionView
 *  @see ISortField
 *  @see spark.collections.Sort
 *  @see spark.collections.SortField
 * 
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 *  @royalesuppresspublicvarwarning
 */
public class Sort extends EventDispatcher 
{
  
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  <p>Creates a new Sort with no fields set and no custom comparator.</p>
     *
     *  @param fields An <code>Array</code> of <code>ISortField</code> objects that
     *  specifies the fields to compare.
     *  @param customCompareFunction Use a custom function to compare the
     *  objects in the collection to which this sort will be applied.
     *  @param unique Indicates if the sort should be unique.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function Sort(fields:Array = null, customCompareFunction:Function = null, unique:Boolean = false)
    {
        super();

        this.fields = fields;
       
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------


    //----------------------------------
    //  fields
    //----------------------------------

    /**
     *  @private
     *  Storage for the fields property.
     */
    private var _fields:Array;

     [Inspectable(category="General", arrayType="mx.collections.ISortField")]
    [Bindable("fieldsChanged")]
 
    /**
     *  @inheritDoc
     *
     *  @default null
     *
     *  @see SortField
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

        dispatchEvent(new Event("fieldsChanged")); 
    }

}
}
