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

import org.apache.flex.utils.Proxy;
COMPILE::SWF
{
import flash.utils.flash_proxy;
import mx.utils.object_proxy;

use namespace flash_proxy;
use namespace object_proxy;
}

/**
 *  OrderedObject acts as a wrapper to Object to preserve the ordering of the
 *  properties as they are added. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */ 
public dynamic class OrderedObject extends Proxy
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
     *  @productversion Flex 3
     */
    public function OrderedObject(item:Object=null)
    {
        super();

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
     *  @productversion Flex 3
     */
	COMPILE::SWF
    object_proxy var propertyList:Array;
	COMPILE::JS
	public var propertyList:Array;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     * 
     *  Work around for the Flash Player bug #232854. The Proxy bug occurs when 
     *  the Proxy class is used in a sibling ApplicationDomain of the main 
     *  application's ApplicationDomain. When the Proxy class is used in a 
     *  sibling ApplicationDomain the RTE looks like this:
     * 
     *  ArgumentError: Error #1063: Argument count mismatch on 
     *  Object/http://adobe.com/AS3/2006/builtin::hasOwnProperty(). 
     *  Expected 0, got 2. 
     * 
     *  Returns the specified property value of the proxied object.
     *
     *  @param name Typically a string containing the name of the property, or
     *  possibly a QName where the property name is found by inspecting the
     *  <code>localName</code> property.
     *
     *  @return The value of the property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    object_proxy function getObjectProperty(name:*):*
    {
        return getProperty(name);
    }
    
    /**
     *  @private
     * 
     *  Work around for the Flash Player bug #232854. See the comments in 
     *  getObjectProperty() for more details.
     * 
     *  Call this method to set a property value instead of hashing into an 
     *  OrderObject which would end up calling setProperty().
     *
     *  Updates the specified property on the proxied object.
     *
     *  @param name Object containing the name of the property that should be
     *  updated on the proxied object.
     *
     *  @param value Value that should be set on the proxied object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    object_proxy function setObjectProperty(name:*, value:*):void
    {
        setProperty(name, value);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

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
        var deleted:Boolean = delete valueMap[name]; 
        
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
	COMPILE::JS
	override public function deleteProperty(name:String):Boolean
	{
		var deleted:Boolean = delete valueMap[name]; 
		
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
     *  This is an internal function that must be implemented by a subclass of
     *  flash.utils.Proxy.
     *  
     *  @param name The property name that should be tested for existence.
     *
     *  @return If the property exists, <code>true</code>; otherwise
     *  <code>false</code>.
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
        return(name in valueMap);
    }
	COMPILE::JS
	override public function hasProperty(name:String):Boolean
	{
		return(name in valueMap);
	}

    /**
     *  This is an internal function that must be implemented by a subclass of
     *  flash.utils.Proxy.
     *
     *  @param index The zero-based index value of the object's property.
     *
     *  @return The property's name.
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
        return propertyList[index -1];
    }
	COMPILE::JS
	override public function elementNames():Array
	{
		return propertyList.slice();
	}

    /**
     *  This is an internal function that must be implemented by a subclass of
     *  flash.utils.Proxy.
     *
     *  @param index The zero-based index value of the object's property.
     *
     *  @return The property's value.
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
        return valueMap[propertyList[index -1]];
    }

    /**
     *  Updates the specified property on the proxied object.
     *
     *  @param name Object containing the name of the property that should be
     *  updated on the proxied object.
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
        var oldVal:* = valueMap[name];
        if (oldVal !== value)
        {
            // Update item.
			valueMap[name] = value;
            
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
	COMPILE::JS
	override public function setProperty(name:String, value:*):void
	{
		var oldVal:* = valueMap[name];
		if (oldVal !== value)
		{
			// Update item.
			valueMap[name] = value;
			
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
