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
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.supportClasses.Viewport;
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.ISparkContainer;
	import spark.layouts.BasicLayout;

	// for host.setSkin()
	import mx.core.mx_internal;
	use namespace mx_internal;

	/**
	 *  @private
	 *  The viewport that loads a Spark Skin.
	 */
	public class SparkSkinViewport extends org.apache.royale.html.supportClasses.Viewport
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.6
		 */
		public function SparkSkinViewport()
		{
			super();
		}

		override public function set strand(value:IStrand):void
		{
			var host:SkinnableComponent = value as SkinnableComponent;

			super.strand = value;

			var c:Class = ValuesManager.valuesImpl.getValue(value, "skinClass") as Class;
			if (c)
			{
				if (!host.skin)
				{
					host.setSkin(new c());
				}
				host.skin.addEventListener("initComplete", initCompleteHandler);
			}
		}

		protected function initCompleteHandler(event:Event):void
		{
			var host:SkinnableComponent = _strand as SkinnableComponent;

			// can SkinPart do this better?
			contentArea = host.skin["contentGroup"];
			prepareContentView();
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
	}
}
