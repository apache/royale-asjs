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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.html.beads.IDrawingLayerBead;
	
    
	/**
	 *  DataGridDrawingLayerBead places a graphic space into the DataGrid that is
	 *  positioned above the Container used to hold the columns. This graphic space
	 *  can be used to insert visualizations into the DataGrid.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class DataGridDrawingLayerBead implements IBead, IDrawingLayerBead
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function DataGridDrawingLayerBead()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(_strand).addEventListener("beadsAdded", handleBeadsAdded);
		}
		
		private var _layer:UIBase;
		
		/**
		 * The component used as the drawing layer.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get layer():UIBase
		{
			return _layer;
		}
		
		/**
		 * @private
		 */
		private function handleBeadsAdded(event:Event):void
		{
			var view:IDataGridView = UIBase(_strand).view as IDataGridView;
			if (view != null) {
				_layer = new UIBase();
				_layer.className = "DataGridDrawingLayer";
				COMPILE::JS {
					_layer.element.style.position = "absolute";
					_layer.element.style['pointer-events'] = 'none';
					_layer.element.style['overflow'] = 'hidden';
				}
				UIBase(_strand).addElement(_layer);
			}
			// else: this is an error as this bead cannot be used with anything but
			// a DataGrid.
		}
	}
}
