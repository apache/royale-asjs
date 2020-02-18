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
    /**
     *  The IItemRendererClassFactory interface is the basic interface for beads
     *  that generate instances of IItemRenderers.  Note that this is not the same
     *  as an org.apache.royale.core.IFactory which is a lower-level interface for generating
     *  an instance of just about anything.  IItemRendererClassFactory implementations
     *  often use IFactory to generate the actual item renderer instance, but
     *  the IItemRendererClassFactory bead allows for more computation about which 
     *  renderer to instantiate. For example, the default implementation
     *  in org.apache.royale.core.ItemRendererClassFactory checks for an itemRenderer
     *  property on the strand, then looks for a default definition in CSS, but
     *  also handles the renderer being defined in MXML in sub tags of the
     *  ItemRendererClassFactory.  Other more advanced implementations could
     *  return different renderers based on the data item's type.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IItemRendererClassFactory extends IBead
	{
        /**
         *  This method is called to generate another instance of an item renderer.
         * 
         *  @return The item renderer.
         * 
         *  @see org.apache.royale.core.IItemRenderer
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function createItemRenderer():IItemRenderer;
	}
}
