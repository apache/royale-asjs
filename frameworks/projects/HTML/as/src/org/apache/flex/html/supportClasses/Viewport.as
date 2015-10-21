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
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IContentView;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
    import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
    import org.apache.flex.geom.Rectangle;
    import org.apache.flex.geom.Size;
	import org.apache.flex.html.beads.models.ScrollBarModel;
    import org.apache.flex.utils.CSSContainerUtils;
	
    /**
     * @copy org.apache.flex.core.IViewport
     */
	public class Viewport implements IBead, IViewport
	{	
		public function Viewport()
		{
		}
		
		protected var contentArea:UIBase;
        public function get contentView():IUIBase
        {
            return contentArea;
        }
        
		protected var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
            contentArea = _strand.getBeadByType(IContentView) as UIBase;
            if (!contentArea)
            {
                var c:Class = ValuesManager.valuesImpl.getValue(_strand, 'iContentView') as Class;
                contentArea = new c() as UIBase;
            }
		}
		
        /**
         * @copy org.apache.flex.core.IViewport 
         */
        public function setPosition(x:Number, y:Number):void
        {
            contentArea.x = x;
            contentArea.y = y;
        }
        
        /**
         * @copy org.apache.flex.core.IViewport 
         */
		public function layoutViewportBeforeContentLayout(width:Number, height:Number):void
		{
			if (!isNaN(width))
                contentArea.width = width;
            if (!isNaN(height))
                contentArea.height = height;
		}
		
        /**
         * @copy org.apache.flex.core.IViewport 
         */
		public function layoutViewportAfterContentLayout():Size
		{
            // pass through all of the children and determine the maxWidth and maxHeight
            // note: this is not done on the JavaScript side because the browser handles
            // this automatically.
            var maxWidth:Number = 0;
            var maxHeight:Number = 0;
            var num:Number = contentArea.numElements;
            
            for (var i:int=0; i < num; i++) {
                var child:IUIBase = contentArea.getElementAt(i) as IUIBase;
                if (child == null || !child.visible) continue;
                var childXMax:Number = child.x + child.width;
                var childYMax:Number = child.y + child.height;
                maxWidth = Math.max(maxWidth, childXMax);
                maxHeight = Math.max(maxHeight, childYMax);
            }
            
            var padding:Rectangle = CSSContainerUtils.getPaddingMetrics(this._strand);
            return new Size(maxWidth + padding.right, maxHeight + padding.bottom);
		}
		
	}
}