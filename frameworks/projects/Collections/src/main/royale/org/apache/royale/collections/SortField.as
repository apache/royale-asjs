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

package org.apache.royale.collections {
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;



/**
 *  Provides the sorting information required to establish a sort on a field
 *  or property in a collection view.
 *
 *  The SortField class is meant to be used with the Sort class.
 *
 *  Typically the sort is defined for collections of complex items, that is
 *  items in which the sort is performed on properties of those objects.
 *  As in the following example:
 *
 *  <pre><code>
 *     var col:ICollectionView = new ArrayListView();
 *     col.addItem({first:"Anders", last:"Dickerson"});
 *     var sort:Sort = new Sort();
 *     sort.fields = [new SortField("first", true)];
 *     col.sort = sort;
 *  </code></pre>
 *
 *  There are situations in which the collection contains simple items, like
 *  <code>String</code>, <code>Date</code>, <code>Boolean</code>, etc.
 *  In this case, sorting should be applied to the simple type directly.
 *  When constructing a sort for this situation only a single sort field is
 *  required and should not have a <code>name</code> specified.
 *  For example:
 *
 *  <pre><code>
 *     var col:ICollectionView = new ArrayListView();
 *     col.addItem("California");
 *     col.addItem("Arizona");
 *     var sort:Sort = new Sort();
 *     sort.fields = [new SortField(null, true)];
 *     col.sort = sort;
 *  </code></pre>
 *
 *  <p>By default the comparison provided by the SortField class does
 *  not provide correct language specific
 *  sorting for strings.  For this type of sorting please see the
 *  <code>spark.collections.Sort</code> and
 *  <code>spark.collections.SortField</code> classes.</p>
 *
 *  Note: to prevent problems like
 *  <a href="https://issues.apache.org/jira/browse/FLEX-34853">FLEX-34853</a>
 *  it is recommended to use SortField
 *  instances as immutable objects (by not changing their state).
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:SortField&gt;</code> tag has the following attributes:</p>
 *
 *  <pre>
 *  &lt;mx:SortField
 *  <b>Properties</b>
 *  caseInsensitive="false"
 *  compareFunction="<em>Internal compare function</em>"
 *  descending="false"
 *  name="null"
 *  numeric="null"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.collections.ICollectionView
 *  @see mx.collections.Sort
 *  @see spark.collections.Sort
 *  @see spark.collections.SortField

 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class SortField extends EventDispatcher implements ISortField
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
     *  @param name The name of the property that this field uses for
     *              comparison.
     *              If the object is a simple type, pass <code>null</code>.
     *  @param caseInsensitive When sorting strings, tells the comparator
     *              whether to ignore the case of the values.
     *  @param descending Tells the comparator whether to arrange items in
     *              descending order.
     *  @param numeric Tells the comparator whether to compare sort items as
     *              numbers, instead of alphabetically.
     *  @param sortCompareType Gives an indication to SortField which of the
     *              default compare functions to use.
     *  @param customCompareFunction Use a custom function to compare the
     *              objects based on this SortField.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function SortField(name:String = null,
							  caseInsensitive:Boolean = false,
							  descending:Boolean = false,
							  numeric:Object = null,
							  sortCompareType:String = null,
							  customCompareFunction:Function = null)
    {
        super();

        _name = name;
        _caseInsensitive = caseInsensitive;
        _descending = descending;
        _numeric = numeric;
        _sortCompareType = sortCompareType;

        if(customCompareFunction != null)
        {
            _compareFunction = customCompareFunction;
        }
        else if (updateSortCompareType() == false)
        {
            _compareFunction = stringCompare;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //---------------------------------
    //  arraySortOnOptions
    //---------------------------------

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get arraySortOnOptions():int
    {
        if (usingCustomCompareFunction
                || _name == null
                || _compareFunction == xmlCompare
                || _compareFunction == dateCompare)
        {
            return -1;
        }
        var options:int = 0;
        if (_caseInsensitive) options |= Array.CASEINSENSITIVE;
        if (_descending) options |= Array.DESCENDING;
        if (_numeric == true || _compareFunction == numericCompare) options |= Array.NUMERIC;
        return options;
    }

    //---------------------------------
    //  caseInsensitive
    //---------------------------------

    /**
     *  @private
     *  Storage for the caseInsensitive property.
     */
    private var _caseInsensitive:Boolean;


    //---------------------------------
    //  compareFunction
    //---------------------------------

    /**
     *  @private
     *  Storage for the compareFunction property.
     */
    private var _compareFunction:Function;

    [Inspectable(category="General")]

    /**
     *  The function that compares two items during a sort of items for the
     *  associated collection. If you specify a <code>compareFunction</code>
     *  property in an <code>ISort</code> object, Flex ignores any
     *  <code>compareFunction</code> properties of the ISort's
     *  <code>SortField</code> objects.
     *
     *  <p>The compare function must have the following signature:</p>
     *
     *  <p><code>function myCompare(a:Object, b:Object):int</code></p>
     *
     *  <p>This function must return the following values:</p>
     *
     *   <ul>
     *        <li>-1, if the <code>Object a</code> should appear before the
     *        <code>Object b</code> in the sorted sequence</li>
     *        <li>0, if the <code>Object a</code> equals the
     *        <code>Object b</code></li>
     *        <li>1, if the <code>Object a</code> should appear after the
     *        <code>Object b</code> in the sorted sequence</li>
     *  </ul>
     *
     *  <p>The default value is an internal compare function that can perform
     *  a string, numeric, or date comparison in ascending or descending order,
     *  with case-sensitive or case-insensitive string comparisons.
     *  Specify your own function only if you need a need a custom comparison
     *  algorithm. This is normally only the case if a calculated field is
     *  used in a display.</p>
     *
     *  Note if you need language-specific sorting then consider using the
     *  <code>spark.collections.SortField</code> class.
     *
     *  @see spark.collections.SortField
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get compareFunction():Function
    {
        return _compareFunction;
    }



    //---------------------------------
    //  descending
    //---------------------------------

    /**
     *  @private
     *  Storage for the descending property.
     */
    private var _descending:Boolean;


    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get descending():Boolean
    {
        return _descending;
    }


    //---------------------------------
    //  name
    //---------------------------------

    /**
     *  @private
     *  Storage for the name property.
     */
    private var _name:String;

    /**
     *  @inheritDoc
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get name():String
    {
        return _name;
    }


    //---------------------------------
    //  numeric
    //---------------------------------

    /**
     *  @private
     *  Storage for the numeric property.
     */
    private var _numeric:Object;


    /**
     *  @inheritDoc
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get numeric():Object
    {
        return _numeric;
    }



    //---------------------------------
    //  sortCompareType
    //---------------------------------

    /**
     *  @private
     */
    private var _sortCompareType:String = null;

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 11.8
     *  @playerversion AIR 3.8
     *  @productversion Flex 4.11
     */
    [Bindable("sortCompareTypeChanged")]
    public function get sortCompareType():String
    {
        return _sortCompareType;
    }



    //---------------------------------
    //  usingCustomCompareFunction
    //---------------------------------

    private var _usingCustomCompareFunction:Boolean;

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get usingCustomCompareFunction():Boolean
    {
        return _usingCustomCompareFunction;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function initializeDefaultCompareFunction(obj:Object):void
    {
        // if the compare function is not already set then we can set it
        if (!usingCustomCompareFunction)
        {
            if (_sortCompareType)
            {
                //Attempt to set the compare function based on the sortCompareType
                if (updateSortCompareType() == true)
                {
                    return;
                }
            }

            if (_numeric == true)
                _compareFunction = numericCompare;
            else if (_caseInsensitive || _numeric == false)
                _compareFunction = stringCompare;
            else
            {
                // we need to introspect the data a little bit
                var value:Object;
                if (_name)
                {
                    value = getSortFieldValue(obj);
                }
                //this needs to be an == null check because !value will return true
                //where value == 0 or value == false
                if (value == null)
                {
                    value = obj;
                }

                var typ:String = typeof(value);
                switch (typ)
                {
                    case "string":
                        _compareFunction = stringCompare;
                        break;
                    case "object":
                        if (value is Date)
                        {
                            _compareFunction = dateCompare;
                        }
                        else
                        {
                            _compareFunction = stringCompare;
                            var test:String;
                            try
                            {
                                test = value.toString();
                            }
                            catch(error2:Error)
                            {
                            }
                            if (!test || test == "[object Object]")
                            {
                                _compareFunction = nullCompare;
                            }
                        }
                        break;
                    case "xml":
                        _compareFunction = xmlCompare;
                        break;
                    case "boolean":
                    case "number":
                        _compareFunction = numericCompare;
                        break;
                }
            }  // else
        } // if
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function reverse():void
    {
        _descending = !_descending;
    }


    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 11.8
     *  @playerversion AIR 3.8
     *  @productversion Flex 4.11
     */
    public function updateSortCompareType():Boolean
    {
        if (!_sortCompareType)
        {
            return false;
        }


        //Lookup the sortCompareType by its SortFieldCompareTypes value and set the associated compare method.
        switch(_sortCompareType)
        {
            case SortFieldCompareTypes.DATE:
            {
                _compareFunction = dateCompare;

                return true;
            }

            case SortFieldCompareTypes.NULL:
            {
                _compareFunction = nullCompare;

                return true;
            }

            case SortFieldCompareTypes.NUMERIC:
            {
                _compareFunction = numericCompare;

                return true;
            }

            case SortFieldCompareTypes.STRING:
            {
                _compareFunction = stringCompare;

                return true;
            }

            case SortFieldCompareTypes.XML:
            {
                _compareFunction = xmlCompare;

                return true;
            }
        }


        return false;
    }


    public function objectHasSortField(object:Object):Boolean
    {
        return getSortFieldValue(object) !== undefined;
    }


    //--------------------------------------------------------------------------
    //
    //  Protected Methods
    //
    //--------------------------------------------------------------------------

    protected function getSortFieldValue(obj:Object):*
    {
        var result:* = undefined;

        try
        {
            //@todo need to support js-release mode here for public vars.
            result = obj[_name];
        }
        catch(error:Error)
        {
        }

        return result;
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    private function nullCompare(a:Object, b:Object):int
    {
        var left:Object;
        var right:Object;

        var found:Boolean = false;

        // return 0 (ie equal) if both are null
        if (a == null && b == null)
        {
            return 0;
        }

        // we need to introspect the data a little bit
        if (_name)
        {
            left = getSortFieldValue(a);
            right = getSortFieldValue(b);
        }

        // return 0 (ie equal) if both are null
        if (left == null && right == null)
            return 0;

        if (left == null && !_name)
            left = a;

        if (right == null && !_name)
            right = b;


        var typeLeft:String = typeof(left);
        var typeRight:String = typeof(right);


        if (typeLeft == "string" || typeRight == "string")
        {
            found = true;
            _compareFunction = stringCompare;
        }
        else if (typeLeft == "object" || typeRight == "object")
        {
            if (left is Date || right is Date)
            {
                found = true;
                _compareFunction = dateCompare;
            }
        }
        else if (typeLeft == "xml" || typeRight == "xml")
        {
            found = true;
            _compareFunction = xmlCompare;
        }
        else if (typeLeft == "number" || typeRight == "number"
                || typeLeft == "boolean" || typeRight == "boolean")
        {
            found = true;
            _compareFunction = numericCompare;
        }

        if (found)
        {
            return _compareFunction(left, right);
        }
        else
        {
            var message:String = /*resourceManager.getString(
                "collections", */"noComparatorSortField"/*, [ name ])*/;
            throw new Error(message);
        }
    }

    /**
     *  Pull the numbers from the objects and call the implementation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    private function numericCompare(a:Object, b:Object):int
    {
        var fa:Number = _name == null ? Number(a) : Number(getSortFieldValue(a));
        var fb:Number = _name == null ? Number(b) : Number(getSortFieldValue(b));

        return CompareUtils.numericCompare(fa, fb);
    }

    /**
     *  Pull the date objects from the values and compare them.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    private function dateCompare(a:Object, b:Object):int
    {
        var fa:Date = _name == null ? a as Date : getSortFieldValue(a) as Date;
        var fb:Date = _name == null ? b as Date : getSortFieldValue(b) as Date;

        return CompareUtils.dateCompare(fa, fb);
    }

    /**
     *  Pull the strings from the objects and call the implementation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    protected function stringCompare(a:Object, b:Object):int
    {
        var fa:String = _name == null ? String(a) : String(getSortFieldValue(a));
        var fb:String = _name == null ? String(b) : String(getSortFieldValue(b));

        return CompareUtils.stringCompare(fa, fb, _caseInsensitive);
    }

    /**
     *  Pull the values out fo the XML object, then compare
     *  using the string or numeric comparator depending
     *  on the numeric flag.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    protected function xmlCompare(a:Object, b:Object):int
    {
        var sa:String = _name == null ? a.toString() : getSortFieldValue(a).toString();
        var sb:String = _name == null ? b.toString() : getSortFieldValue(b).toString();

        if (_numeric == true)
        {
            return CompareUtils.numericCompare(parseFloat(sa), parseFloat(sb));
        }
        else
        {
            return CompareUtils.stringCompare(sa, sb, _caseInsensitive);
        }
    }
}
}
