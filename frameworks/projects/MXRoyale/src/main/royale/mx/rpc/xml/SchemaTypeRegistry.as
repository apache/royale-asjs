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

import org.apache.royale.reflection.getDefinitionByName;
import org.apache.royale.reflection.getQualifiedClassName;

/**
 * XMLDecoder uses this class to map an XML Schema type by QName to an
 * ActionScript Class so that it can create strongly typed objects when
 * decoding content. If the type is unqualified the QName uri may
 * be left null or set to the empty String.
 * <p>
 * It is important to note that the desired Class must be linked into the SWF
 * and possess a default constructor in order for the XMLDecoder to create a
 * new instance of the type, otherwise an anonymous Object will be used to
 * hold the decoded properties.
 * </p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SchemaTypeRegistry
{
    //--------------------------------------------------------------------------
    //
    // Class Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * Returns the sole instance of this singleton class, creating it if it
     * does not already exist.
     *
     * @return Returns the sole instance of this singleton class, creating it
     * if it does not already exist.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getInstance():SchemaTypeRegistry
    {
        if (_instance == null)
            _instance = new SchemaTypeRegistry();

        return _instance;
    }


    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    public function SchemaTypeRegistry()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * Looks for a registered Class for the given type.
     * @param type The QName or String representing the type name.
     * @return Returns the Class for the given type, or null of the type
     * has not been registered.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getClass(type:Object):Class
    {
        var c:Class;
        if (type != null)
        {
            var key:String = getKey(type);
            var definitionName:String = classMap[key] as String;

            if (definitionName != null)
                c = getDefinitionByName(definitionName) as Class;
        }
        return c;
    }

    /**
     * Returns the Class for the collection type represented by the given
     * Qname or String.
     *
     * @param type The QName or String representing the collection type name.
     *
     * @return Returns the Class for the collection type represented by 
     * the given Qname or String.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getCollectionClass(type:Object):Class
    {
        var c:Class;
        if (type != null)
        {
            var key:String = getKey(type);
            var definitionName:String = collectionMap[key] as String;

            if (definitionName != null)
                c = getDefinitionByName(definitionName) as Class;
        }
        return c;
    }

    /**
     * Maps a type QName to a Class definition. The definition can be a String
     * representation of the fully qualified class name or an instance of the
     * Class itself.
     * @param type The QName or String representation of the type name.
     * @param definition The Class itself or class name as a String.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function registerClass(type:Object, definition:Object):void
    {
        register(type, definition, classMap);
    }

    /**
     * Maps a type name to a collection Class. A collection is either the 
     * top level Array type, or an implementation of <code>mx.collections.IList</code>. 
     * The definition can be a String representation of the fully qualified
     * class name or an instance of the Class itself.
     *
     * @param type The QName or String representation of the type name.
     *
     * @param definition The Class itself or class name as a String.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function registerCollectionClass(type:Object, definition:Object):void
    {
        register(type, definition, collectionMap);
    }

    /**
     * Removes a Class from the registry for the given type.
     * @param type The QName or String representation of the type name.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function unregisterClass(type:Object):void
    {
        if (type != null)
        {
            var key:String = getKey(type);
            delete classMap[key];
        }
    }

    /**
     * Removes a collection Class from the registry for the given type.
     * @param type The QName or String representation of the collection type
     * name.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function unregisterCollectionClass(type:Object):void
    {
        if (type != null)
        {
            var key:String = getKey(type);
            delete collectionMap[key];
        }
    }

    /**
     * @private
     * Converts the given type name into a consistent String representation
     * that serves as the key to the type map.
     * @param type The QName or String representation of the type name.
     */
    private function getKey(type:Object):String
    {
        var key:String;
        if (type is QName)
        {
            var typeQName:QName = type as QName;
            if (typeQName.uri == null || typeQName.uri == "")
                key = typeQName.localName;
            else
                key = typeQName.toString();
        }
        else
        {
            key = type.toString();
        }
        return key;
    }

    /**
     * @private
     */
    private function register(type:Object, definition:Object, map:Object):void
    {
        var key:String = getKey(type);
        var definitionName:String;
        if (definition is String)
            definitionName = definition as String;
        else
            definitionName = getQualifiedClassName(definition);

        map[key] = definitionName;
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    private var classMap:Object = {};
    private var collectionMap:Object = {};
    private static var _instance:SchemaTypeRegistry;
}

}
