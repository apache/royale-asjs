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

package org.apache.royale.reflection.beads
{

COMPILE::SWF
{
    import flash.net.registerClassAlias;
    import flash.utils.getDefinitionByName;        
}
COMPILE::JS
{
    import org.apache.royale.reflection.registerClassAlias;
    import org.apache.royale.reflection.getDefinitionByName;        
}
    
import org.apache.royale.core.IBead;
import org.apache.royale.core.IFlexInfo;
import org.apache.royale.core.IStrand;

/**
 *  The JSONReviver creates ActionScript classes when parsing JSON.
 *  Use the JSONReviver's parse function instead of calling JSON.parse().
 *  This is a bead you place on the Application's strand, then call it 
 *  from other code.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 1.0.0
 *  @productversion Royale 0.0
 */
public class JSONReviver implements IBead
{

    public function JSONReviver()
    {
        
    }
    
    private var classMap:Object = {};

    private var _strand:IStrand;
    
    /**
     *  @copy org.apache.royale.core.IBead#strand
     *  
     *  @royaleignorecoercion org.apache.royale.core.IFlexInfo
     *  @royaleignorecoercion Class
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function set strand(value:IStrand):void
    {
        _strand = value;
        var app:IFlexInfo = value as IFlexInfo;
        var info:Object = app.info();
        var map:Object = info.remoteClassAliases;
        if (map)
        {
            for (var cn:String in map)
            {
                var alias:String = map[cn];
                var c:Class = getDefinitionByName(cn) as Class;
                if (c) // if no class, may have only been used in JS as a type and never actually instnatiated
                    classMap[c["key"]] = c;
            }
        }
    }
    
    /**
     *  parse JSON but convert to ValueObjects
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function parse(s:String):Object
    {
        return JSON.parse(s, reviver);
    }
    
    private function reviver(name:String, value:Object):Object
    {
        if (typeof(value) === "object")
        {
            var key:String = generateKey(value);
            var c:Class = classMap[key];
            if (c)
            {
                var newValue:Object = new c();
                for (var p:String in value)
                {
                    newValue[p] = value[p];
                }
            }
        }
        return value;
    }

    public static function generateKey(value:Object):String
    {
        var parts:Array = [];
        for (var p:String in value)
        {
            if (p == "__JSON2ASVO__") 
                continue; // no need to be in the key
            var key:String = "";
            key += p;
            key += ":";
            key += typeof value[p];
            parts.push(key);
        }
        parts.sort();
        return parts.join(";");
    }

}

}
