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

import mx.rpc.IResponder;

[ExcludeClass]

/**
 *  @private
 *  This responder is a fallback in case the set or get methods
 *  we are invoking to implement this binding do not properly
 *  catch the ItemPendingError.  There may be some issues with
 *  leaving this in long term as we are not handling the
 *  case where this binding is executed multiple times in
 *  rapid succession (and thus piling up responders) and
 *  also not dealing with a potential stale item responder.
 */
public class EvalBindingResponder implements IResponder
{
    include "../core/Version.as";

 	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Constructor.
	 */
    public function EvalBindingResponder(binding:Binding, object:Object)
    {
		super();

        this.binding = binding;
        this.object = object;
    }

 	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
    private var binding:Binding;
    
	/**
	 *  @private
	 */
	private var object:Object;

 	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
    public function result(data:Object):void
    {
        binding.execute(object);
    }

	/**
	 *  @private
	 */
    public function fault(data:Object):void
    {
       // skip it
    }
}

}
