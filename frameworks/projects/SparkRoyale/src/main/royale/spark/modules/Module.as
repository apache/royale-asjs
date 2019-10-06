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

package spark.modules
{
	// import flash.events.Event;
	import org.apache.royale.events.Event;
	
	// import mx.core.ContainerCreationPolicy;
	import mx.modules.IModule;
	import spark.components.SkinnableContainer;
	
//	[Frame(factoryClass="mx.core.FlexModuleFactory")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	/**
	 *  Modules are not supported for AIR mobile applications.
	 */
	[DiscouragedForProfile("mobileDevice")]
	
	/**
	 *  The base class for MXML-based dynamically-loadable modules. You extend this
	 *  class in MXML by using the <code>&lt;s:Module&gt;</code> tag in an MXML file, as the
	 *  following example shows:
	 *  
	 *  <pre>
	 *  &lt;?xml version="1.0"?&gt;
	 *  &lt;!-- This module loads an image. --&gt;
	 *  &lt;s:Module  width="100%" height="100%" xmlns:s="library://ns.adobe.com/flex/spark"&gt;
	 *  
	 *    &lt;s:Image source="trinity.gif"/&gt;
	 *  
	 *  &lt;/s:Module&gt;
	 *  </pre>
	 *  
	 *  @see mx.modules.ModuleManager
	 *  @see spark.modules.ModuleLoader
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class Module extends SkinnableContainer implements IModule
	{
		// include "../core/Version.as";
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function Module()
		{
			super();
		}
		
	}
	
}
