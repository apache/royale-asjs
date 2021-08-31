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

COMPILE::SWF
{
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.ByteArray;
    import flash.xml.XMLNode;
}
COMPILE::JS
{
    import org.apache.royale.reflection.describeType;
    import org.apache.royale.reflection.TypeDefinition;
    import org.apache.royale.reflection.AccessorDefinition;
    import org.apache.royale.reflection.VariableDefinition;
    import org.apache.royale.reflection.MetaDataDefinition;
    import org.apache.royale.reflection.MetaDataArgDefinition;
    import org.apache.royale.reflection.MemberDefinitionBase;

    import org.apache.royale.reflection.getAliasByClass;
    import org.apache.royale.reflection.getDefinitionByName;
    import org.apache.royale.reflection.getDynamicFields;
    
    import org.apache.royale.reflection.utils.getMembers;
    import org.apache.royale.reflection.utils.MemberTypes;
    
    import org.apache.royale.net.remoting.amf.AMFBinaryData;
    import org.apache.royale.utils.BinaryData;
    import goog.DEBUG;
}
import mx.collections.IList;
import org.apache.royale.reflection.getQualifiedClassName;
import org.apache.royale.reflection.isDynamicObject;
import org.apache.royale.reflection.getDynamicFields;

/**
 *  The ObjectUtil class is an all-static class with methods for
 *  working with Objects within Flex.
 *  You do not create instances of ObjectUtil;
 *  instead you simply call static methods such as the
 *  <code>ObjectUtil.isSimple()</code> method.
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 *
 *  @royalesuppressexport
 *  JS PAYG : non-reflectable utility class, unused methods will be subject to deadcode elimination
 */
public class ObjectUtil
{
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
     *  Compares the Objects and returns an integer value
     *  indicating if the first item is less than, greater than, or equal to
     *  the second item.
     *  This method will recursively compare properties on nested objects and
     *  will return as soon as a non-zero result is found.
     *  By default this method will recurse to the deepest level of any property.
     *  To change the depth for comparison specify a non-negative value for
     *  the <code>depth</code> parameter.
     *
     *  @param a Object.
     *
     *  @param b Object.
     *
     *  @param depth Indicates how many levels should be
     *  recursed when performing the comparison.
     *  Set this value to 0 for a shallow comparison of only the primitive
     *  representation of each property.
     *  For example:<pre>
     *  var a:Object = {name:"Bob", info:[1,2,3]};
     *  var b:Object = {name:"Alice", info:[5,6,7]};
     *  var c:int = ObjectUtil.compare(a, b, 0);</pre>
     *
     *  <p>In the above example the complex properties of <code>a</code> and
     *  <code>b</code> will be flattened by a call to <code>toString()</code>
     *  when doing the comparison.
     *  In this case the <code>info</code> property will be turned into a string
     *  when performing the comparison.</p>
     *
     *  @return Return 0 if a and b are equal, or both null or NaN.
     *  Return 1 if a is null or greater than b.
     *  Return -1 if b is null or greater than a.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function compare(a:Object, b:Object, depth:int = -1):int
    {
        COMPILE::SWF{
            return internalCompare(a, b, 0, depth, new Dictionary(true));
        }
        COMPILE::JS{
            return internalCompare(a, b, 0, depth, new WeakMap());
        }
    }

    /**
     *  Copies the specified Object and returns a reference to the copy.
     *  The copy is made using a native serialization technique.
     *  This means that custom serialization will be respected during the copy.
     *
     *  <p>This method is designed for copying data objects,
     *  such as elements of a collection. It is not intended for copying
     *  a UIComponent object, such as a TextInput control. If you want to create copies
     *  of specific UIComponent objects, you can create a subclass of the component and implement
     *  a <code>clone()</code> method, or other method to perform the copy.</p>
     *
     *  @param value Object that should be copied.
     *
     *  @return Copy of the specified Object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function copy(value:Object):Object
    {
        COMPILE::SWF{
            //could use AMFBinaryData here as well, but using direct native ByteArray instead:
            var buffer:flash.utils.ByteArray = new flash.utils.ByteArray();
        }
        COMPILE::JS{
            var buffer:AMFBinaryData = new AMFBinaryData();
        }
        buffer.writeObject(value);
        buffer.position = 0;
        var result:Object = buffer.readObject();
        
        return result;
    }

    /**
     *  Clones the specified Object and returns a reference to the clone.
     *  The clone is made using a native serialization technique.
     *  This means that custom serialization will be respected during the
     *  cloning.  clone() differs from copy() in that the uid property of
     *  each object instance is retained.
     *
     *  <p>This method is designed for cloning data objects,
     *  such as elements of a collection. It is not intended for cloning
     *  a UIComponent object, such as a TextInput control. If you want to clone
     *  specific UIComponent objects, you can create a subclass of the component
     *  and implement a <code>clone()</code> method.</p>
     *
     *  @param value Object that should be cloned.
     *
     *  @return Clone of the specified Object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    public static function clone(value:Object):Object
    {
        var result:Object = copy(value);
        cloneInternal(result, value);
        return result;
    }

    /**
     *  Recursive helper used by the public clone method.
     *  @private
     */
    private static function cloneInternal(result:Object, value:Object):void
    {
        if (value && /*value.hasOwnProperty*/("uid" in value))
            result.uid = value.uid;
    
        var classInfo:Object = getClassInfo(value);
        var v:Object;
        for each (var p:* in classInfo.properties)
        {
            //@todo the following 'v = value[p]' will only be emulated safely in js by using reflection library:
            v = value[p];
            if (v && /*v.hasOwnProperty*/("uid" in v))
                cloneInternal(result[p], v);
        }
    }

