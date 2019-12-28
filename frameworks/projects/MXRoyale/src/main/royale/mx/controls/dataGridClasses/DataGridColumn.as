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
use namespace mx_internal;

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

    public var sortDescending:Boolean = false;
    
    mx_internal var owner:UIComponent;
    
    /**
     *  @private
     *  The zero-based index of this column as it is displayed in the grid.
     *  It is not related to the structure of the data being displayed.
     *  In MXML, the default order of the columns is the order of the
     *  <code>mx:DataGridColumn</code> tags.
     */
    mx_internal var colNum:Number;
    

}

}
