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
 * Encodes an ActionScript object graph to XML based on an XML schema.
 * 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IXMLEncoder
{
    /**
     * Encodes an ActionScript value as XML.
     * 
     * @param value The ActionScript value to encode as XML.
     *
     * @param name The QName of an XML Schema <code>element</code> that
     * describes how to encode the value, or the name to be used for the
     * encoded XML node when a type parameter is also specified.
     *
     * @param type The QName of an XML Schema <code>simpleType</code> or
     * <code>complexType</code> definition that describes how to encode the
     * value.
     *
     * @param definition If neither a top-level element nor type exists in the
     * schema to describe how to encode this value, a custom element definition
     * can be provided.
     *
     * @return Returns an XML encoding of the given ActionScript value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    function encode(value:*, name:QName = null, type:QName = null, definition:XML = null):XMLList;

    /**
     * Resets the encoder to its initial state, including resetting any 
     * Schema scope to the top level.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function reset():void;


    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     * The function to be used to escape XML special characters before encoding
     * any simple content.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get xmlSpecialCharsFilter():Function;
    function set xmlSpecialCharsFilter(func:Function):void;
    
    /**
     * When strictNillability is set to <code>true</code>, null values
     * are encoded according to XML Schema rules (requires nillable=true
     * to be set in the definition). When strictNillability is set to
     * <code>false</code>, null values are always encoded with the
     * <code>xsi:nil="true"</code> attribute. The default is <code>false</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     function get strictNillability():Boolean;

    function set strictNillability(value:Boolean):void;
}

}
