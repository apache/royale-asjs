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
package org.apache.royale.utils
{
COMPILE::SWF
{
    import flash.utils.Proxy;
	import flash.utils.flash_proxy;
}

COMPILE::JS
{
    import org.apache.royale.events.EventDispatcher;
}

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  The Proxy class calls methods when properties
 *  are set and read and deleted.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
COMPILE::SWF
public dynamic class Proxy extends flash.utils.Proxy
{
	private var valueMap:Object = {};
	
	override flash_proxy function getProperty(propName:*):*
	{
		return valueMap[propName];
	}
	
	override flash_proxy function setProperty(propName:*, value:*):void
	{
		valueMap[propName] = value;
	}
	
	override flash_proxy function hasProperty(propName:*):Boolean
	{
		return valueMap.hasOwnProperty(propName);
	}
	
	override flash_proxy function deleteProperty(propName:*):Boolean
	{
		return delete valueMap[propName];
	}
	
	private var names:Array;
	
	override flash_proxy function nextNameIndex (index:int):int 
	{
		// initial call
		if (index == 0) {
			names = new Array();
			for (var p:* in valueMap) {
				names.push(p);
			}
		}
		
		if (index < names.length) {
			return index + 1;
		} else {
			return 0;
		}
	}
	
	override flash_proxy function nextName(index:int):String 
	{
		return names[index - 1];
	}
	
	override flash_proxy function nextValue(index:int):* 
	{
		return valueMap[names[index - 1]];
	}
}

COMPILE::JS
public dynamic class Proxy extends EventDispatcher
{
    /**
     *  Constructor.
     * 
     *  @param delay The number of milliseconds 
     *  to wait before dispatching the event.
     *  @param repeatCount The number of times to dispatch
     *  the event.  If 0, keep dispatching forever.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function Proxy()
    {
    }
    
    
	private var valueMap:Object = {};
    
    public function getProperty(propName:String):*
    {
        return valueMap[propName];
    }
    
    public function setProperty(propName:String, value:*):void
    {
        valueMap[propName] = value;
    }
    
    public function callProperty(propName:*, ... args:Array):*
    {
        return valueMap[propName].apply(this, args);
    }
    
    public function hasProperty(propName:String):Boolean
    {
		return valueMap.hasOwnProperty(propName);
    }
    
    public function deleteProperty(propName:String):Boolean
    {
		return delete valueMap[propName];
    }
	
	public function propertyNames():Array
	{
		var names:Array = [];
		for (var p:String in valueMap)
			names.push(p);
		return names;
	}
}

}
