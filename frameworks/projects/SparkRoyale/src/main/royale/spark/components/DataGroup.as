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

package spark.components
{
/* import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.PerspectiveProjection;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
 */
/*
import mx.core.IDataRenderer;
import mx.core.IInvalidating;
import mx.core.ILayoutElement;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.PropertyChangeEvent;
import mx.managers.ILayoutManagerClient;
import mx.managers.LayoutManager;
import mx.utils.MatrixUtil;
import spark.layouts.supportClasses.LayoutBase;

import spark.events.RendererExistenceEvent;
 */
 import mx.core.IFactory;
import mx.core.IVisualElement;
import mx.collections.IList;
 import spark.components.supportClasses.GroupBase;
import org.apache.royale.html.beads.ItemRendererFunctionBead;
 import mx.core.IUIComponent;

 import mx.core.mx_internal;
use namespace mx_internal;  // for mx_internal property contentChangeDelta

import org.apache.royale.core.IBead;
import org.apache.royale.core.ISelectionModel;
import org.apache.royale.core.IItemRendererProvider;
import org.apache.royale.core.IStrandWithPresentationModel;
import org.apache.royale.core.IListPresentationModel;
import org.apache.royale.html.beads.models.ListPresentationModel;

/**
 *  Dispatched when a renderer is added to this dataGroup.
 * <code>event.renderer</code> is the renderer that was added.
 *
 *  @eventType spark.events.RendererExistenceEvent.RENDERER_ADD
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event(name="rendererAdd", type="spark.events.RendererExistenceEvent")] // not implemeneted

/**
 *  Dispatched when a renderer is removed from this dataGroup.
 * <code>event.renderer</code> is the renderer that was removed.
 *
 *  @eventType spark.events.RendererExistenceEvent.RENDERER_REMOVE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Event(name="rendererRemove", type="spark.events.RendererExistenceEvent")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="addChild", kind="method")]
[Exclude(name="addChildAt", kind="method")]
[Exclude(name="removeChild", kind="method")]
[Exclude(name="removeChildAt", kind="method")]
[Exclude(name="setChildIndex", kind="method")]
[Exclude(name="swapChildren", kind="method")]
[Exclude(name="swapChildrenAt", kind="method")]
[Exclude(name="numChildren", kind="property")]
[Exclude(name="getChildAt", kind="method")]
[Exclude(name="getChildIndex", kind="method")]

//--------------------------------------
//  Other metadata
//--------------------------------------

/* [ResourceBundle("components")]

[DefaultProperty("dataProvider")] 

[IconFile("DataGroup.png")]
 */
/**
 *  The DataGroup class is the base container class for data items.
 *  The DataGroup class converts data items to visual elements for display.
 *  While this container can hold visual elements, it is often used only 
 *  to hold data items as children.
 *
 *  <p>The DataGroup class takes as children data items or visual elements 
 *  that implement the IVisualElement interface and are DisplayObjects.  
 *  Data items can be simple data items such String and Number objects, 
 *  and more complicated data items such as Object and XMLNode objects. 
 *  While these containers can hold visual elements, 
 *  they are often used only to hold data items as children.</p>
 *
 *  <p>An item renderer defines the visual representation of the 
 *  data item in the container. 
 *  The item renderer converts the data item into a format that can 
 *  be displayed by the container. 
 *  You must pass an item renderer to a DataGroup container to render 
 *  data items appropriately.</p>
 *
 *  <p>To improve performance and minimize application size, 
 *  the DataGroup container cannot be skinned. 
 *  If you want to apply a skin, use the SkinnableDataContainer instead. </p>
 *  
 *  <p>The DataGroup container has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
 *  </table>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;s:DataGroup&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:DataGroup
 *    <strong>Properties</strong>
 *    dataProvider="null"
 *    itemRenderer="null"
 *    itemRendererFunction="null"
 *    typicalItem="null"
 *  
 *    <strong>Events</strong>
 *    rendererAdd="<i>No default</i>"
 *    rendererRemove="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.components.SkinnableDataContainer
 *  @see spark.components.Group
 *  @see spark.skins.spark.DefaultItemRenderer
 *  @see spark.skins.spark.DefaultComplexItemRenderer
 *  @includeExample examples/DataGroupExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class DataGroup extends GroupBase implements IItemRendererProvider, IStrandWithPresentationModel
{ //implements IItemRendererOwner
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function DataGroup()
    {
        super();
        typeNames = "DataGroup";
        
       // _rendererUpdateDelegate = this;
    }
    
    /**
     *  The presentation model for the list.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
     */
    public function get presentationModel():IBead
    {
        var presModel:IListPresentationModel = getBeadByType(IListPresentationModel) as IListPresentationModel;
        if (presModel == null) {
            presModel = new ListPresentationModel();
            presModel.rowHeight = 20;
            addBead(presModel);
        }
        return presModel;
    }
    
    /**
     *  @private
     *  flag to indicate whether a child in the item renderer has a non-zero layer, requiring child re-ordering.
     */
    /* private var _layeringFlags:uint = 0;
    
    private static const LAYERING_ENABLED:uint =    0x1;
    private static const LAYERING_DIRTY:uint =      0x2;
     */
    /**
     *  @private
     *  The following variables are used to track free virtual item renderers.
     *  When an item renderer is created an entry is added to rendererToFactoryMap
     *  so when it's time to move the renderer to the freeRendererMap "free list",
     *  we can store it with the other renderers produced by the same factory (IFactory).
     *  The value of rendererToFactoryMap[renderer] is a factory, the value of 
     *  freeRendererMap[factory] is the vector of free renderers produced by factory.
     */
    /* private var rendererToFactoryMap:Dictionary = new Dictionary(true);
    private var freeRendererMap:Dictionary = new Dictionary();
    private var addedVirtualRenderer:Boolean = false;  // see createVirtualRendererForItem()
     */
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  baselinePosition
    //----------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* override public function get baselinePosition():Number
    {
        if (!validateBaselinePosition())
            return NaN;
        
        if (numElements == 0)
            return super.baselinePosition;
        
        return getElementAt(0).baselinePosition + getElementAt(0).y;
    }
     */
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  typicalItem
    //----------------------------------
    
    /* private var _typicalItem:Object = null;
    private var explicitTypicalItem:Object = null;
    private var typicalItemChanged:Boolean = false;
    private var typicalLayoutElement:ILayoutElement = null;
    
    [Inspectable(category="Data")]
     */
    /**
     *  Layouts use the preferred size of the <code>typicalItem</code>
     *  when fixed row or column sizes are required, but a specific 
     *  <code>rowHeight</code> or <code>columnWidth</code> value is not set.
     *  Similarly virtual layouts use this item to define the size 
     *  of layout elements that have not been scrolled into view.
     *
     *  <p>The container  uses the typical data item, and the associated item renderer, 
     *  to determine the default size of the container children. 
     *  By defining the typical item, the container does not have to size each child 
     *  as it is drawn on the screen.</p>
     *
     *  <p>Setting this property sets the <code>typicalLayoutElement</code> property
     *  of the layout.</p>
     * 
     *  <p>Restriction: if the <code>typicalItem</code> is an IVisualItem, it must not 
     *  also be a member of the data Provider.</p>
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* public function get typicalItem():Object
    {
        return _typicalItem;
    } */
    
    /**
     *  @private
     */
    /* public function set typicalItem(value:Object):void
    {
        if (_typicalItem === value)
            return;
        _typicalItem = explicitTypicalItem = value;
        invalidateTypicalItemRenderer();
    }
    
    private function setTypicalLayoutElement(element:ILayoutElement):void
    {
        typicalLayoutElement = element;
        if (layout)
            layout.typicalLayoutElement = element;
    }
     */
    /** 
     *  Call this method if some aspect of the <code>typicalItem</code> 
     *  has changed that should be reflected by the layout.  
     * 
     *  <p>This method is called automatically if the <code>typicalItem</code> 
     *  is changed directly. That means if the property is set to a new value 
     *  that is not "==" to current value.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6 
     */
    /* public function invalidateTypicalItemRenderer():void
    {
        typicalItemChanged = true;
        invalidateProperties();
    }
    
    private function initializeTypicalItem():void
    {
        if (_typicalItem === null)
        {
            setTypicalLayoutElement(null);
            return;
        }
        
        var renderer:IVisualElement = createRendererForItem(_typicalItem, false);
        var obj:DisplayObject = DisplayObject(renderer);
        if (!obj)
        {
            setTypicalLayoutElement(null);
            return;
        }
        
        super.addChild(obj);
        setUpItemRenderer(renderer, 0, _typicalItem);
        if (obj is IInvalidating)
            IInvalidating(obj).validateNow();
        setTypicalLayoutElement(renderer);
        super.removeChild(obj);
    } 
     */
    /**
     *  @private 
     *  Create and validate a new item renderer (IR) for dataProvider[index].  
     * 
     *  This method creates a new IR which is not a child of this DataGroup.  It does not 
     *  return the existing IR at the specified index and it does not cache the IRs it 
     *  creates.   This method is intended to be used by clients which need to measure 
     *  virtual IRs that may not be visible/allocated.
     */
    /* mx_internal function createItemRendererFor(index:int):IVisualElement
    {
        if ((index < 0) || (dataProvider == null) || (index >= dataProvider.length))
            return null;
        
        const item:Object = dataProvider.getItemAt(index);
        const renderer:IVisualElement = createRendererForItem(item);
        
        super.addChild(DisplayObject(renderer)); 
        setUpItemRenderer(renderer, index, item);
        if (renderer is IInvalidating)
            IInvalidating(renderer).validateNow();
        super.removeChild(DisplayObject(renderer));
        
        return renderer;
    }
     */
    /**
     *  @private
     *  Called before measure/updateDisplayList(), if useVirtualLayout=true, to guarantee
     *  that the typicalLayoutElement has been defined.  If it hasn't, typicalItem is 
     *  initialized to dataProvider[0] and layout.typicalLayoutElement is set.
     */
    /* private function ensureTypicalLayoutElement():void
    {
        if (layout.typicalLayoutElement)
            return;
        
        const list:IList = dataProvider;
        if (list && (list.length > 0))
        {
            _typicalItem = list.getItemAt(0);
            
            // TextFlows are not shareable.  Soft-link TextFlow class.
            var isTextFlowClass:Boolean = 
                getQualifiedClassName(_typicalItem) == 
                    "flashx.textLayout.elements::TextFlow";
            
            if (isTextFlowClass)
                _typicalItem = _typicalItem["deepCopy"]();
            
            initializeTypicalItem();
        }
    }
     */
    //----------------------------------
    //  layout
    //----------------------------------
    
    //private var useVirtualLayoutChanged:Boolean = false;
    
    /**
     *  @private
     *  Sync the typicalLayoutElement var with this group's layout.
     */ 
    /*
	override public function set layout(value:Object):void
    {
        var oldLayout:LayoutBase = layout;
        if (value == oldLayout)
            return; 
        
        if (oldLayout)
        {
            oldLayout.typicalLayoutElement = null;
            oldLayout.removeEventListener("useVirtualLayoutChanged", layout_useVirtualLayoutChangedHandler);
        }
        // Changing the layout may implicitly change layout.useVirtualLayout
        if (oldLayout && value && (oldLayout.useVirtualLayout != value.useVirtualLayout))
            changeUseVirtualLayout();
        super.layout = value;    
        if (value)
        {
            // If typicalLayoutElement was specified for this DataGroup, then use
            // it, otherwise use the layout's typicalLayoutElement, if any.
            if (typicalLayoutElement)
                value.typicalLayoutElement = typicalLayoutElement;
            else
                typicalLayoutElement = value.typicalLayoutElement;
            value.addEventListener("useVirtualLayoutChanged", layout_useVirtualLayoutChangedHandler);
        }
    }*/
    
    /**
     *  @private
     *  If layout.useVirtualLayout changes, recreate the ItemRenderers.  This can happen
     *  if the layout's useVirtualLayout property is changed directly, or if the DataGroup's
     *  layout is changed. 
     */    
    /* private function changeUseVirtualLayout():void
    {
        removeDataProviderListener();
        removeAllItemRenderers();
        useVirtualLayoutChanged = true;
        invalidateProperties();
    }
     
    private function layout_useVirtualLayoutChangedHandler(event:Event):void
    {
        changeUseVirtualLayout();
    }*/
    
    //----------------------------------
    //  itemRenderer
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the itemRenderer property.
     */
    private var _itemRenderer:IFactory;
    
    //private var itemRendererChanged:Boolean;
    
    [Inspectable(category="Data")]
    
    /**
     *  The item renderer to use for data items. 
     *  The class must implement the IDataRenderer interface.
     *  If defined, the <code>itemRendererFunction</code> property
     *  takes precedence over this property.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    [SWFOverride(returns="org.apache.royale.core.IFactory")]
    public function get itemRenderer():IFactory
    {
        return _itemRenderer;
    }
    
    /**
     *  @private
     */
    [SWFOverride(params="org.apache.royale.core.IFactory", altparams="mx.core.IFactory")]
    public function set itemRenderer(value:IFactory):void
    {
        _itemRenderer = value;
        
       /*  removeDataProviderListener();
        removeAllItemRenderers();
        invalidateProperties();
        
        itemRendererChanged = true;
        typicalItemChanged = true; */
    }
    
    //----------------------------------
    //  itemRendererFunction
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the itemRendererFunction property.
     */
    /* private var _itemRendererFunction:Function;
    
    [Inspectable(category="Data")]
     */
    /**
     *  Function that returns an item renderer IFactory for a 
     *  specific item.  You should define an item renderer function 
     *  similar to this sample function:
     *  
     *  <pre>
     *    function myItemRendererFunction(item:Object):IFactory</pre>
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get itemRendererFunction():Function // not implemeneted
    {
        var itemRendererFunctionBead:ItemRendererFunctionBead = getBeadByType(ItemRendererFunctionBead) as ItemRendererFunctionBead;
	    if (itemRendererFunctionBead)
        {
            return itemRendererFunctionBead.itemRendererFunction;
        }

        return null;
    }
    
    /**
     *  @private
     */
    public function set itemRendererFunction(value:Function):void
    {
        var itemRendererFunctionBead:ItemRendererFunctionBead = getBeadByType(ItemRendererFunctionBead) as ItemRendererFunctionBead;
        if (!itemRendererFunctionBead)
        {
            itemRendererFunctionBead = new ItemRendererFunctionBead();
            addBead(itemRendererFunctionBead);
        }
        itemRendererFunctionBead.itemRendererFunction = value;
    }

    //----------------------------------
    //  rendererUpdateDelegate
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the rendererUpdateDelegate property.
     */
    //private var _rendererUpdateDelegate:IItemRendererOwner;
    
    /**
     *  @private
     *  The rendererUpdateDelgate is used to delegate item renderer
     *  updates to another component, usually the owner of the
     *  DataGroup within the context of data centric component such
     *  as List. 
     *  
     *  The registered delegate must implement the IItemRendererOwner interface.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* mx_internal function get rendererUpdateDelegate():IItemRendererOwner
    {
        return _rendererUpdateDelegate;
    }
     */
    /**
     *  @private
     */
    /* mx_internal function set rendererUpdateDelegate(value:IItemRendererOwner):void
    {
        _rendererUpdateDelegate = value;
    }
     */
    //----------------------------------
    //  dataProvider
    //----------------------------------
    
    /* private var _dataProvider:IList;
    private var dataProviderChanged:Boolean;
    
    [Bindable("dataProviderChanged")]
    [Inspectable(category="Data")]
     */
    /**
     *  The data provider for this DataGroup. 
     *  It must be an IList.
     * 
     *  <p>There are several IList implementations included in the 
     *  Flex framework, including ArrayCollection, ArrayList, and
     *  XMLListCollection.</p>
     *
     *  @default null
     *
     *  @see #itemRenderer
     *  @see #itemRendererFunction
     *  @see mx.collections.IList
     *  @see mx.collections.ArrayCollection
     *  @see mx.collections.ArrayList
     *  @see mx.collections.XMLListCollection
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     *  @royaleignorecoercion mx.collections.IList
     */
    public function get dataProvider():IList
    {
        return (model as ISelectionModel).dataProvider as IList;
    }
    /**
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    public function set dataProvider(value:IList):void
    {
        (model as ISelectionModel).dataProvider = value;
    }
    
    /**
     *  @private
     *  Used below for sorting the virtualRendererIndices Vector.
     */
    /* private static function sortDecreasing(x:int, y:int):Number
    {
        return y - x;
    } */
    
    /**
     *  @private
     *  Apply itemRemoved() to the renderer and dataProvider item at index.
     */
    /* private function removeRendererAt(index:int):void
    {
        // TODO (rfrishbe): we can't key off of the oldDataProvider for 
        // the item because it might not be there anymore (for instance, 
        // in a dataProvider reset where the new data is loaded into 
        // the dataProvider--the dataProvider doesn't actually change, 
        // but we still need to clean up).
        // Because of this, we are assuming the item is either:
        //   1.  The data property if the item implements IDataRenderer 
        //       and there is an itemRenderer or itemRendererFunction
        //   2.  The item itself
        
        // Probably could fix above by also storing indexToData[], but that doesn't 
        // seem worth it.  Sending in the wrong item here doesn't result in a big error...
        // just the event with have the wrong item associated with it
        
        const renderer:IVisualElement = indexToRenderer[index] as IVisualElement;
        if (renderer)
        {
            var item:Object;
            
            if (renderer is IDataRenderer && (itemRenderer != null || itemRendererFunction != null))
                item = IDataRenderer(renderer).data;
            else
                item = renderer;
            itemRemoved(item, index);
        }
    }
     */
    /**
     *  @private
     *  Remove all of the item renderers, clear the indexToRenderer table, clear
     *  any cached virtual layout data, and clear the typical layout element.  Note that
     *  this method does not depend on the dataProvider itself, see removeRendererAt().
     */ 
    /* private function removeAllItemRenderers():void
    {
        if (indexToRenderer.length == 0)
            return;

        if (virtualRendererIndices && (virtualRendererIndices.length > 0))
        {
            for each (var index:int in virtualRendererIndices.concat().sort(sortDecreasing))
                removeRendererAt(index);
            
            virtualRendererIndices.length = 0;
            oldVirtualRendererIndices.length = 0;
            
            const freeRenderers:Vector.<IVisualElement> = allFreeRenderers();
            for each (var renderer:IVisualElement in freeRenderers)
                super.removeChild(renderer as DisplayObject);

            resetFreeRenderers();
        }   
        else 
        {
            for (index = indexToRenderer.length - 1; index >= 0; index--)
                removeRendererAt(index);
        }

        indexToRenderer = [];  // should be redundant
        
        if (layout)
        {
            layout.clearVirtualLayoutCache();
            layout.typicalLayoutElement = null;
        }
    }
     */
    /**
     *  <p>Given a data item, return the <code>toString()</code> representation 
     *  of the data item for an item renderer to display. 
     *  Null data items return the empty string. </p>
     *
     *  @copy spark.components.IItemRendererOwner#itemToLabel()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    /* public function itemToLabel(item:Object):String
    {
        if (item !== null)
            return item.toString();
        return " ";
    }
     */
    /**
     *  Return the indices of the item renderers visible within this DataGroup.
     * 
     *  <p>If <code>clipAndEnableScrolling</code> is <code>true</code>, 
     *  return the indices of the <code>visible</code> = <code>true</code> 
     *  ItemRenderers that overlap this DataGroup's <code>scrollRect</code>.
     *  That is, the ItemRenders 
     *  that are at least partially visible relative to this DataGroup.  
     *  If <code>clipAndEnableScrolling</code> is <code>false</code>, 
     *  return a list of integers from 
     *  0 to <code>dataProvider.length</code> - 1.  
     *  Note that if this DataGroup's owner is a 
     *  Scroller, then <code>clipAndEnableScrolling</code> has been 
     *  set to <code>true</code>.</p>
     * 
     *  <p>The corresponding item renderer for each returned index can be 
     *  retrieved with the <code>getElementAt()</code> method, 
     *  even if the layout is virtual</p>
     * 
     *  <p>The order of the items in the returned Vector is not guaranteed.</p>
     * 
     *  <p>Note that the VerticalLayout and HorizontalLayout classes provide bindable
     *  <code>firstIndexInView</code> and <code>lastIndexInView</code> properties 
     *  which contain the same information as this method.</p>
     * 
     *  @return The indices of the visible item renderers.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    /* public function getItemIndicesInView():Vector.<int>
    {
        if (layout && layout.useVirtualLayout)
            return (virtualRendererIndices) ? virtualRendererIndices.concat() : new Vector.<int>(0);
        
        if (!dataProvider)
            return new Vector.<int>(0);
        
        const scrollR:Rectangle = scrollRect;
        const dataProviderLength:int = dataProvider.length;
        
        if (scrollR)
        {
            const visibleIndices:Vector.<int> = new Vector.<int>();
            const eltR:Rectangle = new Rectangle();
            const perspectiveProjection:PerspectiveProjection = transform.perspectiveProjection;            
            
            for (var index:int = 0; index < dataProviderLength; index++)
            {
                var elt:IVisualElement = getElementAt(index);
                if (!elt || !elt.visible)
                    continue;
                
                // TODO (egeorgie): provide a generic getElementBounds() utility function
                if (elt.hasLayoutMatrix3D && perspectiveProjection)
                {
                    eltR.x = 0; 
                    eltR.y = 0;
                    eltR.width = elt.getLayoutBoundsWidth(false);
                    eltR.height = elt.getLayoutBoundsHeight(false);                    
                    MatrixUtil.projectBounds(eltR, elt.getLayoutMatrix3D(), perspectiveProjection);
                }
                else
                {
                    eltR.x = elt.getLayoutBoundsX();
                    eltR.y = elt.getLayoutBoundsY();
                    eltR.width = elt.getLayoutBoundsWidth();
                    eltR.height = elt.getLayoutBoundsHeight();                    
                }
                
                if (scrollR.intersects(eltR))
                    visibleIndices.push(index);
            }

            return visibleIndices;
        }
        else
        {
            const allIndices:Vector.<int> = new Vector.<int>(dataProviderLength);
            for (index = 0; index < dataProviderLength; index++)
                allIndices[index] = index;
            return allIndices;
        }
    }
     */
    //--------------------------------------------------------------------------
    //
    //  Item -> Renderer mapping
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Return the item renderer factory for the specified item, if any.  Prefer 
     *  itemRendererFunction over itemRenderer.
     */
    /* private function itemToRendererFactory(item:Object):IFactory
    {
        if (itemRendererFunction != null)
            return itemRendererFunction(item);
        
        return itemRenderer;
    }
     */
    /**
     *  Return a new renderer created with the specified factory and add an entry for it
     *  to rendererToFactoryMap so that we can free and allocate it later.
     */
    /* private function createRenderer(factory:IFactory):IVisualElement
    {
        const element:IVisualElement = factory.newInstance() as IVisualElement;
        rendererToFactoryMap[element] = factory;
        return element;
    } */
    
    /**
     *  If a vector of free renderers exists for the specified factory, remove 
     *  one and return it.
     */
    /* private function allocateRenderer(factory:IFactory):IVisualElement
    {
        const renderers:Vector.<IVisualElement> = freeRendererMap[factory] as Vector.<IVisualElement>;
        if (renderers)
        {
            const element:IVisualElement = renderers.pop();
            if (renderers.length == 0)
                delete freeRendererMap[factory];
            if (element)
                return element;
        }
        
        return null;
    }
     */
    /**
     *  Add the specified renderer to the rendererToFactoryMap.
     */
    /* private function freeRenderer(renderer:IVisualElement):void
    {
        if (!renderer)
            return;
        
        const factory:IFactory = rendererToFactoryMap[renderer]; 
        if (!factory)
            return;
        
        var freeRenderers:Vector.<IVisualElement> = freeRendererMap[factory];
        if (!freeRenderers)
        {
            freeRenderers = new Vector.<IVisualElement>();
            freeRendererMap[factory] = freeRenderers;            
        }
        freeRenderers.push(renderer);
    }
     */
    /** 
     *  @private
     *  Return a vector of all of the renderers in freeRendererMap.
     */
    /* private function allFreeRenderers():Vector.<IVisualElement>
    {
        const rv:Vector.<IVisualElement> = new Vector.<IVisualElement>();
        
        for each (var v:Vector.<IVisualElement> in freeRendererMap)
        {
            for each (var e:IVisualElement in v)
                rv.push(e);
        }
        
        return rv;
    } */
    
    /**
     *  @private
     *  Reset the private free renderers data.
     */
    /* private function resetFreeRenderers():void
    {
        rendererToFactoryMap = new Dictionary(true);
        freeRendererMap = new Dictionary();
    }
     */
    /**
     *  @private
     *  Throw an error which indicates that we were unable to create an item renderer
     *  for the specified dataProvide and we weren't able to use the item as an 
     *  item renderer.
     */
    /* private function throwCreateRendererFailedError(item:Object):void
    {
        var err:String;
        if (itemIsRenderer(item))
            err = resourceManager.getString("components", "cannotDisplayVisualElement");
        else
            err = resourceManager.getString("components", "unableToCreateRenderer", [item]);
        
        throw new Error(err);
    }
     */
    /**
     *  @private
     *  True if the specified dataProvider item would serve as a renderer.
     */
    /* private function itemIsRenderer(item:Object):Boolean
    {
        return (item is IVisualElement) && (item is DisplayObject);
    }
     */
    /**
     *  @private
     *  Create or reuse an item renderer for the specified dataProvider item.  This method is 
     *  used by getVirtualLayoutElementAt(), i.e. when useVirtualLayout=true.
     * 
     *  This method actually "returns" two values: the renderer itself and a flag that indicates
     *  if the renderer was newly added.   The second value is actually just a variable.  Each  
     *  time this method is called it sets addedVirtualRenderer.
     */
    /* private function createVirtualRendererForItem(item:Object, failRTE:Boolean=true):IVisualElement
    {
        var renderer:IVisualElement = null;
        
        const rendererFactory:IFactory = itemToRendererFactory(item);
        if (rendererFactory)
            renderer = allocateRenderer(rendererFactory);  // use a free renderer

        if (!renderer && rendererFactory)
        {
            renderer = createRenderer(rendererFactory);
            addedVirtualRenderer = true;
        }
        
        if (!renderer && itemIsRenderer(item))
        {
            renderer = IVisualElement(item);
            addedVirtualRenderer = true;            
        }
        
        if (!renderer && failRTE)
            throwCreateRendererFailedError(item);
        
        return renderer;
    }
     */        
    /**
     *  @private
     *  Create an item renderer for the specified dataProvider item.   This method is used
     *  when useVirtualLayout=false.
     */
    /* private function createRendererForItem(item:Object, failRTE:Boolean=true):IVisualElement
    {
        var renderer:IVisualElement = null;
        
        const rendererFactory:IFactory = itemToRendererFactory(item);
        if (rendererFactory)
            renderer = createRenderer(rendererFactory);
        
        if (!renderer && itemIsRenderer(item))
            renderer = IVisualElement(item);
        
        if (!renderer && failRTE)
            throwCreateRendererFailedError(item);      

        return renderer;
    }
     */
    /** 
     *  @private
     *  If layout.useVirtualLayout=false, then ensure that there's one item 
     *  renderer for every dataProvider item.   This method is only intended to be
     *  called by commitProperties().
     * 
     *  Reuse as many of the IItemRenderer renderers in indexToRenders as possible.
     */
    /* private function createItemRenderers():void
    {
        if (!dataProvider)
        {
            removeAllItemRenderers();
            return;
        }

        if (layout && layout.useVirtualLayout)
        {   
            // Add any existing renderers to the free list.
            if (virtualRendererIndices != null && 
                virtualRendererIndices.length > 0)
            {
                startVirtualLayout();   
                finishVirtualLayout();
            }
            
            // The item renderers will be created lazily, at updateDisplayList() time
            invalidateSize();
            invalidateDisplayList();
            
            return;
        }
        
        const dataProviderLength:int = dataProvider.length; 

        // Remove the renderers we're not going to need
        for(var index:int = indexToRenderer.length - 1; index >= dataProviderLength; index--)
            removeRendererAt(index);
        
        // Reset the existing renderers
        for(index = 0; index < indexToRenderer.length; index++)
        {
            var item:Object = dataProvider.getItemAt(index);
            var renderer:IVisualElement = indexToRenderer[index] as IVisualElement;
            
            // If the (new) item is-a renderer and the old renderer is a different 
            // DisplayObject, then we can't reuse the old renderer.
            
            if (renderer && (!itemIsRenderer(item) || (item == renderer)))
            {
                setUpItemRenderer(renderer, index, item);
            }
            else
            {
                removeRendererAt(index); 
                itemAdded(item, index);
            }
        }
        
        // Create new renderers
        for (index = indexToRenderer.length; index < dataProviderLength; index++)
            itemAdded(dataProvider.getItemAt(index), index);        
    }
     */
    /**
     *  @private
     */
    /* override protected function commitProperties():void
    { 
        // If the itemRenderer, itemRendererFunction, or useVirtualLayout properties changed,
        // then recreate the item renderers from scratch.  If just the dataProvider changed,
        // and layout.useVirtualLayout=false, then reuse as many item renderers as possible,
        // remove the extra ones, or create more as needed.
        
        if (itemRendererChanged || useVirtualLayoutChanged || dataProviderChanged)
        {
            itemRendererChanged = false;
            useVirtualLayoutChanged = false;

            // SDK-29916: The layout's cache may be in sync with the old data provider.
            // The layout will sync up its cache with the new data provider
            // when the DataGroup validateSize() / validateDisplayList().
            // By clearing the cache here, we make sure that any insert/remove 
            // events for the new dataProvider, that occur from this point on till 
            // validteSize() / validateDisplayList(), won't be mixed up with the 
            // stale layout cache state that reflects the old data provider.
            if (layout)
                layout.clearVirtualLayoutCache();
            
            // item renderers and the dataProvider listener have already been removed
            createItemRenderers();
            addDataProviderListener();

            // Don't reset the scroll positions until the new ItemRenderers have been
            // created, see bug https://bugs.adobe.com/jira/browse/SDK-23175
            if (dataProviderChanged)
            {
                dataProviderChanged = false;
                verticalScrollPosition = horizontalScrollPosition = 0;
            }
            
            maskChanged = true;
        }
        
        // Need to create item renderers before calling super.commitProperties()
        // GroupBase's commitProperties reattaches the mask
        super.commitProperties();
        
        if (_layeringFlags & LAYERING_DIRTY)
        {
            if (layout && layout.useVirtualLayout)
                invalidateDisplayList();
            else
                manageDisplayObjectLayers();
        }
        
        if (typicalItemChanged)
        {
            typicalItemChanged = false;
            initializeTypicalItem();
        }
    }
     */
    /**
     *  @private
     *  True if we are updating a renderer currently. 
     *  We keep track of this so we can ignore any dataProvider collectionChange
     *  UPDATE events while we are updating a renderer just in case we try to update 
     *  the rendererInfo of the same renderer twice.  This can happen if setting the 
     *  data in an item renderer causes the data to mutate and issue a propertyChange
     *  event, which causes an collectionChange.UPDATE event in the dataProvider.  This 
     *  can happen for components which are being treated as data because the first time 
     *  they get set on the renderer, they get added to the display list, which may 
     *  cause a propertyChange event (if there's a child with an ID in it, that causes 
     *  a propertyChange event) or the data to morph in some way.
     */
    //private var renderersBeingUpdated:Boolean = false;
    
    /**
     *  @private 
     *  Sets the renderer's data, owner and label properties. 
     *  It does this by calling rendererUpdateDelegate.updateRenderer().
     *  By default, rendererUpdateDelegate points to ourselves, but if 
     *  the "true owner" of the item renderer is a List, then the 
     *  rendererUpdateDelegate points to that object.  The 
     *  rendererUpdateDelegate.updateRenderer() call is in charge of 
     *  setting all the properties on the renderer, like owner, itemIndex, 
     *  data, selected, etc...  Note that data should be the last property 
     *  set in this lifecycle.
     */
    /* private function setUpItemRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
    {
        if (!renderer)
            return;
        
        // keep track of whether we are actively updating an renderers 
        // so we can ignore any collectionChange.UPDATE events
        renderersBeingUpdated = true;
        
        // Defer to the rendererUpdateDelegate
        // to update the renderer.  By default, the delegate is DataGroup
        _rendererUpdateDelegate.updateRenderer(renderer, itemIndex, data);
        
        // technically if this got called "recursively", this renderersBeingUpdated flag
        // would be prematurely set to false, but in most cases, this check should be 
        // good enough.
        renderersBeingUpdated = false;
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    /* public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
    {
        // set the owner
        renderer.owner = this;
        
        // Set the index
        if (renderer is IItemRenderer)
            IItemRenderer(renderer).itemIndex = itemIndex;
        
        // set the label to the toString() of the data 
        if (renderer is IItemRenderer)
            IItemRenderer(renderer).label = itemToLabel(data);
        
        // always set the data last
        if ((renderer is IDataRenderer) && (renderer !== data))
            IDataRenderer(renderer).data = data;
    }
     */
    /**
     *  @private
     *  If the renderer at the specified index has a non-zero depth then: append it to
     *  layers.topLayerItems if depth > 0, or to layers.bottomLayerItems if depth < 0.
     *  Otherwise, if depth is zero (the default) then change the renderer's childIndex 
     *  to insertIndex and increment insertIndex.  The possibly incremented insertIndex is returned.
     *   
     *  See manageDisplayObjectLayers().
     */
    /* private function sortItemAt(index:int, layers:Object, insertIndex:int):int
    {
        const renderer:IVisualElement = getElementAt(index);
        const layer:Number = renderer.depth;
        
        if (layer != 0)
        {               
            if (layer > 0)
            {
                if (layers.topLayerItems == null) 
                    layers.topLayerItems = new Vector.<IVisualElement>();
                layers.topLayerItems.push(renderer);
            }
            else
            {
                if (layers.bottomLayerItems == null) 
                    layers.bottomLayerItems = new Vector.<IVisualElement>();
                layers.bottomLayerItems.push(renderer);
            }
            
            return insertIndex;                   
        }
        
        super.setChildIndex(renderer as DisplayObject, insertIndex);        
        return insertIndex + 1;
    } */
    
    /**
     *  @private
     */
    /* private function manageDisplayObjectLayers():void
    {      
        _layeringFlags &= ~LAYERING_DIRTY;
        
        var insertIndex:uint = 0;
        const layers:Object = {topLayerItems:null,  bottomLayerItems:null};
        
        if (layout && layout.useVirtualLayout)
        {
            for each (var index:int in virtualRendererIndices)
            insertIndex = sortItemAt(index, layers, insertIndex);
        }
        else
        {
            for (index = 0; index < numElements; index++) 
                insertIndex = sortItemAt(index, layers, insertIndex);            
        }
        
        // itemRenderers should be both DisplayObjects and IVisualElements
        const topLayerItems:Vector.<IVisualElement> = layers.topLayerItems;
        const bottomLayerItems:Vector.<IVisualElement> = layers.bottomLayerItems; 
        
        var myItemRenderer:IVisualElement;
        var keepLayeringEnabled:Boolean = false;
        var len:int = numElements;
        var i:int;
        
        if (topLayerItems != null)
        {
            keepLayeringEnabled = true;
            GroupBase.sortOnLayer(topLayerItems);
            len = topLayerItems.length;
            for (i=0;i<len;i++)
            {
                myItemRenderer = topLayerItems[i];
                super.setChildIndex(myItemRenderer as DisplayObject, insertIndex++);
            }
        }
        
        if (bottomLayerItems != null)
        {
            keepLayeringEnabled = true;
            insertIndex=0;
            
            GroupBase.sortOnLayer(bottomLayerItems);
            len = bottomLayerItems.length;
            
            for (i=0;i<len;i++)
            {
                myItemRenderer = bottomLayerItems[i];
                super.setChildIndex(myItemRenderer as DisplayObject, insertIndex++);
            }
        }
        
        if (keepLayeringEnabled == false)
        {
            _layeringFlags &= ~LAYERING_ENABLED;
        } 
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Layout item iteration
    //
    //  Iterators used by Layout objects. For visual items, the layout item
    //  is the item itself. For data items, the layout item is the item renderer
    //  instance that is associated with the item.
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    /* override public function get numElements():int
    {
        return dataProvider ? dataProvider.length : 0;
    }
     */
    /** 
     *  @private
     *  Maps from renderer index (same as dataProvider index) to the item renderer itself.
     */
    private var indexToRenderer:Array = []; 
    
    /**
     *  @private
     *  The set of layout element indices requested with getVirtualElementAt() 
     *  during updateDisplayList(), and the set of "old" indices that were requested
     *  in the previous pass.  These vectors are used by finishVirtualLayout()
     *  to distinguish IRs that can be recycled or discarded.   The virtualRendererIndices
     *  vector is used in various places to iterate over all of the virtual renderers.
     */
    /* private var virtualRendererIndices:Vector.<int> = null;
    private var oldVirtualRendererIndices:Vector.<int> = null;
     */
    /**
     *  @private 
     *  During a virtual layout, virtualLayoutUnderway is true.  This flag is used 
     *  to defeat calls to invalidateSize(), which occur when IRs are lazily validated.   
     *  See invalidateSize() and updateDisplayList().
     */
    //private var virtualLayoutUnderway:Boolean = false;
    
    /**
     *  @private
     *  Called before super.updateDisplayList() if layout.useVirtualLayout=true.
     *  Also called by createItemRenderers to ready existing renderers
     *  to be recycled by the following call to finishVirtualLayout.
     * 
     *  Copies virtualRendererIndices to oldRendererIndices, clears virtualRendererIndices
     *  (which will be repopulated by subsequence getVirtualElementAt() calls), and
     *  calls ensureTypicalElement().
     */
    /* private function startVirtualLayout():void
    {
        // lazily create the virtualRendererIndices vectors
        
        if (!virtualRendererIndices)
            virtualRendererIndices = new Vector.<int>();
        if (!oldVirtualRendererIndices)
            oldVirtualRendererIndices = new Vector.<int>();
        
        // Copy the contents virtualRendererIndices to oldVirtualRendererIndices
        // and then clear virtualRendererIndices
        
        oldVirtualRendererIndices.length = 0;
        for each (var index:int in virtualRendererIndices)
            oldVirtualRendererIndices.push(index);
        virtualRendererIndices.length = 0;
        
        // Ensure that layout.typicalLayoutElement is set
        ensureTypicalLayoutElement();
    }
     */
    /**
     *  @private
     *  Called after super.updateDisplayList() finishes.  Also called by
     *  createItemRenderers to recycle existing renderers that were added
     *  to oldVirtualRendererIndices by the preceeding call to 
     *  startVirtualLayout.
     * 
     *  Discard the ItemRenderers that aren't needed anymore, i.e. the ones
     *  not explicitly requested with getVirtualElementAt() during the most
     *  recent super.updateDisplayList().
     * 
     *  Discarded IRs may be added to the freeRenderers list per the rules
     *  defined in getVirtualElementAt().  If any visible renderer has a non-zero
     *  depth we resort all of them with manageDisplayObjectLayers(). 
     */
    /* private function finishVirtualLayout():void
    {

        if (oldVirtualRendererIndices.length == 0)
            return;
        
        // Remove the old ItemRenderers that aren't new ItemRenderers and if 
        // recycling is possible, add them to the freeRenderers list.
        
        for each (var vrIndex:int in oldVirtualRendererIndices)
        {
            // Skip renderers that are still in view.
            if (virtualRendererIndices.indexOf(vrIndex) != -1)
                continue;
            
            // Remove previously "in view" IR from the item=>IR table
            var elt:IVisualElement = indexToRenderer[vrIndex] as IVisualElement;
            delete indexToRenderer[vrIndex];
            
            // Free or remove the IR.
            var item:Object = (dataProvider.length > vrIndex) ? dataProvider.getItemAt(vrIndex) : null;
            if ((item != elt) && (elt is IDataRenderer))
            {
                // IDataRenderer(elt).data = null;  see https://bugs.adobe.com/jira/browse/SDK-20962
                elt.includeInLayout = false;
                elt.visible = false;
                
                freeRenderer(elt);
            }
            else if (elt)
            {
                dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE, false, false, elt, vrIndex, item));
                super.removeChild(DisplayObject(elt));
            }
        }
        
        // If there are any visible renderers whose depth property is non-zero
        // then use manageDisplayObjectLayers to resort the children list.  Note:
        // we're assuming that the layout has set the bounds of any elements that
        // were allocated but aren't actually visible to 0x0.
        
        var depthSortRequired:Boolean = false;
        for each (vrIndex in virtualRendererIndices)
        {
            elt = indexToRenderer[vrIndex] as IVisualElement;
            if (!elt || !elt.visible || !elt.includeInLayout)
                continue;
            if ((elt.width == 0) || (elt.height == 0))
                continue;
            if (elt.depth != 0)
            {
                depthSortRequired = true;
                break;
            }
        }
        
        if (depthSortRequired)
            manageDisplayObjectLayers();
    }
     */
    /**
     *  @private
     *  This function exists for applications that need to control their footprint by
     *  allowing currently unused IRs to be garbage collected.   It is not used by the SDK.
     */
    /* mx_internal function clearFreeRenderers():void
    {
        resetFreeRenderers();
    } */
    
    /**
     *  @private
     *  During virtual layout getLayoutElementAt() eagerly validates lazily
     *  created (or recycled) IRs.   We don't want changes to those IRs to
     *  invalidate the size of this UIComponent.
     */
    /* override public function invalidateSize():void
    {
        if (!virtualLayoutUnderway)
            super.invalidateSize();
    }
     */
    /**
     *  @private 
     *  Make sure there's a valid typicalLayoutElement for virtual layout.
     */
    /* override protected function measure():void
    {
        if (layout && layout.useVirtualLayout)
            ensureTypicalLayoutElement();
        
        super.measure();
    } */
    
    /**
     *  @private
     *  Manages the state required by virtual layout. 
     */
    /* override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        drawBackground();
        
        if (layout && layout.useVirtualLayout)
        {
            virtualLayoutUnderway = true;
            startVirtualLayout();   
        }           
        
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        if (virtualLayoutUnderway)
        {
            finishVirtualLayout();
            virtualLayoutUnderway = false;
        }
    }
     */
    /**
     *  @private
     *  
     *  Returns the ItemRenderer being used for the data provider item at the specified index.
     *  Note that if the layout is virtual, ItemRenderers that are scrolled
     *  out of view may be reused.
     * 
     *  @param index The index of the data provider item.
     *
     *  @return The ItemRenderer being used for the data provider item 
     *  If the index is invalid, or if a data provider was not specified, then
     *  return <code>null</code>.
     *  If the layout is virtual and the specified item is not in view, then
     *  return <code>null</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    
	/*  public function getElementAt(index:int):IVisualElement
    {
        if ((index < 0) || (index >= indexToRenderer.length))
            return null;
        
        return indexToRenderer[index];  
		
    } */
    
    /**
     *  @private
     */
    /* override public function getVirtualElementAt(index:int, eltWidth:Number=NaN, eltHeight:Number=NaN):IVisualElement
    {
        if ((index < 0) || (dataProvider == null) || (index >= dataProvider.length))
            return null;
        
        var elt:IVisualElement = indexToRenderer[index];
        
        if (virtualLayoutUnderway)
        {
            if (virtualRendererIndices.indexOf(index) == -1)
                virtualRendererIndices.push(index);
            
            var item:Object;
            
            addedVirtualRenderer = false;  // set by createVirtualRendererForItem()
            if (!elt)
            {
                item = dataProvider.getItemAt(index);
                elt = createVirtualRendererForItem(item);
                elt.visible = true;
                elt.includeInLayout = true;
                indexToRenderer[index] = elt;
                addItemRendererToDisplayList(DisplayObject(elt)); 
                setUpItemRenderer(elt, index, item);
            }
            else
            {
                // No need to set the data and label in the IR again.
                // The collectionChangeHandler will handle updates to data.
                addItemRendererToDisplayList(DisplayObject(elt)); 
            }
            
            // We have the renderer now.  getVirtualElement() is called from within layout's 
            // updateDisplayList().  This means it hasn't gone through a fully baked validation 
            // pass yet.  To get it in to a valid state, we want to first force a 
            // commitProperties() and measure() to run on our item renderer.
            if (elt is ILayoutManagerClient)
                LayoutManager.getInstance().validateClient(elt as ILayoutManagerClient, true);
            
            // Now, we can resume normal layout updateDisplayList() code.  The layout 
            // could directly run this setLayoutBoundsSize() for us, but as legacy, 
            // getVirtualElementAt() calls this on behalf of the layout system
            // if eltWidth and eltHeight are both NaN
            if (!isNaN(eltWidth) || !isNaN(eltHeight))
                elt.setLayoutBoundsSize(eltWidth, eltHeight);
            
            if (addedVirtualRenderer) 
                dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, false, false, elt, index, item));
        }
        
        return elt;
    }
     */
    /**
     *  @private
     *  
     *  Returns the index of the data provider item
     *  that the specified item renderer
     *  is being used for, or -1 if there is no such item. 
     *  Note that if the layout is virtual, ItemRenderers that are scrolled
     *  out of view may be reused.
     * 
     *  @param element The item renderer.
     *
     *  @return The index of the data provider item. 
     *  If <code>renderer</code> is <code>null</code>, or if the <code>dataProvider</code>
     *  property was not specified, then return -1.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* override public function getElementIndex(element:IVisualElement):int
    {
        if ((dataProvider == null) || (element == null))
            return -1;
        
        return indexToRenderer.indexOf(element);
    }
     */
    
    /**
     *  @private
     */
    /* override public function invalidateLayering():void
    {
        _layeringFlags |= (LAYERING_ENABLED | LAYERING_DIRTY);
        invalidateProperties();
    }
     */
    /**
     *  @private
     *  Set the itemIndex of the IItemRenderer at index to index. See resetRenderersIndices.
     */
    /* private function resetRendererItemIndex(index:int):void
    {
        var renderer:IItemRenderer = indexToRenderer[index] as IItemRenderer;
        if (renderer)
            renderer.itemIndex = index;    
    }
     */
    
    /**
     *  @private
     *  Recomputes every renderer's index.
     *  This is useful when an item gets added that may change the renderer's 
     *  index.  In turn, this index may cuase the renderer to change appearance, 
     *  like when alternatingItemColors is used.
     */
    /* private function resetRenderersIndices():void
    {
        if (indexToRenderer.length == 0)
            return;
        
        if (layout && layout.useVirtualLayout)
        {
            for each (var index:int in virtualRendererIndices)
                resetRendererItemIndex(index);
        }
        else
        {
            const indexToRendererLength:int = indexToRenderer.length;
            for (index = 0; index < indexToRendererLength; index++)
                resetRendererItemIndex(index);
            // TODO (rfrishbe): could make this more optimal by only re-computing a subset of the visible
            // item renderers, but it's probably not worth it
        }
    }
     */
    /**
     *  Adds the itemRenderer for the specified dataProvider item to this DataGroup.
     * 
     *  This method is called as needed by the DataGroup implementation,
     *  it should not be called directly.
     *
     *  @param item The item that was added, the value of dataProvider[index].
     *  @param index The index where the dataProvider item was added.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* mx_internal function itemAdded(item:Object, index:int):void
    {
        if (layout)
            layout.elementAdded(index);
        
        if (layout && layout.useVirtualLayout)
        {
            // Increment all of the indices in virtualRendererIndices that are >= index.
            
            if (virtualRendererIndices)
            {
                const virtualRendererIndicesLength:int = virtualRendererIndices.length;
                for (var i:int = 0; i < virtualRendererIndicesLength; i++)
                {
                    const vrIndex:int = virtualRendererIndices[i];
                    if (vrIndex >= index)
                        virtualRendererIndices[i] = vrIndex + 1;
                }
                
                indexToRenderer.splice(index, 0, null); // shift items >= index to the right
                // virtual ItemRenderer itself will be added lazily, by updateDisplayList()
            }
            
            invalidateSize();
            invalidateDisplayList();
            return;
        }
        
        var myItemRenderer:IVisualElement = createRendererForItem(item);
        indexToRenderer.splice(index, 0, myItemRenderer);
        addItemRendererToDisplayList(myItemRenderer as DisplayObject, index);
        setUpItemRenderer(myItemRenderer, index, item);
        dispatchEvent(new RendererExistenceEvent(
            RendererExistenceEvent.RENDERER_ADD, false, false, 
            myItemRenderer, index, item));
        
        invalidateSize();
        invalidateDisplayList();
    }
     */
    /**
     *  Removes the itemRenderer for the specified dataProvider item from this DataGroup.
     * 
     *  This method is called as needed by the DataGroup implementation,
     *  it should not be called directly.
     *
     *  @param item The item that is being removed.
     * 
     *  @param index The index of the item that is being removed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* mx_internal function itemRemoved(item:Object, index:int):void
    {
        if (layout)
            layout.elementRemoved(index);
        
        // Decrement all of the indices in virtualRendererIndices that are > index
        // Remove the one (at vrItemIndex) that equals index.
        
        if (virtualRendererIndices && (virtualRendererIndices.length > 0))
        {
            var vrItemIndex:int = -1;  // location of index in virtualRendererIndices 
            const virtualRendererIndicesLength:int = virtualRendererIndices.length;
            for (var i:int = 0; i < virtualRendererIndicesLength; i++)
            {
                const vrIndex:int = virtualRendererIndices[i];
                if (vrIndex == index)
                    vrItemIndex = i;
                else if (vrIndex > index)
                    virtualRendererIndices[i] = vrIndex - 1;
            }
            if (vrItemIndex != -1)
                virtualRendererIndices.splice(vrItemIndex, 1);
        }
        
        // Remove the old renderer at index (if any) from indexToRenderer[], from the
        // DataGroup, and clear its data property (if any).
        
        const oldRenderer:IVisualElement = indexToRenderer[index];
        
        if (indexToRenderer.length > index)
            indexToRenderer.splice(index, 1);
        
        if (oldRenderer)
        {
            dispatchEvent(new RendererExistenceEvent(
                RendererExistenceEvent.RENDERER_REMOVE, false, false, oldRenderer, index, item));
            
            if (oldRenderer is IDataRenderer && oldRenderer !== item)
                IDataRenderer(oldRenderer).data = null;
            
            var child:DisplayObject = oldRenderer as DisplayObject;
            if (child)
                super.removeChild(child);
        }
        
        invalidateSize();
        invalidateDisplayList();
    } */
    
    /**
     *  @private
     */ 
    /* private function addItemRendererToDisplayList(child:DisplayObject, index:int = -1):void
    { 
        const childParent:Object = child.parent;
        const overlayCount:int = _overlay ? _overlay.numDisplayObjects : 0;
        const childIndex:int = (index != -1) ? index : super.numChildren - overlayCount;
        
        if (childParent == this)
        {
            super.setChildIndex(child, childIndex - 1);
            return;
        }
        
        if (childParent is DataGroup)
            DataGroup(childParent)._removeChild(child);
        
        if ((_layeringFlags & LAYERING_ENABLED) || 
            (child is IVisualElement && (child as IVisualElement).depth != 0))
            invalidateLayering();

        super.addChildAt(child, childIndex);
    }
     */
    /**
     *  @private
     */
    /* private function addDataProviderListener():void
    {
        if (_dataProvider)
            _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler, false, 0, true);
    } */

    /**
     *  @private
     */
    /* private function removeDataProviderListener():void
    {
        if (_dataProvider)
            _dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler);
    } */

    /**
     *  @private
     *  Called when contents within the dataProvider changes.  We will catch certain 
     *  events and update our children based on that.
     *
     *  @param event The collection change event
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* mx_internal function dataProvider_collectionChangeHandler(event:CollectionEvent):void
    {
        switch (event.kind)
        {
            case CollectionEventKind.ADD:
            {
                // items are added
                // figure out what items were added and where
                // for virtualization also figure out if items are now in view
                adjustAfterAdd(event.items, event.location);
                break;
            }
                
            case CollectionEventKind.REPLACE:
            {
                // items are replaced
                adjustAfterReplace(event.items, event.location);
                break;
            }
                
            case CollectionEventKind.REMOVE:
            {
                // items are added
                // figure out what items were removed
                // for virtualization also figure out what items are now in view
                adjustAfterRemove(event.items, event.location);
                break;
            }
                
            case CollectionEventKind.MOVE:
            {
                // one item is moved
                adjustAfterMove(event.items[0], event.location, event.oldLocation);
                break;
            }
                
            case CollectionEventKind.REFRESH:
            {
                // from a filter or sort...let's just reset everything
                removeDataProviderListener();
                dataProviderChanged = true;
                invalidateProperties();
                break;
            }
                
            case CollectionEventKind.RESET:
            {
                // reset everything
                removeDataProviderListener();                
                dataProviderChanged = true;
                invalidateProperties();
                break;
            }
                
            case CollectionEventKind.UPDATE:
            {
                // if a renderer is currently being updated, let's 
                // just ignore any UPDATE events.
                if (renderersBeingUpdated)
                    break;
                
                //update the renderer's data and data-dependant
                //properties. 
                for (var i:int = 0; i < event.items.length; i++)
                {
                    var pe:PropertyChangeEvent = event.items[i]; 
                    if (pe)
                    {
                        var index:int = dataProvider.getItemIndex(pe.source);
                        var renderer:IVisualElement = indexToRenderer[index];
                        setUpItemRenderer(renderer, index, pe.source); 
                    }
                }
                break;
            }
        }
    }
     */
    /**
     *  @private
     */
    /* private function adjustAfterAdd(items:Array, location:int):void
    {
        var length:int = items.length;
        for (var i:int = 0; i < length; i++)
        {
            itemAdded(items[i], location + i);
        }
        
        // the order might have changed, so we might need to redraw the other 
        // renderers that are order-dependent (for instance alternatingItemColor)
        resetRenderersIndices();
    }
     */
    /**
     *  @private
     */
    /* private function adjustAfterRemove(items:Array, location:int):void
    {
        var length:int = items.length;
        for (var i:int = length-1; i >= 0; i--)
        {
            itemRemoved(items[i], location + i);
        }
        
        // the order might have changed, so we might need to redraw the other 
        // renderers that are order-dependent (for instance alternatingItemColor)
        resetRenderersIndices();
    }
     */
    /**
     *  @private
     */
    /* private function adjustAfterMove(item:Object, location:int, oldLocation:int):void
    {
        itemRemoved(item, oldLocation);
        itemAdded(item, location);
        resetRenderersIndices();
    }
     */
    /**
     *  @private
     */
    /* private function adjustAfterReplace(items:Array, location:int):void
    {
        var length:int = items.length;
        for (var i:int = length-1; i >= 0; i--)
        {
            itemRemoved(items[i].oldValue, location + i);               
        }
        
        for (i = length-1; i >= 0; i--)
        {
            itemAdded(items[i].newValue, location);
        }
    }
     */
    //--------------------------------------------------------------------------
    //
    //  Methods: Access to overridden methods of base classes
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     * 
     *  This method allows access to the base class's implementation
     *  of removeChild() (UIComponent's version), which can be useful since components
     *  can override removeChild() and thereby hide the native implementation.  For 
     *  instance, we override removeChild() here to throw an RTE to discourage people
     *  from using this method.  We need this method so we can remove children
     *  that were previously attached to another DataGroup (see addItemToDisplayList).
     */
    /* private function _removeChild(child:DisplayObject):DisplayObject
    {
        return super.removeChild(child);
    }
     */
    /**
     *  @private
     */
    /* override public function addChild(child:DisplayObject):DisplayObject
    {
        throw(new Error(resourceManager.getString("components", "addChildDataGroupError")));
    }
     */
    /**
     *  @private
     */
    /* override public function addChildAt(child:DisplayObject, index:int):DisplayObject
    {
        throw(new Error(resourceManager.getString("components", "addChildAtDataGroupError")));
    }
     */
    /**
     *  @private
     */
    /* override public function removeChild(child:DisplayObject):DisplayObject
    {
        throw(new Error(resourceManager.getString("components", "removeChildDataGroupError")));
    }
     */
    /**
     *  @private
     */
    /* override public function removeChildAt(index:int):DisplayObject
    {
        throw(new Error(resourceManager.getString("components", "removeChildAtDataGroupError")));
    }
     */
    /**
     *  @private
     */
    /* override public function setChildIndex(child:DisplayObject, index:int):void
    {
        throw(new Error(resourceManager.getString("components", "setChildIndexDataGroupError")));
    } */
    
    /**
     *  @private
     */
    /* override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
    {
        throw(new Error(resourceManager.getString("components", "swapChildrenDataGroupError")));
    } */
    
    /**
     *  @private
     */
    /* override public function swapChildrenAt(index1:int, index2:int):void
    {
        throw(new Error(resourceManager.getString("components", "swapChildrenAtDataGroupError")));
    } */
}
}
