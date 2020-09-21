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

package mx.controls.dataGridClasses
{
import org.apache.royale.core.ValuesManager;
/*
import flash.display.DisplayObject;
import flash.events.Event;
import flash.utils.Dictionary;

import mx.controls.TextInput;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.ClassFactory;
import mx.core.ContextualClassFactory;
import mx.core.IEmbeddedFontRegistry;
import mx.core.IFactory;
import mx.core.IFlexModuleFactory;
import mx.core.IIMESupport;
import mx.core.Singleton;
import mx.styles.StyleManager;
import mx.utils.StringUtil;

*/
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.controls.TextInput;
import mx.core.IFactory;
import mx.core.ClassFactory;
use namespace mx_internal;

import org.apache.royale.events.Event;
import org.apache.royale.core.UIBase;
import org.apache.royale.html.supportClasses.DataGridColumn;
    
//--------------------------------------
//  Styles
//--------------------------------------

//include "../../styles/metadata/TextStyles.as";

/**
 *  The Background color of the column.
 *  The default value is <code>undefined</code>, which means it uses the value of the 
 *  <code>backgroundColor</code> style of the associated DataGrid control.
 *  The default value for the DataGrid control is <code>0xFFFFFF</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

/**
 *  The name of a CSS style declaration for controlling other aspects of
 *  the appearance of the column headers.
 *  The default value is <code>undefined</code>, which means it uses the value of the 
 *  <code>headerStyleName</code> style of the associated DataGrid control.
 *  The default value for the DataGrid control is 
 *  <code>".dataGridStyles"</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="headerStyleName", type="String", inherit="no")]

/**
 *  The number of pixels between the container's left border and its content 
 *  area.
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="paddingLeft", type="Number", format="Length", inherit="no")]

/**
 *  The number of pixels between the container's right border and its content 
 *  area.
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="paddingRight", type="Number", format="Length", inherit="no")]

/**
 *  The DataGridColumn class describes a column in a DataGrid control.
 *  There is one DataGridColumn per displayable column, even if a column
 *  is hidden or off-screen.
 *  The data provider items of a DataGrid control 
 *  can contain properties that are not displayed
 *  and, therefore, do not need a DataGridColumn.
 *  A DataGridColumn allows specification of the color and font of the text
 *  in a column; what kind of component displays the data for the column;
 *  whether the column is editable, sortable, or resizable;
 *  and the text for the column header.
 *
 *  <p><strong>Notes:</strong><ul>
 *  <li>A DataGridColumn only holds information about a column;
 *  it is not the parent of the item renderers in the column.</li>
 *  <li>If you specify a DataGridColumn class without a <code>dataField</code>
 *  property, you must specify a <code>sortCompareFunction</code>
 *  property. Otherwise, sort operations may cause run-time errors.</li></ul> 
 *  </p>
 *
 *  @mxml
 *
 *  <p>You use the <code>&lt;mx.DataGridColumn&gt;</code> tag to configure a column
 *  of a DataGrid control.
 *  You specify the <code>&lt;mx.DataGridColumn&gt;</code> tag as a child
 *  of the columns property in MXML.
 *  The <code>&lt;mx.DataGridColumn&gt;</code> tag inherits all of the 
 *  tag attributes of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:DataGridColumn
 *  <b>Properties </b>
 *    dataField="<i>No default</i>"
 *    dataTipField="<i>No default</i>"
 *    dataTipFunction="<i>No default</i>"
 *    editable="true|false"
 *    editorDataField="text"
 *    editorHeightOffset="0"
 *    editorUsesEnterKey="false|true"
 *    editorWidthOffset="0"
 *    editorXOffset="0"
 *    editorYOffset="0"
 *    headerRenderer="DataGridItemRenderer"
 *    headerText="<i>No default</i>"
 *    headerWordWrap="undefined"
 *    imeMode="null"
 *    itemEditor="TextInput"
 *    itemRenderer="DataGridItemRenderer"
 *    labelFunction="<i>No default</i>"
 *    minWidth="20"
 *    rendererIsEditor="false|true"
 *    resizable="true|false"
 *    showDataTips="false|true"
 *    sortable="true|false"
 *    sortCompareFunction="<i>No default</i>"
 *    sortDescending="false|true"
 *    visible="true|false"
 *    width="100"
 *    wordWrap="false|true"
 * 
 *  <b>Styles</b>
 *    backgroundColor="0xFFFFFF"
 *    color="<i>No default.</i>"
 *    disabledColor="0xAAB3B3"
 *    fontAntiAliasType="advanced"
 *    fontFamily="<i>No default</i>"
 *    fontGridFitType="pixel"
 *    fontSharpness="0"
 *    fontSize="<i>No default</i>"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="normal|bold"
 *    headerStyleName="<i>No default</i>"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    textAlign="right|center|left"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *  /&gt;
 *  </pre>
 *  </p>
 *
 *  @see mx.controls.DataGrid
 *
 *  @see mx.styles.CSSStyleDeclaration
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DataGridColumn extends org.apache.royale.html.supportClasses.DataGridColumn // implements IIMESupport
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------


    private static var _defaultItemEditorFactory:IFactory;

    mx_internal static function get defaultItemEditorFactory():IFactory
    {
        if (!_defaultItemEditorFactory)
            _defaultItemEditorFactory = new ClassFactory(TextInput);
        return _defaultItemEditorFactory;
    }

    /**
     *  Constructor.
     *
     *  @param columnName The name of the field in the data provider 
     *  associated with the column, and the text for the header cell of this 
     *  column.  This is equivalent to setting the <code>dataField</code>
     *  and <code>headerText</code> properties.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function DataGridColumn(columnName:String = null)
    {
        super();

        if (columnName)
        {
            dataField = columnName;
            headerText = columnName;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  The DataGrid that owns this column.
     */
    mx_internal var owner:UIComponent;

    /**
     *  @private
     */
    mx_internal var list:UIBase; //BaseEx;
    /**
     *  @private
     */
    mx_internal var explicitWidth:Number;

    /**
     *  @private
     *
     * Columns has complex data field named.
     */
  //  protected var hasComplexFieldName:Boolean = false;

    /**
     *  @private
     *
     * Array of split complex field name derived when set so that it is not derived each time.
     */
   // protected var complexFieldNameComponents:Array;


    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------



    //----------------------------------
    //  headerText
    //----------------------------------

    /**
     *  @private
     *  Storage for the headerText property.
     */
    private var _headerText:String;

    [Bindable("headerTextChanged")]
    [Inspectable(category="General")]

    /**
     *  Text for the header of this column. By default, the DataGrid
     *  control uses the value of the <code>dataField</code> property 
     *  as the header text.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get headerText():String
    {
        return (_headerText != null) ? _headerText : dataField;
    }

    /**
     *  @private
     */
    public function set headerText(value:String):void
    {
        _headerText = value;
        label = value;
        dispatchEvent(new Event("headerTextChanged"));
    }


    //----------------------------------
    //  rendererIsEditor
    //----------------------------------

    [Inspectable(category="General", defaultValue="false")]

    /**
     *  A flag that indicates that the item renderer is also an item editor.
     *  If this property is <code>true</code>, Flex
     *  ignores the <code>itemEditor</code> property and uses the item
     *  renderer for that item as the editor.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royalesuppresspublicvarwarning
     */
    public var rendererIsEditor:Boolean = false;

    //----------------------------------
    //  labelFunction
    //----------------------------------

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

    private var _labelField:String;
    public function get labelField():String
    {
        return _labelField;
    }

    public function set labelField(value:String):void
    {
        _labelField = value;
    }

    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _labelFunction:Function;

    [Bindable("labelFunctionChanged")]
    [Inspectable(category="Other")]

    /**
     *  A function that determines the text to display in this column.  By default
     *  the column displays the text for the field in the data that matches the
     *  column name.  However, sometimes you want to display text based on
     *  more than one field in the data, or display something that does not
     *  have the format that you want.
     *  In such a case you specify a callback function using <code>labelFunction</code>.
     *
     *  <p>For the DataGrid control, the method signature has the following form:</p>
     *
     *  <pre>labelFunction(item:Object, column:DataGridColumn):String</pre>
     *
     *  <p>Where <code>item</code> contains the DataGrid item object, and
     *  <code>column</code> specifies the DataGrid column.</p>
     *
     *  <p>A callback function might concatenate the firstName and
     *  lastName fields in the data, or do some custom formatting on a Date,
     *  or convert a number for the month into the string for the month.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelFunction():Function
    {
        return _labelFunction;
    }

    /**
     *  @private
     */
    public function set labelFunction(value:Function):void
    {
        _labelFunction = value;
    }

    //----------------------------------
    //  width
    //----------------------------------

    /**
     *  @private
     *  Storage for the width property.
     */
    private var _width:Number = 100;

    [Bindable("widthChanged")]
    [Inspectable(category="General", defaultValue="100")]

    /**
     *  The width of the column, in pixels. 
     *  If the DataGrid's <code>horizontalScrollPolicy</code> property 
     *  is <code>false</code>, all visible columns must fit in the displayable 
     *  area, and the DataGrid will not always honor the width of
     *  the columns if the total width of the columns is too
     *  small or too large for the displayable area.
     *
     *  @default 100
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get width():Number
    {
        return _width;
    }

    /**
     *  @private
     */
    public function set width(value:Number):void
    {
        // otherwise, just store the size
        _width = value;
    }
    
    //----------------------------------
    //  minWidth
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the width property.
     */
    private var _minWidth:Number = 20;
    
    [Inspectable(category="General", defaultValue="20")]
    
    /**
     *  The width of the column, in pixels. 
     *  If the DataGrid's <code>horizontalScrollPolicy</code> property 
     *  is <code>false</code>, all visible columns must fit in the displayable 
     *  area, and the DataGrid will not always honor the width of
     *  the columns if the total width of the columns is too
     *  small or too large for the displayable area.
     *
     *  @default 100
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minWidth():Number
    {
        return _minWidth;
    }
    
    /**
     *  @private
     */
    public function set minWidth(value:Number):void
    {
        _minWidth = value;
    }


    public function get textAlign():Object
    {
        trace("textAlign not implemented");
        return 0;
    }
    public function set textAlign(value:Object):void
    {
        trace("textAlign not implemented");
    }

    //----------------------------------
    //  wordWrap
    //----------------------------------

    /**
     *  @private
     *  Storage for the wordWrap property.
     */
    private var _wordWrap:*;

    [Inspectable(category="Advanced")]

    /**
     *  Set to <code>false</code> to wrap the text in a row of this column
     *  because it does not fit on one line
     *  If <code>undefined</code>, the AdvancedDataGrid control's <code>wordWrap</code> property 
     *  is used.
     *
     *  @default undefined
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get wordWrap():*
    {
        return _wordWrap;
    }

    /**
     *  @private
     */
    public function set wordWrap(value:*):void
    {
        _wordWrap = value;

       /*  if (owner)
        {
            owner.invalidateList();
        } */
    }
    //----------------------------------
    //  sortDescending
    //----------------------------------
    private var _sortDescending:Boolean = false;

    [Inspectable(category="General")]
    public function get sortDescending():Boolean{
        return _sortDescending
    }
    public function set sortDescending(value:Boolean):void{
        _sortDescending = value;
    }

    /**
     *  @private
     *  The zero-based index of this column as it is displayed in the grid.
     *  It is not related to the structure of the data being displayed.
     *  In MXML, the default order of the columns is the order of the
     *  <code>mx:DataGridColumn</code> tags.
     */
    mx_internal var colNum:Number;



    //----------------------------------
    //  resizable
    //----------------------------------

    /**
     *  Set to <code>true</code> if the user is allowed to resize
     *  the width of the column.
     *  If <code>true</code>, the user can drag the grid lines between
     *  the column headers to resize the column.
     *
     *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    private var _resizable:Boolean = true;

    [Inspectable(category="General")]
    public function get resizable():Boolean {
        return _resizable;
    }
    public function set resizable(value:Boolean):void {
        _resizable  = value;
    }

    //----------------------------------
    //  showDataTips
    //----------------------------------

    /**
     *  @private
     *  Storage for the showDataTips property.
     */
    private var _showDataTips:*;

    [Inspectable(category="Advanced")]

    /**
     *  Set to <code>true</code> to show data tips in the column.
     *  If <code>true</code>, datatips are displayed for text in the rows. Datatips
     *  are tooltips designed to show the text that is too long for the row.
     *
     *  @default false
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get showDataTips():*
    {
        return _showDataTips;
    }

    /**
     *  @private
     */
    public function set showDataTips(value:*):void
    {
        _showDataTips = value;

        /*  if (owner)
         {
             owner.invalidateList();
         } */
    }

    //----------------------------------
    //  sortable
    //----------------------------------



    /**
     *  Set to <code>true</code> to indicate that the user can click on the
     *  header of this column to sort the data provider.
     *  If this property and the AdvancedDataGrid <code>sortableColumns</code> property
     *  are both <code>true</code>, the AdvancedDataGrid control dispatches a
     *  <code>headerRelease</code> event when a user releases the mouse button
     *  on this column's header.
     *  If no other handler calls the <code>preventDefault()</code> method on
     *  the <code>headerRelease</code> event, the <code>dataField</code>
     *  property or <code>sortCompareFunction</code> in the column is used
     *  to reorder the items in the data provider.
     *
     *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    private var _sortable:Boolean = true;

    [Inspectable(category="General")]
    public function get sortable():Boolean{
        return _sortable;
    }

    public function set sortable(value:Boolean):void{
        _sortable = value;
    }

    //----------------------------------
    //  sortCompareFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the sortCompareFunction property.
     */
    private var _sortCompareFunction:Function;

    [Bindable("sortCompareFunctionChanged")]
    [Inspectable(category="Advanced")]

    /**
     *
     *  A callback function that gets called when sorting the data in
     *  the column.  If this property is not specified, the sort tries
     *  to use a basic string or number sort on the data.
     *  If the data is not a string or number or if the <code>dataField</code>
     *  property is not a valid property of the data provider, the sort does
     *  not work or will generate an exception.
     *  If you specify a value of the <code>labelFunction</code> property,
     *  you typically also provide a function to the <code>sortCompareFunction</code> property,
     *  unless sorting is not allowed on this column.
     *  That means you specify a function when the value from the column's <code>dataField</code>
     *  does not sort in the same way as the computed value from the <code>labelFunction</code> property.
     *
     *  <p>The AdvancedDataGrid control uses this function to sort the elements of the data
     *  provider collection. The function signature of
     *  the callback function takes two parameters and has the following form:</p>
     *
     *  <pre>mySortCompareFunction(obj1:Object, obj2:Object):int </pre>
     *
     *  <p><code>obj1</code> &#x2014; A data element to compare.</p>
     *
     *  <p><code>obj2</code> &#x2014; Another data element to compare with <code>obj1</code>.</p>
     *
     *  <p>The function should return a value based on the comparison
     *  of the objects: </p>
     *  <ul>
     *    <li>-1 if obj1 should appear before obj2 in ascending order. </li>
     *    <li>0 if obj1 = obj2. </li>
     *    <li>1 if obj1 should appear after obj2 in ascending order.</li>
     *  </ul>
     *
     *  <p><strong>Note:</strong> The <code>obj1</code> and
     *  <code>obj2</code> parameters are entire data provider elements and not
     *  just the data for the item.</p>
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get sortCompareFunction():Function
    {
        return _sortCompareFunction;
    }

    /**
     *  @private
     */
    public function set sortCompareFunction(value:Function):void
    {
        _sortCompareFunction = value;

        //  dispatchEvent(new Event("sortCompareFunctionChanged"));
    }




    //----------------------------------
    //  visible
    //----------------------------------

    /**
     *  @private
     *  Storage for the visible property.
     */
    private var _visible:Boolean = true;

    [Inspectable(category="General", defaultValue="true")]

    /**
     *  If <code>true</code>, the column is visible.
     *  Set to <code>false</code> to hide the column.
     *
     *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get visible():Boolean
    {
        return _visible;
    }

    /**
     *  @private
     */
    public function set visible(value:Boolean):void
    {
        if (_visible != value)
        {
            _visible = value;

            if (owner)
            {
               // (owner as AdvancedDataGrid).columnsInvalid();
                owner.dispatchEvent(new Event("columnsInvalid"));
                // columns invisible at init don't get a dataprovider so
                // force assignment by faking a dp change
               // (owner as AdvancedDataGrid).model.dispatchEvent(new Event("dataProviderChanged"));
                owner.model.dispatchEvent(new Event("dataProviderChanged"));

                //owner.invalidateProperties();
                //owner.invalidateSize();
                //owner.invalidateList();



            }
        }
    }
        private var o:Object;
		public function getStyle(styleProp:String):*
        {
        var v:*;
        
        if (o == null)
        {
            if (defaultFactory != null)
            {
                defaultFactory.prototype = {};
                o = new defaultFactory();
            }
        }
        if (o != null)
        {
            v = o[styleProp];
            if (v !== undefined)
                return v;
        }
        var values:Object = ValuesManager.valuesImpl["values"]; // assume AllCSSValuesImpl
        
        return v;
        }
		
		private var _defaultFactory:Function;
		public function get defaultFactory():Function
       {
         return _defaultFactory;
       }
    
    /**
     *  @private
     */ 
        public function set defaultFactory(f:Function):void
       {
         _defaultFactory = f;
       }
       
       private var _headerRenderer:IFactory;
		
       /**
	*  The itemRenderer class or factory to use to make instances of itemRenderers for
	*  display of data.
	*
        *  @langversion 3.0
	*  @playerversion Flash 10.2
	*  @playerversion AIR 2.6
	*  @productversion Royale 0.0
	*/
	
	public function get headerRenderer():IFactory
	{
	   return _headerRenderer;
	}
	public function set headerRenderer(value:IFactory):void
	{
	  _headerRenderer = value;
	  trace("DataGridColumn.headerRenderer is not implemented");
	}
	
	        //----------------------------------
		//  editable
		//----------------------------------

		private var _editable:Boolean = true;

		[Inspectable(category="General")]

		/**
		 *  A flag that indicates whether the items in the column are editable.
		 *  If <code>true</code>, and the DataGrid's <code>editable</code>
		 *  property is also <code>true</code>, the items in a column are 
		 *  editable and can be individually edited
		 *  by clicking on an item or by navigating to the item by using the 
		 *  Tab and Arrow keys.
		 *
		 *  @default true
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get editable():Boolean
		{
			return _editable;
		}

		/**
		 *  @private
		 */
		public function set editable(value:Boolean):void
		{
			_editable = value;
		}
}

}
