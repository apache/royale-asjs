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
package org.apache.royale.collections {
/**
 *  The <code>ISort</code> interface defines the interface for classes that
 *  provide the sorting information required to sort the
 *  data of a collection view.
 *
 *  @see mx.collections.ICollectionView
 *  @see mx.collections.ISortField
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Flex 4.5
 */
public interface ISort {
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  The method used to compare items when sorting.
     *  If you specify this property, Flex ignores any
     *  <code>compareFunction</code> properties that you specify in the
     *  <code>ISortField</code> objects that you use in this class.
     *
     *  <p>The compare function must have the following signature:</p>
     *
     *  <pre><code>
     *
     *     function [name](a:Object, b:Object, fields:Array = null):int
     *
     *  </code></pre>
     *
     *  <p>This function must return the following value:
     *  <ul>
     *        <li>-1, if the <code>Object a</code> should appear before the
     *        <code>Object b</code> in the sorted sequence</li>
     *        <li>0, if the <code>Object a</code> equals the
     *        <code>Object b</code></li>
     *        <li>1, if the <code>Object a</code> should appear after the
     *        <code>Object b</code> in the sorted sequence</li>
     *  </ul></p>
     *  <p>To return to the internal comparision function, set this value to
     *  <code>null</code>.</p>
     *  <p>
     *  The <code>fields</code> array specifies the object fields
     *  to compare.
     *  Typically the algorithm will compare properties until the field list is
     *  exhausted or a non-zero value can be returned.
     *  For example:</p>
     *
     *  <pre><code>
     *    function myCompare(a:Object, b:Object, fields:Array = null):int
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
     *    }
     *  </code></pre>
     *
     *  <p>The default value is an internal compare function that can perform
     *  a string, numeric, or date comparison in ascending or descending order.
     *  Specify your own function only if you need a need a custom
     *  comparison algorithm. This is normally only the case if a calculated
     *  field is used in a display.</p>
     *
     *  <p>Alternatively you can specify separate compare functions for each
     *  sort field by using the <code>ISortField</code> class
     *  <code>compareFunction</code> property; This way you can use the default
     *  comparison for some fields and a custom comparison for others.</p>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */
    function get compareFunction():Function;

    /**
     *  @deprecated A future release of Apache Flex SDK will remove this function. Please use the constructor
     *  argument instead.
     */
    function set compareFunction(value:Function):void;

    /**
     *  An <code>Array</code> of <code>ISortField</code> objects that
     *  specifies the fields to compare.
     *  The order of the ISortField objects in the array determines
     *  field priority order when sorting.
     *  The default sort comparator checks the sort fields in array
     *  order until it determinines a sort order for the two
     *  fields being compared.
     *
     *  @default null
     *
     *  @see org.apache.royale.collections.ISortField
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */
    function get fields():Array;

    /**
     *  @deprecated A future release of Apache Flex SDK will remove this function. Please use the constructor
     *  argument instead.
     */
    function set fields(value:Array):void;

    /**
     *  Indicates if the sort should be unique.
     *  Unique sorts fail if any value or combined value specified by the
     *  fields listed in the fields property result in an indeterminate or
     *  non-unique sort order; that is, if two or more items have identical
     *  sort field values. An error is thrown if the sort is not unique.
     *  The sorting logic uses this <code>unique</code> property value only if sort
     *  field(s) are specified explicitly. If no sort fields are specified
     *  explicitly, no error is thrown even when there are identical value
     *  elements.
     *
     *  @default false
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */
    function get unique():Boolean;


    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Finds the specified object within the specified array (or the insertion
     *  point if asked for), returning the index if found or -1 if not.
     *  The <code>ListCollectionView</code> class <code>find<i>xxx</i>()</code>
     *  methods use this method to find the requested item; as a general rule,
     *  it is easier to use these functions, and not <code>findItem()</code>
     *  to find data in <code>ListCollectionView</code>-based objects.
     *  You call the <code>findItem()</code> method directly when writing a
     *  class that supports sorting, such as a new <code>ICollectionView</code>
     *  implementation.
     *  The input items array need to be sorted before calling this function.
     *  Otherwise this function will not be able to find the specified value
     *  properly.
     *
     *  @param items the Array within which to search.
     *  @param values Object containing the properties to look for (or
     *                the object to search for, itself).
     *                The object must consist of field name/value pairs, where
     *                the field names are names of fields specified by the
     *                <code>fields</code> property, in the same order they
     *                are used in that property.
     *                You do not have to specify all of the fields from the
     *                <code>fields</code> property, but you
     *                cannot skip any in the order.
     *                Therefore, if the <code>fields</code>
     *                properity lists three fields, you can specify its first
     *                and second fields in this parameter, but you cannot
     *                specify  only the first and third fields.
     *  @param mode String containing the type of find to perform.
     *           Valid values are:
     *             <table>
     *               <tr>
     *                 <th>ANY_INDEX_MODE</th>
     *                 <th>Return any position that
     *                   is valid for the values.</th>
     *               </tr>
     *               <tr>
     *                 <th>FIRST_INDEX_MODE</th>
     *                 <th>Return the position
     *                   where the first occurrance of the values is found.</th>
     *               </tr>
     *               <tr>
     *                 <th>LAST_INDEX_MODE</th>
     *                 <th>Return the position where the
     *                   last ocurrance of the specified values is found.
     *                 </th>
     *               </tr>
     *               </table>
     *  @param returnInsertionIndex If the method does not find an item
     *                     identified by the <code>values</code> parameter,
     *                     and this parameter is <code>true</code> the
     *                     <code>findItem()</code>
     *                     method returns the insertion point for the values,
     *                     that is the point in the sorted order where you
     *                     should insert the item.
     *  @param compareFunction a comparator function to use to find the item.
     *                 If you do not specify this parameter or , or if you
     *                 provide a <code>null</code> value,
     *                 <code>findItem()</code> function uses the
     *                 compare function determined by the <code>ISort</code>
     *                 instance's <code>compareFunction</code> property,
     *                 passing in the array of fields determined
     *                 by the values object and the current
     *                 <code>SortFields</code>.
     *
     *                 If you provide a non-null value, <code>findItem()</code>
     *                 function uses it as the compare function.
     *
     *                 The signature of the function passed as
     *                 <code>compareFunction</code> must be as follows:
     *                 <code>function myCompareFunction(a:Object, b:Object):int</code>.
     *                 Note that there is no third argument unlike the
     *                 compare function for <code>ISort.compareFunction()</code>
     *                 property.
     *  @return int The index in the array of the found item.
     *                If the <code>returnInsertionIndex</code> parameter is
     *              <code>false</code> and the item is not found, returns -1.
     *                If the <code>returnInsertionIndex</code> parameter is
     *              <code>true</code> and the item is not found, returns
     *                the index of the point in the sorted array where the
     *                values would be inserted.
     *
     *  @throws SortError If there are any parameter errors,
     *          the find critieria is not compatible with the sort
     *          or the comparator function for the sort can not be determined.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */
    function findItem(
            items:Array,
            values:Object,
            mode:String,
            returnInsertionIndex:Boolean = false,
            compareFunction:Function = null):int;

    /**
     *  Return whether the specified property is used to control the sort.
     *  The function cannot determine a definitive answer if the sort uses a
     *  custom comparator; it always returns <code>true</code> in this case.
     *
     *  @param property The name of the field to test.
     *  @return Whether the property value might affect the sort outcome.
     *  If the sort uses the default compareFunction, returns
     *  <code>true</code> if the
     *  <code>property</code> parameter specifies a sort field.
     *  If the sort or any <code>ISortField</code> uses a custom comparator,
     *  there's no way to know, so return <code>true</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */
    function propertyAffectsSort(property:String):Boolean;

    /**
     *  Goes through the <code>fields</code> array and calls
     *  <code>reverse()</code> on each of the <code>ISortField</code> objects in
     *  the array. If the field was descending now it is ascending,
     *  and vice versa.
     *
     *  <p>Note: an <code>ICollectionView</code> does not automatically
     *  update when the objects in the <code>fields</code> array are modified;
     *  call its <code>refresh()</code> method to update the view.</p>
     *
     *  <p>Note: a future release of Apache Flex SDK will change the signature
     *  of this function to return a reversed clone of this Sort instance. See
     *  FLEX-34853.</p>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */
    function reverse():void;

    /**
     *  Apply the current sort to the specified array (not a copy).
     *  To prevent the array from being modified, create a copy
     *  use the copy in the <code>items</code> parameter.
     *
     *  <p>Flex <code>ICollectionView</code> implementations call the
     *  <code>sort</code> method automatically and ensure that the sort is
     *  performed on a copy of the underlying data.</p>
     *
     *  @param items Array of items to sort.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */
    function sort(items:Array):void;
}
}
