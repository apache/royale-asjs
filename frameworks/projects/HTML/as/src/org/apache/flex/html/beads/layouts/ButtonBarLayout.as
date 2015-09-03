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
package org.apache.flex.html.beads.layouts
{	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.List;
	import org.apache.flex.html.beads.ButtonBarView;
	
	/**
	 *  The ButtonBarLayout class bead sizes and positions the org.apache.flex.html.Button 
	 *  elements that make up a org.apache.flex.html.ButtonBar. This bead arranges the Buttons 
	 *  horizontally and makes them all the same width unless the buttonWidths property has been set in which case
	 *  the values stored in that array are used.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ButtonBarLayout implements IBeadLayout
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ButtonBarLayout()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _buttonWidths:Array = null;
		
		/**
		 *  An array of widths (Number), one per button. These values supersede the
		 *  default of equally-sized buttons.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get buttonWidths():Array
		{
			return _buttonWidths;
		}
		public function set buttonWidths(value:Array):void
		{
			_buttonWidths = value;
		}
		
		/**
		 * @copy org.apache.flex.core.IBeadLayout#layout
		 */
		public function layout():Boolean
		{
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:IParentIUIBase = layoutParent.contentView as IParentIUIBase;
			var itemRendererParent:IItemRendererParent = contentView as IItemRendererParent;
			var viewportModel:IViewportModel = (layoutParent as ButtonBarView).viewportModel;
			
			var n:int = contentView.numElements;
			var realN:int = n;
			
			for (var j:int=0; j < n; j++)
			{
				var child:IUIBase = itemRendererParent.getElementAt(j) as IUIBase;
				if (child == null || !child.visible) realN--;
			}
			
			var xpos:Number = 0;
			var useWidth:Number = contentView.width / realN;
			var useHeight:Number = contentView.height;
			
			for (var i:int=0; i < n; i++)
			{
				var ir:ISelectableItemRenderer = itemRendererParent.getElementAt(i) as ISelectableItemRenderer;
				if (ir == null || !UIBase(ir).visible) continue;
				UIBase(ir).y = 0;
				UIBase(ir).x = xpos;
				if (!isNaN(useHeight) && useHeight > 0) {
					UIBase(ir).height = useHeight;
				}
				
				if (buttonWidths) UIBase(ir).width = Number(buttonWidths[i]);
				else if (!isNaN(useWidth) && useWidth > 0) {
					UIBase(ir).width = useWidth;
				}
				xpos += UIBase(ir).width;
			}
			
			IEventDispatcher(_strand).dispatchEvent( new Event("layoutComplete") );
			
            return true;
		}
	}
}
