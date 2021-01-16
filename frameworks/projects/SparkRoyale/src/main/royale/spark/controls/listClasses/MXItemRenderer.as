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

package spark.controls.listClasses
{
import org.apache.royale.events.Event;

import mx.controls.listClasses.ListBase;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.managers.IFocusManagerComponent;
import mx.styles.StyleManager;
import spark.components.supportClasses.ItemRenderer;

/**
 *  The MXItemRenderer class is the base class for Spark item renderers  
 *  and item editors used in MX list-based controls. 
 *  This class lets you use the Spark item renderer architecture with the 
 *  MX DataGrid, MX AdvancedDataGrid, and MX Tree controls. 
 *
 *  <p><b>Note: </b>Many MX controls support item renderers or item editors. 
 *  However, only the MX DataGrid, MX AdvancedDataGrid, and MX Tree controls 
 *  support the MXItemRenderer class. 
 *  Therefore, continue to use MX item renderers and item editors with 
 *  MX controls other than DataGrid, AdvancedDataGrid, and Tree.</p>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;s:MXItemRenderer&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:MXItemRenderer
 *    <strong>Properties</strong>
 *  /&gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class MXItemRenderer extends ItemRenderer implements IListItemRenderer, IDropInListItemRenderer
{    
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
     *  @productversion Flex 4
     */
    public function MXItemRenderer()
    {
        super();
        focusEnabled = false;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    
    //----------------------------------
    //  listData
    //----------------------------------

    /**
     *  @private
     *  Storage for the listData property.
     */
    private var _listData:BaseListData;

    [Bindable("dataChange")]
    
    /**
     *  The implementation of the <code>listData</code> property
     *  as defined by the IDropInListItemRenderer interface.
     *
     *  @see mx.controls.listClasses.IDropInListItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get listData():BaseListData
    {
        return _listData;
    }

    /**
     *  @private
     */
    public function set listData(value:BaseListData):void
    {
        _listData = value;

        invalidateProperties();
    }

    //----------------------------------
    //  editor
    //----------------------------------

    /**
     *  If supplied, the component that will receive focus as the editor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var editor:IFocusManagerComponent;

    //----------------------------------
    //  text
    //----------------------------------

    /**
     *  The <code>text</code> property of
     *  the component specified by <code>editorID</code>.
     *  This is a convenience property to
     *  let the item editor of the MX control, 
     *  specified by the <code>itemEditor</code> property, 
     *  pull the value from most item editors
     *  without having to propagate a property
     *  to the MXItemRenderer.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get text():String
    {
        if (editor && ("text" in editor))
            return editor["text"];

        return null;
    }

  

}
}