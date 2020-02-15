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

package mx.formatters
{

    import mx.managers.ISystemManager;
    //import mx.managers.SystemManager;

    //[ResourceBundle("formatters")]
    //[ResourceBundle("SharedResources")]

    [Alternative(replacement="spark.formatters.NumberFormatter", since="4.5")]
    /**
     *  The NumberFormatter class formats a valid number
     *  by adjusting the decimal rounding and precision,
     *  the thousands separator, and the negative sign.
     *
     *  <p>If you use both the <code>rounding</code> and <code>precision</code>
     *  properties, rounding is applied first, and then you set the decimal length
     *  by using the specified <code>precision</code> value.
     *  This lets you round a number and still have a trailing decimal;
     *  for example, 303.99 = 304.00.</p>
     *
     *  <p>If an error occurs, an empty String is returned and a String
     *  describing  the error is saved to the <code>error</code> property.
     *  The <code>error</code>  property can have one of the following values:</p>
     *
     *  <ul>
     *    <li><code>"Invalid value"</code> means an invalid numeric value is passed to
     *    the <code>format()</code> method. The value should be a valid number in the
     *    form of a Number or a String.</li>
     *    <li><code>"Invalid format"</code> means one of the parameters
     *    contain an unusable setting.</li>
     *  </ul>
     *
     *  @mxml
     *
     *  <p>The <code>&lt;mx:NumberFormatter&gt;</code> tag
     *  inherits all of the tag attributes of its superclass,
     *  and adds the following tag attributes:</p>
     *
     *  <pre>
     *  &lt;mx:NumberFormatter
     *    decimalSeparatorFrom="."
     *    decimalSeparatorTo="."
     *    precision="-1"
     *    rounding="none|up|down|nearest"
     *    thousandsSeparatorFrom=","
     *    thousandsSeparatorTo=","
     *    useNegativeSign="true|false"
     *    useThousandsSeparator="true|false"/>
     *  </pre>
     *
     *  @includeExample examples/NumberFormatterExample.mxml
     *
     *  @see mx.formatters.NumberBase
     *  @see mx.formatters.NumberBaseRoundType
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public class NumberFormatter extends Formatter
    {
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
        public function NumberFormatter()
        {
            super();
        }

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  decimalSeparatorFrom
        //----------------------------------

        /**
         *  @private
         *  Storage for the decimalSeparatorFrom property.
         */
        private var _decimalSeparatorFrom:String = ".";

        /**
         *  @private
         */
        //private var decimalSeparatorFromOverride:String;

        [Inspectable(category="General", defaultValue=".")]

        /**
         *  Decimal separator character to use
         *  when parsing an input String.
         *
         *  <p>When setting this property, ensure that the value of the
         *  <code>thousandsSeparatorFrom</code> property does not equal this property.
         *  Otherwise, an error occurs when formatting the value.</p>
         *
         *  @default "."
         *
         *  @see #format()
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.3
         */
        public function get decimalSeparatorFrom():String
        {
            return _decimalSeparatorFrom;
        }

        /**
         *  @private
         */
        public function set decimalSeparatorFrom(value:String):void
        {
            //decimalSeparatorFromOverride = value;

            _decimalSeparatorFrom = value != null ?
                                    value : value
                                   /* resourceManager.getString(
                                        "SharedResources", "decimalSeparatorFrom") */;
        }

        //----------------------------------
        //  decimalSeparatorTo
        //----------------------------------

        /**
         *  @private
         *  Storage for the decimalSeparatorTo property.
         */
        private var _decimalSeparatorTo:String = ".";

        /**
         *  @private
         */
        //private var decimalSeparatorToOverride:String;

        [Inspectable(category="General", defaultValue=".")]

        /**
         *  Decimal separator character to use
         *  when outputting formatted decimal numbers.
         *
         *  <p>When setting this property, ensure that the value of the
         *  <code>thousandsSeparatorTo</code> property does not equal this property.
         *  Otherwise, an error occurs when formatting the value.</p>
         *
         *  @default "."
         *
         *  @see #format()
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.3
         */
        public function get decimalSeparatorTo():String
        {
            return _decimalSeparatorTo;
        }

        /**
         *  @private
         */
        public function set decimalSeparatorTo(value:String):void
        {
            //decimalSeparatorToOverride = value;

            _decimalSeparatorTo = value != null ?
                                  value : value
                                 /* resourceManager.getString(
                                    "SharedResources", "decimalSeparatorTo") */ ;
        }

        //----------------------------------
        //  precision
        //----------------------------------

        /**
         *  @private
         *  Storage for the precision property.
         */
        private var _precision:Object = -1;

        /**
         *  @private
         */
        //private var precisionOverride:Object;

        [Inspectable(category="General", defaultValue="-1")]

        /**
         *  Number of decimal places to include in the output String.
         *  You can disable precision by setting it to <code>-1</code>.
         *  A value of <code>-1</code> means do not change the precision. For example,
         *  if the input value is 1.453 and <code>rounding</code>
         *  is set to <code>NumberBaseRoundType.NONE</code>, return a value of 1.453.
         *  If <code>precision</code> is <code>-1</code> and you have set some form of
         *  rounding, return a value based on that rounding type.
         *
         *  @default -1
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.3
         */
        public function get precision():Object
        {
            return _precision;
        }

        /**
         *  @private
         */
        public function set precision(value:Object):void
        {
            //precisionOverride = value;

            _precision = value != null ?
                         int(value) : int(value)
                        /* resourceManager.getInt(
                             "formatters", "numberFormatterPrecision") */ ;
        }

        //----------------------------------
        //  rounding
        //----------------------------------

        /**
         *  @private
         *  Storage for the rounding property.
         */
        private var _rounding:String = "none";

        /**
         *  @private
         */
        //private var roundingOverride:String;

        [Inspectable(category="General", enumeration="none,up,down,nearest", defaultValue="none")]
            // !!@ Should enumeration include null?

        /**
         *  Specifies how to round the number.
         *
         *  <p>In ActionScript, you can use the following constants to set this property:
         *  <code>NumberBaseRoundType.NONE</code>, <code>NumberBaseRoundType.UP</code>,
         *  <code>NumberBaseRoundType.DOWN</code>, or <code>NumberBaseRoundType.NEAREST</code>.
         *  Valid MXML values are "down", "nearest", "up", and "none".</p>
         *
         *  @default NumberBaseRoundType.NONE
         *
         *  @see mx.formatters.NumberBaseRoundType
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.3
         */
        public function get rounding():String
        {
            return _rounding;
        }

        /**
         *  @private
         */
        public function set rounding(value:String):void
        {
            //roundingOverride = value;

            _rounding = value != null ?
                        value : value
                       /* resourceManager.getString(
                            "formatters", "rounding") */ ;
        }

        //----------------------------------
        //  thousandsSeparatorFrom
        //----------------------------------

        /**
         *  @private
         *  Storage for the thousandsSeparatorFrom property.
         */
        private var _thousandsSeparatorFrom:String = ",";

        /**
         *  @private
         */
        //private var thousandsSeparatorFromOverride:String;

        [Inspectable(category="General", defaultValue=",")]

        /**
         *  Character to use as the thousands separator
         *  in the input String.
         *
         *  <p>When setting this property, ensure that the value of the
         *  <code>decimalSeparatorFrom</code> property does not equal this property.
         *  Otherwise, an error occurs when formatting the value.</p>
         *
         *  @default ","
         *
         *  @see #format()
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.3
         */
        public function get thousandsSeparatorFrom():String
        {
            return _thousandsSeparatorFrom;
        }

        /**
         *  @private
         */
        public function set thousandsSeparatorFrom(value:String):void
        {
            //thousandsSeparatorFromOverride = value;

            _thousandsSeparatorFrom = value != null ?
                                      value : value
                                     /* resourceManager.getString(
                                          "SharedResources",
                                          "thousandsSeparatorFrom"); */
        }

        //----------------------------------
        //  thousandsSeparatorTo
        //----------------------------------

        /**
         *  @private
         *  Storage for the thousandsSeparatorTo property.
         */
        private var _thousandsSeparatorTo:String = ",";

        /**
         *  @private
         */
        //private var thousandsSeparatorToOverride:String;

        [Inspectable(category="General", defaultValue=",")]

        /**
         *  Character to use as the thousands separator
         *  in the output String.
         *
         *  <p>When setting this property, ensure that the value of the
         *  <code>decimalSeparatorTo</code> property does not equal this property.
         *  Otherwise, an error occurs when formatting the value.</p>
         *
         *  @default ","
         *
         *  @see #format()
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.3
         */
        public function get thousandsSeparatorTo():String
        {
            return _thousandsSeparatorTo;
        }

        /**
         *  @private
         */
        public function set thousandsSeparatorTo(value:String):void
        {
            //thousandsSeparatorToOverride = value;

            _thousandsSeparatorTo = value != null ?
                                    value : value
                                  /*  resourceManager.getString(
                                        "SharedResources",
                                        "thousandsSeparatorTo") */ ;
        }

        //----------------------------------
        //  useNegativeSign
        //----------------------------------

        /**
         *  @private
         *  Storage for the useNegativeSign property.
         */
        private var _useNegativeSign:Object = true;

        /**
         *  @private
         */
        //private var useNegativeSignOverride:Object;

        [Inspectable(category="General", defaultValue="true")]

        /**
         *  If <code>true</code>, format a negative number
         *  by preceding it with a minus "-" sign.
         *  If <code>false</code>, format the number
         *  surrounded by parentheses, for example (400).
         *
         *  @default true
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.3
         */
        public function get useNegativeSign():Object
        {
            return _useNegativeSign;
        }

        /**
         *  @private
         */
        public function set useNegativeSign(value:Object):void
        {
            //useNegativeSignOverride = value;

            _useNegativeSign = value != null ?
                               Boolean(value) : Boolean(value)
                            /*   resourceManager.getBoolean(
                                   "formatters", "useNegativeSignInNumber") */ ;
        }

        //----------------------------------
        //  useThousandsSeparator
        //----------------------------------

        /**
         *  @private
         *  Storage for the useThousandsSeparator property.
         */
        private var _useThousandsSeparator:Object = true;

        /**
         *  @private
         */
        //private var useThousandsSeparatorOverride:Object;

        [Inspectable(category="General", defaultValue="true")]

        /**
         *  If <code>true</code>, split the number into thousands increments
         *  by using a separator character.
         *
         *  @default true
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.3
         */
        public function get useThousandsSeparator():Object
        {
            return _useThousandsSeparator;
        }

        /**
         *  @private
         */
        public function set useThousandsSeparator(value:Object):void
        {
            //useThousandsSeparatorOverride = value;

            _useThousandsSeparator = value != null ?
                                     Boolean(value) : Boolean(value)
                                 /*     resourceManager.getBoolean(
                                         "formatters", "useThousandsSeparator") */ ;
        }

        //--------------------------------------------------------------------------
        //
        //  Overridden methods
        //
        //--------------------------------------------------------------------------
        /**
         *  Formats the number as a String.
         *  If <code>value</code> cannot be formatted, return an empty String
         *  and write a description of the error to the <code>error</code> property.
         *
         *  @param value Value to format.
         *
         *  @return Formatted String. Empty if an error occurs.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.3
         */
        override public function format(value:Object):String
        {
            // Reset any previous errors.
            //if (error)
            //    error = null;

            if (useThousandsSeparator &&
                ((decimalSeparatorFrom == thousandsSeparatorFrom) ||
                 (decimalSeparatorTo == thousandsSeparatorTo)))
            {
                //error = defaultInvalidFormatError;
                return "";
            }

            if (decimalSeparatorTo == "" || !isNaN(Number(decimalSeparatorTo)))
            {
                //error = defaultInvalidFormatError;
                return "";
            }

            var dataFormatter:NumberBase = new NumberBase(decimalSeparatorFrom,
                                                          thousandsSeparatorFrom,
                                                          decimalSeparatorTo,
                                                          thousandsSeparatorTo);

            // -- value --

            if (value is String)
                value = dataFormatter.parseNumberString(String(value));

            if (value === null || isNaN(Number(value)))
            {
                //error = defaultInvalidValueError;
                return "";
            }

            // -- format --

            var isNegative:Boolean = (Number(value) < 0);

            var numStr:String = value.toString();

            numStr = numStr.toLowerCase();
            var e:int = numStr.indexOf("e");
            if (e != -1)  //deal with exponents
                numStr = dataFormatter.expandExponents(numStr);

            var numArrTemp:Array = numStr.split(".");
            var numFraction:int = numArrTemp[1] ? String(numArrTemp[1]).length : 0;

            if (precision < numFraction)
            {
                if (rounding != NumberBaseRoundType.NONE)
                {
                    numStr = dataFormatter.formatRoundingWithPrecision(
                        numStr, rounding, int(precision));
                }
            }

            var numValue:Number = Number(numStr);
            if (Math.abs(numValue) >= 1)
            {
                numArrTemp = numStr.split(".");
                var front:String = useThousandsSeparator ?
                                   dataFormatter.formatThousands(String(numArrTemp[0])) :
                                   String(numArrTemp[0]);
                if (numArrTemp[1] != null && numArrTemp[1] != "")
                    numStr = front + decimalSeparatorTo + numArrTemp[1];
                else
                    numStr = front;
            }
            else if (Math.abs(numValue) > 0)
            {
                // Check if the string is in scientific notation
                numStr = numStr.toLowerCase();
                if (numStr.indexOf("e") != -1)
                {
                    var temp:Number = Math.abs(numValue) + 1;
                    numStr = temp.toString();
                }
                numStr = decimalSeparatorTo +
                         numStr.substring(numStr.indexOf(".") + 1);
            }

            numStr = dataFormatter.formatPrecision(numStr, int(precision));

            // If our value is 0, then don't show -0
            if (Number(numStr) == 0)
            {
                isNegative = false;
            }

            if (isNegative)
                numStr = dataFormatter.formatNegative(numStr, useNegativeSign);

            if (!dataFormatter.isValid)
            {
                error = defaultInvalidFormatError;
                return "";
            }

            return numStr;
        }

    }

}
