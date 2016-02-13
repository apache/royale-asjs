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

package mx.styles
{
import mx.utils.ObjectUtil;

/**
 * Represents a dimension with an optional unit, to be used in css media queries.
 * <p>Valid units are:
 * no unit
 * px : pixel
 * in : inch
 * cm : centimeter
 * pt : point
 * dp :  device independent pixel ( 1 pix at about 160 DPI )
 * </p>
 * 
 *  @langversion 3.0
 *  @playerversion AIR 3.0
 *  @productversion Flex 4.13
 */
public class CSSDimension
{
    /* device independent units */
    static public  const NO_UNIT: String = "";
    static public  const UNIT_INCH: String = "in";
    static public  const UNIT_CM: String = "cm";
    static public  const UNIT_PT: String = "pt";
    static public  const UNIT_DP: String = "dp";

    /* pixel units */
    static private  const UNIT_PX: String = "px";

    /* scale factor for device independent units */
    static private  const INCH_PER_INCH: Number = 1.0;
    static private  const CM_PER_INCH: Number = 2.54;
    static private  const PT_PER_INCH: Number = 72;
    static private  const DP_PER_INCH: Number = 160;

    private var _value: Number;
    private var _unit: String;
    private var _pixelValue: int;

    /** Constructor
     *
     * @param value
     * @param refDPI
     * @param unit
     *
     */
    public function CSSDimension(value: Number, refDPI: Number, unit: String = NO_UNIT)
    {
        _value = value;
        _unit = unit;
        _pixelValue = computePixelValue(refDPI);
    }

    /** Dimension unit, as a string, or empty string if no unit
     *
     */
    public function get unit(): String
    {
        return _unit;
    }

    /** Dimension value as a number, without the unit
     */
    public function get value(): Number
    {
        return _value;
    }

    /**
     * Dimension converted to actual pixels, considering the current device DPI
     */
    public function get pixelValue(): Number
    {
        return _pixelValue;
    }

    /**
     *  Compares to another CSSDimension instance.
     *  Actual pixel values are used for comparison, so dimensions can have different units.
     *
     *  @param other another  CSSDimension instance
     *
     *  @return 0 if both dimensions are of equal value. rounding errors may occur due to conversion
     *  -1 if <code>this</code> is lower than <code>other</code>.
     *  1 if <code>this</code> is greater than <code>other</code>.
     *
     *  @langversion 3.0
     *  @playerversion AIR 3.0
     *  @productversion Flex 4.13
     */
    public function compareTo(other: CSSDimension): int
    {
        return ObjectUtil.numericCompare(_pixelValue, other.pixelValue);
    }

    /**
     * Printable string of the dimension
     * @return version as a string
     */
    public function toString(): String
    {
        return  _value.toString() + _unit;
    }

    /** @private converts a value with unit an actual pixel value, according to refDPI screen resolution
     * the formula is the following for physical units
     *   pixelValue = value * refDPI / unit_per_inch ;
     *   eg. 5in at 132 DPI =>  5 * 132 /1 =
     *   eg. 19cm at 132 DPI => 19 * 132 /2.54  =
     * */
    private function computePixelValue(refDPI: Number): int
    {
        switch (_unit) {
            // test device-independent units
            case UNIT_INCH:
                return _value * refDPI;
            case UNIT_DP:
                return _value * refDPI / DP_PER_INCH;
            case UNIT_CM:
                return _value * refDPI / CM_PER_INCH;
            case UNIT_PT:
                return _value * refDPI / PT_PER_INCH;
        }
        // else it's pixel unit
        return _value;
    }


}

}
