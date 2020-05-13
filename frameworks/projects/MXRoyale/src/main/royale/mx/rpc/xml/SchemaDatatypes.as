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

package mx.rpc.xml
{

[ExcludeClass]

/**
 * Establishes the datatypes for a particular version of XML Schema. The
 * default namespace is http://www.w3.org/2001/XMLSchema representing
 * XML Schema 1.1.
 * 
 * @private
 */
public class SchemaDatatypes
{
    public function SchemaDatatypes(xsdURI:String = null)
    {
        super();

        // Default to XSD and XSI 2001
        if (xsdURI == null || xsdURI == "")
            xsdURI = SchemaConstants.XSD_URI_2001;
        
        anyTypeQName = new QName(xsdURI,"anyType");
        anySimpleTypeQName = new QName(xsdURI,"anySimpleType");
        anyAtomicTypeQName = new QName(xsdURI,"anyAtomicType");

        stringQName = new QName(xsdURI,"string");
        booleanQName = new QName(xsdURI,"boolean");
        decimalQName = new QName(xsdURI,"decimal");
        precisionDecimal = new QName(xsdURI,"precisionDecimal");
        floatQName = new QName(xsdURI,"float");
        doubleQName = new QName(xsdURI,"double");
        durationQName = new QName(xsdURI,"duration");
        dateTimeQName = new QName(xsdURI,"dateTime");
        timeQName = new QName(xsdURI,"time");
        dateQName = new QName(xsdURI,"date");
        gYearMonthQName = new QName(xsdURI,"gYearMonth");
        gYearQName = new QName(xsdURI,"gYear");
        gMonthDayQName = new QName(xsdURI,"gMonthDay");
        gDayQName = new QName(xsdURI,"gDay");
        gMonthQName = new QName(xsdURI,"gMonth");
        hexBinaryQName = new QName(xsdURI,"hexBinary");
        base64BinaryQName = new QName(xsdURI,"base64Binary");
        anyURIQName = new QName(xsdURI,"anyURI");
        QNameQName = new QName(xsdURI,"QName");
        NOTATIONQName = new QName(xsdURI,"NOTATION");

        normalizedStringQName = new QName(xsdURI,"normalizedString");
        tokenQName = new QName(xsdURI,"token");
        languageQName = new QName(xsdURI,"language");
        NMTOKENQName = new QName(xsdURI,"NMTOKEN");
        NMTOKENSQName = new QName(xsdURI,"NMTOKENS");
        NameQName = new QName(xsdURI,"Name");
        NCNameQName = new QName(xsdURI,"NCName");
        IDQName = new QName(xsdURI,"ID");
        IDREF = new QName(xsdURI,"IDREF");
        IDREFS = new QName(xsdURI,"IDREFS");
        ENTITY = new QName(xsdURI,"ENTITY");
        ENTITIES = new QName(xsdURI,"ENTITIES");
        integerQName = new QName(xsdURI,"integer");
        nonPositiveIntegerQName = new QName(xsdURI,"nonPositiveInteger");
        negativeIntegerQName = new QName(xsdURI,"negativeInteger");
        longQName = new QName(xsdURI,"long");
        intQName = new QName(xsdURI,"int");
        shortQName = new QName(xsdURI,"short");
        byteQName = new QName(xsdURI,"byte");
        nonNegativeIntegerQName = new QName(xsdURI,"nonNegativeInteger");
        unsignedLongQName = new QName(xsdURI,"unsignedLong");
        unsignedIntQName = new QName(xsdURI,"unsignedInt");
        unsignedShortQName = new QName(xsdURI,"unsignedShort");
        unsignedByteQName = new QName(xsdURI,"unsignedByte");
        positiveIntegerQName = new QName(xsdURI,"positiveInteger");
        yearMonthDurationQName = new QName(xsdURI,"yearMonthDuration");
        dayTimeDurationQName = new QName(xsdURI,"dayTimeDuration");

        // 1999
        if (xsdURI == SchemaConstants.XSD_URI_1999)
            timeInstantQName = new QName(xsdURI,"timeInstant");
    }


    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    public static function getConstants(xsdURI:String = null):SchemaDatatypes
    {
        if (constantsCache == null)
            constantsCache = {};

        if (xsdURI == null || xsdURI == "")
            xsdURI = SchemaConstants.XSD_URI_2001;

        var constants:SchemaDatatypes = constantsCache[xsdURI];
        if (constants == null)
        {
            constants = new SchemaDatatypes(xsdURI);
            constantsCache[xsdURI] = constants;
        }

        return constants;
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    // Special built-in schema datatypes
    public var anyTypeQName:QName;
    public var anySimpleTypeQName:QName;
    public var anyAtomicTypeQName:QName;

    // Primitive datatypes
    public var stringQName:QName;
    public var booleanQName:QName;
    public var decimalQName:QName;
    public var precisionDecimal:QName;
    public var floatQName:QName;
    public var doubleQName:QName;
    public var durationQName:QName;
    public var dateTimeQName:QName;
    public var timeQName:QName;
    public var dateQName:QName;
    public var gYearMonthQName:QName;
    public var gYearQName:QName;
    public var gMonthDayQName:QName;
    public var gDayQName:QName;
    public var gMonthQName:QName;
    public var hexBinaryQName:QName;
    public var base64BinaryQName:QName;
    public var anyURIQName:QName;
    public var QNameQName:QName;
    public var NOTATIONQName:QName;

    // Other built-in datatypes
    public var normalizedStringQName:QName;
    public var tokenQName:QName;
    public var languageQName:QName;
    public var NMTOKENQName:QName;
    public var NMTOKENSQName:QName;
    public var NameQName:QName;
    public var NCNameQName:QName;
    public var IDQName:QName;
    public var IDREF:QName;
    public var IDREFS:QName;
    public var ENTITY:QName;
    public var ENTITIES:QName;
    public var integerQName:QName;
    public var nonPositiveIntegerQName:QName;
    public var negativeIntegerQName:QName;
    public var longQName:QName;
    public var intQName:QName;
    public var shortQName:QName;
    public var byteQName:QName;
    public var nonNegativeIntegerQName:QName;
    public var unsignedLongQName:QName;
    public var unsignedIntQName:QName;
    public var unsignedShortQName:QName;
    public var unsignedByteQName:QName;
    public var positiveIntegerQName:QName;
    public var yearMonthDurationQName:QName;
    public var dayTimeDurationQName:QName;

    // 1999
    public var timeInstantQName:QName;

    private static var constantsCache:Object;
}

}
