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
package org.apache.royale.style.stylebeads
{
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.StyleUIBase;

	/**
	 * Convenience class for styles that are composed of multiple leaf styles.
	 * This class does not have any functionality on its own,
	 * but serves as a base class for composite styles that contain multiple leaf styles.
	 * 
	 * It can also be used in MXML to group multiple styles together without adding any additional functionality.
	 */
	public class CompositeStyle extends StyleBeadBase
	{
		public function CompositeStyle()
		{
			super();
		}
		/**
		 * Composite styles have no effect, so it should not insert itself into the hierarchy.
		 */
		override public function getLeaves():Array
		{
			assert(styles && styles.length > 0, "Non-leaf style beads must have child styles");
			// nothing to preprocess.
			_leavesGathered = true;
			return gatherLeaves(parentStyle);
		}
		private var _leavesGathered:Boolean;

		override public function addStyleBead(bead:IStyleBead):void
		{
			super.addStyleBead(bead);
			if(_leavesGathered && _strand)
			{
				var pStyle:IStyleBead = parentStyle || this;
				bead.parentStyle = pStyle;
				if(bead is ILeafStyleBead)
					(bead as ILeafStyleBead).unit = unit;
				else if (bead is StyleBeadBase)
					(bead as StyleBeadBase).unit = unit;

				if(bead.isLeaf)
				{
					var leaf:ILeafStyleBead = bead as ILeafStyleBead;
					if(!leaf.isDecorated())
						decorateChildStyle(leaf, []);
					(_strand as StyleUIBase).setStyles([leaf], true);
				}
				else
					(_strand as StyleUIBase).setStyles(bead.getLeaves(), true);
			}
		}

		//TODO: Figure this out.
		override public function decorateChildStyle(style:ILeafStyleBead,decorations:Array):void
		{
			if(parentStyle)
				parentStyle.decorateChildStyle(style, decorations);
		}
	}
}