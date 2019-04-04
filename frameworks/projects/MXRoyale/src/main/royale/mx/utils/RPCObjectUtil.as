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

import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.describeType;
import flash.xml.XMLNode;

import mx.collections.IList;

/**
 *  The RPCObjectUtil class is a subset of ObjectUtil, removing methods
 *  that create dependency issues when RPC messages are in a bootstrap loader.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class RPCObjectUtil
{
    include "../core/Version.as";
    
    /**
    *  Array of properties to exclude from debugging output.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    private static var defaultToStringExcludes:Array = ["password", "credentials"];

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  Change deault set of strings to exclude.
	 * 
	 *  @param excludes The array of strings to exclude.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion ApacheFlex 4.10
	 */
	public static function setToStringExcludes(excludes:Array):void
	{
		defaultToStringExcludes = excludes;
	}
	
	private static var _externalToString:Function = null;
	
	/**
	 *  Assign an static external toString method rather than use the internal one.
	 * 
	 *  <p>The function passed in needs to have the same signature as toString.
	 *  <code>
	 *     public static function externalToString(value:Object, 
     *                              namespaceURIs:Array = null, 
     *                              exclude:Array = null):String
	 *  </code></p>
	 * 
	 *  @param externalToString The function to call instead of internalToString.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion ApacheFlex 4.10
	 */
	public static function externalToString(value:Function):void
	{
		_externalToString = value;
	}
	
    /**
     *  Pretty-prints the specified Object into a String.
     *  All properties will be in alpha ordering.
     *  Each object will be assigned an id during printing;
     *  this value will be displayed next to the object type token
     *  preceded by a '#', for example:
     *
     *  <pre>
     *  (mx.messaging.messages::AsyncMessage)#2.</pre>
     *
     *  <p>This id is used to indicate when a circular reference occurs.
     *  Properties of an object that are of the <code>Class</code> type will
     *  appear only as the assigned type.
     *  For example a custom definition like the following:</p>
     *
     *  <pre>
     *    public class MyCustomClass {
     *      public var clazz:Class;
     *    }</pre>
     * 
     *  <p>With the <code>clazz</code> property assigned to <code>Date</code>
     *  will display as shown below:</p>
     * 
     *  <pre>
     *   (somepackage::MyCustomClass)#0
     *      clazz = (Date)</pre>
     *
     *  @param obj Object to be pretty printed.
     * 
     *  @param namespaceURIs Array of namespace URIs for properties 
     *  that should be included in the output.
     *  By default only properties in the public namespace will be included in
     *  the output.
     *  To get all properties regardless of namespace pass an array with a 
     *  single element of "*".
     * 
     *  @param exclude Array of the property names that should be 
     *  excluded from the output.
     *  Use this to remove data from the formatted string.
     * 
     *  @return String containing the formatted version
     *  of the specified object.
     *
     *  @example
     *  <pre>
     *  // example 1
     *  var obj:AsyncMessage = new AsyncMessage();
     *  obj.body = [];
     *  obj.body.push(new AsyncMessage());
     *  obj.headers["1"] = { name: "myName", num: 15.3};
     *  obj.headers["2"] = { name: "myName", num: 15.3};
     *  obj.headers["10"] = { name: "myName", num: 15.3};
     *  obj.headers["11"] = { name: "myName", num: 15.3};
     *  trace(ObjectUtil.toString(obj));
     *
     *  // will output to flashlog.txt
     *  (mx.messaging.messages::AsyncMessage)#0
     *    body = (Array)#1
     *      [0] (mx.messaging.messages::AsyncMessage)#2
     *        body = (Object)#3
     *        clientId = (Null)
     *        correlationId = ""
     *        destination = ""
     *        headers = (Object)#4
     *        messageId = "378CE96A-68DB-BC1B-BCF7FFFFFFFFB525"
     *        sequenceId = (Null)
     *        sequencePosition = 0
     *        sequenceSize = 0
     *        timeToLive = 0
     *        timestamp = 0
     *    clientId = (Null)
     *    correlationId = ""
     *    destination = ""
     *    headers = (Object)#5
     *      1 = (Object)#6
     *        name = "myName"
     *        num = 15.3
     *      10 = (Object)#7
     *        name = "myName"
     *        num = 15.3
     *      11 = (Object)#8
     *        name = "myName"
     *        num = 15.3
     *      2 = (Object)#9
     *        name = "myName"
     *        num = 15.3
     *    messageId = "1D3E6E96-AC2D-BD11-6A39FFFFFFFF517E"
     *    sequenceId = (Null)
     *    sequencePosition = 0
     *    sequenceSize = 0
     *    timeToLive = 0
     *    timestamp = 0
     *
     *  // example 2 with circular references
     *  obj = {};
     *  obj.prop1 = new Date();
     *  obj.prop2 = [];
     *  obj.prop2.push(15.2);
     *  obj.prop2.push("testing");
     *  obj.prop2.push(true);
     *  obj.prop3 = {};
     *  obj.prop3.circular = obj;
     *  obj.prop3.deeper = new ErrorMessage();
     *  obj.prop3.deeper.rootCause = obj.prop3.deeper;
     *  obj.prop3.deeper2 = {};
     *  obj.prop3.deeper2.deeperStill = {};
     *  obj.prop3.deeper2.deeperStill.yetDeeper = obj;
     *  trace(ObjectUtil.toString(obj));
     *
     *  // will output to flashlog.txt
     *  (Object)#0
     *    prop1 = Tue Apr 26 13:59:17 GMT-0700 2005
     *    prop2 = (Array)#1
     *      [0] 15.2
     *      [1] "testing"
     *      [2] true
     *    prop3 = (Object)#2
     *      circular = (Object)#0
     *      deeper = (mx.messaging.messages::ErrorMessage)#3
     *        body = (Object)#4
     *        clientId = (Null)
     *        code = (Null)
     *        correlationId = ""
     *        destination = ""
     *        details = (Null)
     *        headers = (Object)#5
     *        level = (Null)
     *        message = (Null)
     *        messageId = "14039376-2BBA-0D0E-22A3FFFFFFFF140A"
     *        rootCause = (mx.messaging.messages::ErrorMessage)#3
     *        sequenceId = (Null)
     *        sequencePosition = 0
     *        sequenceSize = 0
     *        timeToLive = 0
     *        timestamp = 0
     *      deeper2 = (Object)#6
     *        deeperStill = (Object)#7
     *          yetDeeper = (Object)#0
     *  </pre>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function toString(value:Object, 
                                    namespaceURIs:Array = null, 
                                    exclude:Array = null):String
    {
        if (exclude == null)
        {
            exclude = defaultToStringExcludes;
        }
        
        refCount = 0;
		
		if (_externalToString != null) 
			return _externalToString(value, namespaceURIs, exclude);
		else
        	return internalToString(value, 0, null, namespaceURIs, exclude);
    }
    
    /**
     *  This method cleans up all of the additional parameters that show up in AsDoc
     *  code hinting tools that developers shouldn't ever see.
     *  @private
     */
    private static function internalToString(value:Object, 
                                             indent:int = 0,
                                             refs:Dictionary= null, 
                                             namespaceURIs:Array = null, 
                                             exclude:Array = null):String
    {
        var str:String;
        var type:String = value == null ? "null" : typeof(value);
		
        switch (type)
        {
            case "boolean":
            case "number":
            {
                return value.toString();
            }

            case "string":
            {
                return "\"" + value.toString() + "\"";
            }

            case "object":
            {
                if (value is Date)
                {
                    return value.toString();
                }
                else if (value is XMLNode)
                {
                    return value.toString();
                }
                else if (value is Class)
                {
                    return "(" + getQualifiedClassName(value) + ")";
                }
                else
                {
                    var classInfo:Object = getClassInfo(value, exclude,
                        { includeReadOnly: true, uris: namespaceURIs, includeTransient: false });
                        
                    var properties:Array = classInfo.properties;
                    
                    str = "(" + classInfo.name + ")";
                    
                    // refs help us avoid circular reference infinite recursion.
                    // Each time an object is encoumtered it is pushed onto the
                    // refs stack so that we can determine if we have visited
                    // this object already.
                    if (refs == null)
                        refs = new Dictionary(true);

                    // Check to be sure we haven't processed this object before
                    var id:Object = refs[value];
                    if (id != null)
                    {
                        str += "#" + int(id);
                        return str;
                    }
                    
                    if (value != null)
                    {
                        str += "#" + refCount.toString();
                        refs[value] = refCount;
                        refCount++;
                    }

                    var isArray:Boolean = value is Array;
                    var prop:*;
                    indent += 2;
                    
                    // Print all of the variable values.
					var length:int = properties.length;
                    for (var j:int = 0; j < length; j++)
                    {
                        str = newline(str, indent);
                        prop = properties[j];
                        if (isArray)
                            str += "[";
                        str += prop.toString();
                        if (isArray)
                            str += "] ";
                        else
                            str += " = ";
                        try
                        {
                            str += internalToString(
                                        value[prop], indent, refs, namespaceURIs, 
                                        exclude);
                        }
                        catch(e:Error)
                        {
                            // value[prop] can cause an RTE
                            // for certain properties of certain objects.
                            // For example, accessing the properties
                            //   actionScriptVersion
                            //   childAllowsParent
                            //   frameRate
                            //   height
                            //   loader
                            //   parentAllowsChild
                            //   sameDomain
                            //   swfVersion
                            //   width
                            // of a Stage's loaderInfo causes
                            //   Error #2099: The loading object is not
                            //   sufficiently loaded to provide this information
                            // In this case, we simply output ? for the value.
                            str += "?";
                        }
                    }
                    indent -= 2;
                    return str;
                }
                break;
            }

            case "xml":
            {
                return value.toString();
            }

            default:
            {
                return "(" + type + ")";
            }
        }
        
        return "(unknown)";
    }

    /**
     *  @private
     *  This method will append a newline and the specified number of spaces
     *  to the given string.
     */
    private static function newline(str:String, length:int = 0):String
    {
        var result:String = str + "\n";      
        for (var i:int = 0; i < length; i++)
        {
            result += " ";
        }
        return result;
    }
    
    
    /**
     *  Returns information about the class, and properties of the class, for
     *  the specified Object.
     *
     *  @param obj The Object to inspect.
     *
     *  @param exclude Array of Strings specifying the property names that should be 
     *  excluded from the returned result. For example, you could specify 
     *  <code>["currentTarget", "target"]</code> for an Event object since these properties 
     *  can cause the returned result to become large.
     *
     *  @param options An Object containing one or more properties 
     *  that control the information returned by this method. 
     *  The properties include the following:
     *
     *  <ul>
     *    <li><code>includeReadOnly</code>: If <code>false</code>, 
     *      exclude Object properties that are read-only. 
     *      The default value is <code>true</code>.</li>
     *  <li><code>includeTransient</code>: If <code>false</code>, 
     *      exclude Object properties and variables that have <code>[Transient]</code> metadata.
     *      The default value is <code>true</code>.</li>
     *  <li><code>uris</code>: Array of Strings of all namespaces that should be included in the output.
     *      It does allow for a wildcard of "~~". 
     *      By default, it is null, meaning no namespaces should be included. 
     *      For example, you could specify <code>["mx_internal", "mx_object"]</code> 
     *      or <code>["~~"]</code>.</li>
     *  </ul>
     * 
     *  @return An Object containing the following properties:
     *  <ul>
     *    <li><code>name</code>: String containing the name of the class;</li>
     *    <li><code>properties</code>: Sorted list of the property names of the specified object.</li>
     *  </ul>
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public static function getClassInfo(obj:Object,
                                        excludes:Array = null,
                                        options:Object = null):Object
    {   
        var length:int;
        var i:int;

		// this version doesn't handle ObjectProxy

        if (options == null)
            options = { includeReadOnly: true, uris: null, includeTransient: true };

        var result:Object;
        var propertyNames:Array = [];
        var cacheKey:String;

        var className:String;
        var classAlias:String;
        var properties:XMLList;
        var prop:XML;
        var dynamic:Boolean = false;
        var metadataInfo:Object;

        if (typeof(obj) == "xml")
        {
            className = "XML";
            properties = obj.text();
            if (properties.length())
                propertyNames.push("*");
            properties = obj.attributes();
        }
        else
        {
			// don't cache describe type.  Makes it slower, but fewer dependencies
            var classInfo:XML = describeType(obj);
            className = classInfo.@name.toString();
            classAlias = classInfo.@alias.toString();
            dynamic = (classInfo.@isDynamic.toString() == "true");

            if (options.includeReadOnly)
                properties = classInfo..accessor.(@access != "writeonly") + classInfo..variable;
            else
                properties = classInfo..accessor.(@access == "readwrite") + classInfo..variable;

            var numericIndex:Boolean = false;
        }

        // If type is not dynamic, check our cache for class info...
        if (!dynamic)
        {
            cacheKey = getCacheKey(obj, excludes, options);
            result = CLASS_INFO_CACHE[cacheKey];
            if (result != null)
                return result;
        }

        result = {};
        result["name"] = className;
        result["alias"] = classAlias;
        result["properties"] = propertyNames;
        result["dynamic"] = dynamic;
        result["metadata"] = metadataInfo = recordMetadata(properties);
        
        var excludeObject:Object = {};
        if (excludes)
        {
            length = excludes.length;
            for (i = 0; i < length; i++)
            {
                excludeObject[excludes[i]] = 1;
            }
        }

        var isArray:Boolean = className == "Array";
        if (dynamic)
        {
            for (var p:String in obj)
            {
                if (excludeObject[p] != 1)
                {
                    if (isArray)
                    {
                         var pi:Number = parseInt(p);
                         if (isNaN(pi))
                             propertyNames.push(new QName("", p));
                         else
                            propertyNames.push(pi);
                    }
                    else
                    {
                        propertyNames.push(new QName("", p));
                    }
                }
            }
            numericIndex = isArray && !isNaN(Number(p));
        }

        if (className == "Object" || isArray)
        {
            // Do nothing since we've already got the dynamic members
        }
        else if (className == "XML")
        {
            length = properties.length();
            for (i = 0; i < length; i++)
            {
                p = properties[i].name();
                if (excludeObject[p] != 1)
                    propertyNames.push(new QName("", "@" + p));
            }
        }
        else
        {
            length = properties.length();
            var uris:Array = options.uris;
            var uri:String;
            var qName:QName;
			var includeTransients:Boolean;
			
			includeTransients = options.hasOwnProperty("includeTransient") && options.includeTransient;
			
            for (i = 0; i < length; i++)
            {
                prop = properties[i];
                p = prop.@name.toString();
                uri = prop.@uri.toString();
                
                if (excludeObject[p] == 1)
                    continue;
                    
                if (!includeTransients && internalHasMetadata(metadataInfo, p, "Transient"))
                    continue;
                
                if (uris != null)
                {
                    if (uris.length == 1 && uris[0] == "*")
                    {   
                        qName = new QName(uri, p);
                        try
                        {
                            obj[qName]; // access the property to ensure it is supported
                            propertyNames.push();
                        }
                        catch(e:Error)
                        {
                            // don't keep property name 
                        }
                    }
                    else
                    {
                        for (var j:int = 0; j < uris.length; j++)
                        {
                            uri = uris[j];
                            if (prop.@uri.toString() == uri)
                            {
                                qName = new QName(uri, p);
                                try
                                {
                                    obj[qName];
                                    propertyNames.push(qName);
                                }
                                catch(e:Error)
                                {
                                    // don't keep property name 
                                }
                            }
                        }
                    }
                }
                else if (uri.length == 0)
                {
                    qName = new QName(uri, p);
                    try
                    {
                        obj[qName];
                        propertyNames.push(qName);
                    }
                    catch(e:Error)
                    {
                        // don't keep property name 
                    }
                }
            }
        }

        propertyNames.sort(Array.CASEINSENSITIVE |
                           (numericIndex ? Array.NUMERIC : 0));
        // remove any duplicates, i.e. any items that can't be distingushed by toString()
        length = propertyNames.length;
		for (i = 0; i < length - 1; i++)
        {
            // the list is sorted so any duplicates should be adjacent
            // two properties are only equal if both the uri and local name are identical
            if (propertyNames[i].toString() == propertyNames[i + 1].toString())
            {
                propertyNames.splice(i, 1);
                i--; // back up
            }
        }

        // For normal, non-dynamic classes we cache the class info
        if (!dynamic)
        {
            cacheKey = getCacheKey(obj, excludes, options);
            CLASS_INFO_CACHE[cacheKey] = result;
        }

        return result;
    }

    /**
     *  @private
     */
    private static function internalHasMetadata(metadataInfo:Object, propName:String, metadataName:String):Boolean
    {
        if (metadataInfo != null)
        {
            var metadata:Object = metadataInfo[propName];
            if (metadata != null)
            {
                if (metadata[metadataName] != null)
                    return true;
            }
        }
        return false;
    }

    /**
     *  @private
     */
    private static function recordMetadata(properties:XMLList):Object
    {
        var result:Object = null;

        try
        {
            for each (var prop:XML in properties)
            {
                var propName:String = prop.attribute("name").toString();
                var metadataList:XMLList = prop.metadata;

                if (metadataList.length() > 0)
                {
                    if (result == null)
                        result = {};

                    var metadata:Object = {};
                    result[propName] = metadata;

                    for each (var md:XML in metadataList)
                    {
                        var mdName:String = md.attribute("name").toString();
                        
                        var argsList:XMLList = md.arg;
                        var value:Object = {};

                        for each (var arg:XML in argsList)
                        {
                            var argKey:String = arg.attribute("key").toString();
                            if (argKey != null)
                            {
                                var argValue:String = arg.attribute("value").toString();
                                value[argKey] = argValue;
                            }
                        }

                        var existing:Object = metadata[mdName];
                        if (existing != null)
                        {
                            var existingArray:Array;
                            if (existing is Array)
                                existingArray = existing as Array;
                            else
                                existingArray = [];
                            existingArray.push(value);
                            existing = existingArray;
                        }
                        else
                        {
                            existing = value;
                        }
                        metadata[mdName] = existing;
                    }
                }
            }
        }
        catch(e:Error)
        {
        }
        
        return result;
    }

    /**
     *  @private
     */
    private static function getCacheKey(o:Object, excludes:Array = null, options:Object = null):String
    {
        var key:String = getQualifiedClassName(o);

        if (excludes != null)
        {
			var length:int = excludes.length;
            for (var i:uint = 0; i < length; i++)
            {
                var excl:String = excludes[i] as String;
                if (excl != null)
                    key += excl;
            }
        }

        if (options != null)
        {
            for (var flag:String in options)
            {
                key += flag;
				var value:String = options[flag];
				if (value != null)
					key += value.toString();
            }
        }
        return key;
    }

   
    /**
     * @private
     */
    private static var refCount:int = 0;

    /**
     * @private
     */ 
    private static var CLASS_INFO_CACHE:Object = {};
}

}