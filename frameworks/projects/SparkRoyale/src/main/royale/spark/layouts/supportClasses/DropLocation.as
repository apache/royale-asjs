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

package spark.layouts.supportClasses
{
import org.apache.royale.geom.Point;

import mx.core.IVisualElement;
//import mx.events.DragEvent;

/**
 *  The DropLocation class contains information describing the drop location
 *  for the dragged data in a drag-and-drop operation. 
 * 
 *  <p>The <code>DropLocation</code> is created by the <code>LayoutBase</code>
 *  class when the <code>List</code> calls the layout's
 *  <code>calculateDropLocation()</code> method in response to a <code>dragOver</code>.</p>
 * 
 *  <p>The DropLocation class is used by the layout for operations such as
 *  calculating the drop indicator bounds and drag-scroll deltas.</p>
 * 
 *  @see spark.layouts.supportClasses.LayoutBase#calculateDropLocation()
 *  @see spark.layouts.supportClasses.LayoutBase#calculateDropIndicatorBounds()
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 * 
 *  @royalesuppresspublicvarwarning
 */
public class DropLocation
{
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function DropLocation()
    {
    }
    
    /**
     *  The <code>DragEvent</code> associated with this location. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    public var dragEvent:DragEvent = null;
     */
    
    /**
     *  The drop index corresponding to the event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var dropIndex:int = -1;
    
    /**
     *  The event point in local coordinates of the layout's target.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var dropPoint:Point = null;
}
}