    /**
     *  Returns <code>true</code> if the object reference specified
     *  is a simple data type. The simple data types include the following:
     *  <ul>
     *    <li><code>String</code></li>
     *    <li><code>Number</code></li>
     *    <li><code>uint</code></li>
     *    <li><code>int</code></li>
     *    <li><code>Boolean</code></li>
     *    <li><code>Date</code></li>
     *    <li><code>Array</code></li>
     *  </ul>
     *
     *  @param value Object inspected.
     *
     *  @return <code>true</code> if the object specified
     *  is one of the types above; <code>false</code> otherwise.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function isSimple(value:Object):Boolean
    {
        var objectType:String = typeof(value);
        switch (objectType)
        {
            case "number":
            case "string":
            case "boolean":
            {
                return true;
            }

            case "object":
            {
                return (value is Date) || (value is Array);
            }
        }

        return false;
    }

    /**
     *  Compares two numeric values.
     *
     *  @param a First number.
     *
     *  @param b Second number.
     *
     *  @return 0 is both numbers are NaN.
     *  1 if only <code>a</code> is a NaN.
     *  -1 if only <code>b</code> is a NaN.
     *  -1 if <code>a</code> is less than <code>b</code>.
     *  1 if <code>a</code> is greater than <code>b</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function numericCompare(a:Number, b:Number):int
    {
        if (isNaN(a) && isNaN(b))
            return 0;

        if (isNaN(a))
            return 1;

        if (isNaN(b))
           return -1;

        if (a < b)
            return -1;

        if (a > b)
            return 1;

        return 0;
    }

    /**
     *  Compares two String values.
     *
     *  @param a First String value.
     *
     *  @param b Second String value.
     *
     *  @param caseInsensitive Specifies to perform a case insensitive compare,
     *  <code>true</code>, or not, <code>false</code>.
     *
     *  @return 0 is both Strings are null.
     *  1 if only <code>a</code> is null.
     *  -1 if only <code>b</code> is null.
     *  -1 if <code>a</code> precedes <code>b</code>.
     *  1 if <code>b</code> precedes <code>a</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function stringCompare(a:String, b:String,
                                         caseInsensitive:Boolean = false):int
    {
        if (a == null && b == null)
            return 0;

        if (a == null)
          return 1;

        if (b == null)
           return -1;

        // Convert to lowercase if we are case insensitive.
        if (caseInsensitive)
        {
            a = a.toLocaleLowerCase();
            b = b.toLocaleLowerCase();
        }

        var result:int = a.localeCompare(b);

        if (result < -1)
            result = -1;
        else if (result > 1)
            result = 1;

        return result;
    }

    /**
     *  Compares the two Date objects and returns an integer value
     *  indicating if the first Date object is before, equal to,
     *  or after the second item.
     *
     *  @param a Date object.
     *
     *  @param b Date object.
     *
     *  @return 0 if <code>a</code> and <code>b</code> are equal
     *  (or both are <code>null</code>);
     *  -1 if <code>a</code> is before <code>b</code>
     *  (or <code>b</code> is <code>null</code>);
     *  1 if <code>a</code> is after <code>b</code>
     *  (or <code>a</code> is <code>null</code>);
	 *  0 is both dates getTime's are NaN;
     *  1 if only <code>a</code> getTime is a NaN;
     *  -1 if only <code>b</code> getTime is a NaN.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function dateCompare(a:Date, b:Date):int
    {
        if (a == null && b == null)
            return 0;

        if (a == null)
          return 1;

        if (b == null)
           return -1;

        var na:Number = a.getTime();
        var nb:Number = b.getTime();

        if (na < nb)
            return -1;

        if (na > nb)
            return 1;

		if (isNaN(na) && isNaN(nb))
			return 0;

		if (isNaN(na))
			return 1;

		if (isNaN(nb))
			return -1;

        return 0;
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
     *  @param value Object to be pretty printed.
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
     *
     * // example 3 with Dictionary
     * var point:Point = new Point(100, 100);
     * var point2:Point = new Point(100, 100);
     * var obj:Dictionary = new Dictionary();
     * obj[point] = "point";
     * obj[point2] = "point2";
     * obj["1"] = { name: "one", num: 1};
     * obj["two"] = { name: "2", num: 2};
     * obj[3] = 3;
     * trace(ObjectUtil.toString(obj));
     *
     * // will output to flashlog.txt
     * (flash.utils::Dictionary)#0
     *   {(flash.geom::Point)#1
     *     length = 141.4213562373095
     *     x = 100
     *     y = 100} = "point2"
     *   {(flash.geom::Point)#2
     *     length = 141.4213562373095
     *     x = 100
     *     y = 100} = "point"
     *   {1} = (Object)#3
     *     name = "one"
     *     num = 1
     *   {3} = 3
     *   {"two"} = (Object)#4
     *     name = "2"
     *     num = 2
     *
     * </pre>
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *
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
        return internalToString(value, 0, null, namespaceURIs, exclude);
    }

    /**
     *  This method cleans up all of the additional parameters that show up in AsDoc
     *  code hinting tools that developers shouldn't ever see.
     *  @private
     *
     *  @royaleignorecoercion WeakMap
     */
    private static function internalToString(value:Object,
                                             indent:int = 0,
											 refs:Object = null,
                                             namespaceURIs:Array = null,
                                             exclude:Array = null):String
    {
        var str:String;
        var objectType:String = value == null ? "null" : typeof(value);
        COMPILE::SWF{
            //the following only works for swf (covers XML and XMLList):
            if (objectType == 'xml') return value.toXMLString();
        }
        switch (objectType)
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
                COMPILE::SWF{
                    if (value is XMLNode)
                    {
                        return value.toString();
                    }
                }
                COMPILE::JS{
                    if (value is XML || value is XMLList){
                        return value.toXMLString();
                    }
                }
                
                
                if (value is Date)
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
                            { includeReadOnly: true, uris: namespaceURIs });
                
