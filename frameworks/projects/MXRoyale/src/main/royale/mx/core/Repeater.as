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

package mx.core
{

import mx.core.UIComponent;
import org.apache.royale.events.Event;

import mx.collections.ArrayCollection;
import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.IViewCursor;
//import mx.collections.ItemResponder;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.collections.errors.ItemPendingError;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.managers.ISystemManager;
import mx.managers.SystemManager;
import mx.automation.IAutomationObject;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched each time an item is processed and the 
 *  <code>currentIndex</code> and <code>currentItem</code> 
 *  properties are updated.
 *
 *  @eventType mx.events.FlexEvent.REPEAT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.8
 */
//[Event(name="repeat", type="mx.events.FlexEvent")]

/**
 *  Dispatched after all the subcomponents of a repeater are created.
 *  This event is triggered even if the <code>dataProvider</code>
 *  property is empty or <code>null</code>.
 *
 *  @eventType mx.events.FlexEvent.REPEAT_END
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.8
 */
//[Event(name="repeatEnd", type="mx.events.FlexEvent")]

/**
 *  Dispatched when Flex begins processing the <code>dataProvider</code>
 *  property and begins creating the specified subcomponents.
 *  This event is triggered even if the <code>dataProvider</code>
 *  property is empty or <code>null</code>.
 *
 *  @eventType mx.events.FlexEvent.REPEAT_START
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.8
 */
//[Event(name="repeatStart", type="mx.events.FlexEvent")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[IconFile("Repeater.png")]

[ResourceBundle("core")]

/**
 *  The Repeater class is the runtime object that corresponds
 *  to the <code>&lt;mx:Repeater&gt;</code> tag.
 *  It creates multiple instances of its subcomponents
 *  based on its dataProvider.
 *  The repeated components can be any standard or custom
 *  controls or containers.
 *
 *  <p>You can use the <code>&lt;mx:Repeater&gt;</code> tag
 *  anywhere a control or container tag is allowed, with the exception
 *  of the <code>&lt;mx:Application&gt;</code> container tag.
 *  To repeat a user interface component, you place its tag
 *  in the <code>&lt;mx:Repeater&gt;</code> tag.
 *  You can use more than one <code>&lt;mx:Repeater&gt;</code> tag
 *  in an MXML document.
 *  You can also nest <code>&lt;mx:Repeater&gt;</code> tags.</p>
 *
 *  <p>You cannot use the <code>&lt;mx:Repeater&gt;</code> tag
 *  for objects that do not extend the UIComponent class.</p>
 *
 *  @mxml
 *
 *  <p>The &lt;Repeater&gt; class has the following properties:</p>
 *
 *  <pre>
 *  &lt;mx:Repeater
 *    <strong>Properties</strong>
 *    id="<i>No default</i>"
 *    childDescriptors="<i>No default</i>"
 *    count="<i>No default</i>"
 *    dataProvider="<i>No default</i>"
 *    recycleChildren="false|true"
 *    startingIndex="0"
 *
 *    <strong>Events</strong>
 *    repeat="<i>No default</i>"
 *    repeatEnd="<i>No default</i>"
 *    repeatStart="<i>No default</i>"
 *  &gt;
 *  </pre>
 *
 *  @includeExample examples/RepeaterExample.mxml
 *
 *  @see mx.core.Container
 *  @see mx.core.UIComponent
 *  @see mx.core.UIComponentDescriptor
 *  @see flash.events.EventDispatcher
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.8
 */
public class Repeater extends UIComponent //implements IRepeater
{
    //include "../core/Version.as";

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
     *  @productversion Royale 0.9.8
     */
    public function Repeater()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    

    //----------------------------------
    //  dataProvider
    //----------------------------------

    /**
     *  @private
     *  Storage for the 'dataProvider' property.
     */
    private var collection:ICollectionView;

    [Bindable("collectionChange")]
    [Inspectable(category="General", defaultValue="null")]

    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.8
     */
    public function get dataProvider():Object
    {
        return collection;
    }

    /**
     *  @private
     */
    public function set dataProvider(value:Object):void
    {
        var hadValue:Boolean = false;

        if (collection)
        {
            hadValue = true;
            collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangedHandler);
            collection = null;
          //  iterator = null;
        }

        if (value is Array)
        {
            collection = new ArrayCollection(value as Array);
        }
        else if (value is ICollectionView)
        {
            collection = ICollectionView(value);
        }
        else if (value is IList)
        {
            collection = new ListCollectionView(IList(value));
        }
        else if (value is XMLList)
        {
            collection = new XMLListCollection(value as XMLList);
        }
        else if (value is XML)
        {
            var xl:XMLList = new XMLList();
            xl += value;
            collection = new XMLListCollection(xl);
        }
        else if (value != null)
        {
            // convert it to an array containing this one item
            var tmp:Array = [value];
            collection = new ArrayCollection(tmp);
        }

        if (collection)
        {
            // weak reference
            //collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangedHandler, false, 0, true);
			collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangedHandler, false, 0);
            //iterator = collection.createCursor();
        }

        dispatchEvent(new Event("collectionChange"));

        if (collection || hadValue)
        {
           // execute();
        }
    }

     /**
     *  @private
     *  Handles "Change" event sent by calls to Collection APIs
     *  on this Repeater's dataProvider.
     */
    private function collectionChangedHandler(collectionEvent:CollectionEvent):void
    {
        switch (collectionEvent.kind)
        {
            case CollectionEventKind.UPDATE:
            {
                break;
            }

            default:
            {
              //  execute();
            }
        }
    }

    //----------------------------------
    //  recycleChildren
    //----------------------------------

    /**
     *  @private
     *  Storage for the recycleChildren property.
     */
    private var _recycleChildren:Boolean = false;

    [Inspectable(category="Other", defaultValue="false")]

    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.8
     */
    public function get recycleChildren():Boolean
    {
        return _recycleChildren;
    }

    /**
     *  @private
     */
    public function set recycleChildren(value:Boolean):void
    {
        _recycleChildren = value;
    }

}
}
