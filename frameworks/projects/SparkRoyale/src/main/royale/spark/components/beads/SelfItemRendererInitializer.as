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
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IItemRendererInitializer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.ILayoutChild;
   
	/**
	 *  The SelfItemRendererInitializer class initializes self item renderers.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class SelfItemRendererInitializer extends Bead implements IItemRendererInitializer, IIndexedItemRendererInitializer
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function SelfItemRendererInitializer()
		{
		}

		/**
		 *  @private
		 */
		public function initializeItemRenderer(renderer:IItemRenderer, data:Object):void
		{
			var child:IChild = data as IChild;
			if (child == null) return;
		
			var sir:SelfItemRenderer = renderer as SelfItemRenderer;
			if (sir == null) return;
			
			var plc:ILayoutChild = sir.parent as ILayoutChild;
			var clc:ILayoutChild = child as ILayoutChild;
			if (plc && clc)
			{
				sir.explicitWidth = NaN;
				sir.percentWidth = NaN;
				if (!plc.isWidthSizedToContent() && !clc.isWidthSizedToContent()) sir.percentWidth = 100;
				sir.explicitHeight = NaN;
				sir.percentHeight = NaN;
				if (!plc.isHeightSizedToContent() && !clc.isHeightSizedToContent()) sir.percentHeight = 100;
			}
			
			sir.removeAllElements();
			sir.addElement(child);
			sir.invalidateSize();
		}

		/**
		 *  @private
		 */
		public function initializeIndexedItemRenderer(renderer:IIndexedItemRenderer, data:Object, index:int):void
		{
			initializeItemRenderer(renderer, data);
		}
	}
}
