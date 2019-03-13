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
 *  The IGroupingCollection2 interface defines the interface required 
 *  to create grouped data from flat data.
 *
 *  @see mx.collections.GroupingCollection2
 *  @see mx.controls.AdvancedDataGrid
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface IGroupingCollection2 extends IHierarchicalData
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  grouping
    //----------------------------------
    
    /**
     *  The Grouping object applied to the source data. 
     *  Setting this property does not automatically refresh the view;
     *  therefore, you must call the <code>refresh()</code> method
     *  after setting this property.
     *
     *  <p><b>Note:</b> The Flex implementations of IGroupingCollection2 retrieve all
     *  items from a remote location before executing grouping.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get grouping():Grouping;
       
    /**
     *  @private
     */
    function set grouping(value:Grouping):void;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Applies the grouping to the collection.
     *  The collection does not detect changes to a group 
     *  automatically, so you must call the <code>refresh()</code>
     *  method to update the collection after setting the <code>grouping</code>, 
     *  <code>source</code>, or <code>summaries</code> properties.
     *  You also call the <code>refresh()</code> method when you modify 
     *  a GroupingField of the collection, such as by changing the 
     *  <code>caseInsensitive</code>, <code>compareFunction</code>, 
     *  or <code>groupingFunction</code> properties.
     *
     *  <p>The <code>refresh()</code> method can be applied synchronously
     *  or asynchronously.</p>
     *  
     *  <p>When <code>refresh()</code> is called synchronously, 
     *  all groups and summaries are updated together before the method returns. 
     *  That means your application cannot perform other processing operations 
     *  for the duration of the call.
     *  A client should wait for a CollectionEvent event
     *  with the value of the <code>kind</code> property set 
     *  to <code>CollectionEventKind.REFRESH</code> 
     *  to ensure that the <code>refresh()</code> method completed.</p>
     *
     *  <p>In asynchronous refresh, all groups and summaries are updated individually. 
     *  The <code>refresh()</code> method returns before the groups and summaries 
     *  are updated so that your application can continue execution.
     *  Also, the control is updated during the refresh so that the 
     *  user can continue to interact with it.</p>
     *
     *  <p>The overhead of updating groups and summaries individually, 
     *  rather than all at once, makes an asynchronous refresh take longer 
     *  than a synchronous one. 
     *  However, for large data sets, your application continues 
     *  to operate during the refresh.</p>
     *
     *  @param async If <code>true</code>, defines the refresh to be asynchronous.
     *  By default it is <code>false</code> denoting synchronous refresh.
     * 
     *  @param dispatchCollectionEvents If <code>true</code>, events are
     *  dispatched when groups are formed.
     *  For better performance, set it to <code>false</code>.
     *  If <code>true</code>, then events are dispatched as groups and summaries are calculated 
     *  synchronously to update the control.
     *  Note: If <code>async</code> is <code>true</code>, 
     *  the <code>dispatchCollectionEvents</code> is always set to <code>true</code>.
     *  By default it is <code>false</code> denoting no events will be dispatched.
     *  
     *  @return <code>true</code> if the <code>refresh()</code> method completed,
     *  and <code>false</code> if the refresh is incomplete, 
     *  which can mean that items are still pending.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 3
     */
    function refresh(async:Boolean = false, dispatchCollectionEvents:Boolean = false):Boolean;
    
    /**
     *  If the refresh is performed asynchronously,
     *  cancels the refresh operation and stops the building of the groups.
     *  
     *  This method only cancels the refresh
     *  if it is initiated by a call to the <code>refresh()</code> method 
     *  with an <code>asynch</code> argument of <code>true</code>, corresponding to an asynchronous refresh.
     *  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 3
     */
    function cancelRefresh():void;
}

}
