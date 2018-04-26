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

package mx.charts
{

/* import flash.events.Event;

import mx.charts.chartClasses.AxisBase;
import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.IAxis;
import mx.collections.ArrayCollection;
import mx.collections.CursorBookmark;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
use namespace mx_internal; */
import mx.collections.ICollectionView;

/**
 *  The CategoryAxis class lets charts represent data
 *  grouped by a set of discrete values along an axis.
 *  You typically use the CategoryAxis class to define
 *  a set of labels that appear along an axis of a chart.
 *  For example, charts that render data according to City,
 *  Year, Business unit, and so on.
 *  
 *  <p>You are not required to explicitly set the <code>dataProvider</code> property
 *  on a CategoryAxis. A CategoryAxis used in a chart inherits its
 *  <code>dataProvider</code> property from the containing chart.</p>
 *  
 *  <p>While you can use the same data provider to provide data
 *  to the chart and categories to the CategoryAxis, a CategoryAxis
 *  can optimize rendering if its data provider is relatively static.
 *  If possible, ensure that the categories are relatively static
 *  and that changing data is stored in separate data providers.</p>
 *  
 *  <p>The <code>dataProvider</code> property can accept
 *  either an array of strings or an array of records (Objects)
 *  with a property that specifies the category name.
 *  If you specify a <code>categoryField</code> property,
 *  the CategoryAxis assumes that the data provider is an array of Objects.
 *  If the value of the <code>categoryField</code> property is <code>null</code>,
 *  the CategoryAxis assumes that the data provider is an array of Strings.</p>
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:CategoryAxis&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:CategoryAxis
 *    <strong>Properties</strong>
 *    categoryField="null"
 *    dataFunction="<i>No default</i>"
 *    dataProvider="<i>No default</i>"
 *    labelFunction="<i>No default</i>"
 *    padding="<i>Default depends on chart type</i>"
 *    ticksBetweenLabels="<i>true</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/HLOCChartExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class CategoryAxis 
{
//extends AxisBase implements IAxis
   
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function CategoryAxis()
    {
       /*  super();

        workingDataProvider = new ArrayCollection(); */
    }

	// displayName property copied from AxisBase
    //----------------------------------
    //  displayName
    //----------------------------------

    /**
     *  @private
     *  Storage for the name property.
     */
    private var _displayName:String = "";

    [Inspectable(category="Display")]

    /**
     *  @copy mx.charts.chartClasses.IAxis#displayName
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get displayName():String
    {
        return _displayName;
    }
    
    /**
     *  @private
     */
    public function set displayName(value:String):void
    {
        _displayName = value;
    }
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    

    //----------------------------------
    //  categoryField
    //----------------------------------

    /**
     *  @private
     *  Storage for the categoryField property.
     */
    private var _categoryField:String = "";
    
    [Inspectable(category="General")]
    
    /**
     *  Specifies the field of the data provider
     *  containing the text for the labels.
     *  If this property is <code>null</code>, CategoryAxis assumes 
     *  that the dataProvider contains an array of Strings.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get categoryField():String
    {
        return _categoryField;
    }
    
    /**
     *  @private
     */
    public function set categoryField(value:String):void
    {
        _categoryField = value;

     //   collectionChangeHandler();
    }
    
   

    //----------------------------------
    //  dataProvider
    //----------------------------------

    /**
     *  @private
     *  Storage for the dataProvider property.
     */
    private var _dataProvider:ICollectionView;
    
    /**
     *  @private
     */
    private var _userDataProvider:Object;
    
    [Inspectable(category="General")]
    
    /**
     *  Specifies the data source containing the label names.
     *  The <code>dataProvider</code> can be an Array of Strings, an Array of Objects,
     *  or any object that implements the IList or ICollectionView interface.
     *  If the <code>dataProvider</code> is an Array of Strings,
     *  ensure that the <code>categoryField</code> property
     *  is set to <code>null</code>. 
     *  If the dataProvider is an Array of Objects,
     *  set the <code>categoryField</code> property
     *  to the name of the field that contains the label text.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get dataProvider():Object
    {
        return _dataProvider;
    }
    
    /**
     *  @private
     */
    public function set dataProvider(value:Object):void
    {
       /*  _userDataProvider = value;

        if (_userDataProvider != null)
            workingDataProvider = _userDataProvider;
        else
            workingDataProvider = _chartDataProvider; */
    }

    //----------------------------------
    //  labelFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _labelFunction:Function = null;
    
    [Inspectable(category="General")]
    
    /**
     *  Specifies a function that defines the labels that are generated
     *  for each item in the CategoryAxis's <code>dataProvider</code>.
     *  If no <code>labelFunction</code> is provided,
     *  the axis labels default to the value of the category itself.
     *
     *  <p>The <code>labelFunction</code> method for a CategoryAxis
     *  has the following signature:</p>
     *  <pre>
     *  function <i>function_name</i>(<i>categoryValue</i>:Object, <i>previousCategoryValue</i>:Object, <i>axis</i>:CategoryAxis, <i>categoryItem</i>:Object):String { ... }
     *  </pre>
     *  
     *  <p>Where:</p>
     *  <ul>
     *   <li><code><i>categoryValue</i></code> is the value of the category to be represented.</li>
     *   <li><code><i>previousCategoryValue</i></code> is the value of the previous category on the axis.</li>
     *   <li><code><i>axis</i></code> is the CategoryAxis being rendered.</li>
     *   <li><code><i>categoryItem</i></code> is the item from the <code>dataProvider</code> 
     *     that is being represented.</li>
     *  </ul>
     *  
     *  <p>Flex displays the returned String as the axis label.</p>
     * 
     *  <p>If the <code>categoryField</code> property is not set, the value
     *  will be the same as the <code>categoryValue</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
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

     //   invalidateCategories();
    }
    
    

    /**
     *  @copy mx.charts.chartClasses.IAxis#formatForScreen()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function formatForScreen(value:Object):String    
    {
       /*  if (value is Number && value < _categoryValues.length)
        {
            var catValue:Object = _categoryValues[Math.round(Number(value))];
            return catValue == null ? value.toString() : catValue.toString();
        }
		*/ 
        return value.toString();    
    }

    
    
}

}
