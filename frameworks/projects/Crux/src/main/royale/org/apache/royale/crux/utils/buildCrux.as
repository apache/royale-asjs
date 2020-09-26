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
package org.apache.royale.crux.utils
{
    import org.apache.royale.crux.BeanFactory;
    import org.apache.royale.crux.Crux;
    import org.apache.royale.crux.CruxConfig;
    import org.apache.royale.crux.ICrux;
    import org.apache.royale.crux.ICruxConfig;
    import org.apache.royale.events.IEventDispatcher;

	/**
	 *  Initialize a crux instance.
	 *
	 *  @param dispatcher The <code>IEventDispatcher</code> used for crux to dispatch events
	 *  @param beanProviderClasses The <code>Array</code> of classes where crux will get its beans
	 *  @param eventPackages The <code>Array</code> of packages where crux should search for events
	 *  @param viewPackages The <code>Array</code> of packages where crux should search for views
	 * 
	 *  @return The <code>ICrux</code> with the recently created crux instance.
	 */
	public function buildCrux(dispatcher:IEventDispatcher, beanProviderClasses:Array, eventPackages:Array, viewPackages:Array):ICrux
	{
		// crux config
		var config:ICruxConfig = new CruxConfig();
		config.eventPackages = eventPackages ? eventPackages : new Array();
		config.viewPackages = viewPackages ? viewPackages : new Array();
		config.strict = true;

		// add beans
		var providers:Array = new Array();
		var _beanLoaders:Array = beanProviderClasses ? beanProviderClasses : new Array();

		var len:int = _beanLoaders.length;
		for(var index:int = 0; index < len; index++)
		{
			providers.push(_beanLoaders[index]);
		}

		return new Crux(dispatcher, config, new BeanFactory(), providers);
	}
}