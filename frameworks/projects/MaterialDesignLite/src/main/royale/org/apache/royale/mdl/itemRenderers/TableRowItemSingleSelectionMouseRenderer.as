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
package org.apache.royale.mdl.itemRenderers
{
    COMPILE::JS
    {
        import org.apache.royale.html.beads.controllers.ItemRendererMouseController;
        import org.apache.royale.core.WrappedHTMLElement;
    }
    
	/**
	 *  The TableRowItemSingleSelectionMouseRenderer defines the basic Item Renderer for a MDL Table Component and handles mouse events, notifying about them host component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class TableRowItemSingleSelectionMouseRenderer extends TableRowItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function TableRowItemSingleSelectionMouseRenderer()
		{
			super();
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            super.createElement();

            controller = new ItemRendererMouseController();
            controller.strand = this;

            return element;
        }

	}
}

import org.apache.royale.core.IUIBase;
import org.apache.royale.html.beads.SelectableItemRendererBeadBase;

class TableRowItemSelectableItemRendererBead extends SelectableItemRendererBeadBase
{
    override public function updateRenderer():void
    {
        COMPILE::JS
        {
            var row:IUIBase = _strand as IUIBase;
            if (selected)
            {
                row.element.classList.add("is-selected");
            }
            else
            {
                row.element.classList.remove("is-selected");
            }
        }
    }    
}