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

package spark.components { 
    
import org.apache.royale.events.Event;
import mx.core.IDataRenderer;
import mx.events.FlexEvent;
//import org.apache.royale.events.EventDispatcher;
/**
 *  Dispatched when the <code>data</code> property changes.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 * 
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 * 
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  The DataRenderer class is the base class for data components in Spark. 
 *
 *  <p><b>Note:</b> This class may be removed in a later release.</p>
 *
 *  @mxml <p>The <code>&lt;s:DataRenderer&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:DataRenderer
 *    <strong>Properties</strong>
 *    data=""
 *  
 *    <strong>Events</strong>
 *    dataChange="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class DataRenderer extends Group implements IDataRenderer

{

   // include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function DataRenderer()
    {
        super();
    }
    
    private var _itemRendererParent:Object;
    
    /**
     * The parent container for the itemRenderer instance.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get itemRendererParent():Object
    {
        return _itemRendererParent;
    }
    public function set itemRendererParent(value:Object):void
    {
        _itemRendererParent = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     *  Storage for the data property.
     */
    private var _data:Object;

    [Bindable("dataChange")]

    /**
     *  The implementation of the <code>data</code> property
     *  as defined by the IDataRenderer interface.
     *  
     *  <p>This property is Bindable; it dispatches 
     * "dataChange" events</p>
     *
     *  @default null
     *  @eventType dataChange 
     *  @see mx.core.IDataRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get data():Object
    {
        return _data;
    }

    /**
     *  @private
     */
    public function set data(value:Object):void
    {
        _data = value;

        if (hasEventListener(FlexEvent.DATA_CHANGE))
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        callLater(runLayout);
    }
    
    public function runLayout():void
    {
        dispatchEvent(new Event("layoutNeeded"));
    }
    
    private var _listData:Object;
    
    [Bindable("__NoChangeEvent__")]
    /**
     *  Additional data about the list structure the itemRenderer may
     *  find useful.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get listData():Object
    {
        return _listData;
    }
    public function set listData(value:Object):void
    {
        _listData = value;
    }
    
    private var _labelField:String = "label";
    
    /**
     * The name of the field within the data to use as a label. Some itemRenderers use this field to
     * identify the value they should show while other itemRenderers ignore this if they are showing
     * complex information.
     */
    public function get labelField():String
    {
        return _labelField;
    }
    public function set labelField(value:String):void
    {
        _labelField = value;
    }
    
    override public function addedToParent():void
    {
        super.addedToParent();
        COMPILE::JS
        {
            // UIComponent defaults everything to absolute positioning, but
            // item renderers are likely to be positioned by the virtual layout
            // and thus need to use default positioning.
            element.style.position = "static";
        }
        
    }

}
}
