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
 * Manages an XML Schema Definition. Schemas can import other schemas.
 * 
 * @private
 */
public class Schema
{
    public function Schema(xml:XML = null)
    {
        super();
        this.xml = xml;
    }


    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    public var attributeFormDefault:String = "unqualified";
    public var blockDefault:String;
    public var elementFormDefault:String = "unqualified";
    public var finalDefault:String;


    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     * Maps a namespace prefix (as a <code>String</code>) to a
     * <code>Namespace</code> (i.e. this helps to resolve a prefix to a URI).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get namespaces():Object
    {
        if (_namespaces == null)
            _namespaces = {};

        return _namespaces;
    }
    
    public function set namespaces(value:Object):void
    {
        _namespaces = value;
    }

    /**
     * The targetNamespace of this Schema. A targetNamespace establishes a
     * scope for the collection of type definitions and element declarations
     * to distinguish them from in-built XML Schema types and other collections
     * of types.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get targetNamespace():Namespace
    {
        return _targetNamespace;
    }

    public function set targetNamespace(tns:Namespace):void
    {
        _targetNamespace = tns;
    }

    /**
     * Constants for the particular version of XML Schema that was used
     * to define this Schema.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get schemaConstants():SchemaConstants
    {
        if (_schemaConstants == null)
        {
            _schemaConstants = SchemaConstants.getConstants(_xml);
        }
        return _schemaConstants;
    }

    /**
     * Datatype constants for the particular version of XML Schema that was
     * used to define this Schema.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get schemaDatatypes():SchemaDatatypes
    {
        if (_schemaDatatypes == null)
        {
            _schemaDatatypes = SchemaDatatypes.getConstants(schemaConstants.xsdURI);
        }
        return _schemaDatatypes;
    }

    /**
     * The raw XML definition of this Schema.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get xml():XML
    {
        return _xml;
    }

    public function set xml(value:XML):void
    {
        _xml = value;

        if (_xml != null)
        {
            // XSD global attributes

            // targetNamespace
            var tns:String = _xml.@targetNamespace.toString();
            _targetNamespace = new Namespace(tns);

            // attributeFormDefault="unqualified|qualified"
            attributeFormDefault = _xml.@attributeFormDefault.toString();
            if (attributeFormDefault == "")
                attributeFormDefault = "unqualified";
            
            // blockDefault=""
            blockDefault = _xml.@blockDefault.toString();

            // elementFormDefault="unqualified|qualified"
            elementFormDefault = _xml.@elementFormDefault.toString();
            if (elementFormDefault == "")
                elementFormDefault = "unqualified";

            // finalDefault=""
            finalDefault = _xml.@finalDefault.toString();

            // XSD namespaces
            namespaces = {};

            var nsArray:Array = _xml.inScopeNamespaces();

            for each (var ns:Namespace in nsArray)
            {
                namespaces[ns.prefix] = ns;
            }
            
            _schemaConstants = SchemaConstants.getConstants(_xml);
            _schemaDatatypes = SchemaDatatypes.getConstants(_schemaConstants.xsdURI);
        }
        else
        {
            // Reset constants
            _schemaConstants = null;
            _schemaDatatypes = null;
        }
    }

    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /*
        FIXME:
        1. Validate that the targetNamespace matches the one defined on the
           import XML

        2. Also, check that the schema being added does not cause a cyclic
        relationship.
    */
    public function addImport(targetNamespace:Namespace, schema:Schema):void
    {
        if (importsManager == null)
            importsManager = new QualifiedResourceManager();

        importsManager.addResource(targetNamespace, schema);
    }

    public function addInclude(fragment:XMLList):void
    {
        xml.appendChild(fragment);
    }

    public function getNamedDefinition(definitionName:QName, ...componentTypes:Array):Object
    {
        var uri:String = definitionName.uri;
        var schemas:Array = [this]
        
        // Also consider any imports at this level for the given URI
        if (importsManager != null)
        {
            var imports:Array = importsManager.getResourcesForURI(uri);
            if (imports != null)
            {
                schemas = schemas.concat(imports);
            }
        }

        for (var s:uint = 0; s < schemas.length; s++)
        {
            var schema:Schema = schemas[s] as Schema;
            var currentTargetNamespace:Namespace = schema.targetNamespace;

            var schemaXML:XML = schema.xml;
            var constants:SchemaConstants = schema.schemaConstants;

            for (var t:uint = 0; t < componentTypes.length; t++)
            {
                var componentType:QName = componentTypes[t] as QName;

                // Enforce qualified element form lookup
                if (schema.elementFormDefault == "qualified"
                    && componentType == schemaConstants.elementTypeQName)
                {
                    if (uri != null && uri != "")
                    {
                        if (currentTargetNamespace == null || currentTargetNamespace.uri != uri)
                            continue;
                    }
                }

                // Enforce qualified attribute form lookup
                if (schema.attributeFormDefault == "qualified"
                    && componentType == schemaConstants.attributeQName)
                {
                    if (uri != null && uri != "")
                    {
                        if (currentTargetNamespace == null || currentTargetNamespace.uri != uri)
                            continue;
                    }
                }
                
                // If not element or attribute, component must match the target
                // namespace (it can't be unqualified).
                if (componentType != schemaConstants.elementTypeQName
                    && componentType != schemaConstants.attributeQName
                    && currentTargetNamespace.uri != definitionName.uri)
                    continue;

                // ...and ensure we have the qualified name of the schema component
                // as defined in a particular schema...
                var localComponentType:QName = new QName(constants.xsdURI, componentType.localName);

                // ...then look for <[localComponentType] name="[definitionName.localName]">
                var definition:XML = schemaXML[localComponentType].(@name == definitionName.localName)[0];
                if (definition != null)
                {
                    return {definition:definition, schema:schema};
                }
            }
        }

        return null;
    }

    private var importsManager:QualifiedResourceManager;
    private var _namespaces:Object;
    private var _schemaConstants:SchemaConstants;
    private var _schemaDatatypes:SchemaDatatypes;
    private var _targetNamespace:Namespace;
    private var _xml:XML;
}

}
