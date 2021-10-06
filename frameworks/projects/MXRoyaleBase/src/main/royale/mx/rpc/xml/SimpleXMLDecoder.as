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
  
  /*  import flash.xml.XMLNode;
    import flash.xml.XMLNodeType;*/
    import mx.collections.ArrayCollection;
    import mx.utils.ObjectProxy;
    
    /**
     *  The SimpleXMLDecoder class deserialize XML into a graph of ActionScript objects.
     * Use  this class when no schema information is available.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public class SimpleXMLDecoder
    {
        //--------------------------------------------------------------------------
        //
        //  Class Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */
        public static function simpleType(val:String):Object
        {
            var result:Object = val;
            
            if (val != null)
            {
                //return the value as a string, a boolean or a number.
                //numbers that start with 0 are left as strings
                //bForceObject removed since we'll take care of converting to a String or Number object later
                if (val is String && String(val) == "")
                {
                    result = val.toString();
                }
                else if (isNaN(Number(val)) || (val.charAt(0) == '0') || ((val.charAt(0) == '-') && (val.charAt(1) == '0')) || val.charAt(val.length -1) == 'E')
                {
                    var valStr:String = val.toString();
                    
                    //Bug 101205: Also check for boolean
                    var valStrLC:String = valStr.toLowerCase();
                    if (valStrLC == "true")
                        result = true;
                    else if (valStrLC == "false")
                        result = false;
                    else
                        result = valStr;
                }
                else
                {
                    result = Number(val);
                }
            }
            
            return result;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  Constructor.
         */
        public function SimpleXMLDecoder(makeObjectsBindable:Boolean = false)
        {
            super();
            
            this.makeObjectsBindable = makeObjectsBindable;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Converts a tree of XMLNodes into a tree of ActionScript Objects.
         *
         *  @param dataNode An XMLNode to be converted into a tree of ActionScript Objects.
         *
         *  @return A tree of ActionScript Objects.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function decodeXML(dataNode:XML):Object
        {
            var result:Object;
            var isSimpleType:Boolean = false;
            
            if (dataNode == null)
                return null;
            
            // Cycle through the subnodes
            var children:XMLList = dataNode.children();
            if (children.length() == 1 && children[0].nodeKind() == 'text')
            {
                // If exactly one text node subtype, we must want a simple
                // value.
                isSimpleType = true;
                result = SimpleXMLDecoder.simpleType(children[0].toString());
            }
            else if (children.length() > 0)
            {
                result = {};
                if (makeObjectsBindable)
                    result = new ObjectProxy(result);
                
                for (var i:uint = 0; i < children.length(); i++)
                {
                    var partNode:XML = children[i];
                    
                    // skip text nodes, which are part of mixed content
                    if (partNode.nodeKind() != 'element')
                    {
                        continue;
                    }
                    
                    var partName:String = getLocalName(partNode);
                    var partObj:Object = decodeXML(partNode);
                    
                    // Enable processing multiple copies of the same element (sequences)
                    var existing:Object = result[partName];
                    if (existing != null)
                    {
                        if (existing is Array)
                        {
                            existing.push(partObj);
                        }
                        else if (existing is ArrayCollection)
                        {
                            existing.source.push(partObj);
                        }
                        else
                        {
                            existing = [existing];
                            existing.push(partObj);
                            
                            if (makeObjectsBindable)
                                existing = new ArrayCollection(existing as Array);
                            
                            result[partName] = existing;
                        }
                    }
                    else
                    {
                        result[partName] = partObj;
                    }
                }
            }
            
            // Cycle through the attributes
            var attributes:XMLList = dataNode.attributes();
            for each (var attribute:XML in attributes)
            {
              /*  if (attribute == "xmlns" || attribute.indexOf("xmlns:") != -1)
                    continue;*/
                
                // result can be null if it contains no children.
                if (result == null)
                {
                    result = {};
                    if (makeObjectsBindable)
                        result = new ObjectProxy(result);
                }
                
                // If result is not currently an Object (it is a Number, Boolean,
                // or String), then convert it to be a ComplexString so that we
                // can attach attributes to it.  (See comment in ComplexString.as)
                if (isSimpleType && !(result is ComplexString))
                {
                    result = new ComplexString(result.toString());
                    isSimpleType = false;
                }
                
                result[attribute.localName()] = SimpleXMLDecoder.simpleType(attribute.toString());
            }
            
            return result;
        }
        
        /**
         * Returns the local name of an XMLNode.
         *
         *  @param xmlNode The XMLNode.
         *
         * @return The local name of an XMLNode.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function getLocalName(xml:XML):String
        {
            var name:String = xml.localName().toString();
            /*var myPrefixIndex:int = name.indexOf(":");
            if (myPrefixIndex != -1)
            {
                name = name.substring(myPrefixIndex+1);
            }*/
            return name;
        }
        
        private var makeObjectsBindable:Boolean;
    }
    
}
