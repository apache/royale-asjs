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
package org.apache.flex.html.beads
{	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.IDrawingLayerBead;
	
	COMPILE::SWF {
		import flash.display.DisplayObjectContainer;
	}
	
    
	/**
	 *  ListDrawingLayerBead places a graphic space into the List that is
	 *  positioned the item renderers.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class ListDrawingLayerBead implements IBead, IDrawingLayerBead
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function ListDrawingLayerBead()
		{
			super();
			
			_layer = new UIBase();
			_layer.className = "ListDrawingLayer";
			
			COMPILE::SWF {
				var doc:DisplayObjectContainer = _layer.$displayObject as DisplayObjectContainer;
				doc.mouseEnabled = false;
				doc.mouseChildren = false;
			}
			COMPILE::JS {
				_layer.element.style.position = 'absolute';
				_layer.element.style['pointer-events'] = 'none';
				_layer.element.style['overflow'] = 'hidden';
			}
		}
		
		private var _strand:IStrand;
		
		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _layer:UIBase;
		
		/**
		 * Returns the component drawing layer.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get layer():UIBase
		{
			return _layer;
		}
	}
}
