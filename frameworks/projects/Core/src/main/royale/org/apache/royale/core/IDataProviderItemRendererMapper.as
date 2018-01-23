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
package org.apache.royale.core
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IItemRendererClassFactory;

    /**
     *  The IDataProviderItemRendererMapper interface is the interface for beads
     *  that know how to iterate through a dataProvider, generate item renderers,
     *  and assign items from the dataProvider to those item renderers.  In Royale,
     *  a wide range of data providers are allowed, from simple Arrays and Vectors
     *  on up to sophisticated data structures that dispatch change events.
     *  Different IDataProviderItemRendererMapper implements are often required to
     *  iterate through those different data structures.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IDataProviderItemRendererMapper extends IBead
	{
        /**
         *  IDataProviderItemRendererMapper use an IItemRendererClassFactory
         *  to generate instances of item renderers.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get itemRendererFactory():IItemRendererClassFactory;
        function set itemRendererFactory(value:IItemRendererClassFactory):void;
	}
}
