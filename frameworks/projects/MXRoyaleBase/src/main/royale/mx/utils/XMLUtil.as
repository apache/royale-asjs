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

package mx.utils
{

//import flash.xml.XMLDocument;

/**
 *  The XMLUtil class is an all-static class
 *  with methods for working with XML within Flex.
 *  You do not create instances of XMLUtil;
 *  instead you simply call static methods such as
 *  the <code>XMLUtil.qnamesEqual()</code> method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class XMLUtil
{
//	include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

    /**
     *  Creates XML out of the specified string, ignoring whitespace.
     *  This method is used to create objects defined in
	 *  <code>&lt;mx:XML&gt;</code> tags and WebService requests,
	 *  although they, in turn, get the <code>firstChild</code>
	 *  of the structure.
	 *
     *  @param str XML string.
	 *
     *  @return New XML object that ignored whitespace.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
    public static function createXMLDocument(str:String):XMLDocument
    {
	    var xml:XMLDocument = new XMLDocument();
        xml.ignoreWhite = true;
		xml.parseXML(str);
		return xml;
    }
     */

    /**
	 *  Returns <code>true</code> if the two QName parameters have identical
	 *  <code>uri</code> and <code>localName</code> properties.
	 *
	 *  @param qname1 First QName object.
	 *
	 *  @param qname2 Second QName object.
	 *
	 *  @return <code>true</code> if the two QName parameters have identical
	 *  <code>uri</code> and <code>localName</code> properties.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function qnamesEqual(qname1:QName, qname2:QName):Boolean
    {
        return qname1.uri == qname2.uri &&
			   qname1.localName == qname2.localName;
    }

    /**
	 *  Returns the concatenation of a Qname object's
	 *  <code>uri</code> and <code>localName</code> properties,
	 *  separated by a colon.
	 *  If the object does not have a <code>uri</code> property,
	 *  or the value of <code>uri</code> is the empty string,
	 *  returns the <code>localName</code> property.
	 *
	 *  @param qname QName object.
	 *
	 *  @return Concatenation of a Qname object's
	 *  <code>uri</code> and <code>localName</code> properties,
	 *  separated by a colon.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    public static function qnameToString(qname:QName):String
    {
        return qname.uri && qname.uri != "" ?
			   qname.uri + ":" + qname.localName :
			   qname.localName;
    }
    
    /**
    * Returns the XML value of an attribute matching the given QName
    * 
    * @param xml the XML object being inspected
    * @param attrQName the QName of the attribute to find
    * 
    * @return XMLList of matching attributes or an empty list if none are found.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public static function getAttributeByQName(xml:XML, attrQName:QName):XMLList
    {
        var attributes:XMLList = xml.attribute(attrQName);
        //xml.attribute(QName) will also return local no-namespace attributes
        //even if we are looking for a specific full qualified name.
        for each (var attribute:XML in attributes)
        {
            var thisQName:QName = attribute.name() as QName;
            if (thisQName.uri == attrQName.uri)
                return new XMLList(attribute);
        }  
        return new XMLList();
    }

}
}
