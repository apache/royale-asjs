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
package org.apache.flex.utils.validation.resources.creditcard
{
    public function get en_us():Object{
            return{
                "decimalPointCountError":"The decimal separator can occur only once.",
                "invalidCharError":"The input contains invalid characters.",
                "invalidFormatCharsError":"One of the formatting parameters is invalid.",
                "lowerThanMinError":"The amount entered is too small.",
                "negativeError":"The amount may not be negative.",
                "negativeNumberFormatError":"The negative format of the input number is incorrect.",
                "negativeCurrencyFormatError":"The negative format of the input currency is incorrect.",
                "positiveCurrencyFormatError":"The positive format of the input currency is incorrect.",
                "parseError":"The input string could not be parsed.",
                "negativeSymbolError":"The negative symbol is repeated or not in right place.",
                "precisionError":"The amount entered has too many digits beyond the decimal point.",
                "fractionalDigitsError":"The amount entered has too many digits beyond the decimal point.",
                "separationError":"The thousands separator must be followed by three digits.",
                "currencyStringError":"Currency name is repeated or not correct.",
                "localeUndefinedError":"Locale is undefined."
            }
    }
}