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

public interface IArrayListView extends ICollectionView {


    //----------------------------------
    //  filterFunction
    //----------------------------------

    /**
     *  A function that the view will use to eliminate items that do not
     *  match the function's criteria.
     *  A filterFunction is expected to have the following signature:
     *
     *  <pre>f(item:Object):Boolean</pre>
     *
     *  where the return value is <code>true</code> if the specified item
     *  should remain in the view.
     *
     *  <p>If a filter is unsupported, Flex throws an error when accessing
     *  this property.
     *  You must call <code>refresh()</code> after setting the
     *  <code>filterFunction</code> property for the view to update.</p>
     *
     *  <p>Note: The Flex implementations of ICollectionView retrieve all
     *  items from a remote location before executing the filter function.
     *  If you use paging, apply the filter to the remote collection before
     *  you retrieve the data.</p>
     *
     *  @see #refresh()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    function get filterFunction():Function;

    /**
     *  @private
     */
    function set filterFunction(value:Function):void;


    //----------------------------------
    //  sort
    //----------------------------------

    /**
     *  The ISort that will be applied to the ICollectionView.
     *  Setting the sort does not automatically refresh the view,
     *  so you must call the <code>refresh()</code> method
     *  after setting this property.
     *  If sort is unsupported an error will be thrown when accessing
     *  this property.
     *
     *  <p>Note: The Flex implementations of ICollectionView retrieve all
     *  items from a remote location before executing a sort.
     *  If you use paging with a sorted list, apply the sort to the remote
     *  collection before you retrieve the data.</p>
     *
     *  @see #refresh()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    function get sort():ISort;

    /**
     *  @private
     */
    function set sort(value:ISort):void;

    /**
     *  Returns whether the view contains the specified object.
     *  If the view has a filter applied to it this method may return
     *  <code>false</code> even if the underlying collection
     *  does contain the item.
     *
     *  @param item The object to look for.
     *
     *  @return true if the ICollectionView, after applying any filter,
     *  contains the item; false otherwise.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    function contains(item:Object):Boolean;

    /**
     *  Applies the sort and filter to the view.
     *  The IArrayListView does not detect changes to a sort or
     *  filter automatically, so you must call the <code>refresh()</code>
     *  method to update the view after setting the <code>sort</code>
     *  or <code>filterFunction</code> property.
     *
     *  <p>Returns <code>true</code> if the refresh was successful
     *  and <code>false</code> if the sort is not yet complete
     *  (e.g., items are still pending).
     *  A client of the view should wait for a CollectionEvent event
     *  with the <code>CollectionEventKind.REFRESH</code> <code>kind</code>
     *  property to ensure that the <code>refresh()</code> operation is
     *  complete.</p>
     *
     *  @return <code>true</code> if the refresh() was complete,
     *  <code>false</code> if the refresh() is incomplete.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    function refresh():Boolean;

}
}
