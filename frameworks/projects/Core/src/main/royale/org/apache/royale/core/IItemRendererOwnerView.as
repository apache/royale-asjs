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
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.core.IUIBase;

    /**
     *  The IItemRendererOwnerView interface is the basic interface for the 
     *  container that parents item renderers.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IItemRendererOwnerView extends IEventDispatcher
	{
        /**
         *  The IItemRendererOwnerView interface is the basic interface for the 
         *  container that parents item renderers.
         * 
         *  @param index The index of the data item.
         *  @return The item renderer for the data item.
         * 
         *  @see org.apache.royale.core.IItemRenderer
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function addItemRenderer(renderer:IItemRenderer, dispatchAdded:Boolean):void;
		function addItemRendererAt(renderer:IItemRenderer, index:int):void;
		function removeItemRenderer(renderer:IItemRenderer):void;
		function getItemRendererForIndex(index:int):IItemRenderer;
        function getItemRendererAt(index:int):IItemRenderer;
		function removeAllItemRenderers():void;
		function updateAllItemRenderers():void;
        function get numItemRenderers():int;
        
        function get host():IUIBase;
	}
}
