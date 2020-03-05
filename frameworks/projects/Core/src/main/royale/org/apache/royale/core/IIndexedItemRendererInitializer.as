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
    import org.apache.royale.core.IItemRendererOwnerView;

    /**
     *  The IIndexedItemRendererInitializer interface is the basic interface for beads
     *  that initialize properties on an IItemRenderer.  Simple implementations
     *  only assign the data and itemRendererOwnerView property, but others will 
     *  assign other properties if needed. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IIndexedItemRendererInitializer extends IItemRendererInitializer
	{
        /**
         *  This method is called to generate another instance of an item renderer.
         * 
         *  @param renderer The renderer
         *  @param data The data for the renderer
         *  @param ownerView the view of the component that owns the renderers
         *  @param index the index in the list of renderers
         * 
         *  @see org.apache.royale.core.IItemRenderer
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function initializeIndexedItemRenderer(renderer:IIndexedItemRenderer, data:Object, index:int):void;
	}
}
