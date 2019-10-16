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

/**
 * Decodes an XML document to an ActionScript object graph based on XML
 * Schema definitions.
 * 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */ 
public interface IXMLDecoder
{
    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     * When makeObjectsBindable is set to <code>true</code>, anonymous Objects and Arrays
     * are wrapped to make them bindable. Objects are wrapped with
     * <code>mx.utils.ObjectProxy</code> and Arrays are wrapped with
     * <code>mx.collections.ArrayCollection</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get makeObjectsBindable():Boolean;

    function set makeObjectsBindable(value:Boolean):void;

    /**
     * When recordXSIType is set to <code>true</code>, if an encoded complexType
     * has an <code>xsi:type</code> attribute the type information will be
     * recorded on the decoded instance if it is strongly typed and implements
     * <code>mx.rpc.xml.IXMLSchemaInstance</code> or is an anonymous
     * <code>mx.utils.ObjectProxy</code>. This type information can be used
     * to post process the decoded objects and identify which concrete
     * implementation of a potentially abstract type was used.
     * The default is false.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get recordXSIType():Boolean;

    function set recordXSIType(value:Boolean):void;

    /**
     * Maps XML Schema types by QName to ActionScript Classes in order to 
     * create strongly typed objects when decoding content.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get typeRegistry():SchemaTypeRegistry;

    function set typeRegistry(value:SchemaTypeRegistry):void;

    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------
    
    /**
     * Decodes an XML document to an ActionScript object.
     * 
     * @param xml The XML instance to decode to an ActionScript object. 
     * This may be an XML instance, an XMLList of length 1 or a String that is
     * valid XML.
     *
     * @param name The QName of an XML Schema <code>element</code> that
     * describes how to decode the value, or the name to be used for the
     * decoded value when a type parameter is also specified.
     *
     * @param type The QName of an XML Schema <code>simpleType</code> or
     * <code>complexType</code> definition that describes how to decode the
     * value.
     *
     * @param definition If neither a top-level element nor type exists in the
     * schema to describe how to decode this value, a custom element definition
     * can be provided.
     *
     * @return Returns an ActionScript object decoded from the given XML document.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function decode(xml:*, name:QName = null, type:QName = null, definition:XML = null):*;

    /**
     * Resets the decoder to its initial state, including resetting any 
     * Schema scope to the top level and releases the current XML document by
     * setting it to null.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function reset():void;
}

}
