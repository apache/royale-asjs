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

package mx.binding
{

[ExcludeClass]

/**
 * @private
 * This class is used to satisfy old MXML codegen
 * for both Falcon and MXML, but in FlexJS with mxml.children-as-data output
 * it isn't needed so there is no JS equivalent
 */
public class PropertyWatcher extends Watcher
{

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

    /**
     *  Create a PropertyWatcher
     *
     *  @param prop The name of the property to watch.
     *  @param event The event type that indicates the property has changed.
     *  @param listeners The binding objects that are listening to this Watcher.
     *  @param propertyGetter A helper function used to access non-public variables.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function PropertyWatcher(propertyName:String,
                                    events:Object,
                                    listeners:Array,
                                    propertyGetter:Function = null)
    {
		super(listeners);

    }

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
     *  The parent object of this property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var parentObj:Object;

    /**
     *  The events that indicate the property has changed
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var events:Object;

    /**
     *  Storage for the propertyGetter property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var propertyGetter:Function;

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  propertyName
	//----------------------------------

	/**
     *  Storage for the propertyName property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _propertyName:String;
    
    /**
     *  The name of the property this Watcher is watching.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get propertyName():String
    {
        return _propertyName;
    }

	//----------------------------------
	//  useRTTI
	//----------------------------------

    /**
     *	If compiler can't determine bindability from static type,
	 *  use RTTI on runtime values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var useRTTI:Boolean;

}

}
