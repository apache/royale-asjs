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

COMPILE::SWF
{
import flash.utils.flash_proxy;
}

import mx.utils.ObjectProxy;
import mx.utils.ObjectUtil;
import mx.utils.object_proxy;

import org.apache.royale.reflection.getQualifiedClassName;
import org.apache.royale.utils.Proxy;

[ExcludeClass]

/**
 * Wraps the value of an element's or child type's content so that it can be
 * added as a property to a parent complex type at a later time when processing
 * against a Schema.
 * 
 * @private
 */
public dynamic class ContentProxy extends Proxy
{
    public function ContentProxy(content:* = undefined, makeObjectsBindable:Boolean = false, isSimple:Boolean = true)
    {
        super();

        object_proxy::content = content;
        object_proxy::makeObjectsBindable = makeObjectsBindable;
        object_proxy::isSimple = isSimple;
    }

    //--------------------------------------------------------------------------
    //
    //  Internal Properties
    //
    //--------------------------------------------------------------------------

    object_proxy function get makeObjectsBindable():Boolean
    {
        return _makeObjectsBindable;
    }

    object_proxy function set makeObjectsBindable(value:Boolean):void
    {
        _makeObjectsBindable = value;
        if (value && !_isSimple && !(_content is ObjectProxy))
        {
            _content = new ObjectProxy(_content);
        }
    }

    object_proxy function get isSimple():Boolean
    {
        return _isSimple;
    }

    object_proxy function set isSimple(value:Boolean):void
    {
        _isSimple = value;
    }

    object_proxy function get content():*
    {
        return _content;
    }

    object_proxy function set content(value:*):void
    {
        if (value is ContentProxy)
            value = ContentProxy(value).object_proxy::content;
        _content = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns the specified property value of the proxied object.
     *
     *  @param name Typically a string containing the name of the property,
     *  or possibly a QName where the property name is found by 
     *  inspecting the <code>localName</code> property.
     *
     *  @return The value of the property.
     *  In some instances this value may be an instance of 
     *  <code>ObjectProxy</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    override flash_proxy function getProperty(name:*):*
    {
        return proxy_getProperty(name);
    }
    COMPILE::JS
    override public function getProperty(name:String):*
    {
        return proxy_getProperty(name);
    }
    
    private function proxy_getProperty(name:String):*
    {
        if (_content != null)
            return _content[name];
        else
            return undefined;                
    }

    /**
     *  Returns the value of the proxied object's method with the specified name.
     *
     *  @param name The name of the method being invoked.
     *
     *  @param rest An array specifying the arguments to the
     *  called method.
     *
     *  @return The return value of the called method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    override flash_proxy function callProperty(name:*, ... rest):*
    {
        if (_content != null)
            return _content[name].apply(_content, rest);
        else
            return undefined;
    }
    
    COMPILE::JS
    override public function callProperty(name:*, ... rest):*
    {
        if (_content != null)
            return _content[name].apply(_content, rest);
        else
            return undefined;
    }
        
    /**
     *  Deletes the specified property on the proxied object.
     * 
     *  @param name Typically a string containing the name of the property,
     *  or possibly a QName where the property name is found by 
     *  inspecting the <code>localName</code> property.
     *
     *  @return A Boolean indicating if the property was deleted.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    override flash_proxy function deleteProperty(name:*):Boolean
    {
        return proxy_deleteProperty(name);
    }
    
    COMPILE::JS
    override public function deleteProperty(name:String):Boolean
    {
        return proxy_deleteProperty(name);
    }
    
    private function proxy_deleteProperty(name:*):Boolean
    {
        var deleted:Boolean;
        if (!_isSimple && _content != null)
        {
            var oldVal:Object = _content[name];
            deleted = delete _content[name]; 
        }
        return deleted;        
    }


    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *  
     *  @param name The property name that should be tested 
     *  for existence.
     *
     *  @see flash.utils.Proxy#hasProperty()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    override flash_proxy function hasProperty(name:*):Boolean
    {
        return proxy_hasProperty(name);
    }
    
    COMPILE::JS
    override public function hasProperty(name:String):Boolean
    {
        return proxy_hasProperty(name);
    }

    private function proxy_hasProperty(name:*):Boolean
    {
        var hasProperty:Boolean;
        if (_content != null)
        {
            hasProperty = (name in _content);
        }
        return hasProperty;        
    }
    
    /**
     *  Updates the specified property on the proxied object.
     *
     *  @param name Object containing the name of the property that
     *  should be updated on the proxied object.
     *
     *  @param value Value that should be set on the proxied object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    override flash_proxy function setProperty(name:*, value:*):void
    {
        proxy_setProperty(name, value);
    }    
    COMPILE::JS
    override public function setProperty(name:String, value:*):void
    {
        proxy_setProperty(name, value);
    }
    private function proxy_setProperty(name:String, value:*):void
    {
        var oldContent:*;
        
        if (_isSimple)
        {
            oldContent = _content;
            if (oldContent !== value)
            {
                _content = value;
            }
        }
        else
        {
            if (_content == null)
                _content = object_proxy::createObject();
            
            oldContent = _content[name];
            if (oldContent !== value)
            {
                _content[name] = value;
            }
        }        
    }
    
    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *
     *  @see flash.utils.Proxy#nextName()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    override flash_proxy function nextName(index:int):String
    {
        return _propertyList[index - 1];
    }
    
    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *
     *  @see flash.utils.Proxy#nextNameIndex()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index == 0)
        {
            object_proxy::setupPropertyList();
        }

        if (index < _propertyList.length)
        {
            return index + 1;
        }
        else
        {
            return 0;
        }
    }

    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *
     *  @see flash.utils.Proxy#nextValue()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    override flash_proxy function nextValue(index:int):*
    {
        if (!_isSimple && _content != null)
        {
            return _content[_propertyList[index -1]];
        }
        return undefined;
    }

    //--------------------------------------------------------------------------
    //
    //  Internal Methods
    //
    //--------------------------------------------------------------------------

    object_proxy function setupPropertyList():void
    {
        if (getQualifiedClassName(_content) == "Object")
        {
            _propertyList = [];
            for (var prop:String in _content)
                _propertyList.push(prop);
        }
        else
        {
            _propertyList = ObjectUtil.getClassInfo(_content, null, {includeReadOnly:false, uris:["*"]}).properties;
        }
    }

    object_proxy function createObject():*
    {
        if (object_proxy::makeObjectsBindable)
        {
            return new ObjectProxy();
        }
        else
        {
            return {};
        }
    }

    private var _content:*;
    private var _isSimple:Boolean = true;
    private var _makeObjectsBindable:Boolean;
    private var _propertyList:Array;
}

}