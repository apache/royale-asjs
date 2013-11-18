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
public class FunctionReturnWatcher extends Watcher
{

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

    /**
	 *  @private
	 *  Constructor.
	 */
	public function FunctionReturnWatcher(functionName:String,
										  document:Object,
										  parameterFunction:Function,
										  events:Object,
                                          listeners:Array,
                                          functionGetter:Function = null,
                                          isStyle:Boolean = false)
    {
		super(listeners);

        this.functionName = functionName;
        this.document = document;
        this.parameterFunction = parameterFunction;
        this.events = events;
        this.functionGetter = functionGetter;
        this.isStyle = isStyle;
    }

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
     *  The name of the property, used to actually get the property
	 *  and for comparison in propertyChanged events.
     */
    private var functionName:String;
    
	/**
 	 *  @private
     *  The document is what we need to use to execute the parameter function.
     */
    private var document:Object;
    
	/**
 	 *  @private
     *  The function that will give us the parameters for calling the function.
     */
    private var parameterFunction:Function;
    
    /**
 	 *  @private
     *  The events that indicate the property has changed.
     */
    private var events:Object;
    
	/**
	 *  @private
     *  The parent object of this function.
     */
    private var parentObj:Object;
    
	/**
	 *  @private
     *  The watcher holding onto the parent object.
     */
    public var parentWatcher:Watcher;

    /**
     *  Storage for the functionGetter property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var functionGetter:Function;

    /**
     *  Storage for the isStyle property.  This will be true, when
     *  watching a function marked with [Bindable(style="true")].  For
     *  example, UIComponent.getStyle().
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    private var isStyle:Boolean;

}

}
