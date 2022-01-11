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

package spark.components.beads
{
	import mx.core.LayoutElementUIComponentUtils;
	import mx.core.UIComponent;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.ContainerView;
	import spark.components.supportClasses.GroupBase;
	import spark.core.ISparkContainer;
	import spark.core.ISparkLayoutHost;
	import spark.layouts.BasicLayout;
	
	/**
	 *  @private
	 *  The SparkContainerView for emulation.
	 */
	public class SparkContainerView extends ContainerView implements ISparkLayoutHost
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.6
		 */
		public function SparkContainerView()
		{
			super();
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			prepareContentView();
			prepareDisplayView();
		}
		
		protected function prepareContentView():void
		{
			var host:ILayoutChild = _strand as ILayoutChild;
			var g:GroupBase = contentView as GroupBase;
			
			if (!host || !g)
				return;
				
			if (host == g)
			{
				if (g.layout == null)
					g.layout = new BasicLayout();
				return;
			}

			// only for the case where host.layout was set before view set
			var hc:ISparkContainer = _strand as ISparkContainer;
			if (hc.layout != null)
				g.layout = hc.layout;

			if (g.layout == null)
				g.layout = new BasicLayout();
		}

		public function get displayView():GroupBase
		{
			return contentView as GroupBase;
		}
		
		protected function prepareDisplayView():void
		{
			var host:ILayoutChild = _strand as ILayoutChild;
			var g:GroupBase = displayView as GroupBase;

			if (!host || !g || host == g)
				return;

			// Resize content to host, because 
			// (a) ScrollingViewport sets content to 100% and
			// (b) we don't yet have content reverse-proxing the explicit size functions 
			//     (explicitXX, percentXX, isXXSizedToContent) back to the host.
			// Layout asks target (content) for explicit sizes, sometimes.
			//
			LayoutElementUIComponentUtils.setSizeFromChild(g, host);
		}
		
		/**
		 *  Measure before layout.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override public function beforeLayout():Boolean
		{
			if (_strand != displayView)
			{
				var host:UIComponent = _strand as UIComponent;
				var g:GroupBase = displayView as GroupBase;

				// Resize content to host, because 
				// (a) ScrollingViewport sets content to 100% and
				// (b) we don't yet have content reverse-proxing the explicit size functions 
				//     (explicitXX, percentXX, isXXSizedToContent) back to the host.
				// Layout asks target (content) for explicit sizes, sometimes.
				//
				LayoutElementUIComponentUtils.setSizeFromChild(g, host);
				
				if (g.isWidthSizedToContent() || g.isHeightSizedToContent())
				{
					g.layout.measure();
				}
			}
			return true;
		}
		
		/**
		 *  Dispatch after layout.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override public function afterLayout():void
		{
			if (_strand != displayView)
			{
				var host:UIComponent = _strand as UIComponent;
				var g:GroupBase = displayView as GroupBase;

				host.setActualSize(g.width, g.height);

				if (g.isWidthSizedToContent() || g.isHeightSizedToContent())
				{
					// request re-run layout on the parent.  In theory, we should only
					// end up in afterLayout if the content size changed.
					if (host.parent)
					{
						(host.parent as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));   
					}
				}
			}
		}
	}
}
