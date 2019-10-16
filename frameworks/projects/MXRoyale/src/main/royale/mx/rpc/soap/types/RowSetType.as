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

package mx.rpc.soap.types
{

import mx.rpc.soap.SOAPDecoder;
import mx.rpc.soap.SOAPEncoder;
import mx.rpc.xml.ContentProxy;
import mx.rpc.xml.TypeIterator;
import mx.utils.object_proxy;

use namespace object_proxy;

[ExcludeClass]

/**
 * Marshalls between the SOAP representation of a ColdFusion Query (aka a
 * "Query Bean") and ActionScript.
 * @private
 */
public class RowSetType implements ICustomSOAPType
{
    public function RowSetType()
    {
        super();
    }

    public function encode(encoder:SOAPEncoder, parent:XML, name:QName, value:*, restriction:XML = null):void
    {
        throw new Error("Unsupported operation - RowSet cannot be sent to a server.");
    }

    // Custom deserialization for rowsets, which look like this:
    //
    // <rowSet>
    //   <fields>
    //     <field type="xsd:string">Field1</field>
    //     <field type="xsd:int">Field2</field>
    //   </fields>
    //   <data>
    //    <item>
    //     <d>a string</d>
    //     <d>52</d>
    //    </item>
    //   </data>
    // </rowSet>
    //
    // (That would decode into an Array with a single object {Field1:"a string", Field2:52})
    //
    public function decode(decoder:SOAPDecoder, parent:*, name:*, value:*, restriction:XML = null):void
    {
        if (parent is ContentProxy)
            parent.object_proxy::isSimple = false;

        var rowSetNode:XML = value as XML;

        var returnVal:Array = [];
        var types:Array = [];
        var fields:Array = [];

        var fieldNodes:XMLList = rowSetNode.elements()[0].elements();
        var i:uint;

        // Gather each of the field names and types
        for each (var field:XML in fieldNodes)
        {
            var typeAttr:String = field.attribute("type").toString();
            var typeQName:QName;

            if (typeAttr != null && typeAttr != "")
                typeQName = decoder.schemaManager.getQNameForPrefixedName(typeAttr, field);

            if (typeQName == null)
                typeQName = decoder.schemaManager.schemaDatatypes.stringQName;

            types[i] = typeQName;
            fields[i] = field.text().toString();
            i++;
        }

        var items:XMLList = rowSetNode.elements()[1].elements();

        // Process each Row using field names and types
        i = 0;
        for each (var item:XML in items)
        {
            var columns:XMLList = item.elements();
            var row:* = decoder.createContent();
            var j:uint = 0;
            for each (var column:XML in columns)
            {
                row[fields[j]] = decoder.decode(column, null, types[j] as QName);
                j++;
            }
            returnVal[i] = row;
            i++;
        }

        decoder.setValue(parent, name, returnVal);
    }
}
}
