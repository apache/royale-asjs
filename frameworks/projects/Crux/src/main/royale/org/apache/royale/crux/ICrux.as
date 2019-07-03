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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux
{
    import org.apache.royale.events.IEventDispatcher;

    /**
	 * ICrux Interface
	 */
	public interface ICrux
	{
		/**
		 * whether or not to process views
		 */
		function get catchViews():Boolean;
		function set catchViews( value:Boolean ):void;
		
		/**
		 * Local Dispatcher
		 */
		function get dispatcher():IEventDispatcher;
		function set dispatcher(value:IEventDispatcher):void;
		
		/**
		 * Global Dispatcher
		 */
		function get globalDispatcher():IEventDispatcher;
		function set globalDispatcher(value:IEventDispatcher):void;
		
		/**
		 * Config
		 */
		function get config():ICruxConfig;
		function set config(value:ICruxConfig):void;
		
		[ArrayElementType("org.apache.royale.crux.IBeanProvider")]
		/**
		 * Bean Providers
		 */
		function get beanProviders():Array;
		function set beanProviders(value:Array):void;
		
		/**
		 * Bean Factory
		 */
		function get beanFactory():IBeanFactory;
		function set beanFactory(value:IBeanFactory):void;
		
		[ArrayElementType("org.apache.royale.crux.processors.IProcessor")]
		/**
		 * Processors
		 */
		function get processors():Array;
		
		/**
		 * Custom Processors
		 */
		function set customProcessors( value:Array ):void;
		
		/**
		 * Parent Crux instance, for nesting and modules
		 */
		function get parentCrux():ICrux;
		function set parentCrux(parentCrux:ICrux):void;
		
		/**
		 * Called once in initialize Crux
		 */
		function init():void;
		
		/**
		 * Clean up this Crux instance
		 */
		function tearDown():void;
		
	}
}
