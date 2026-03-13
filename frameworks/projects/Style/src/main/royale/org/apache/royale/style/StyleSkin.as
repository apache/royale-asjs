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
package org.apache.royale.style
{
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.style.stylebeads.IStyleBead;
	[DefaultProperty("styles")]
	/**
	 * The StyleSkin class is a bead that can be added to a component to provide styling capabilities.
	 * All style skins have an array of style beads that they use to apply styles to the component.
	 * When the strand is set, the StyleSkin will apply all of its style beads to the component.
	 * 
	 * StyleSkins can have more complex styling where it applies style beads to specific elements within the component.
	 * Each skin must know the composition of the component it is styling and how to apply styles to the various elements
	 * within that component.
	 * 
	 * The component must have all its parts when added to parent for the styling to be correctly applied.
	 */
	public class StyleSkin extends Bead implements IStyleSkin
	{
		public function StyleSkin()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.IStyleUIBase
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			assert(value is IStyleUIBase, "StyleSkin can only be added to components that implement IStyleUIBase");
			var styleUIBase:IStyleUIBase = value as IStyleUIBase;
			for each(var styleBead:IStyleBead in styles)
			{
				styleUIBase.addStyleBead(styleBead);
			}
		}
		protected var _styles:Array;

		/**
		 *  The array of style beads that this StyleSkin will apply to the component.
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
		 * 
		 */
		public function get styles():Array
		{
			return _styles;
		}

		public function set styles(value:Array):void
		{
			_styles = value;
		}
	}
}