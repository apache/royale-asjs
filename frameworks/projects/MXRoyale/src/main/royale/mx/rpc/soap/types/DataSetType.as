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
    
import mx.rpc.soap.SOAPConstants;
import mx.rpc.soap.SOAPDecoder;
import mx.rpc.soap.SOAPEncoder;
import mx.rpc.xml.ContentProxy;
import mx.rpc.xml.Schema;
import mx.rpc.xml.SchemaConstants;
import mx.rpc.xml.TypeIterator;
import mx.rpc.xml.XMLDecoder;
import mx.utils.ObjectProxy;
import mx.utils.object_proxy;

use namespace object_proxy;

[ExcludeClass]

/**
 * Marshalls between a .NET DataSet diffgram and ActionScript.
 * @private
 */
public class DataSetType implements ICustomSOAPType
{
    public function DataSetType()
    {
        super();
    }

    public function encode(encoder:SOAPEncoder, parent:XML, name:QName, value:*, restriction:XML = null):void
    {
        throw new Error("Unsupported operation - .NET DataSet diffgrams cannot be sent from client.");
    }

    /**
     * Decode a response part that contains a serialized DataSet.
     * 
     * @param SOAPDecoder the decoder instance
     * @param * parent object (content proxy)
     * @param name ignored
     * @param value the top level XML node. Must have two child elements, schema and diffgram.
     * @param restriction ignored
     * 
     * @private
     */
    public function decode(decoder:SOAPDecoder, parent:*, name:*, value:*, restriction:XML = null):void
    {
        if (parent is ContentProxy)
            ContentProxy(parent).object_proxy::isSimple = false;

        schemaConstants = decoder.schemaConstants;

        var schemaXML:XML = XML(value).elements(schemaConstants.schemaQName)[0];

        //TODO: handle <diffgr:before> and <diffgr:errors>
        var rootDataXML:XML = XML(value).elements(SOAPConstants.diffgramQName)[0].elements()[0];
        var dataSet:* = parent;
        var tableDefinitions:Object = processTables(schemaXML);

        // First create .Tables and .Columns and .Rows for each table
        var tableCollection:* = decoder.createContent();
        if (tableCollection is ContentProxy)
                ContentProxy(tableCollection).object_proxy::isSimple = false;
        
        for (var tblName:String in tableDefinitions)
        {
            var tableObj:* = decoder.createContent();
            if (tableObj is ContentProxy)
                ContentProxy(tableObj).object_proxy::isSimple = false;
            decoder.setValue(tableObj, "Columns",
                            processColumns(decoder, tableDefinitions[tblName]));
            decoder.setValue(tableObj, "Rows",
                            decoder.createIterableValue());
            decoder.setValue(tableCollection, tblName, tableObj);
        }
        
        if (rootDataXML != null)
        {
            var schema:Schema = new Schema(schemaXML);
            decoder.schemaManager.addSchema(schema, false);
            
            for (tblName in tableCollection)
            {
                for each (var rowXML:XML in rootDataXML.elements(tblName))
                {
                    var rowObj:* = decoder.decode(rowXML, rowXML.name() as QName, null, tableDefinitions[tblName]);
                    TypeIterator.push(tableCollection[tblName]["Rows"], rowObj);
                }
            }

            decoder.schemaManager.releaseScope();
        }

        decoder.setValue(dataSet, "Tables", tableCollection);
    }
    
    /**
     * Parse table information out of the inline schema
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function processTables(schemaXML:XML):Object
    {
        // The table definitions are elements inside a choice inside
        // a complexType inside a top-level element in the schema
        var tblsXMLList:XMLList = schemaXML.elements(schemaConstants.elementTypeQName)[0]
                .elements(schemaConstants.complexTypeQName)[0]
                .elements(schemaConstants.choiceQName)[0]
                .elements(schemaConstants.elementTypeQName);
        
        var tables:Object = {};
        for each (var tblXML:XML in tblsXMLList)
            tables[tblXML.attribute("name")] = tblXML;

        return tables;
    }
    
    /**
     * Parse column definitions out of a table definition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function processColumns(decoder:SOAPDecoder, tableXML:XML):*
    {
        // The column definitions are elements inside a sequence inside
        // a complexType in the table definition element.
        var colsXMLList:XMLList = tableXML.elements(schemaConstants.complexTypeQName)[0]
                .elements(schemaConstants.sequenceQName)[0]
                .elements(schemaConstants.elementTypeQName);
        
        var columns:* = decoder.createIterableValue();
        for each (var colXML:XML in colsXMLList)
            TypeIterator.push(columns, colXML.attribute("name").toString());
            
        return columns;
    }
    
    private var schemaConstants:SchemaConstants;
}
}