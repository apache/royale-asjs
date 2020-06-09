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

package spark.controls.advancedDataGridClasses
{
import mx.events.MouseEvent;

import mx.controls.AdvancedDataGrid;
import mx.controls.listClasses.AdvancedListBase;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.mx_internal;
import mx.managers.IFocusManagerComponent;

import spark.components.Group;
import spark.components.supportClasses.ItemRenderer;

use namespace mx_internal;

import org.apache.royale.binding.ItemRendererDataBinding;
import org.apache.royale.events.Event;


/**
 *  The MXAdvancedDataGridItemRenderer class defines the Spark item renderer class 
 *  for use with the MX AdvancedDataGrid control.
 *  This class lets you use the Spark item renderer architecture with the 
 *  MX AdvancedDataGrid control. 
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;s:MXAdvancedDataGridItemRenderer&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:MXAdvancedDataGridItemRenderer
 *    <strong>Properties</strong>
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.controls.AdvancedDataGrid
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class MXAdvancedDataGridItemRenderer extends ItemRenderer implements IListItemRenderer, IDropInListItemRenderer
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
    public function MXAdvancedDataGridItemRenderer()
    {
        super();
       // focusEnabled = false;
		typeNames = "MXAdvancedDataGridItemRenderer";
    }
    
	override protected function createChildren():void
	{
		addBead(new ItemRendererDataBinding());
		super.createChildren();
	}
	
    //----------------------------------
    //  listData
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the listData property.
     */
    private var _listData:Object;
    
    [Bindable("dataChange")]

    /**
     *  The implementation of the <code>listData</code> property
     *  as defined by the IDropInListItemRenderer interface.
     *  Use this property to access information about the 
     *  data item displayed by the item renderer.     
     *
     *  @see mx.controls.listClasses.IDropInListItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get listData():Object
    {
        return _listData;
    }
    
    /**
     *  @private
     */
    public function set listData(value:Object):void
    {
        _listData = value;
        
        invalidateProperties();
    }
    
    /**
     *  @private
     */
    override public function set data(value:Object):void
    {
		addBead(new ItemRendererDataBinding());
        super.data = value;        
		dispatchEvent(new Event("initBindings"));
    }

    //----------------------------------
    //  editor
    //----------------------------------
    
    /**
     *  The ID of the component that receives focus as the item editor.
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
     *  to the item renderer.
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
    
    //----------------------------------
    //  disclosureGroup
    //----------------------------------
    
    /**
     *  storage for disclosureGroup
     */
    // private var _disclosureGroup:Group;
    
    /**
     *  The ID of the component that receives focus as the item editor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* public function get disclosureGroup():Group
    {
        return _disclosureGroup;
    } */
    
    /**
     *  @private
     */
    /* public function set disclosureGroup(value:Group):void
    {
        if (value != _disclosureGroup)
        {
            if (_disclosureGroup)
            {
                _disclosureGroup.removeEventListener(MouseEvent.MOUSE_DOWN,
                    disclosureGroup_mouseDownHandler);
                _disclosureGroup.removeEventListener(MouseEvent.CLICK,
                    disclosureGroup_clickHandler);
            }
            _disclosureGroup = value;
            if (_disclosureGroup)
            {
                _disclosureGroup.addEventListener(MouseEvent.MOUSE_DOWN,
                    disclosureGroup_mouseDownHandler);
                _disclosureGroup.addEventListener(MouseEvent.CLICK,
                    disclosureGroup_clickHandler);
            }
        }
    }
	*/
	//---------------------------------
	//  advancedDataGridListData
	//----------------------------------
	
	//[Bindable("dataChange")]
	
	/**
	 *  The implementation of the <code>listData</code> property
	 *  as defined by the IDropInListItemRenderer interface.
	 *
	 *  @see mx.controls.listClasses.IDropInListItemRenderer
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	/* public function get advancedDataGridListData():AdvancedDataGridListData
	{
		return listData as AdvancedDataGridListData;
	} */
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Handle special behavior when clicking on the disclosure icon
     */
   /*  protected function disclosureGroup_mouseDownHandler(event:MouseEvent):void
    {
        event.stopPropagation();
		
		var adg:AdvancedDataGrid = listData.owner as AdvancedDataGrid;
		
        if (adg.isOpening || !adg.enabled)
            return;
        
        advancedDataGridListData.open = !advancedDataGridListData.open;
        
		adg.dispatchAdvancedDataGridEvent("itemOpening",
            data,      //item
            this,      //renderer
            event,     //trigger
            advancedDataGridListData.open,      //opening
            true,      //animate
            true);      //dispatch
    }
     */
    /**
     *  @private
     *  Handle special behavior when clicking on the disclosure icon
     */
   /*  protected function disclosureGroup_clickHandler(event:MouseEvent):void
    { */
        // stop this event from bubbling up because the click is 
        // for item selection and clicking on the disclosureIcon doesn't
        // select the items (only expands/closes them).
       /*  event.stopPropagation();
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */ 
   /*  override public function invalidateDisplayList():void
    {
        if (listData)
        { */
            // see if we need to change state.  This is the only invalidation method guaranteed to be
            // called.  We set up the renderers properties here so no matter what validation method gets
            // called first, the properties are set up accordingly.
            /* var listBase:AdvancedListBase = listData.owner as AdvancedListBase;
            if (listBase)
            {
                showsCaret = listBase.isItemShowingCaret(data);
                selected = listBase.isItemSelected(data);
                super.hovered = listBase.isItemHighlighted(data);
            }
        }
        
        super.invalidateDisplayList();
    }
     */
    /**
     *  @private
     */ 
    /* override protected function set hovered(value:Boolean):void
    {
        if (listData)
        { */
            // see if we need to change state.
            // in Halo list, you can rollout of the renderer and onto the padding area
            // and you should still be hovered, so we double check and override here.
            // then we get all the other state-related variables updated so the state
            // calculation will do the right thing.
           /*  var listBase:AdvancedListBase = listData.owner as AdvancedListBase;
            if (listBase)
            {
                selected = listBase.isItemSelected(data);
                value = listBase.isItemHighlighted(data);
            }
        }
        super.hovered = value;
    }
     */
    /**
     *  @private
     */ 
   /*  override protected function commitProperties():void
    {
        if (listData)
        { */
            // make sure itemIndex is correct before the base class does any computation
            // based on it
            /* var listBase:Object = listData.owner;
            itemIndex = listData.rowIndex + listBase.verticalScrollPosition;
        }
        
        super.commitProperties();
    } */
    
}
}
