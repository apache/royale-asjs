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

package mx.messaging.channels.amfx
{

import mx.logging.ILogger;

[ExcludeClass]

/**
 * Holds a list of complex object references, object trait info references,
 * or string references generated while encoding or decoding and AMFX packet.
 * Note that a new set of reference tables should be used per AMFX packet.
 * Calling reset() will create new tables for each of these types of references.
 * @private
 */
public class AMFXContext
{
    /**
     * Constructor.
     * Initializes object, trait info and string reference tables.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function AMFXContext()
    {
        super();
        reset();
    }

    /**
     * Resets the trait info, object and string reference tables.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function reset():void
    {
        traits = [];
        objects = [];
        strings = [];
    }

    /**
     * Check whether the trait info reference table
     * already contains this list of traits. If found,
     * the index of the trait info is returned, starting
     * from 0. If not found -1 is returned.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function findTraitInfo(traitInfo:Object):int
    {
        for (var i:uint = 0; i < traits.length; i++)
        {
            var ti:Object = traits[i];

            if (ti.alias == traitInfo.alias
                && ti.properties.length == traitInfo.properties.length)
            {
                var j:uint = 0;
                for (; j < ti.properties.length; j++)
                {
                    if (ti.properties[i] != traitInfo.properties[j])
                    {
                        break;
                    }
                }

                if (j == traitInfo.properties.length)
                {
                    //Match found
                    return i;
                }
            }
        }

        return -1;
    }

    /**
     * Check whether the object reference table
     * already contains this object. If found, the index
     * of the object is returned, starting from 0. If
     * not found -1 is returned.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function findObject(object:Object):int
    {
        for (var i:uint = 0; i < objects.length; i++)
        {
            var o:Object = objects[i];
            if (o === object)
            {
                return i;
            }
        }

        return -1;
    }

    /**
     * Check whether the string reference table
     * already contains this string. If found, the index
     * of the string is returned, starting from 0. If
     * not found (or if the value passed is the empty string)
     * -1 is returned.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function findString(str:String):int
    {
        if (str != "")
        {
            for (var i:uint = 0; i < strings.length; i++)
            {
                var s:String = strings[i];
                if (s == str)
                {
                    return i;
                }
            }
        }

        return -1;
    }

    /**
     * Remember the trait info for an object in this context
     * for an encoding or decoding session.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function addTraitInfo(traitInfo:Object):void
    {
        traits.push(traitInfo);
    }

    /**
     * Remember an object in this context for an encoding
     * or decoding session.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function addObject(obj:Object):void
    {
        objects.push(obj);
    }

    /**
     * Remember a string in this context for an encoding
     * or decoding session. Note that the empty string
     * is not remembered as it should not be serialized
     * by reference.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function addString(str:String):void
    {
        if (str != "")
        {
            strings.push(str);
        }
    }


    /**
     * Retrieve trait info for an object by its reference
     * table index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function getTraitInfo(ref:uint):*
    {
        return traits[ref];
    }

    /**
     * Retrieve an object by its reference table index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function getObject(ref:uint):*
    {
        return objects[ref];
    }

    /**
     * Retrieve a string by its reference table index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function getString(ref:uint):String
    {
        return strings[ref];
    }

    /**
     * Trait Info reference table
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    internal var traits:Array;

    /**
     * Object reference table
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    internal var objects:Array;

    /**
     * Strings reference table
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    internal var strings:Array;

    /**
     * Log for the current encoder/decoder context.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public var log:ILogger;
}

}
