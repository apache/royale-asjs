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

COMPILE::AS3
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;		
}

import mx.core.IPropertyChangeNotifier;
import mx.core.IUIComponent;
import mx.core.IUID;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  The UIDUtil class is an all-static class
 *  with methods for working with UIDs (unique identifiers) within Flex.
 *  You do not create instances of UIDUtil;
 *  instead you simply call static methods such as the
 *  <code>UIDUtil.createUID()</code> method.
 * 
 *  <p><b>Note</b>: If you have a dynamic object that has no [Bindable] properties 
 *  (which force the object to implement the IUID interface), Flex  adds an 
 *  <code>mx_internal_uid</code> property that contains a UID to the object. 
 *  To avoid having this field 
 *  in your dynamic object, make it [Bindable], implement the IUID interface
 *  in the object class, or set a <coded>uid</coded> property with a value.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class UIDUtil
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Char codes for 0123456789ABCDEF
     */
	private static const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 
		55, 56, 57, 65, 66, 67, 68, 69, 70];

    private static const DASH:int = 45;       // dash ascii
	COMPILE::AS3
    private static const UIDBuffer:ByteArray = new ByteArray();       // static ByteArray used for UID generation to save memory allocation cost

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /** 
     *  This Dictionary records all generated uids for all existing items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::AS3
    private static var uidDictionary:Dictionary = new Dictionary(true);

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Generates a UID (unique identifier) based on ActionScript's
     *  pseudo-random number generator and the current time.
     *
     *  <p>The UID has the form
     *  <code>"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"</code>
     *  where X is a hexadecimal digit (0-9, A-F).</p>
     *
     *  <p>This UID will not be truly globally unique; but it is the best
     *  we can do without player support for UID generation.</p>
     *
     *  @return The newly-generated UID.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	public static function createUID():String
    {
		var i:int;
		var j:int;
		
		COMPILE::AS3
		{
        UIDBuffer.position = 0;

        for (i = 0; i < 8; i++)
        {
            UIDBuffer.writeByte(ALPHA_CHAR_CODES[int(Math.random() * 16)]);
        }

        for (i = 0; i < 3; i++)
        {
            UIDBuffer.writeByte(DASH);
            for (j = 0; j < 4; j++)
            {
                UIDBuffer.writeByte(ALPHA_CHAR_CODES[int(Math.random() * 16)]);
            }
        }

        UIDBuffer.writeByte(DASH);

        var time:uint = new Date().getTime(); // extract last 8 digits
        var timeString:String = time.toString(16).toUpperCase();
        // 0xFFFFFFFF milliseconds ~= 3 days, so timeString may have between 1 and 8 digits, hence we need to pad with 0s to 8 digits
        for (i = 8; i > timeString.length; i--)
            UIDBuffer.writeByte(48);
        UIDBuffer.writeUTFBytes(timeString);

        for (i = 0; i < 4; i++)
        {
            UIDBuffer.writeByte(ALPHA_CHAR_CODES[int(Math.random() * 16)]);
        }

        return UIDBuffer.toString();
		}
		COMPILE::JS
		{
			var s:String = "";
			for (i = 0; i < 8; i++)
			{
				s += ALPHA_CHAR_CODES[int(Math.random() * 16)];
			}
			
			for (i = 0; i < 3; i++)
			{
				s += DASH;
				for (j = 0; j < 4; j++)
				{
					s += ALPHA_CHAR_CODES[int(Math.random() * 16)];
				}
			}
			
			s += DASH;
			
			var time:uint = new Date().getTime(); // extract last 8 digits
			var timeString:String = time.toString(16).toUpperCase();
			// 0xFFFFFFFF milliseconds ~= 3 days, so timeString may have between 1 and 8 digits, hence we need to pad with 0s to 8 digits
			for (i = 8; i > timeString.length; i--)
				s += "0";
			s += timeString;
			
			for (i = 0; i < 4; i++)
			{
				s += ALPHA_CHAR_CODES[int(Math.random() * 16)];
			}
			
			return s;
		}
    }

    /**
     * Converts a 128-bit UID encoded as a ByteArray to a String representation.
     * The format matches that generated by createUID. If a suitable ByteArray
     * is not provided, null is returned.
     * 
     * @param ba ByteArray 16 bytes in length representing a 128-bit UID.
     * 
     * @return String representation of the UID, or null if an invalid
     * ByteArray is provided.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::AS3
    public static function fromByteArray(ba:ByteArray):String
    {
        if (ba != null && ba.length >= 16 && ba.bytesAvailable >= 16)
        {
            UIDBuffer.position = 0;
            var index:uint = 0;
            for (var i:uint = 0; i < 16; i++)
            {
                if (i == 4 || i == 6 || i == 8 || i == 10)
                    UIDBuffer.writeByte(DASH); // Hyphen char code

                var b:int = ba.readByte();
                UIDBuffer.writeByte(ALPHA_CHAR_CODES[(b & 0xF0) >>> 4]);
                UIDBuffer.writeByte(ALPHA_CHAR_CODES[(b & 0x0F)]);
            }
            return UIDBuffer.toString();
        }

        return null;
    }

    /**
     * A utility method to check whether a String value represents a 
     * correctly formatted UID value. UID values are expected to be 
     * in the format generated by createUID(), implying that only
     * capitalized A-F characters in addition to 0-9 digits are
     * supported.
     * 
     * @param uid The value to test whether it is formatted as a UID.
     * 
     * @return Returns true if the value is formatted as a UID.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function isUID(uid:String):Boolean
    {
        if (uid != null && uid.length == 36)
        {
            for (var i:uint = 0; i < 36; i++)
            {
                var c:Number = uid.charCodeAt(i);

                // Check for correctly placed hyphens
                if (i == 8 || i == 13 || i == 18 || i == 23)
                {
                    if (c != DASH)
                    {
                        return false;
                    }
                }
                // We allow capital alpha-numeric hex digits only
                else if (c < 48 || c > 70 || (c > 57 && c < 65))
                {
                    return false;
                }
            }

            return true;
        }

        return false;
    }

    /**
     * Converts a UID formatted String to a ByteArray. The UID must be in the
     * format generated by createUID, otherwise null is returned.
     * 
     * @param String representing a 128-bit UID
     * 
     * @return ByteArray 16 bytes in length representing the 128-bits of the
     * UID or null if the uid could not be converted.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::AS3
    public static function toByteArray(uid:String):ByteArray
    {
        if (isUID(uid))
        {
            var result:ByteArray = new ByteArray();

            for (var i:uint = 0; i < uid.length; i++)
            {
                var c:String = uid.charAt(i);
                if (c == "-")
                    continue;
                var h1:uint = getDigit(c);
                i++;
                var h2:uint = getDigit(uid.charAt(i));
                result.writeByte(((h1 << 4) | h2) & 0xFF);
            }
            result.position = 0;
            return result;
        }

        return null;
    }

    /**
     *  Returns the UID (unique identifier) for the specified object.
     *  If the specified object doesn't have an UID
     *  then the method assigns one to it.
     *  If a map is specified this method will use the map
     *  to construct the UID.
     *  As a special case, if the item passed in is null,
     *  this method returns a null UID.
     *  
     *  @param item Object that we need to find the UID for.
     *
     *  @return The UID that was either found or generated.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getUID(item:Object):String
    {
        var result:String = null;

        if (item == null)
            return result;

        if (item is IUID)
        {
            result = IUID(item).uid;
            if (result == null || result.length == 0)
            {
                result = createUID();
                IUID(item).uid = result;
            }
        }
        else if ((item is IPropertyChangeNotifier) &&
                 !(item is IUIComponent))
        {
            result = IPropertyChangeNotifier(item).uid;
            if (result == null || result.length == 0)
            {
                result = createUID();
                IPropertyChangeNotifier(item).uid = result;
            }
        }
        else if (item is String)
        {
            return item as String;
        }
        else
        {
            try
            {
				COMPILE::AS3
				{
                // We don't create uids for XMLLists, but if
                // there's only a single XML node, we'll extract it.
                if (item is XMLList && item.length == 1)
                    item = item[0];

                if (item is XML)
                {
                    // XML nodes carry their UID on the
                    // function-that-is-a-hashtable they can carry around.
                    // To decorate an XML node with a UID,
                    // we need to first initialize it for notification.
                    // There is a potential performance issue here,
                    // since notification does have a cost, 
                    // but most use cases for needing a UID on an XML node also
                    // require listening for change notifications on the node.
                    var xitem:XML = XML(item);
                    var nodeKind:String = xitem.nodeKind();
                    if (nodeKind == "text" || nodeKind == "attribute")
                        return xitem.toString();

                    var notificationFunction:Function = xitem.notification();
                    if (!(notificationFunction is Function))
                    {
                        // The xml node hasn't already been initialized
                        // for notification, so do so now.
                        notificationFunction =
                            XMLNotifier.initializeXMLForNotification(); 
                        xitem.setNotification(notificationFunction);
                    }
                    
                    // Generate a new uid for the node if necessary.
                    if (notificationFunction["uid"] == undefined)
                        result = notificationFunction["uid"] = createUID();

                    result = notificationFunction["uid"];
                }
                else
                {
                    if ("mx_internal_uid" in item)
                        return item.mx_internal_uid;

                    if ("uid" in item)
                        return item.uid;

                    result = uidDictionary[item];

                    if (!result)
                    {
                        result = createUID();
                        try 
                        {
                            item.mx_internal_uid = result;
                        }
                        catch(e:Error)
                        {
                            uidDictionary[item] = result;
                        }
                    }
                }
				}
				COMPILE::JS
				{
					if ("mx_internal_uid" in item)
						return item.mx_internal_uid;
					
					if ("uid" in item)
						return item.uid;
					
					item["mx_internal_uid"] = result = createUID();
				}
            }
            catch(e:Error)
            {
                result = item.toString();
            }
        }

        return result;
    }

    /**
     * Returns the decimal representation of a hex digit.
     * @private
     */
    private static function getDigit(hex:String):uint
    {
        switch (hex) 
        {
            case "A": 
            case "a":           
                return 10;
            case "B":
            case "b":
                return 11;
            case "C":
            case "c":
                return 12;
            case "D":
            case "d":
                return 13;
            case "E":
            case "e":
                return 14;                
            case "F":
            case "f":
                return 15;
            default:
				COMPILE::AS3
				{
                return new uint(hex);
				}
				COMPILE::JS
				{
				return parseInt(hex, 16);
				}
        }    
    }
}

}
