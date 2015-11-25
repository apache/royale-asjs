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
package org.apache.flex.html.supportClasses
{	
    import org.apache.flex.core.IContentView;
    import org.apache.flex.core.IItemRenderer;
    import org.apache.flex.core.IItemRendererParent;
    import org.apache.flex.core.UIBase;

    /**
     *  The DataGroup class is the IItemRendererParent used internally
     *  by org.apache.flex.html.List class.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class DataGroup extends ContainerContentArea implements IItemRendererParent, IContentView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function DataGroup()
		{
			super();
		}

        /**
         *  @copy org.apache.flex.core.IItemRendererParent#getItemRendererForIndex()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function getItemRendererForIndex(index:int):IItemRenderer
        {
			if (index < 0 || index >= numChildren) return null;
            return getChildAt(index) as IItemRenderer;
        }
		
		/**
		 *  Refreshes the itemRenderers. Useful after a size change by the data group.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
		 */
		public function updateAllItemRenderers():void
		{
			var n:Number = numElements;
			for (var i:Number = 0; i < n; i++)
			{
				var renderer:DataItemRenderer = getItemRendererForIndex(i) as DataItemRenderer;
				if (renderer) {
					renderer.setWidth(this.width,true);
					renderer.adjustSize();
				}
			}
		}
	}
}
