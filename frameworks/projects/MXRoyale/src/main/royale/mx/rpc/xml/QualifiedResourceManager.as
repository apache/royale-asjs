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
 * QualifiedResourceManager is a helper class that simply maintains
 * the order that resources were added and maps a target namespace to
 * one or more resources.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class QualifiedResourceManager
{
    /**
     * Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function QualifiedResourceManager()
    {
        super();
    }
    
    /**
     * Adds a resource to a potential Array of resources for a
     * given namespace.
     *
     * @param ns The namespace for the Array of resources.
     *
     * @param resource The resource to add.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addResource(ns:Namespace, resource:Object):void
    {
        if (resources == null)
            resources = [];

        resources.push(resource);

        if (resourcesMap == null)
            resourcesMap = {};
            
        var uri:String = ns.uri;
        if (uri == null)
            uri = "";

        var existingResources:Array = resourcesMap[uri] as Array;
        if (existingResources == null)
            existingResources = [];

        existingResources.push(resource);

        resourcesMap[uri] = existingResources;
    }

    /**
     * Returns an Array of resources for a given target namespace.
     *
     * @param The namespace for the Array of resources.
     *
     * @return An Array of resources.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getResourcesForNamespace(ns:Namespace):Array
    {
        return getResourcesForURI(ns.uri);
    }

    /**
     * Returns an Array of resources for a given target URI.
     *
     * @param uri The URI for the Array of resources.
     *
     * @return An Array of resources.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getResourcesForURI(uri:String):Array
    {
        if (resourcesMap == null)
            return null;

        if (uri == null)
            uri = "";

        var resourcesArray:Array = resourcesMap[uri];
        return resourcesArray;
    }


    /**
     * Gets an Array of all resources.
     *
     * @return An Array of resources.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getResources():Array
    {
        return resources;
    }

    /**
     * This Array is used to preserve order in which resources were
     * added so as to support the order in which they are searched.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var resources:Array;

    /**
     * Maps <code>Namespace.uri</code> to an <code>Array</code> of
     * resources.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var resourcesMap:Object;
}

}
