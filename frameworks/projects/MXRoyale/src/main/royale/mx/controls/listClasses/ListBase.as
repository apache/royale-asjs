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
package mx.controls.listClasses
{

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.core.EdgeMetrics;
import mx.core.IUIComponent;
import mx.core.ScrollControlBase;
import mx.core.ScrollPolicy;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.utils.UIDUtil;

import org.apache.royale.core.ContainerBaseStrandChildren;
import org.apache.royale.core.IBead;
import org.apache.royale.core.IBeadLayout;
import org.apache.royale.core.IBeadView;
import org.apache.royale.core.IChild;
import org.apache.royale.core.IContainer;
import org.apache.royale.core.IContainerBaseStrandChildrenHost;
import org.apache.royale.core.IDataProviderItemRendererMapper;
import org.apache.royale.core.IFactory;
import org.apache.royale.core.IItemRendererClassFactory;
import org.apache.royale.core.IItemRendererProvider;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.ILayoutHost;
import org.apache.royale.core.ILayoutParent;
import org.apache.royale.core.ILayoutView;
import org.apache.royale.core.IListPresentationModel;
import org.apache.royale.core.IParent;
import org.apache.royale.core.ISelectionModel;
import org.apache.royale.core.IStrandWithPresentationModel;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.Event;
import org.apache.royale.events.ValueEvent;
import org.apache.royale.utils.loadBeadFromValuesManager;

use namespace mx_internal;

	
/**
 *  Dispatched when the user clicks on an item in the control.
 *
 *  @eventType mx.events.ListEvent.ITEM_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemClick", type="mx.events.ListEvent")]

/**
 *  Dispatched when the user double-clicks on an item in the control.
 *
 *  @eventType mx.events.ListEvent.ITEM_DOUBLE_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemDoubleClick", type="mx.events.ListEvent")]
	
    /**
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royalesuppresspublicvarwarning
	*/
	public class ListBase extends ScrollControlBase 
        implements IContainerBaseStrandChildrenHost, IContainer, ILayoutParent, 
                    ILayoutView, IItemRendererProvider, IStrandWithPresentationModel
	{  //extends UIComponent
	
	
	
	public function get value():Object
	{
	   return null;
	}
        //----------------------------------
        //  dragEnabled
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the dragEnabled property.
         */
        private var _dragEnabled:Boolean = false;
        
        /**
         *  A flag that indicates whether you can drag items out of
         *  this control and drop them on other controls.
         *  If <code>true</code>, dragging is enabled for the control.
         *  If the <code>dropEnabled</code> property is also <code>true</code>,
         *  you can drag items and drop them within this control
         *  to reorder the items.
         *
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get dragEnabled():Boolean
        {
            return _dragEnabled;
        }
        
        /**
         *  @private
         */
        public function set dragEnabled(value:Boolean):void
        {
            _dragEnabled = value;
        }
        
        //----------------------------------
        //  dragMoveEnabled
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the dragMoveEnabled property.
         */
        private var _dragMoveEnabled:Boolean = false;
        
        [Inspectable(defaultValue="false")]
        
        /**
         *  A flag that indicates whether items can be moved instead
         *  of just copied from the control as part of a drag-and-drop
         *  operation.
         *  If <code>true</code>, and the <code>dragEnabled</code> property
         *  is <code>true</code>, items can be moved.
         *  Often the data provider cannot or should not have items removed
         *  from it, so a MOVE operation should not be allowed during
         *  drag-and-drop.
         *
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get dragMoveEnabled():Boolean
        {
            return _dragMoveEnabled;
        }
        
        /**
         *  @private
         */
        public function set dragMoveEnabled(value:Boolean):void
        {
            _dragMoveEnabled = value;
        }
        
        //----------------------------------
        //  dataProvider
        //----------------------------------
        
        [Bindable("collectionChange")]
        [Inspectable(category="Data", defaultValue="undefined")]
        
        /**
         *  Set of data to be viewed.
         *  This property lets you use most types of objects as data providers.
         *  If you set the <code>dataProvider</code> property to an Array, 
         *  it will be converted to an ArrayCollection. If you set the property to
         *  an XML object, it will be converted into an XMLListCollection with
         *  only one item. If you set the property to an XMLList, it will be 
         *  converted to an XMLListCollection.  
         *  If you set the property to an object that implements the 
         *  IList or ICollectionView interface, the object will be used directly.
         *
         *  <p>As a consequence of the conversions, when you get the 
         *  <code>dataProvider</code> property, it will always be
         *  an ICollectionView, and therefore not necessarily be the type of object
         *  you used to  you set the property.
         *  This behavior is important to understand if you want to modify the data 
         *  in the data provider: changes to the original data may not be detected, 
         *  but changes to the ICollectionView object that you get back from the 
         *  <code>dataProvider</code> property will be detected.</p>
         * 
         *  @default null
         *  @see mx.collections.ICollectionView
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function get dataProvider():Object
        {
            return (model as ISelectionModel).dataProvider;
        }
        /**
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function set dataProvider(value:Object):void
        {
            if (value is Array)
            {
                value = new ArrayCollection(value as Array);
            }
            else if (value is ICollectionView)
            {
                value = ICollectionView(value);
            }
            else if (value is IList)
            {
                value = new ListCollectionView(IList(value));
            }
            else if (value is XMLList)
            {
                value = new XMLListCollection(value as XMLList);
            }
            else if (value is XML)
            {
                var xl:XMLList = new XMLList();
                xl += value;
                value = new XMLListCollection(xl);
            }
            else
            {
                // convert it to an array containing this one item
                var tmp:Array = [];
                if (value != null)
                    tmp.push(value);
                value = new ArrayCollection(tmp);
            }
            (model as ISelectionModel).dataProvider = value;
        }
        
        
        //----------------------------------
        //  dropEnabled
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the <code>dropEnabled</code> property.
         */
        private var _dropEnabled:Boolean = false;
        
        [Inspectable(defaultValue="false")]
        
        /**
         *  A flag that indicates whether dragged items can be dropped onto the 
         *  control.
         *
         *  <p>If you set this property to <code>true</code>,
         *  the control accepts all data formats, and assumes that
         *  the dragged data matches the format of the data in the data provider.
         *  If you want to explicitly check the data format of the data
         *  being dragged, you must handle one or more of the drag events,
         *  such as <code>dragOver</code>, and call the DragEvent's
         *  <code>preventDefault()</code> method to customize
         *  the way the list class accepts dropped data.</p>
         *
         *  <p>When you set <code>dropEnabled</code> to <code>true</code>, 
         *  Flex automatically calls the <code>showDropFeedback()</code> 
         *  and <code>hideDropFeedback()</code> methods to display the drop indicator.</p>
         *
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get dropEnabled():Boolean
        {
            return _dropEnabled;
        }
        
        /**
         *  @private
         */
        public function set dropEnabled(value:Boolean):void
        {
            _dropEnabled = value;
        }
        
        //----------------------------------
        //  labelField
        //----------------------------------
                
        [Bindable("labelFieldChanged")]
        [Inspectable(category="Data", defaultValue="label")]
        
        /**
         *  The name of the field in the data provider items to display as the label. 
         *  By default the list looks for a property named <code>label</code> 
         *  on each item and displays it.
         *  However, if the data objects do not contain a <code>label</code> 
         *  property, you can set the <code>labelField</code> property to
         *  use a different property in the data object. An example would be 
         *  "FullName" when viewing a set of people names fetched from a database.
         *
         *  @default "label"
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function get labelField():String
        {
            return (model as ISelectionModel).labelField;
        }
        
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function set labelField(value:String):void
        {
            (model as ISelectionModel).labelField = value;
        }
        
        //----------------------------------
        //  labelFunction
        //----------------------------------
        
        private var _labelFunction:Function;
        
        /**
         *  The name of the field in the data provider items to display as the label. 
         *  By default the list looks for a property named <code>label</code> 
         *  on each item and displays it.
         *  However, if the data objects do not contain a <code>label</code> 
         *  property, you can set the <code>labelField</code> property to
         *  use a different property in the data object. An example would be 
         *  "FullName" when viewing a set of people names fetched from a database.
         *
         *  @default "label"
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function get labelFunction():Function
        {
            return _labelFunction;
        }
        
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function set labelFunction(value:Function):void
        {
            _labelFunction = value;
        }

    //----------------------------------
    //  selectedIndex
    //----------------------------------

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="-1")]

    /**
     *  The index in the data provider of the selected item.
     * 
     *  <p>The default value is -1 (no selected item).</p>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    public function get selectedIndex():int
    {
        return (model as ISelectionModel).selectedIndex;
    }

    /**
     *  @private
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    public function set selectedIndex(value:int):void
    {
       // if (!collection || collection.length == 0)
       // {
        (model as ISelectionModel).selectedIndex = value;
         //   bSelectionChanged = true;
         //   bSelectedIndexChanged = true;
          //  invalidateDisplayList();
            return;
       // }
        //commitSelectedIndex(value);
    }
	
    //----------------------------------
    //  selectedIndices
    //----------------------------------
    
    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General")]
    
    /**
     *  An array of indices in the data provider of the selected items. The
     *  items are in the reverse order that the user selected the items.
     *  @default [ ]
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedIndices():Array
    {
        // TODO
        trace("selectedIndices not implemented");
        return null;
    }
    
    /**
     *  @private
     */
    public function set selectedIndices(indices:Array):void
    {
        // TODO
        trace("selectedIndices not implemented");
    }
    
    //----------------------------------
    //  selectedItem
    //----------------------------------
    
    [Bindable("change")]
    [Bindable("valueCommit")]
    
    /**
     *  The selected item in the data provider.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedItem():Object
    {
        return (model as ISelectionModel).selectedItem;
    }
    
    /**
     *  @private
     */
    public function set selectedItem(item:Object):void
    {
        (model as ISelectionModel).selectedItem = item;
    }
    
    //----------------------------------
    //  selectedItems
    //----------------------------------
    
    [Bindable("change")]
    [Bindable("valueCommit")]
    
    /**
     *  An array of references to the selected items in the data provider. The
     *  items are in the reverse order that the user selected the items.
     *  @default [ ]
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedItems():Array
    {
        // TODO
        trace("selectedItems not implemented");
        return null;
    }
    
    /**
     *  @private
     */
    public function set selectedItems(items:Array):void
    {
        // TODO
        trace("selectedItems not implemented");
    }
    
	//----------------------------------
    //  variableRowHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the variableRowHeight property.
     */
    private var _variableRowHeight:Boolean = false;

    [Inspectable(category="General")]

    /**
     *  A flag that indicates whether the individual rows can have different
     *  height. This property is ignored by TileList and HorizontalList.
     *  If <code>true</code>, individual rows can have different height values.
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get variableRowHeight():Boolean
    {
        return _variableRowHeight;
    }

    /**
     *  @private
     */
    public function set variableRowHeight(value:Boolean):void
    {
        _variableRowHeight = value;
       // itemsSizeChanged = true;

       // invalidateDisplayList();

       // dispatchEvent(new Event("variableRowHeightChanged"));
    }

    //----------------------------------
    //  allowMultipleSelection
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the allowMultipleSelection property.
     */
    private var _allowMultipleSelection:Boolean = false;
    
    [Inspectable(category="General", enumeration="false,true", defaultValue="false")]
    
    /**
     *  A flag that indicates whether you can allow more than one item to be
     *  selected at the same time.
     *  If <code>true</code>, users can select multiple items.
     *  There is no option to disallow discontiguous selection.
     *  Standard complex selection options are always in effect 
     *  (Shift-click, Ctrl-click).
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get allowMultipleSelection():Boolean
    {
        return _allowMultipleSelection;
    }
    
    /**
     *  @private
     */
    public function set allowMultipleSelection(value:Boolean):void
    {
        _allowMultipleSelection = value;
    }
//----------------------------------
    //  showDataTips
    //----------------------------------

    /**
     *  @private
     *  Storage for the showDataTips property.
     */
    private var _showDataTips:Boolean = false;

    [Bindable("showDataTipsChanged")]
    [Inspectable(category="Data", defaultValue="false")]

    /**
     *  A flag that indicates whether dataTips are displayed for text in the rows.
     *  If <code>true</code>, dataTips are displayed. DataTips
     *  are tooltips designed to show the text that is too long for the row.
     *  If you set a dataTipFunction, dataTips are shown regardless of whether the
     *  text is too long for the row.
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showDataTips():Boolean
    {
        return _showDataTips;
    }

    /**
     *  @private
     */
    public function set showDataTips(value:Boolean):void
    {
        _showDataTips = value;

       // itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("showDataTipsChanged"));
    }
	 //----------------------------------
    //  rowCount
    //----------------------------------

    /**
     *  @private
     *  Storage for the rowCount property.
     */
    private var _rowCount:int = -1;

    /**
     *  @private
     */
    private var rowCountChanged:Boolean = true;

    /**
     *  Number of rows to be displayed.
     *  If the height of the component has been explicitly set,
     *  this property might not have any effect.
     *
     *  <p>For a DataGrid control, the <code>rowCount</code> property does   
     *  not include the header row. </p>
     * 
     *  @default 4
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get rowCount():int
    {
        return _rowCount;
    }

    /**
     *  @private
     */
    public function set rowCount(value:int):void
    {
        explicitRowCount = value;

        if (_rowCount != value)
        {

            setRowCount(value);
            rowCountChanged = true;
            invalidateProperties();

            invalidateSize();
           // itemsSizeChanged = true;
            invalidateDisplayList();

            dispatchEvent(new Event("rowCountChanged"));
        }
    }
	/**
     *  Sets the <code>rowCount</code> property without causing
     *  invalidation or setting the <code>explicitRowCount</code>
     *  property, which permanently locks in the number of rows.
     *
     *  @param v The row count.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function setRowCount(v:int):void
    {
        //trace("setRowCount " + v);
        _rowCount = v;
    }
	
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ListBase()
		{
			super();            
			rowHeight = 22; //match Flex?
		}
        
        private var _DCinitialized:Boolean = true;
        
        /**
         * @private
         */
        override public function addedToParent():void
        {
            if (!_DCinitialized)
            {
                ValuesManager.valuesImpl.init(this);
                _DCinitialized = true;
            }
            
            super.addedToParent();

            // Load the layout bead if it hasn't already been loaded.
            loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this);

            // Even though super.addedToParent dispatched "beadsAdded", DataContainer still needs its data mapper
            // and item factory beads. These beads are added after super.addedToParent is called in case substitutions
            // were made; these are just defaults extracted from CSS.
            loadBeadFromValuesManager(IDataProviderItemRendererMapper, "iDataProviderItemRendererMapper", this);
            loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", this);
            
            dispatchEvent(new Event("initComplete"));
        }
        
        /*
        * IItemRendererProvider
        */
        
        private var _itemRenderer:IFactory;
        
        /**
         *  The class or factory used to display each item.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get itemRenderer():IFactory
        {
            return _itemRenderer;
        }
        public function set itemRenderer(value:IFactory):void
        {
            _itemRenderer = value;
        }
        
        private var _strandChildren:ContainerBaseStrandChildren;
        
        /**
         * @private
         */
        public function get strandChildren():IParent
        {
            if (_strandChildren == null) {
                _strandChildren = new ContainerBaseStrandChildren(this);
            }
            return _strandChildren;
        }
        
        public function scrollToIndex(index:int):Boolean
        {

            trace("ListBase:scrollToIndex not implemented");
			return false;
        }
        
        /**
         *  @private
         */
        public function childrenAdded():void
        {
            dispatchEvent(new ValueEvent("childrenAdded"));
        }
        
        /**
         * Returns the ILayoutHost which is its view. From ILayoutParent.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
         */
        public function getLayoutHost():ILayoutHost
        {
            return view as ILayoutHost;
        }
        
        /**
         * @private
         */
        private var _presentationModel:IListPresentationModel;
        
        /**
         *  The DataGrid's presentation model
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         *  @royaleignorecoercion org.apache.royale.core.IBead
         */
        public function get presentationModel():IBead
        {
            if (_presentationModel == null) {
                var bead:IBead = getBeadByType(IListPresentationModel);
                if (bead)
                    _presentationModel = bead as IListPresentationModel;
                else
                {
                    var c:Class = ValuesManager.valuesImpl.getValue(this, "iListPresentationModel");
                    if (c) {
                        _presentationModel = new c() as IListPresentationModel;
                        addBead(_presentationModel as IBead);
                    }
                }
            }
            
            return _presentationModel;
        }
        
        /*
        * The following functions are for the SWF-side only and re-direct element functions
        * to the content area, enabling scrolling and clipping which are provided automatically
        * in the JS-side. GroupBase handles event dispatching if necessary.
        */
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            var contentView:IParent = getLayoutHost().contentView as IParent;
            if (contentView == this)
                return super.addElement(c, dispatchEvent);
            contentView.addElement(c, dispatchEvent);
            if (dispatchEvent)
                this.dispatchEvent(new ValueEvent("childrenAdded", c));
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            var contentView:IParent = getLayoutHost().contentView as IParent;
            if (contentView == this)
                return super.addElementAt(c, index, dispatchEvent);
            contentView.addElementAt(c, index, dispatchEvent);
            if (dispatchEvent)
                this.dispatchEvent(new ValueEvent("childrenAdded", c));
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function getElementIndex(c:IChild):int
        {
            var layoutHost:ILayoutHost = view as ILayoutHost;
            var contentView:IParent = layoutHost.contentView as IParent;
            if (contentView == this)
                return super.getElementIndex(c);
            return contentView.getElementIndex(c);
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            var layoutHost:ILayoutHost = view as ILayoutHost;
            var contentView:IParent = layoutHost.contentView as IParent;
            contentView.removeElement(c, dispatchEvent);
            //TODO This should possibly be ultimately refactored to be more PAYG
            if(dispatchEvent)
                this.dispatchEvent(new ValueEvent("childrenRemoved", c));
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function get numElements():int
        {
            // the view getter below will instantiate the view which can happen
            // earlier than we would like (when setting mxmlDocument) so we
            // see if the view bead exists on the strand.  If not, nobody
            // has added any children so numElements must be 0
            if (!getBeadByType(IBeadView))
                return 0;
            var layoutHost:ILayoutHost = view as ILayoutHost;
            var contentView:IParent = layoutHost.contentView as IParent;
            if (contentView == this)
                return super.numElements;
            return contentView.numElements;
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function getElementAt(index:int):IChild
        {
            var layoutHost:ILayoutHost = view as ILayoutHost;
            var contentView:IParent = layoutHost.contentView as IParent;
            if (contentView == this)
                    return super.getElementAt(index);
            return contentView.getElementAt(index);
        }
        
        /**
         * @private
         */
        [SWFOverride(returns="flash.display.DisplayObject")]
        COMPILE::SWF
        override public function getChildAt(index:int):IUIComponent
        {
            return getElementAt(index) as IUIComponent;
        }
        
        /*
        * IStrandPrivate
        *
        * These "internal" function provide a backdoor way for proxy classes to
        * operate directly at strand level. While these function are available on
        * both SWF and JS platforms, they really only have meaning on the SWF-side. 
        * Other subclasses may provide use on the JS-side.
        *
        * @see org.apache.royale.core.IContainer#strandChildren
        */
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function get $numElements():int
        {
            return super.numElements;
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            super.addElement(c, dispatchEvent);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            super.addElementAt(c, index, dispatchEvent);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            super.removeElement(c, dispatchEvent);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $getElementIndex(c:IChild):int
        {
            return super.getElementIndex(c);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $getElementAt(index:int):IChild
        {
            return super.getElementAt(index);
        }
        
        //----------------------------------
        //  explicitColumnCount
        //----------------------------------
        
        /**
         *  The column count requested by explicitly setting the
         *  <code>columnCount</code> property.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var explicitColumnCount:int = -1;
        
        //----------------------------------
        //  explicitColumnWidth
        //----------------------------------
        
        /**
         *  The column width requested by explicitly setting the 
         *  <code>columnWidth</code>.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var explicitColumnWidth:Number;
        
        //----------------------------------
        //  explicitRowHeight
        //----------------------------------
        
        /**
         *  The row height requested by explicitly setting
         *  <code>rowHeight</code>.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var explicitRowHeight:Number;
        
        //----------------------------------
        //  explicitRowCount
        //----------------------------------
        
        /**
         *  The row count requested by explicitly setting
         *  <code>rowCount</code>.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var explicitRowCount:int = -1;
        
        //----------------------------------
        //  defaultColumnCount
        //----------------------------------
        
        /**
         *  The default number of columns to display.  This value
         *  is used if the calculation for the number of
         *  columns results in a value less than 1 when
         *  trying to calculate the columnCount based on size or
         *  content.
         *
         *  @default 4
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var defaultColumnCount:int = 4;
        
        //----------------------------------
        //  defaultRowCount
        //----------------------------------
        
        /**
         *  The default number of rows to display.  This value
         *  is used  if the calculation for the number of
         *  columns results in a value less than 1 when
         *  trying to calculate the rowCount based on size or
         *  content.
         *
         *  @default 4
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var defaultRowCount:int = 4;
        
        //----------------------------------
        //  rowHeight
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the rowHeight property.
         */
        private var _rowHeight:Number;
        
        /**
         *  @private
         */
        private var rowHeightChanged:Boolean = false;
        
        [Inspectable(category="General")]
        
        /**
         *  The height of the rows in pixels.
         *  Unless the <code>variableRowHeight</code> property is
         *  <code>true</code>, all rows are the same height.  
         *  If not specified, the row height is based on
         *  the font size and other properties of the renderer.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get rowHeight():Number
        {
            return _rowHeight;
        }
        
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         */
        public function set rowHeight(value:Number):void
        {
            explicitRowHeight = value;
            
            if (_rowHeight != value)
            {
                _rowHeight = value;
                
                (presentationModel as IListPresentationModel).rowHeight = value;
                /*
                invalidateSize();
                itemsSizeChanged = true;
                invalidateDisplayList();
                
                dispatchEvent(new Event("rowHeightChanged"));
                */
            }
        }
        
        //----------------------------------
        //  columnWidth
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the columnWidth property.
         */
        private var _columnWidth:Number;
        
        /**
         *  @private
         */
        private var columnWidthChanged:Boolean = false;
        
        /**
         *  The width of the control's columns.
         *  This property is used by TileList and HorizontalList controls;
         *  It has no effect on DataGrid controls, where you set the individual
         *  DataGridColumn widths.
         *  
         * @default 50
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get columnWidth():Number
        {
            return _columnWidth;
        }
        
        /**
         *  @private
         */
        public function set columnWidth(value:Number):void
        {
            explicitColumnWidth = value;
            
            if (_columnWidth != value)
            {
                _columnWidth = value;
                
                /*
                invalidateSize();
                itemsSizeChanged = true;
                invalidateDisplayList();
                
                dispatchEvent(new Event("columnWidthChanged"));*/
            }
        }
        
        /**
         *  @royaleignorecoercion org.apache.royale.core.ILayoutChild
         */
        override protected function measure():void
        {
            super.measure();
            
            var cc:int = explicitColumnCount < 1 ?
                defaultColumnCount :
                explicitColumnCount;
            
            var rc:int = explicitRowCount < 1 ?
                defaultRowCount :
                explicitRowCount;
            
            if (!isNaN(explicitRowHeight))
            {
                measuredHeight = explicitRowHeight * rc // + o.top + o.bottom;
                //measuredMinHeight = explicitRowHeight * Math.min(rc, 2) +
                //    o.top + o.bottom;
            }
            else
            {
                if (isNaN(rowHeight) && numChildren > 0)
                {
                    rowHeight = (getElementAt(0) as ILayoutChild).height;
                }
                measuredHeight = rowHeight * rc // + o.top + o.bottom;
                //measuredMinHeight = rowHeight * Math.min(rc, 2) +
                //    o.top + o.bottom;
            }
            
            if (!isNaN(explicitColumnWidth))
            {
                measuredWidth = explicitColumnWidth * cc // + o.left + o.right;
                //measuredMinWidth = explicitColumnWidth * Math.min(cc, 1) +
                //    o.left + o.right;
            }
            else
            {
                if (isNaN(columnWidth) && numChildren > 0)
                {
                    columnWidth = (getElementAt(0) as ILayoutChild).width;
                }
                measuredWidth = columnWidth * cc // + o.left + o.right;
                //measuredMinWidth = columnWidth * Math.min(cc, 1) +
                //    o.left + o.right;
            }
        }
        
        /**
         *  Determines the UID for a data provider item.  All items
         *  in a data provider must either have a unique ID (UID)
         *  or one will be generated and associated with it.  This
         *  means that you cannot have an object or scalar value
         *  appear twice in a data provider. 
         *
         *  <p>For example, the following
         *  data provider is not supported because the value "foo"
         *  appears twice and the UID for a string is the string itself:</p>
         *
         *  <pre>var sampleDP:Array = ["foo", "bar", "foo"]</pre>
         *
         *  <p>Simple dynamic objects can appear twice if they are two
         *  separate instances. The following is supported because
         *  each of the instances will be given a different UID because
         *  they are different objects:</p>
         *
         *  <pre>var sampleDP:Array = [{label: "foo"}, {label: "foo"}]</pre>
         *
         *  <p>Note that the following is not supported because the same instance
         *  appears twice.</p>
         *
         *  <pre>
         *  var foo:Object = {label: "foo"};
         *  sampleDP:Array = [foo, foo];</pre>
         *
         *  @param data The data provider item.
         *
         *  @return The UID as a string.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected function itemToUID(data:Object):String
        {
            if (data == null)
                return "null";
            return UIDUtil.getUID(data);
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: Item fields
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Returns the string the renderer would display for the given data object
         *  based on the labelField and labelFunction properties.
         *  If the method cannot convert the parameter to a string, it returns a
         *  single space.
         *
         *  @param data Object to be rendered.
         *
         *  @return The string to be displayed based on the data.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function itemToLabel(data:Object):String
        {
            if (data == null)
                return " ";
            
            /*
            if (labelFunction != null)
                return labelFunction(data);
            */
            
            if (data is XML)
            {
                try
                {
                    if ((data as XML)[labelField].length() != 0)
                        data = (data as XML)[labelField];
                    //by popular demand, this is a default XML labelField
                    //else if (data.@label.length() != 0)
                    //  data = data.@label;
                }
                catch(e:Error)
                {
                }
            }
            else if (data is Object)
            {
                try
                {
                    if (data[labelField] != null)
                        data = data[labelField];
                }
                catch(e:Error)
                {
                }
            }
            
            if (data is String)
                return String(data);
            
            try
            {
                return data.toString();
            }
            catch(e:Error)
            {
            }
            
            return " ";
        }

    }
}
