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
package org.apache.royale.html.beads
{
	/**
	 *  The MultiSelectionItemRendererClassFactory class extends ItemRendererClassFactory to add a multiselection controller to item renderers
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ItemRendererClassFactory;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.html.beads.controllers.MultiSelectionItemRendererMouseController;

	public class MultiSelectionItemRendererClassFactory extends ItemRendererClassFactory
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function MultiSelectionItemRendererClassFactory()
		{
			super();
		}

		override public function createFromClass():IItemRenderer
		{
			var renderer:IItemRenderer = super.createFromClass();
			var strand:IStrand = renderer as IStrand;
			var bead:IBead = strand.getBeadByType(IBeadController);
			if (bead)
			{
				strand.removeBead(bead);
			}
			strand.addBead(new MultiSelectionItemRendererMouseController());
			return renderer;
		}
	}
}
