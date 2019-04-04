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

package mx.messaging.config
{

import org.apache.royale.reflection.getQualifiedClassName;
import org.apache.royale.utils.Proxy;
//import mx.utils.object_proxy;

COMPILE::SWF
{
import flash.utils.flash_proxy;
use namespace flash_proxy;
}
//use namespace object_proxy;
import mx.core.mx_internal;
use namespace mx_internal;

[RemoteClass(alias="flex.messaging.config.ConfigMap")]

/**
 *  The ConfigMap class provides a mechanism to store the properties returned 
 *  by the server with the ordering of the properties maintained. 
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3  
 */ 
public dynamic class ConfigMap extends Proxy
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     *
     * @param item An Object containing name/value pairs.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3       
     */
    public function ConfigMap(item:Object = null)
    {
        super();

        if (!item)
            item = {};
        _item = item;
       
		propertyList = [];                                
    }    
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Contains a list of all of the property names for the proxied object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3     
     */
    mx_internal var propertyList:Array;
            
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  object
    //----------------------------------

    /**
     *  Storage for the object property.
     */
    private var _item:Object;

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
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3     
     */
    COMPILE::SWF
    override flash_proxy function getProperty(name:*):*
    {
        // if we have a data proxy for this then
        var result:Object = null;
            
        result = _item[name];
        
        return result;
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
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3     
     */
    COMPILE::SWF
    override flash_proxy function callProperty(name:*, ... rest):*
    {
        return _item[name].apply(_item, rest)
    }
        
    /**
     *  Deletes the specified property on the proxied object and
     *  sends notification of the delete to the handler.
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
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3     
     */
    COMPILE::SWF
    override flash_proxy function deleteProperty(name:*):Boolean
    {
        var oldVal:Object = _item[name];
        var deleted:Boolean = delete _item[name]; 
		
        var deleteIndex:int = -1;
        for (var i:int = 0; i < propertyList.length; i++)
        {
        	if (propertyList[i] == name)
        	{
        		deleteIndex = i;
        		break;
        	}
        }
		if (deleteIndex > -1)
		{
			propertyList.splice(deleteIndex, 1);
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
     *  @return If the property exists, <code>true</code>; 
     *  otherwise <code>false</code>.
     *
     *  @see flash.utils.Proxy#hasProperty()
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3     
     */
    COMPILE::SWF
    override flash_proxy function hasProperty(name:*):Boolean
    {
        return(name in _item);
    }

    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *
     *  @param index The zero-based index of the object's
     *  property.
     *
     *  @return The property's name.
     *
     *  @see flash.utils.Proxy#nextName()
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3     
     */
    COMPILE::SWF
    override flash_proxy function nextName(index:int):String
    {
        return propertyList[index -1];
    }

    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *
     *  @param index The zero-based index of the object's
     *  property.
     *
     *  @return The zero-based index of the next proprety.
     *
     *  @see flash.utils.Proxy#nextNameIndex()
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3     
     */
    COMPILE::SWF
    override flash_proxy function nextNameIndex(index:int):int
    {        
        if (index < propertyList.length)
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
     *  @param index The zero-based index value of the object's
     *  property.
     *
     *  @return The property's value.
     *
     *  @see flash.utils.Proxy#nextValue()
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3     
     */
    COMPILE::SWF
    override flash_proxy function nextValue(index:int):*
    {
        return _item[propertyList[index -1]];
    }

    /**
     *  Updates the specified property on the proxied object
     *  and sends notification of the update to the handler.
     *
     *  @param name Object containing the name of the property that
     *  should be updated on the proxied object.
     *
     *  @param value Value that should be set on the proxied object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3     
     */
    COMPILE::SWF
    override flash_proxy function setProperty(name:*, value:*):void
    {
        var oldVal:* = _item[name];
        if (oldVal !== value)
        {
            // Update item.
            _item[name] = value;
            
			for (var i:int = 0; i < propertyList.length; i++)
        	{
        		if (propertyList[i] == name)
        		{
        			return;
	        	}
	        }
	        propertyList.push(name);
        }
    }              	
}

}
