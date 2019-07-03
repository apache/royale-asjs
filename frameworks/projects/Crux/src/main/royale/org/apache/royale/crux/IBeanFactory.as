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
    public interface IBeanFactory
	{
        function setUp( crux:ICrux ):void;
		function tearDown():void;
		
		function setUpBean( bean:Bean ):void;
		function addBean( bean:Bean, autoSetUpBean:Boolean = true ):Bean;
		function addBeanProvider( beanProvider:IBeanProvider, autoSetUpBeans:Boolean = true ):void;
		
		function tearDownBean( bean:Bean ):void;
		function removeBean( bean:Bean ):void;
		function removeBeanProvider( beanProvider:IBeanProvider ):void;
		
		function get beans():Array;
		function getBeanByName( name:String ):Bean;
		function getBeanByType( type:Class ):Bean;
		
		/**
		 * Parent Crux instance, for nesting and modules
		 */
		function get parentBeanFactory():IBeanFactory;
		function set parentBeanFactory( parentBeanFactory:IBeanFactory ):void;
    }
}