                    var properties:Array = classInfo.properties;
                
                    str = "(" + classInfo.name + ")";
                
                    // refs help us avoid circular reference infinite recursion.
                    // Each time an object is encoumtered it is pushed onto the
                    // refs stack so that we can determine if we have visited
                    // this object already.
                    COMPILE::SWF{
                        if (refs == null)
                            refs = new Dictionary(true);
                    }
                    COMPILE::JS{
                        if (refs == null)
                            refs = new WeakMap();
                    }
                
                    // Check to be sure we haven't processed this object before
                    // Dictionary has some bugs, so we want to work around them as best we can
                    try
                    {
                        var id:Object ;
                        COMPILE::SWF{id = refs[value];}
                        COMPILE::JS{id = (refs as WeakMap).get(value);}
                        
                        if (id != null)
                        {
                            str += "#" + int(id);
                            return str;
                        }
                    }
                    catch (e:Error)
                    {
                        //Since we can't test for infinite loop, we simply return toString.
                        return String(value);
                    }
                
                    if (value != null)
                    {
                        str += "#" + refCount.toString();
                        COMPILE::SWF{
                            refs[value] = refCount;
                        }
                        COMPILE::JS{
                            WeakMap(refs).set(value,refCount);
                        }
                       
                        refCount++;
                    }
                
                    var isArray:Boolean = value is Array;
                    var isDict:Boolean;
                    COMPILE::SWF{
                        isDict = value is Dictionary
                    }
                    COMPILE::JS{
                        isDict = value instanceof Map || value instanceof WeakMap;
                    }
                    var prop:*;
                    indent += 2;
                
