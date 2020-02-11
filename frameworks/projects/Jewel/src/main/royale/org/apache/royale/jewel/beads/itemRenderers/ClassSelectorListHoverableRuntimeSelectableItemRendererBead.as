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
package org.apache.royale.jewel.beads.itemRenderers
{
    COMPILE::SWF
    {
        import flash.display.Sprite;
    }
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.utils.ClassSelectorList;

	/**
	 *  UnselectableElement bead prevents from text selection of html element
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class ClassSelectorListHoverableRuntimeSelectableItemRendererBead extends ClassSelectorListRuntimeSelectableItemRendererBead
	{

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function ClassSelectorListHoverableRuntimeSelectableItemRendererBead(classSelectorList:ClassSelectorList)
		{
            super(classSelectorList);
		}
        
        /**
         * @private
         */
        override public function updateRenderer():void
        {
            // there's no selection only hover state
            if(hoverable)
                classSelectorList.toggle("hovered", hovered);
        }
        

	}
}
