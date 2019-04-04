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

import org.apache.royale.events.Event;

import mx.charts.chartClasses.AxisBase;
import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.IAxis;
import mx.collections.ArrayCollection;
import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
use namespace mx_internal;

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
 *  @productversion Flex 3
 */
public class CategoryAxis extends AxisBase implements IAxis
{
//    include "../core/Version.as";

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
     *  @productversion Flex 3
     */
    public function CategoryAxis()
    {
        super();

        workingDataProvider = new ArrayCollection();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private var _cursor:IViewCursor;
    
    /**
     *  @private
     */
    private var _catMap:Object;

    /**
     *  @private
     */
    private var _categoryValues:Array /* of Object */;
    
    /**
     *  @private
     */
    private var _labelsMatchToCategoryValuesByIndex:Array /* of AxisLabel */;

    /**
     *  @private
     */
    private var _cachedMinorTicks:Array /* of Number */ = null; 
    
    /**
     *  @private
     */
    private var _cachedTicks:Array /* of Number */ = null;  

    /**
     *  @private
     */
    private var _labelSet:AxisLabelSet;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  chartDataProvider
    //----------------------------------

    /**
     *  @private
     *  Storage for the chartDataProvider property.
     */
    private var _chartDataProvider:Object;
    
    /**
     *  @private
     */
    override public function set chartDataProvider(value:Object):void
    {
		if(_chartDataProvider != value)
		{
        	_chartDataProvider = value;

	        if (!_userDataProvider)
    	        workingDataProvider = _chartDataProvider;
		}
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  baseline
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get baseline():Number
    {
        return -_padding;
    }

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
     *  @productversion Flex 3
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

        collectionChangeHandler();
    }
    
    //---------------------------------
    // dataFunction
    //---------------------------------
    
    [Bindable]
    [Inspectable(category="General")]
    
    /**
     *  @private
     * Storage for dataFunction property
     */
     private var _dataFunction:Function = null;
     
    /**
     * Specifies a method that returns the value that should be used as
     * categoryValue for current item.If this property is set, the return 
     * value of the custom data function takes precedence over 
     * <code>categoryField</code>
     * 
     * <p>The custom <code>dataFunction</code> has the following signature:
     *  
     * <pre>
     * <i>function_name</i> (axis:CategoryAxis, item:Object):Object { ... }
     * </pre>
     * 
     * <code>axis</code> is the current axis that uses this <code>dataFunction</code>
     * <code>item</code> is the item in the dataProvider that is considered.
     * This function returns an object.
     * </p>
     *  
     * <p>An example usage of a customized <code>dataFunction</code> is to return a value
     * from a dataProvider that has items with nested fields</p>
     *   
     * @example
     * <pre>
     * public function myFunction(axis:CategoryAxis,item:Object):Object {
     *      return(item.Country.State);
     * }     
     * </pre>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dataFunction():Function
    {
        return _dataFunction;
    }
    
    /**
     *  @private
     */
    public function set dataFunction(value:Function):void
    {
        _dataFunction = value;
        collectionChangeHandler();
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
     *  @productversion Flex 3
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
        _userDataProvider = value;

        if (_userDataProvider != null)
            workingDataProvider = _userDataProvider;
        else
            workingDataProvider = _chartDataProvider;
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

        invalidateCategories();
    }
    
    //----------------------------------
    //  minorTicks (private)
    //----------------------------------
 
    /**
     *  @private
     */
    private function get minorTicks():Array /* of Number */
    {
        if (!_cachedMinorTicks)
        {
            _cachedMinorTicks = [];

            var n:int;
            var min:Number;
            var max:Number;
            var alen:Number;
            var i:Number;
            
            if (_ticksBetweenLabels == false)
            {
                n = _categoryValues.length;
                min = -_padding;
                max = n - 1 + _padding;
                alen = max - min;
                
                var start:Number = min <= -0.5 ? 0 : 1;
                var end:Number = max >= n - 0.5 ? n : n - 1
                
                for (i = start; i <= end; i++) // <= to draw final tick
                {
                    _cachedMinorTicks.push((i - 0.5 - min) / alen);
                }
            }
            else
            {
                n = _categoryValues.length;
                min = -_padding;
                max = n - 1 + _padding;
                alen = max - min;
                
                for (i = 0; i < n; i++) // <= to draw final tick
                {
                    _cachedMinorTicks.push((i - min) / alen);
                }
            }
        }

        return _cachedMinorTicks;
    }

    //----------------------------------
    //  padding
    //----------------------------------

    /**
     *  @private
     *  Storage for the padding property.
     */
    private var _padding:Number = 0.5;
    
    [Inspectable(category="General")]

    /**
     *  Specifies the padding added to either side of the axis
     *  when rendering data on the screen.
     *  Set to 0 to map the first category to the
     *  very beginning of the axis and the last category to the end.
     *  Set to 0.5 to leave padding of half the width
     *  of a category on the axis between the beginning of the axis
     *  and the first category and between the last category
     *  and the end of the axis.
     *  
     *  <p>This is useful for chart types that render beyond the bounds
     *  of the category, such as columns and bars.
     *  However, when used as the horizontalAxis in a LineChart or AreaChart,
     *  it is reset to 0.</p>
     *  
     *  @default 0.5
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get padding():Number
    {
        return _padding;
    }
    
    /**
     *  @private
     */
    public function set padding(value:Number):void
    {
        _padding = value;

        invalidateCategories();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }
    
    //----------------------------------
    //  ticksBetweenLabels
    //----------------------------------

    /**
     *  @private
     *  Storage for the tickBetweenLabels property.
     */
    private var _ticksBetweenLabels:Boolean = true;
    
    [Inspectable]

    /**
     *  Specifies the location of major tick marks on the axis,
     *  relative to the category labels.
     *  If <code>true</code>, tick marks (and any associated grid lines)
     *  appear between the categories.
     *  If <code>false</code>, tick marks appear in the middle of the category,
     *  aligned with the label.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get ticksBetweenLabels():Boolean
    {
        return _ticksBetweenLabels;
    }

    /**
     *  @private
     */
    public function set ticksBetweenLabels(value:Boolean):void
    {
        _ticksBetweenLabels = value;
    }

    //----------------------------------
    //  workingDataProvider
    //----------------------------------

    /**
     *  @private
     */
    private function set workingDataProvider(value:Object):void
    {
        if (_dataProvider != null)
        {
            _dataProvider.removeEventListener(
                CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
        }
        
        if (value is Array)
        {
            value = new ArrayCollection(value as Array);
        }
        else if (value is ICollectionView)
        {
        }
        else if (value is XMLList)
        {
            value = new XMLListCollection(XMLList(value));
        }
        else if (value != null)
        {
            value = new ArrayCollection([ value ]);
        } 
        else 
        {
            value = new ArrayCollection();
        }
            
        _dataProvider = ICollectionView(value);

        _cursor = value.createCursor();

        if (_dataProvider) 
        {
            // weak listeners to collections and dataproviders
            _dataProvider.addEventListener(
                CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler/*, false, 0, true*/);
        }

        collectionChangeHandler();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @copy mx.charts.chartClasses.IAxis#mapCache()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function mapCache(cache:Array /* of ChartItem */, field:String,
                             convertedField:String,
                             indexValues:Boolean = false):void
    {
        update();

        var n:int = cache.length;
        
        // Find the first non null item in the cache so we can determine type.
        // Since these initial values are null,
        // we can safely skip assigning values for them.
        for (var i:int = 0; i < n; i++)
        {
            if (cache[i][field] != null)
                break;
        }
        if (i == n)
            return;
        
        var value:Object = cache[i][field]
        if (value is XML ||
                 value is XMLList)
        {
            for (; i < n; i++)
            {
                cache[i][convertedField] = _catMap[cache[i][field].toString()];             
            }
        }
        else if ((value is Number || value is int || value is uint) &&
                 indexValues == true)
        {
            for (i = 0; i < n; i++)
            {
                var v:Object = cache[i];
                v[convertedField] = v[field];
            }
        }
        else
        {
            for (; i < n; i++)
            {
                cache[i][convertedField] = _catMap[cache[i][field]];                
            }
        }
        
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#filterCache()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function filterCache(cache:Array /* of ChartItem */, field:String,
                                filteredField:String):void
    {
        update();

        // Our bounds are the categories, plus/minus padding,
        // plus a little fudge factor to account for floating point errors.
        var computedMaximum:Number = _categoryValues.length - 1 +
                                     _padding + 0.000001;
        var computedMinimum:Number = -_padding - 0.000001;
        
        var n:int = cache.length;
        for (var i:int = 0; i < n; i++)
        {
            var v:Number =  cache[i][field];
            cache[i][filteredField] = v >= computedMinimum &&
                                      v < computedMaximum ?
                                      v :
                                      NaN;
        }
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#transformCache()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function transformCache(cache:Array /* of ChartItem */, field:String,
                                   convertedField:String):void
    {
        update();

        var min:Number = -_padding;
        var max:Number = _categoryValues.length - 1 + _padding;
        var alen:Number = max - min;

        var n:int = cache.length;
        for (var i:int = 0; i < n; i++)
        {
            cache[i][convertedField] = (cache[i][field] - min) / alen;
        }
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#invertTransform()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function invertTransform(value:Number):Object
    {
        update();

        var min:Number = -_padding;
        var max:Number = _categoryValues.length - 1 + _padding;
        var alen:Number = max - min;

        return _categoryValues[Math.round((value * alen) + min)];
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#formatForScreen()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function formatForScreen(value:Object):String    
    {
        if (value is Number && value < _categoryValues.length)
        {
            var catValue:Object = _categoryValues[Math.round(Number(value))];
            return catValue == null ? value.toString() : catValue.toString();
        }

        return value.toString();    
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#getLabelEstimate()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getLabelEstimate():AxisLabelSet
    {
        update();

        return _labelSet;
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#preferDropLabels()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function preferDropLabels():Boolean
    {
        return false;
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#getLabels()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getLabels(minimumAxisLength:Number):AxisLabelSet
    {
        update();

        return _labelSet;
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#reduceLabels()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function reduceLabels(intervalStart:AxisLabel,intervalEnd:AxisLabel):AxisLabelSet
    {
        var skipCount:int = _catMap[intervalEnd.value] - _catMap[intervalStart.value] + 1;
        
        if (skipCount <= 0)
            return null;
            
        var newLabels:Array /* of AxisLabel */ = [];
        var newTicks:Array /* of Number */ = [];
        
        var min:Number = -_padding;
        var max:Number = _categoryValues.length - 1 + _padding;
        var alen:Number = (max-min);
		
		var n:int  = _categoryValues.length;
		for (var i:int = 0; i < n; i += skipCount)
        {
            newLabels.push(_labelsMatchToCategoryValuesByIndex[i]);
            newTicks.push(_labelsMatchToCategoryValuesByIndex[i].position);
        }
        
        var axisLabelSet:AxisLabelSet = new AxisLabelSet();
        axisLabelSet.labels = newLabels;
        axisLabelSet.minorTicks = minorTicks;
        axisLabelSet.ticks = generateTicks();
        return axisLabelSet;
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#update()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function update():void
    {
        if (!_labelSet)
        {
            var prop:Object;
            
            _catMap = {};
            _categoryValues = [];
            _labelsMatchToCategoryValuesByIndex = [];

            var categoryItems:Array = [];
            var i:int;
            
            if (_dataFunction != null)
            {
                _cursor.seek(CursorBookmark.FIRST);
                i = 0;
                while (!_cursor.afterLast)
                {
                    categoryItems[i] = _cursor.current;
                    prop = dataFunction(this,categoryItems[i]);
                    if (prop)
                      _catMap[prop.toString()] = i;                   
                    _categoryValues[i] = prop;
                    i++;
                    _cursor.moveNext()
                }
            }
            
            else if (_categoryField == "")
            {
                _cursor.seek(CursorBookmark.FIRST);
                i = 0;
                while (!_cursor.afterLast)
                {
                    prop = _cursor.current;
                    if (prop != null)
                        _catMap[prop.toString()] = i;                   
                    _categoryValues[i] = categoryItems[i] = prop;
                    _cursor.moveNext();
                    i++;
                }
            }
            else
            {
                _cursor.seek(CursorBookmark.FIRST);
                i = 0;
                while (!_cursor.afterLast)
                {
                    categoryItems[i] = _cursor.current;
                    if (categoryItems[i] && _categoryField in categoryItems[i])
                    {
                        prop = categoryItems[i][_categoryField];
                        if (prop != null)
                            _catMap[prop.toString()] = i;                   
                        _categoryValues[i] = prop;
                    }
                    else
                    {
                        _categoryValues[i] = null;
                    }
                    i++;
                    _cursor.moveNext()
                }
            }

            var axisLabels:Array /* of AxisLabel */ = [];
            
            var min:Number = -_padding;
            var max:Number = _categoryValues.length - 1 + _padding;
            var alen:Number = max - min;
            var label:AxisLabel;

            var n:int = _categoryValues.length;
            if (_labelFunction != null)
            {
                var previousValue:Object = null;
                for (i = 0; i < n; i++)
                {
                    if (_categoryValues[i] == null)
                        continue;
                        
                    label = new AxisLabel((i - min) / alen, _categoryValues[i],
                        _labelFunction(_categoryValues[i], previousValue,
                        this, categoryItems[i]));
                    _labelsMatchToCategoryValuesByIndex[i] = label;
                    axisLabels.push(label);

                    previousValue = _categoryValues[i];
                }
            }
            else
            {
                for (i = 0; i < n; i++)
                {
                    if (!_categoryValues[i])
                        continue;
                    
                    label = new AxisLabel((i - min) / alen, _categoryValues[i],
                        _categoryValues[i].toString());
                    _labelsMatchToCategoryValuesByIndex[i] = label;
                    axisLabels.push(label);
                }               
            }

            _labelSet = new AxisLabelSet();
            _labelSet.labels = axisLabels;
            _labelSet.accurate = true;
            _labelSet.minorTicks = minorTicks;
            _labelSet.ticks = generateTicks();          
        }
    }

    /**
     *  @private
     */
    private function generateTicks():Array /* of Number */
    {
        if (!_cachedTicks)
        {
            _cachedTicks = [];

            var n:int;
            var min:Number;
            var max:Number;
            var alen:Number;
            var i:Number;
            
            if (_ticksBetweenLabels == false)
            {
                n = _categoryValues.length;
                min = -_padding;
                max = n - 1 + _padding;
                alen = max - min;
                
                for (i = 0; i < n; i++) // <= to draw final tick
                {
                    _cachedTicks.push((i - min) / alen);
                }
            }
            else
            {
                _cachedMinorTicks = [];
                
                n = _categoryValues.length;
                min = -_padding;
                max = n - 1 + _padding;
                alen = max - min;
                
                var start:Number = _padding < 0.5 ? 0.5 : -0.5;
                var end:Number = _padding < 0.5 ? n - 1.5 : n - 0.5;
                
                for (i = start; i <= end; i += 1)
                {
                    _cachedTicks.push((i - min) / alen);
                }
            }
        }

        return _cachedTicks;
    }
    
    /**
     *  @private
     */
    private function invalidateCategories():void
    {
        _labelSet = null;
        _cachedMinorTicks = null;
        _cachedTicks = null;

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }
    
    /**
     *  @private
     */
    mx_internal function getCategoryValues():Array /* of Object */
    {
        return _categoryValues;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function collectionChangeHandler(event:CollectionEvent = null):void
    {
        if (event && event.kind == CollectionEventKind.RESET)
            _cursor = _dataProvider.createCursor();

        invalidateCategories();
    }
    
}

}