                    // Print all of the variable values.
                    for (var j:int = 0; j < properties.length; j++)
                    {
                        str = newline(str, indent);
                        prop = properties[j];
                    
                        if (isArray)
                            str += "[";
                        else if (isDict)
                            str += "{";
                    
                    
                        if (isDict)
                        {
                            // in dictionaries, recurse on the key, because it can be a complex object
                            COMPILE::SWF{
                                str += internalToString(prop, indent, refs,
                                        namespaceURIs, exclude);
                            }
                           COMPILE::JS{
                               str += " Map or WeakMap key (not stringified) ";
                           }
                        }
                        else
                        {
                            str += prop.toString();
                        }
                    
                        if (isArray)
                            str += "] ";
                        else if (isDict)
                            str += "} = ";
                        else
                            str += " = ";
                    
                        try
                        {
                            // print the value
                            var val:Object;
                            COMPILE::JS{
                                if (isDict) val = value.get(prop);
                                    else val = value[prop];
                            }
                            COMPILE::SWF{
                                val = value[prop];
                            }
                            str += internalToString(val, indent, refs,
                                    namespaceURIs, exclude);
                           
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
                            
                            //this is for swf target.
                            str += "?";
                        }
                    }
                    indent -= 2;
                    return str;
                }
                break;
            }
       
            default:
            {
                return "(" + objectType + ")";
            }
        }
    }

    /**
     *  @private
     *  This method will append a newline and the specified number of spaces
     *  to the given string.
     *
     */
    private static function newline(str:String, n:int = 0):String
    {
        var result:String = str;
        result += "\n";

        for (var i:int = 0; i < n; i++)
        {
            result += " ";
        }
        return result;
    }
    /**
     *  @royaleignorecoercion WeakMap
     *  @royaleignorecoercion BinaryData
     */
    private static function internalCompare(a:Object, b:Object,
                                            currentDepth:int, desiredDepth:int,
                                            /*refs:Dictionary*/ refs:Object):int
    {
        if (a == null && b == null)
            return 0;

        if (a == null)
            return 1;

        if (b == null)
            return -1;
//@todo ObjectProxy

//        if (a is ObjectProxy)
//            a = ObjectProxy(a).object_proxy::object;
//
//        if (b is ObjectProxy)
//            b = ObjectProxy(b).object_proxy::object;

        var typeOfA:String = typeof(a);
        var typeOfB:String = typeof(b);

        var result:int = 0;

        if (typeOfA == typeOfB)
        {
            switch(typeOfA)
            {
                case "boolean":
                    result = numericCompare(Number(a), Number(b));
                	break;

                case "number":
                    result = numericCompare(a as Number, b as Number);
                    break;

                case "string":
                    result = stringCompare(a as String, b as String);
                    break;

                case "object":
                    var newDepth:int = desiredDepth > 0 ? desiredDepth -1 : desiredDepth;
                    COMPILE::SWF{
                        const byteArrayClass:Class = flash.utils.ByteArray;
                    }
                    COMPILE::JS{
                        const byteArrayClass:Class = BinaryData;
                    }
                    // refs help us avoid circular reference infinite recursion.
                    var aRef:Object = getRef(a,refs);
                    var bRef:Object = getRef(b,refs);

                    if (aRef == bRef)
                        return 0;
                    // the cool thing about our dictionary is that if
                    // we've seen objects and determined that they are unequal, then
                    // we would've already exited out of this compare() call.  So the
                    // only info in the dictionary are sets of equal items

                    // let's first define them as equal
                    // this stops an "infinite loop" problem where A.i = B and B.i = A
                    // if we later find that an object (one of the subobjects) is in fact unequal,
                    // then we will return false and quit out of everything.  These refs are thrown away
                    // so it doesn't matter if it's correct.
                    COMPILE::SWF{
                        refs[bRef] = aRef;
                    }
                    COMPILE::JS{
                        (refs as WeakMap).set(bRef, aRef);
                    }
                    
                    if (desiredDepth != -1 && (currentDepth > desiredDepth))
                    {
                        // once we try to go beyond the desired depth we should
                        // toString() our way out
                        result = stringCompare(a.toString(), b.toString());
                    }
                    else if ((a is Array) && (b is Array))
                    {
                        result = arrayCompare(a as Array, b as Array, currentDepth, desiredDepth, refs);
                    }
                    else if ((a is Date) && (b is Date))
                    {
                        result = dateCompare(a as Date, b as Date);
                    }
                    else if ((a is IList) && (b is IList))
                    {
                        result = listCompare(a as IList, b as IList, currentDepth, desiredDepth, refs);
                    }
                    else if ((a is byteArrayClass) && (b is byteArrayClass))
                    {
                        COMPILE::SWF{
                            result = byteArrayCompare(a as flash.utils.ByteArray, b as flash.utils.ByteArray);
                        }
                        COMPILE::JS{
                            result = byteArrayCompare(a as BinaryData, b as BinaryData);
                        }
                        
                    }
                    else if (getQualifiedClassName(a) == getQualifiedClassName(b))
                    {
                        var aProps:Array = getClassInfo(a).properties;
                        var bProps:Array;
    
                        // if the objects are dynamic they could have different
                        // # of properties and should be treated on that basis first
                        var isObjectDynamic:Boolean = isDynamicObject(a);
    
                        // if it's dynamic, check to see that they have all the same properties
                        if (isObjectDynamic)
                        {
                            bProps = getClassInfo(b).properties;
                            result = arrayCompare(aProps, bProps, currentDepth, newDepth, refs);
                            if (result != 0)
                                return result;
                        }
    
                        // now that we know we have the same properties, let's compare the values
                        var propName:QName;
                        var aProp:Object;
                        var bProp:Object;
                        for (var i:int = 0; i < aProps.length; i++)
                        {
                            propName = aProps[i];
                            aProp = a[propName];
                            bProp = b[propName];
                            result = internalCompare(aProp, bProp, currentDepth+1, newDepth, refs);
                            if (result != 0)
                            {
                                return result;
                            }
                        }
                    }
                    else
                    {
                        // We must be unequal, so return 1
                        return 1;
                    }
                    break;

				default:
					break;
            }
        }
        else // be consistent with the order we return here
        {
            return stringCompare(typeOfA, typeOfB);
        }

        return result;
    }
    
    
    COMPILE::JS
    private static var _debugCheck:Boolean;
    
    //by default the 'name' in classInfo objects is of legacy form: package.name::ClassName
    //it can be changed to: package.name.ClassName
    //this is assumed to be set at startup before cache becomes populated.
    //otherwise this should be changed to a setter and empty CLASS_INFO_CACHE on toggle.
    public static var USE_DOUBLE_COLON:Boolean = true;

    /**
     *  Returns information about the class, and properties of the class, for
     *  the specified Object.
     *
     *  @param obj The Object to inspect.
     *
     *  @param excludes Array of Strings specifying the property names that should be
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
     *    <li><code>name</code>: String containing the name of the class.</li>
     *    <li><code>properties</code>: Sorted list of the property names of the specified object,
     *    or references to the original key if the specified object is a Dictionary. The individual
     *    array elements are QName instances, which contain both the local name of the property as well as the URI.</li>
     *  </ul>
    *
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    *
    */
    COMPILE::SWF
    public static function getClassInfo(obj:Object,
                                        excludes:Array = null,
                                        options:Object = null):Object
    {
        if (options == null)
            options = { includeReadOnly: true, uris: null, includeTransient: true };
        var n:int;
        var i:int;
        var p:String;
        //@todo ObjectProxy
        //if (obj is ObjectProxy)
        //    obj = ObjectProxy(obj).object_proxy::object;
        
        var result:Object;
        var propertyNames:Array = [];
        var cacheKey:String;
        var numericIndex:Boolean = false;
        var className:String;
        var classAlias:String;
        var properties:XMLList;
        var prop:XML;
        var isDynamic:Boolean = false;
        var metadataInfo:Object;
        
        if (typeof(obj) == "xml") //covers both XML and XMLList
        {
            className = "XML";
            properties = obj.text();
            if (properties.length())
                propertyNames.push("*");
            properties = obj.attributes();
        }
        else
        {
            var classInfo:XML = /*DescribeTypeCache.*/describeType(obj)/*.typeDescription*/;
            
            className = classInfo.@name.toString();
            if (!USE_DOUBLE_COLON) {
                i = className.lastIndexOf('::');
                if (i != -1) {
                    className = className.substr(0,i) + '.'+ className.substr(i+2);
                }
            }
            classAlias = classInfo.@alias.toString();
            isDynamic = classInfo.@isDynamic.toString() == "true";
            
            if (options.includeReadOnly)
                properties = classInfo..accessor.(@access != "writeonly") + classInfo..variable;
            else
                properties = classInfo..accessor.(@access == "readwrite") + classInfo..variable;
        }
        
        // If type is not dynamic, check our cache for class info...(except for XML)
        if (!isDynamic && className != "XML")
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
        result["dynamic"] = isDynamic;
        result["metadata"] = metadataInfo = recordMetadata(properties);
        
        var excludeObject:Object = {};
        if (excludes)
        {
            n = excludes.length;
            for (i = 0; i < n; i++)
            {
                excludeObject[excludes[i]] = 1;
            }
        }
        
        var isArray:Boolean = (obj is Array);
        var isDict:Boolean  = (obj is Dictionary);
        
        if (isDict)
        {
            // dictionaries can have multiple keys of the same type,
            // (they can index by reference rather than QName, String, or number),
            // which cannot be looked up by QName, so use references to the actual key
            for (var key:* in obj)
            {
                propertyNames.push(key);
            }
        }
        else if (isDynamic)
        {
            for (p in obj)
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
        
        if (isArray || isDict || className == "Object")
        {
            // Do nothing since we've already got the dynamic members
        }
        else if (className == "XML")
        {
            n = properties.length();
            for (i = 0; i < n; i++)
            {
                p = properties[i].name();
                if (excludeObject[p] != 1)
                    propertyNames.push(new QName("", "@" + p));
            }
        }
        else
        {
            n = properties.length();
            var uris:Array = options.uris;
            var uri:String;
            var qName:QName;
            for (i = 0; i < n; i++)
            {
                prop = properties[i];
                p = prop.@name.toString();
                uri = prop.@uri.toString();
                
                if (excludeObject[p] == 1)
                    continue;
                
                if (!options.includeTransient && internalHasMetadata(metadataInfo, p, "Transient"))
                    continue;
                
                if (uris != null)
                {
                    if (uris.length == 1 && uris[0] == "*")
                    {
                        qName = new QName(uri, p);
                        try
                        {
                            obj[qName]; // access the property to ensure it is supported
                            propertyNames.push(qName); //<-- (Greg) this was changed compared to the original flex code, only on a hunch... it 'looked' like a bug based on the comment below
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
        
        propertyNames.sort(Array.CASEINSENSITIVE | (numericIndex ? Array.NUMERIC : 0));
        
        // dictionary keys can be indexed by an object reference
        // there's a possibility that two keys will have the same toString()
        // so we don't want to remove duplicates
        if (!isDict)
        {
            // for Arrays, etc., on the other hand...
            // remove any duplicates, i.e. any items that can't be distingushed by toString()
            for (i = 0; i < propertyNames.length - 1; i++)
            {
                // the list is sorted so any duplicates should be adjacent
                // two properties are only equal if both the uri and local name are identical
                if (propertyNames[i].toString() == propertyNames[i + 1].toString())
                {
                    propertyNames.splice(i, 1);
                    i--; // back up
                }
            }
        }
        
        // For normal, non-dynamic classes we cache the class info
        // Don't cache XML as it can be dynamic
        if (!isDynamic && className != "XML")
        {
            cacheKey = getCacheKey(obj, excludes, options);
            CLASS_INFO_CACHE[cacheKey] = result;
        }
        
        return result;
    }
    
    
    /**
     *  Returns information about the class, and properties of the class, for
     *  the specified Object.
     *
     *  @param obj The Object to inspect.
     *
     *  @param excludes Array of Strings specifying the property names that should be
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
     *    <li><code>name</code>: String containing the name of the class.</li>
     *    <li><code>properties</code>: Sorted list of the property names of the specified object,
     *    or references to the original key if the specified object is a Dictionary. The individual
     *    array elements are QName instances, which contain both the local name of the property as well as the URI.</li>
     *  </ul>
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *
     *  @royaleignorecoercion Class
     *  @royaleignorecoercion Map
     *  @royaleignorecoercion WeakMap
     */
    COMPILE::JS
    public static function getClassInfo(obj:Object,
                                        excludes:Array = null,
                                        options:Object = null):ClassInfo
    {
        if (options == null)
            options = { includeReadOnly: true, uris: null, includeTransient: true };
        
        var n:int;
        var i:int;
        var p:String;
        
        //@todo ObjectProxy
        //if (obj is ObjectProxy)
        //    obj = ObjectProxy(obj).object_proxy::object;
        
        var result:ClassInfo;
        var properties:Array ;
        var propertyNames:Array = [];
        var cacheKey:String;
        
        var className:String;
        var classAlias:String='';
        var isDynamic:Boolean = false;
        var metadataInfo:Object;
        
        var prop:MemberDefinitionBase;
        var excludeObject:Object = {};
        if (excludes)
        {
            n = excludes.length;
            for (i = 0; i < n; i++)
            {
                excludeObject[excludes[i]] = 1;
            }
        }
        
        if (obj is XML || obj is XMLList)
        {
            className = "XML";
            classAlias = null; //<- this is to be consistent with swf implementation results
            var xmlproperties:XMLList = obj.text();
            if (xmlproperties.length())
                propertyNames.push("*");
            xmlproperties = obj.attributes();
            n = xmlproperties.length();
            for (i = 0; i < n; i++)
            {
                p = xmlproperties[i].name();
                if (excludeObject[p] != 1)
                    propertyNames.push(new QName("", "@" + p));
            }
        }
        else
        {
            var classInfo:TypeDefinition = describeType(obj);
            if (classInfo == null) // probably not a Royale class
            {
                if (obj && obj.constructor != Object) {
                    //this can get the name of some native classes without repeating the same logic here.
                    className = getQualifiedClassName(obj);
                    if (USE_DOUBLE_COLON) {
                        i = className.lastIndexOf('.');
                        if (i != -1) {
                            className = className.substr(0,i) + '::'+ className.substr(i+1);
                        }
                    }
                    
                    //warn in debug build:
                    if (goog.DEBUG) {
                        if (!_debugCheck) {
                            _debugCheck = true;
                            if (describeType([]) == null) {
                                console.warn("You may need to add ExtraData to support this application's reflection Requirements. Check Reflection Beads for 'ExtraReflectionDataBead'. This warning will not appear in release builds");
                                console.warn("This warning was generated when trying to classify :", obj);
                            }
                        }
                    }
                }
                else className = "Object";
                //classAlias = null;
                isDynamic = true;
            }
            else
            {
                className = classInfo.qualifiedName;
                classAlias = getAliasByClass(getDefinitionByName(className) as Class) || '';
                if (USE_DOUBLE_COLON) {
                    i = className.lastIndexOf('.');
                    if (i != -1) {
                        className = className.substr(0,i) + '::'+ className.substr(i+1);
                    }
                }
                
                isDynamic = org.apache.royale.reflection.isDynamicObject(obj);
                
                const isClass:Boolean = obj is Class;
                var selectors:uint = MemberTypes.ACCESSORS | MemberTypes.VARIABLES;
                if (isClass) selectors |= MemberTypes.STATIC_ONLY;
                
                properties = getMembers(classInfo, isClass, selectors);
                
                n = properties.length;
                for (i = 0; i < n; i++) {
                    var accessor:AccessorDefinition = properties[i] as AccessorDefinition;
                    if (accessor) { // otherwise it is a VariableDefinition and does not need scrutiny here
                        var includeAccessor:Boolean = accessor.access == 'readwrite' || (options.includeReadOnly && accessor.access == 'readonly');
                        
                        if (!includeAccessor) {
                            properties.splice(i,1);
                            i--;
                        }
                    }
                    
                }
                var numericIndex:Boolean = false;
            }
        }
        
        // If type is not dynamic, check our cache for class info...(except for XML)
        if (!isDynamic && className != "XML")
        {
            cacheKey = getCacheKey(obj, excludes, options);
            result = CLASS_INFO_CACHE[cacheKey];
            if (result != null)
                return result;
        }
        if (!properties) properties=[];
        result = new ClassInfo();
        result.name = className;
        result.alias = classAlias;
        result.properties = propertyNames;
        result.dynamic = isDynamic;
        result.metadata = metadataInfo = recordMetadata(properties);
        
        var isArray:Boolean = (obj is Array);
        var isDict:Boolean  = (obj instanceof Map || obj instanceof WeakMap);
        if (isDict) {
            if (obj instanceof WeakMap) throw new Error('WeakMap cannot be enumerated, use Map instead');
            // Map can have multiple keys of the same type,
            // (they can index by reference rather than QName, String, or number),
            // which cannot be looked up by QName, so use references to the actual key
            (obj as Map).forEach(
                    function(value:Object, key:*):void
                    {
                        propertyNames.push(key);
                    }
            )
        }
        else if (isDynamic)
        {
            var dynFields:Array = getDynamicFields(obj);
            
            while (dynFields.length) {
                p = dynFields.shift();
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
        
        if (isArray || isDict || className == "Object")
        {
            // Do nothing since we've already got the dynamic members
        }
        else if (className == "XML")
        {
            n = properties.length;
            for (i = 0; i < n; i++)
            {
                p = properties[i].name();
                if (excludeObject[p] != 1)
                    propertyNames.push(new QName("", "@" + p));
            }
        }
        else
        {
            n = properties.length;
            var uris:Array = options.uris;
            var uri:String;
            var qName:QName;
            for (i = 0; i < n; i++)
            {
                prop = properties[i];
                p = prop.name;
                uri = prop.uri;
                
                if (excludeObject[p] == 1)
                    continue;
                
                if (!options.includeTransient && internalHasMetadata(metadataInfo, p, "Transient"))
                    continue;
                
                if (uris != null)
                {
                    if (uris.length == 1 && uris[0] == "*")
                    {
                        qName = new QName(uri, p);
                        propertyNames.push(qName);
                        //js won't error trap here... check results:
                        /*try
                        {
                            obj[qName]; // access the property to ensure it is supported
                            propertyNames.push(qName);
                        }
                        catch(e:Error)
                        {
                            // don't keep property name
                        }*/
                    }
                    else
                    {
                        for (var j:int = 0; j < uris.length; j++)
                        {
                            uri = uris[j];
                            if (prop.uri == uri)
                            {
                                qName = new QName(uri, p);
                                propertyNames.push(qName);
                                //js won't error trap here... check results:
                                /*try
                                {
                                    obj[qName];
                                    propertyNames.push(qName);
                                }
                                catch(e:Error)
                                {
                                    // don't keep property name
                                }*/
                            }
                        }
                    }
                }
                else if (uri.length == 0)
                {
                    qName = new QName(uri, p);
                    propertyNames.push(qName);
                    //js won't error trap here... check results:
                    /*try
                    {
                        obj[qName];
                        propertyNames.push(qName);
                    }
                    catch(e:Error)
                    {
                        // don't keep property name
                    }*/
                }
                
            }
        }
        
        propertyNames.sort(Array.CASEINSENSITIVE | (numericIndex ? Array.NUMERIC : 0));
        // map keys can be indexed by an object reference
        // there's a possibility that two keys will have the same toString()
        // so we don't want to remove duplicates
        if (!isDict)
        {
            // for Arrays, etc., on the other hand...
            // remove any duplicates, i.e. any items that can't be distinguished by toString()
            for (i = 0; i < propertyNames.length - 1; i++)
            {
                // the list is sorted so any duplicates should be adjacent
                // two properties are only equal if both the uri and local name are identical
                if (propertyNames[i].toString() == propertyNames[i + 1].toString())
                {
                    propertyNames.splice(i, 1);
                    i--; // back up
                }
            }
        }
        
        // For normal, non-dynamic classes we cache the class info
        // Don't cache XML as it can be dynamic
        if (!isDynamic && className != "XML")
        {
            cacheKey = getCacheKey(obj, excludes, options);
            CLASS_INFO_CACHE[cacheKey] = result;
        }
        return result;
    }

    /**
     * Uses <code>getClassInfo</code> and examines the metadata information to
     * determine whether a property on a given object has the specified
     * metadata.
     *
     * @param obj The object holding the property.
     * @param propName The property to check for metadata.
     * @param metadataName The name of the metadata to check on the property.
     * @param excludes If any properties need to be excluded when generating class info. (Optional)
     * @param options If any options flags need to changed when generating class info. (Optional)
     * @return true if the property has the specified metadata.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function hasMetadata(obj:Object,
                propName:String,
                metadataName:String,
                excludes:Array = null,
                options:Object = null):Boolean
    {

        var classInfo:Object = getClassInfo(obj, excludes, options);
        var metadataInfo:Object = classInfo.metadata;
        return internalHasMetadata(metadataInfo, propName, metadataName);
    }

    /**
     *  Returns <code>true</code> if the object is an instance of a dynamic class.
     *
     *  @param object The object.
     *
     *  @return <code>true</code> if the object is an instance of a dynamic class.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function isDynamicObject(object:Object):Boolean
    {
        return org.apache.royale.reflection.isDynamicObject(object);
    }

    /**
     *  Returns all the properties defined dynamically on an object.
     *
     *  @param object The object to inspect.
     *
     *  @return an <code>Array</code> of the enumerable properties of the object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getEnumerableProperties(object:Object):Array
    {
        return getDynamicFields(object, null, true, true);
    }


    /**
     *  Verifies if the first object is dynamic and is a subset of the second object.
     *
     *  @param values The values which need to be shared by <code>object</code>
     *  @param object The object to verify against.
     *
     *  @return true if and only if the objects are the same, or if <code>values</code>
     *  is dynamic and <code>object</code> shares all its properties and values.
     *  (Even if <code>object</code> contains other properties and values, we still
     *  consider it a match).
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function valuesAreSubsetOfObject(values:Object, object:Object):Boolean
    {

        if(!object && !values)
            return true;

        if(!object || !values)
            return false;

        if(object === values)
            return true;

        var enumerableProperties:Array = ObjectUtil.getEnumerableProperties(values);
        var matches:Boolean = enumerableProperties.length > 0 || ObjectUtil.isDynamicObject(values);

        for each(var property:String in enumerableProperties)
        {
            if (!object.hasOwnProperty(property) || object[property] != values[property])
            {
                matches = false;
                break;
            }
        }

        return matches;
    }

    /**
     *  Returns the value at the end of the property chain <code>path</code>.
     *  If the value cannot be reached due to null links on the chain,
     *  <code>undefined</code> is returned.
     *
     *  @param obj The object at the beginning of the property chain
     *  @param path The path to inspect (e.g. "address.street")
     *
     *  @return the value at the end of the property chain, <code>undefined</code>
     *  if it cannot be reached, or the object itself when <code>path</code> is empty.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getValue(obj:Object, path:Array):*
    {
        if(!obj)
            return undefined;

        if(!path || !path.length)
            return obj;

        var result:* = obj;
        var i:int = -1;
        COMPILE::SWF{
            while(++i < path.length && result)
                result = result.hasOwnProperty(path[i]) ? result[path[i]] : undefined;
        }
        COMPILE::JS{
            while(++i < path.length && result) {
                //@todo: this works for public accessors, but need to use reflection here for safety (including vars)
                result = path[i] in result ? result[path[i]] : undefined;
            }
            
        }

        return result;
    }


    /**
     *  Sets a new value at the end of the property chain <code>path</code>.
     *  If the value cannot be reached due to null links on the chain,
     *  <code>false</code> is returned.
     *
     *  @param obj The object at the beginning of the property chain
     *  @param path The path to traverse (e.g. "address.street")
     *  @param newValue The value to set (e.g. "Fleet Street")
     *
     *  @return <code>true</code> if the value is successfully set,
     *  <code>false</code> otherwise. Note that the function does not
     *  use a try/catch block. You can implement one in the calling
     *  function if there's a risk of type mismatch or other errors during
     *  the assignment.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function setValue(obj:Object, path:Array, newValue:*):Boolean
    {
        if(!obj || !path || !path.length)
            return false;

        var secondToLastLink:* = getValue(obj, path.slice(0, -1));
        COMPILE::SWF{
            if(secondToLastLink && secondToLastLink.hasOwnProperty(path[path.length - 1]))
            {
                secondToLastLink[path[path.length - 1]] = newValue;
                return true;
            }
        }
        COMPILE::JS{
            //@todo: this works for public accessors, but need to use reflection here for safety (including vars)
            if(secondToLastLink && (path[path.length - 1] in secondToLastLink))
            {
                secondToLastLink[path[path.length - 1]] = newValue;
                return true;
            }
        }

        return false;
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
    COMPILE::SWF
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
                            {
                                existingArray = [existing];
                                delete metadata[mdName];
                            }
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
    COMPILE::JS
    private static function recordMetadata(properties:Array):Object
    {
        var result:Object = null;
        //note: VariableDefinition is the base class for AccessorDefinition
        try
        {
            for each (var prop:VariableDefinition in properties)
            {
                var propName:String = prop.name;
                
                var metadataList:Array = prop.metadata;
                
                if (metadataList.length)
                {
                    if (result == null)
                        result = {};
                    
                    var metadata:Object = {};
                    result[propName] = metadata;
                    
                    for each (var md:MetaDataDefinition in metadataList)
                    {
                        var mdName:String = md.name;
                        
                        var argsList:Array = md.args;
                        var value:Object = {};
                        
                        for each (var arg:MetaDataArgDefinition in argsList)
                        {
                            var argKey:String = arg.key;
                            if (argKey != null)
                            {
                                var argValue:String = arg.value;
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
                            {
                                existingArray = [existing];
                                delete metadata[mdName];
                            }
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
     *  @private
     */
    private static function arrayCompare(a:Array, b:Array,
                                         currentDepth:int, desiredDepth:int,
                                         /*refs:Dictionary*/ refs:Object):int
    {
        var result:int = 0;

        if (a.length != b.length)
        {
            if (a.length < b.length)
                result = -1;
            else
                result = 1;
        }
        else
        {
            var key:Object;
            for (key in a)
            {
                if (b.hasOwnProperty(key))
                {
                    result = internalCompare(a[key], b[key], currentDepth,
                                         desiredDepth, refs);

                    if (result != 0)
                        return result;
                }
                else
                {
                    return -1;
                }
            }

            for (key in b)
            {
                if (!a.hasOwnProperty(key))
                {
                    return 1;
                }
            }
        }

        return result;
    }


    COMPILE::SWF
    private static function byteArrayCompare(a:flash.utils.ByteArray, b:flash.utils.ByteArray):int
    {
        var result:int = 0;

        if (a == b)
            return result;

        if (a.length != b.length)
        {
            if (a.length < b.length)
                result = -1;
            else
                result = 1;
        }
        else
        {
            for (var i:int = 0; i < a.length; i++)
            {
                result = numericCompare(a[i], b[i]);
                if (result != 0)
                {
                    i = a.length;
                }
            }
        }
        return result;
    }
    

    COMPILE::JS
    private static function byteArrayCompare(a:BinaryData, b:BinaryData):int
    {
        var result:int = 0;
    
        if (a == b)
            return result;
    
        if (a.length != b.length)
        {
            if (a.length < b.length)
                result = -1;
            else
                result = 1;
        }
        else
        {
            for (var i:int = 0; i < a.length; i++)
            {
                result = numericCompare(a[i], b[i]);
                if (result != 0)
                {
                    i = a.length;
                }
            }
        }
        return result;
    }
    
    /**
     *  @private
     */
    private static function listCompare(a:IList, b:IList, currentDepth:int,
                                        desiredDepth:int, /*refs:Dictionary*/ refs:Object):int
    {
        var result:int = 0;

        if (a.length != b.length)
        {
            if (a.length < b.length)
                result = -1;
            else
                result = 1;
        }
        else
        {
            for (var i:int = 0; i < a.length; i++)
            {
                result = internalCompare(a.getItemAt(i), b.getItemAt(i),
                                         currentDepth+1, desiredDepth, refs);
                if (result != 0)
                {
                    i = a.length;
                }
            }
        }

        return result;
    }

    /**
     * @private
     * This is the "find" for our union-find algorithm when doing object searches.
     * The dictionary keeps track of sets of equal objects
     *
     * @royaleignorecoercion WeakMap
     */
    private static function getRef(o:Object, /*refs:Dictionary*/ refs:Object):Object
    {
        COMPILE::SWF{
            var oRef:Object = refs[o];
            while (oRef && oRef != refs[oRef])
            {
                oRef = refs[oRef];
            }
            if (!oRef)
                oRef = o;
            if (oRef != refs[o])
                refs[o] = oRef;
        }
        COMPILE::JS{
            var map:WeakMap = refs as WeakMap;
            var oRef:Object = map.get(o);
            while (oRef && oRef != map.get(oRef))
            {
                oRef = map.get(oRef);
            }
            if (!oRef)
                oRef = o;
            if (oRef !=  map.get(o))
                map.set(o,oRef);
        }

        return oRef;
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
COMPILE::JS
/**
 * @royalesuppressexport
 */
class ClassInfo{
    private var _obj:Object;
    function ClassInfo() {
        _obj = {};
    }
    
    public function get name():String{
        return _obj['name'];
    }
    public function set name(value:String):void{
        _obj['name'] = value;
    }
    
    public function get alias():String{
        return _obj['alias'];
    }
    public function set alias(value:String):void{
        _obj['alias'] = value;
    }
    public function get properties():Array{
        return _obj['properties'];
    }
    public function set properties(value:Array):void{
        _obj['properties'] = value;
    }
    public function get dynamic():Boolean{
        return _obj['dynamic'];
    }
    public function set dynamic(value:Boolean):void{
        _obj['dynamic'] = value;
    }
    public function get metadata():Object{
        return _obj['metadata'];
    }
    public function set metadata(value:Object):void{
        _obj['metadata'] = value;
    }
    
    public function toJSON():Object{
        return _obj;
    }
}
