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

package mx.core
{

/**
 * @private
 * This class is used to satisfy old MXML codegen
 * for both Falcon and MXML, but in FlexJS with mxml.children-as-data output
 * it isn't needed so there is no JS equivalent
 */
public class DeferredInstanceFromFunction
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param generator A function that creates and returns an instance
     *  of the required object.
     *
     *  @param destructor An optional function used to cleanup outstanding
     *  references when <code>reset()</code> is called.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function DeferredInstanceFromFunction(generator:Function,
        destructor:Function = null )
    {
        super();

        this.generator = generator;
        this.destructor = destructor;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  The generator function.
     */
    private var generator:Function;

    /**
     *  @private
     *  The generated value.
     */
    private var instance:Object = null;

    /**
     *  @private
     *  An optional function used to cleanup outstanding
     *  references when reset() is invoked
     */
    private var destructor:Function;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns a reference to an instance of the desired object.
     *  If no instance of the required object exists, calls the function
     *  specified in this class' <code>generator</code> constructor parameter.
     * 
     *  @return An instance of the object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getInstance():Object
    {
        if (!instance)
            instance = generator();

        return instance;
    }
    
    /**
     *  Resets the state of our factory to the initial, uninitialized state.
     *  The reference to our cached instance is cleared.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    public function reset():void
    {
        instance = null;
        
        if (destructor != null)
            destructor();
    }

}

}
