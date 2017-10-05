////////////////////////////////////////////////////////////////////////////////
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

/***
 * AMF JavaScript library by Emil Malinov https://github.com/emilkm/amfjs
 */

package org.apache.royale.net.remoting.amf
{

    import org.apache.royale.reflection.getAliasByClass;
    import org.apache.royale.reflection.getClassByAlias;
    
/**
 *  A version of BinaryData specific to AMF.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class AMFBinaryData
{
    //--------------------------------------------------------------------------
    //
    // Class Constants
    // 
    //--------------------------------------------------------------------------
    
    public static const CLASS_ALIAS:String = "_explicitType";
    public static const EXTERNALIZED_FIELD:String = "_externalizedData";
    
    public static const RESULT_METHOD:String = "/onResult";
    public static const STATUS_METHOD:String = "/onStatus";
    
    public static const EMPTY_STRING:String = "";
    public static const NULL_STRING:String = "null";
    
    public static const AMF0_OBJECT_ENCODING:int = 0;
    
    public static const AMF0_NUMBER:int = 0;
    public static const AMF0_BOOLEAN:int = 1;
    public static const AMF0_STRING:int = 2;
    public static const AMF0_OBJECT:int = 3;
    public static const AMF0_MOVIECLIP:int = 4;
    public static const AMF0_NULL:int = 5;
    public static const AMF0_UNDEFINED:int = 6;
    public static const AMF0_REFERENCE:int = 7;
    public static const AMF0_MIXEDARRAY:int = 8; //ECMAArray
    public static const AMF0_OBJECTEND:int = 9;
    public static const AMF0_ARRAY:int = 10; //StrictArray
    public static const AMF0_DATE:int = 11;
    public static const AMF0_LONGSTRING:int = 12;
    public static const AMF0_UNSUPPORTED:int = 13;
    public static const AMF0_RECORDSET:int = 14;
    public static const AMF0_XMLDOCUMENT:int = 15;
    public static const AMF0_TYPEDOBJECT:int = 16;
    public static const AMF0_AMF3:int = 17;
    
    public static const AMF3_OBJECT_ENCODING:int = 3;
    
    public static const AMF3_UNDEFINED:int = 0;
    public static const AMF3_NULL:int = 1;
    public static const AMF3_BOOLEAN_FALSE:int = 2;
    public static const AMF3_BOOLEAN_TRUE:int = 3;
    public static const AMF3_INTEGER:int = 4;
    public static const AMF3_DOUBLE:int = 5;
    public static const AMF3_STRING:int = 6;
    public static const AMF3_XMLDOCUMENT:int = 7;
    public static const AMF3_DATE:int = 8;
    public static const AMF3_ARRAY:int = 9;
    public static const AMF3_OBJECT:int = 10;
    public static const AMF3_XML:int = 11;
    public static const AMF3_BYTEARRAY:int = 12;
    public static const AMF3_VECTOR_INT:int = 13;
    public static const AMF3_VECTOR_UINT:int = 14;
    public static const AMF3_VECTOR_DOUBLE:int = 15;
    public static const AMF3_VECTOR_OBJECT:int = 16;
    public static const AMF3_DICTIONARY:int = 17;
    
    public static const UNKNOWN_CONTENT_LENGTH:int = 1;
    
    public static const UINT29_MASK:int = 536870911;
    public static const INT28_MAX_VALUE:int = 268435455;
    public static const INT28_MIN_VALUE:int = -268435456;
    public static const UINT_MAX_VALUE:uint = 4294967295;
    public static const UINT_MIN_VALUE:uint = 0;
    
    public static const MAX_STORED_OBJECTS:int = 1024;
    
    public static const POW_2_20:int = Math.pow(2, 20);
    public static const POW_2_52:int = Math.pow(2, 52);
    public static const POW_2_52N:int = Math.pow(2, -52);

    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Constructs an uninitialized AMFBinaryData.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function AMFBinaryData(data:Array = null)
    {
        // TODO: (aharui) try to share code with BinaryData.
        // BinaryData has different methods and also
        // has ENDIAN code which AMF doesn't seem to need.
        super();
        if (data)
            this.data = data;
    }
    
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------    

    public var data:Array = [];
    
    private var objects:Array = [];
    
    private var traits:Object = {};
    
    private var strings:Object = {};
    
    private var stringCount:int = 0;
    private var traitCount:int = 0;
    private var objectCount:int = 0;
    
    public var pos:int = 0;
        
    public function write(v:uint):void
    {
        data.push(v);
    };
    
    public function writeShort(v:uint):void
    {
        write((v >>> 8) & 255);
        write((v >>> 0) & 255);
    };
    
    public function writeUTF(v:String, asAmf:Boolean = false):int
    {
        var bytearr:Array = [];
        var strlen:int = v.length;
        var utflen:int = 0;
        
        for (var i:int = 0; i < strlen; i++) 
        {
            var c1:int = v.charCodeAt(i);
            //var enc = null;
            
            if (c1 < 128) 
            {
                utflen++;
                bytearr.push(c1);
                //end++;
            } 
            else if (c1 > 127 && c1 < 2048) 
            {
                utflen += 2;
                bytearr.push(192 | (c1 >> 6));
                if (asAmf) 
                    bytearr.push(128 | ((c1 >> 0) & 63));
                else 
                    bytearr.push(128 | (c1 & 63));
            }
            else if ((c1 & 0xF800) !== 0xD800) 
            {
                utflen += 3;
                bytearr.push(224 | (c1 >> 12));
                bytearr.push(128 | ((c1 >> 6) & 63));
                if (asAmf) 
                    bytearr.push(128 | ((c1 >> 0) & 63));
                else
                    bytearr.push(128 | (c1 & 63));
            } 
            else 
            {
                utflen += 4;
                if ((c1 & 0xFC00) !== 0xD800)
                {
                    throw new RangeError('Unmatched trail surrogate at ' + i);
                }
                var c2:int = v.charCodeAt(++i);
                if ((c2 & 0xFC00) !== 0xDC00) 
                {
                    throw new RangeError('Unmatched lead surrogate at ' + (i - 1));
                }
                c1 = ((c1 & 0x3FF) << 10) + (c2 & 0x3FF) + 0x10000;
                bytearr.push(240 | (c1 >> 18));
                bytearr.push(128 | ((c1 >> 12) & 63));
                bytearr.push((c1 >> 6) & 63);
                if (asAmf)
                    bytearr.push(128 | ((c1 >> 0) & 63));
                else
                    bytearr.push(128 | (c1 & 63));
            }
        }
        
        if (asAmf)
            writeUInt29((utflen << 1) | 1);
        else 
        {
            bytearr.unshift(utflen & 255);
            bytearr.unshift((utflen >>> 8) & 255);
        }
        
        writeAll(bytearr);
        return asAmf ? utflen : utflen + 2;
    };
    
    public function writeUInt29(v:uint):void
    {
        if (v < 128) 
        {
            this.write(v);
        } 
        else if (v < 16384) 
        {
            this.write(((v >> 7) & 127) | 128);
            this.write(v & 127);
        } 
        else if (v < 2097152) 
        {
            this.write(((v >> 14) & 127) | 128);
            this.write(((v >> 7) & 127) | 128);
            this.write(v & 127);
        } 
        else if (v < 0x40000000) 
        {
            this.write(((v >> 22) & 127) | 128);
            this.write(((v >> 15) & 127) | 128);
            this.write(((v >> 8) & 127) | 128);
            this.write(v & 255);
        }
        else 
        {
            throw "Integer out of range: " + v;
        }
    };
    
    public function writeAll(bytes:Array):void
    {
        for (var i:int = 0; i < bytes.length; i++) {
            this.write(bytes[i]);
        }
    };
    
    public function writeBoolean(v:Boolean):void
    {
        this.write(v ? 1 : 0);
    };
    
    public function writeInt(v:int):void
    {
        this.write((v >>> 24) & 255);
        this.write((v >>> 16) & 255);
        this.write((v >>> 8) & 255);
        this.write((v >>> 0) & 255);
    };
    
    public function writeUInt32(v):void
    {
        v < 0 && (v = -(v ^ UINT_MAX_VALUE) - 1);
        v &= UINT_MAX_VALUE;
        this.write((v >>> 24) & 255);
        this.write((v >>> 16) & 255);
        this.write((v >>> 8) & 255);
        this.write((v & 255));
    };
    
    private function getDouble(v:Number):Array
    {
        var r:Array = [0,0];
        if (v != v) 
        {
            r[0] = -524288;
            return r;
        }
        var d:int = v < 0 || v === 0 && 1 / v < 0 ? -2147483648 : 0;
        v = Math.abs(v);
        if (v === Number.POSITIVE_INFINITY) 
        {
            r[0] = d | 2146435072;
            return r;
        }
        for (var e:int = 0; v >= 2 && e <= 1023;) 
        {
            e++;
            v /= 2;
        }
        for (; v < 1 && e >= -1022;)
        {
            e--;
            v *= 2;
        }
        e += 1023;
        if (e == 2047) 
        {
            r[0] = d | 2146435072;
            return r;
        }
        var i:Number;
        if (e == 0)
            (i = v * Math.pow(2, 23) / 2, v = Math.round(v * POW_2_52 / 2))
        else
            (i = v * POW_2_20 - POW_2_20, v = Math.round(v * POW_2_52 - POW_2_52));
        r[0] = d | e << 20 & 2147418112 | i & 1048575;
        r[1] = v;
        return r;
    };
    
    public function writeDouble(v:Number):void
    {
        var parts:Array  = getDouble(v);
        this.writeUInt32(parts[0]);
        this.writeUInt32(parts[1]);
    };
    
    public function getResult():String
    {
        return data.join("");
    };
    
    public function reset():void
    {
        this.objects = [];
        this.objectCount = 0;
        this.traits = {};
        this.traitCount = 0;
        this.strings = {};
        this.stringCount = 0;
    };
    
    private function writeStringWithoutType(v:String):void
    {
        if (v.length == 0) 
            this.writeUInt29(1);
        else 
        {
            if (!this.stringByReference(v)) 
            {
                this.writeUTF(v, true);
            }
        }
    };
    
    private function stringByReference(v):uint
    {
        var ref:uint = this.strings[v];
        if (ref) 
            this.writeUInt29(ref << 1);
        else 
            this.strings[v] = this.stringCount++;
        return ref;
    };
    
    public function objectByReference(v):uint
    {
        var ref:uint = 0;
        var found:Boolean = false;
        for (; ref < this.objects.length; ref++) 
        {
            if (this.objects[ref] === v) 
            {
                found = true;
                break;
            }
        }
        if (found) 
            this.writeUInt29(ref << 1);
        else 
        {
            this.objects.push(v);
            this.objectCount++;
        }
        
        return found ? ref : null;
    };
    
    private function traitsByReference(v:Array, alias:String):uint
    {
        var s:String = alias + "|";
        for (var i:int = 0; i < v.length; i++) {
            s += v[i] + "|";
        }
        var ref:uint = this.traits[s];
        if (ref)
            this.writeUInt29((ref << 2) | 1);
        else
            this.traits[s] = this.traitCount++;
        
        return ref;
    };
    
    private function writeAmfInt(v:int):void
    {
        if (v >= INT28_MIN_VALUE && v <= INT28_MAX_VALUE) {
            v = v & UINT29_MASK;
            this.write(AMF3_INTEGER);
            this.writeUInt29(v);
        }
        else
        {
            this.write(AMF3_DOUBLE);
            this.writeDouble(v);
        }
    };
    
    private function writeDate(v:Date):void
    {
        this.write(AMF3_DATE);
        if (!this.objectByReference(v))
        {
            this.writeUInt29(1);
            this.writeDouble(v.getTime());
        }
    };
    
    /**
     * @royaleignorecoercion Class
     * @royaleignorecoercion String
     * @royaleignorecoercion Number
     */
    public function writeObject(v:Object):void
    {
        if (v == null)
        {
            this.write(AMF3_NULL);
            return;
        }
        if (v is String) 
        {
            this.write(AMF3_STRING);
            this.writeStringWithoutType(v as String);
        }
        else if (v is Number)
        {
            var n:Number = v as Number;
            if (n === +n && n === (n | 0))
            {
                this.writeAmfInt(n);
            }
            else
            {
                this.write(AMF3_DOUBLE);
                this.writeDouble(n);
            }
        }
        else if (v is Boolean)
            this.write((v
                ? AMF3_BOOLEAN_TRUE
                : AMF3_BOOLEAN_FALSE));
        else if (v is Date)
            this.writeDate(v as Date);
        else
        {
            if (v is Array) 
            {
                if (v.toString().indexOf("[Vector") == 0) 
                    this.writeVector(v);
                else 
                    this.writeArray(v as Array);
            }
            else if (getAliasByClass(v.constructor as Class))
                this.writeCustomObject(v);
            else
                this.writeMap(v);
        }
    };
    
    private function writeCustomObject(v:Object):void
    {
        this.write(AMF3_OBJECT);
        if (!this.objectByReference(v))
        {
            var traits:Array = this.writeTraits(v);
            for (var i:int = 0; i < traits.length; i++)
            {
                var prop:String = traits[i];
                this.writeObject(v[prop]);
            }
        }
    };
    
    /**
     * @royaleignorecoercion Class
     */
    private function writeTraits(v:Object):Array
    {
        var traits:Array = [];
        var count:int = 0;
        var externalizable:Boolean = false; // some day: v is IExternalizable;
        var dynamic:Boolean = false; // some day v.getClassInfo().isDynamic;
        
        var classInfo:Object = v.ROYALE_CLASS_INFO;
        var reflectionInfo:Object = v.ROYALE_REFLECTION_INFO();
        var c:Object = v;
        var t:String;
        var traitsInfo:Object;
        var vars:Array = [];
        var accs:Array = [];
        while (classInfo)
        {
            var className:String = classInfo.names[0].name;
            traitsInfo = reflectionInfo.variables();
            for (t in traitsInfo) 
            {
                vars.push(t);
                count++;
            }
            traitsInfo = reflectionInfo.accessors();
            for (t in traitsInfo) 
            {
                accs.push(t);
                count++;
            }
            if (!c.constructor.superClass_)
                break;
            classInfo = c.constructor.superClass_.ROYALE_CLASS_INFO;
            reflectionInfo = c.constructor.superClass_.ROYALE_REFLECTION_INFO();
            c = c.constructor.superClass_;
        }
        traits = traits.concat(vars);
        traits = traits.concat(accs);
        if (!this.traitsByReference(traits, getAliasByClass(v.constructor as Class)))
        {
            this.writeUInt29(3 | (externalizable ? 4 : 0) | (dynamic ? 8 : 0) | (count << 4));
            this.writeStringWithoutType(getAliasByClass(v.constructor as Class));
            if (count > 0)
            {
                for (var prop:String in traits)
                {
                    this.writeStringWithoutType(traits[prop]);
                }
            }
        }
        return traits;
    };
    
    /* Write map as array
    amf.Writer.prototype.writeMap = function(v) {
    this.write(amf.const.AMF3_ARRAY);
    if (!this.objectByReference(map)) {
    this.writeUInt29((0 << 1) | 1);
    for (var key in v) {
    if (key) {
    this.writeStringWithoutType(key);
    } else {
    this.writeStringWithoutType(amf.const.EMPTY_STRING);
    }
    this.writeObject(v[key]);
    }
    this.writeStringWithoutType(amf.const.EMPTY_STRING);
    }
    };*/
    
    private function writeMap(v:Object):void
    {
        this.write(AMF3_OBJECT);
        if (!this.objectByReference(v))
        {
            this.writeUInt29(11);
            this.traitCount++; //bogus traits entry here
            this.writeStringWithoutType(EMPTY_STRING); //class name
            for (var key:String in v)
            {
                if (key)
                    this.writeStringWithoutType(key);
                else
                    this.writeStringWithoutType(EMPTY_STRING);
                this.writeObject(v[key]);
            }
            this.writeStringWithoutType(EMPTY_STRING); //empty string end of dynamic members
        }
    };
    
    private function writeArray(v:Array):void
    {
        this.write(AMF3_ARRAY);
        var len:int = v.length;
        if (!this.objectByReference(v))
        {
            this.writeUInt29((len << 1) | 1);
            this.writeUInt29(1); //empty string implying no named keys
            if (len > 0) 
            {
                for (var i:int = 0; i < len; i++)
                {
                    this.writeObject(v[i]);
                }
            }
        }
    };
    
    private function writeVector(v:Object):void
    {
        this.write(v.type);
        var i:int;
        var len:int = v.length;
        if (!this.objectByReference(v))
        {
            this.writeUInt29((len << 1) | 1);
            this.writeBoolean(v.fixed);
        }
        if (v.type == AMF3_VECTOR_OBJECT)
        {
            var className:String = "";
            if (len > 0) {
                // TODO: how much of the PHP logic can we do here
                className = v[0].constructor.name;
            }
            this.writeStringWithoutType(className);
            for (i = 0; i < len; i++)
            {
                this.writeObject(v[i]);
            }
        } 
        else if (v.type == AMF3_VECTOR_INT)
        {
            for (i = 0; i < len; i++)
            {
                this.writeInt(v[i]);
            }
        } 
        else if (v.type == AMF3_VECTOR_UINT)
        {
            for (i = 0; i < len; i++)
            {
                this.writeUInt32(v[i]);
            }
        }
        else if (v.type == AMF3_VECTOR_DOUBLE)
        {
            for (i = 0; i < len; i++) 
            {
                this.writeDouble(v[i]);
            }
        }
    };
        
    public function read():uint
    {
        //if (this.pos + 1 > this.datalen) { //this.data.length store in this.datalen
        //  throw "Cannot read past the end of the data.";
        //}
        return this.data[this.pos++];
    };
    
    public function readUIntN(n:int):uint
    {
        var value:uint = this.read();
        for (var i:int = 1; i < n; i++) {
            value = (value << 8) | this.read();
        }
        return value;
    };
    
    public function readUnsignedShort():uint
    {
        var c1:uint = this.read();
        var c2:uint = this.read();
        return ((c1 << 8) + (c2 << 0));
    };
    
    public function readInt():int
    {
        var c1:int = this.read();
        var c2:int = this.read();
        var c3:int = this.read()
        var c4:int = this.read();
        return ((c1 << 24) + (c2 << 16) + (c3 << 8) + (c4 << 0));
    };
    
    public function readUInt32():uint
    {
        var c1:uint = this.read();
        var c2:uint = this.read();
        var c3:uint = this.read();
        var c4:uint = this.read();
        return (c1 * 0x1000000) + ((c2 << 16) | (c3 << 8) | c4);
    };
    
    public function readUInt29():int
    {
        var b:uint = this.read() & 255;
        if (b < 128) {
            return b;
        }
        var value:uint = (b & 127) << 7;
        b = this.read() & 255;
        if (b < 128) 
            return (value | b);
        value = (value | (b & 127)) << 7;
        b = this.read() & 255;
        if (b < 128)
            return (value | b);
        value = (value | (b & 127)) << 8;
        b = this.read() & 255;
        return (value | b);
    };
    
    public function readFully(buff:Array, start:int, length:int):void
    {
        for (var i:int = start; i < length; i++)
        {
            buff[i] = this.read();
        }
    };
    
    public function readUTF(length:int = 0):String
    {
        var utflen:int = length ? length : this.readUnsignedShort();
        var len:int = this.pos + utflen;
        var chararr:Array = [];
        var c1:int = 0;
        var seqlen:int = 0;
        
        while (this.pos < len)
        {
            c1 = this.read() & 0xFF;
            seqlen = 0;
            
            if (c1 <= 0xBF)
            {
                c1 = c1 & 0x7F;
                seqlen = 1;
            }
            else if (c1 <= 0xDF)
            {
                c1 = c1 & 0x1F;
                seqlen = 2;
            }
            else if (c1 <= 0xEF)
            {
                c1 = c1 & 0x0F;
                seqlen = 3;
            }
            else
            {
                c1 = c1 & 0x07;
                seqlen = 4;
            }
            
            for (var i:int = 1; i < seqlen; ++i)
            {
                c1 = c1 << 0x06 | this.read() & 0x3F;
            }
            
            if (seqlen === 4)
            {
                c1 -= 0x10000;
                chararr.push(String.fromCharCode(0xD800 | c1 >> 10 & 0x3FF));
                chararr.push(String.fromCharCode(0xDC00 | c1 & 0x3FF));
            }
            else 
            {
                chararr.push(String.fromCharCode(c1));
            }
        }
        
        return chararr.join("");
    };
    
    public function readObject():Object
    {
        var type:uint = this.read();
        return this.readObjectValue(type);
    };
    
    public function readString():String
    {
        var ref:uint = this.readUInt29();
        if ((ref & 1) == 0)
        {
            return this.getString(ref >> 1);
        }
        else
        {
            var len:int = (ref >> 1);
            if (len == 0)
            {
                return EMPTY_STRING;
            }
            var str:String = this.readUTF(len);
            this.rememberString(str);
            return str;
        }
        return null;
    };
    
    private function rememberString(v:String):void
    {
        this.strings[stringCount++] =  v;
    };
    
    private function getString(v:int):String
    {
        return this.strings[v];
    };
    
    private function getObject(v:int):Object
    {
        return this.objects[v];
    };
    
    private function getTraits(v:int):Traits
    {
        return this.traits[v] as Traits;
    };
    
    private function rememberTraits(v:Traits):void
    {
        this.traits[traitCount++] = v;
    };
    
    private function rememberObject(v:Object):void
    {
        this.objects.push(v);
    };
    
    private function readTraits(ref:int):Traits
    {
        if ((ref & 3) == 1)
            return this.getTraits(ref >> 2);
        else 
        {
            var ti:Traits = new Traits();
            ti.externalizable = ((ref & 4) == 4);
            ti.dynamic = ((ref & 8) == 8);
            ti.count = (ref >> 4);
            var className:String = this.readString();
            if (className != null && className != "") {
                ti.alias = className;
            }
            for (var i:int = 0; i < ti.count; i++) {
                ti.props.push(this.readString());
            }
            this.rememberTraits(ti);
            return ti;
        }
    };
    
    private function readScriptObject():Object
    {
        var ref:int = this.readUInt29();
        if ((ref & 1) == 0)
            return this.getObject(ref >> 1);
        else 
        {
            var traits:Traits = this.readTraits(ref);
            var obj:Object;
            if (traits.alias) {
                var c:Class = getClassByAlias(traits.alias);
                if (c)
                    obj = new c();
                else 
                {
                    obj = {};
                    obj[CLASS_ALIAS] = traits.alias;
                }
            }
            else
            {
                obj = {};
            }
            this.rememberObject(obj);
            if (traits.externalizable)
            {
                if (obj[CLASS_ALIAS] == "flex.messaging.io.ArrayCollection"
                    || obj[CLASS_ALIAS] == "flex.messaging.io.ObjectProxy")
                    return this.readObject();
                else
                    obj[EXTERNALIZED_FIELD] = this.readObject();
            } 
            else 
            {
                for (var i:int in traits.props)
                    obj[traits.props[i]] = this.readObject();
                if (traits.dynamic)
                {
                    for (; ;)
                    {
                        var name:String = this.readString();
                        if (name == null || name.length == 0)
                        {
                            break;
                        }
                        obj[name] = this.readObject();
                    }
                }
            }
            return obj;
        }
    };
    
    /**
     * @royaleignorecoercion Array
     */
    public function readArray():Array
    {
        var ref:uint = this.readUInt29();
        if ((ref & 1) == 0)
            return this.getObject(ref >> 1) as Array;
        var len:int = (ref >> 1);
        var map:Object = null;
        var i:int = 0;
        while (true)
        {
            var name:String = this.readString();
            if (!name)
                break;
            if (!map)
            {
                map = {};
                this.rememberObject(map);
            }
            map[name] = this.readObject();
        }
        if (!map)
        {
            var array:Array = new Array(len);
            this.rememberObject(array);
            for (i = 0; i < len; i++)
                array[i] = this.readObject();
            return array;
        }
        else
        {
            var amap:Array = [];
            for (i = 0; i < len; i++)
                amap[i] = this.readObject();
            return amap;
        }
    };
    
    public function readDouble():Number
    {
        var c1:uint = this.read() & 255;
        var c2:uint = this.read() & 255;
        if (c1 === 255) {
            if (c2 === 248)
                return Number.NaN;
            if (c2 === 240)
                return Number.NEGATIVE_INFINITY;
        }
        else if (c1 === 127 && c2 === 240)
            return Number.POSITIVE_INFINITY;
        var c3:uint = this.read() & 255;
        var c4:uint = this.read() & 255;
        var c5:uint = this.read() & 255;
        var c6:uint = this.read() & 255;
        var c7:uint = this.read() & 255;
        var c8:uint = this.read() & 255;
        if (!c1 && !c2 && !c3 && !c4)
            return 0;
        var d:uint = (c1 << 4 & 2047 | c2 >> 4) - 1023;
        var e:String = ((c2 & 15) << 16 | c3 << 8 | c4).toString(2);
        for (var i:uint = e.length; i < 20; i++)
            e = "0" + e;
        var f:String = ((c5 & 127) << 24 | c6 << 16 | c7 << 8 | c8).toString(2);
        for (var j:uint = f.length; j < 31; j++)
            f = "0" + f;
        var g:int = parseInt(e + (c5 >> 7 ? "1" : "0") + f, 2);
        if (g == 0 && d == -1023)
            return 0;
        return (1 - (c1 >> 7 << 1)) * (1 + POW_2_52N * g) * Math.pow(2, d);
    };
    
    /**
     * @royaleignorecoercion Array
     */
    public function readDate():Date
    {
        var ref:uint = this.readUInt29();
        if ((ref & 1) == 0)
            return this.getObject(ref >> 1) as Date;
        var time:Number = this.readDouble();
        var date:Date = new Date(time);
        this.rememberObject(date);
        return date;
    };
    
    public function readMap():Object
    {
        var ref:uint = this.readUInt29();
        if ((ref & 1) == 0)
            return this.getObject(ref >> 1);
        var length:int = (ref >> 1);
        var map:Object = null;
        if (length > 0)
        {
            map = {};
            this.rememberObject(map);
            var name:String = this.readObject() as String;
            while (name != null)
            {
                map[name] = this.readObject();
                name = this.readObject() as String;
            }
        }
        return map;
    };
    
    public function readByteArray():Array
    {
        var ref:uint = this.readUInt29();
        if ((ref & 1) == 0)
            return this.getObject(ref >> 1) as Array;
        else
        {
            var len:int = (ref >> 1);
            var ba:Array = [];
            this.readFully(ba, 0, len);
            this.rememberObject(ba);
            return ba;
        }
    };
    
    private function readAmf3Vector(type:int):Object
    {
        var ref:uint = this.readUInt29();
        if ((ref & 1) == 0)
            return this.getObject(ref >> 1);
        var len:int = (ref >> 1);
        var vector:Array = toVector(type, [], this.readBoolean());
        var i:int;
        if (type === AMF3_VECTOR_OBJECT)
        {
            this.readString(); //className
            for (i = 0; i < len; i++)
                vector.push(this.readObject());
        }
        else if (type === AMF3_VECTOR_INT)
        {
            for (i = 0; i < len; i++)
                vector.push(this.readInt());
        }
        else if (type === AMF3_VECTOR_UINT)
        {
            for (i = 0; i < len; i++)
                vector.push(this.readUInt32());
        }
        else if (type === AMF3_VECTOR_DOUBLE)
        {
            for (i = 0; i < len; i++)
                vector.push(this.readDouble());
        }
        this.rememberObject(vector);
        return vector;
    };
    
    private function readObjectValue(type:uint):Object
    {
        var value:Object = null;
        var u:uint;
        
        switch (type)
        {
            case AMF3_STRING:
                value = this.readString();
                break;
            case AMF3_OBJECT:
                try
                {
                    value = this.readScriptObject();
                } 
                catch (e)
                {
                    throw "Failed to deserialize: " + e;
                }
                break;
            case AMF3_ARRAY:
                value = this.readArray();
                //value = this.readMap();
                break;
            case AMF3_BOOLEAN_FALSE:
                value = false;
                break;
            case AMF3_BOOLEAN_TRUE:
                value = true;
                break;
            case AMF3_INTEGER:
                u = this.readUInt29();
                // Symmetric with writing an integer to fix sign bits for
                // negative values...
                value = (u << 3) >> 3;
                break;
            case AMF3_DOUBLE:
                value = this.readDouble();
                break;
            case AMF3_UNDEFINED:
            case AMF3_NULL:
                break;
            case AMF3_DATE:
                value = this.readDate();
                break;
            case AMF3_BYTEARRAY:
                value = this.readByteArray();
                break;
            case AMF3_VECTOR_INT:
            case AMF3_VECTOR_UINT:
            case AMF3_VECTOR_DOUBLE:
            case AMF3_VECTOR_OBJECT:
                value = this.readAmf3Vector(type);
                break;
            case AMF0_AMF3:
                value = this.readObject();
                break;
            default:
                throw "Unsupported AMF type: " + type;
        }
        return value;
    };
    
    public function readBoolean():Boolean
    {
        return this.read() === 1;
    };
    
    private function toVector(type:uint, array:Array, fixed:Boolean):Array
    {
        // TODO (aharui) handle vectors
        return array;
    }

}

}

class Traits
{
    public var alias:String;
    public var externalizable:Boolean;
    public var dynamic:Boolean;
    public var count:int = 0;
    public var props:Array = [];
}
