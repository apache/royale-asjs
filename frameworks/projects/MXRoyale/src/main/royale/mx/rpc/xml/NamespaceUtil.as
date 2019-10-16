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

import flash.xml.XMLDocument;
import flash.xml.XMLNode;

[ExcludeClass]

/**
 * @private
 */
public class NamespaceUtil
{
    public function NamespaceUtil()
    {
        super();
    }

    public static function getLocalName(xmlNode:XMLNode):String
    {
        var name:String = xmlNode.nodeName;
        var myPrefixIndex:int = name.indexOf(":");
        if (myPrefixIndex != -1)
        {
            name = name.substring(myPrefixIndex+1);
        }
        return name;
    }

    public static function getElementsByLocalName(xmlNode:XMLNode, lname:String):Array
    {
        var elements:Array;

        if (xmlNode is XMLDocument)
        {
            elements = getElementsByLocalName(xmlNode.firstChild, lname);
        }
        else
        {
            elements = [];
            if (getLocalName(xmlNode) == lname)
            {
                elements.push(xmlNode);
            }

            var numChildren:uint = xmlNode.childNodes.length;
            for (var i:uint = 0; i < numChildren; i++)
            {
                var subElement:XMLNode = xmlNode.childNodes[i];
                // NOTE: No longer digging deeper than one level (big perf boost)
                if (getLocalName(subElement) == lname)
                {
                    elements.push(subElement);
                }
            }
        }

        return elements;
    }
}

}