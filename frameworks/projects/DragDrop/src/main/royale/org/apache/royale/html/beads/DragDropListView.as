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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.IParent;
	import org.apache.royale.html.beads.ListView;
	import org.apache.royale.core.IUIBase;


	/**
	 *  DragDropListView is the view to use for Lists when you want to use
	 *  drag and drop beads. This view provides a drawing layer in which the
	 *  the drop indicator can be displayed when the list is the target for
	 *  drag and drop operations.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	COMPILE::JS
	public class DragDropListView extends ListView
	{
		private var _strand:IStrand;

		private var _layer:UIBase;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IParent
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;

			var layerBead:ListDrawingLayerBead = new ListDrawingLayerBead();
			_strand.addBead(layerBead);
			_layer = layerBead.layer;
			_layer.percentHeight = 100;
			_layer.percentWidth = 100;

			//var chost:IContainer = host as IContainer;
			//chost.strandChildren.addElement(_layer);
			(_strand as IParent).addElement(_layer);

		}

	}

	COMPILE::SWF
	public class DragDropListView extends ListView
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function DragDropListView()
		{
			super();
		}

		private var _strand:IStrand;

		private var _layer:UIBase;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IContainer

		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;

			var layerBead:ListDrawingLayerBead = new ListDrawingLayerBead();
			_strand.addBead(layerBead);
			_layer = layerBead.layer;

			var chost:IContainer = host as IContainer;
			chost.strandChildren.addElement(_layer);

		}

		/**
		 * @private
		 */
		override public function afterLayout():void
		{
			super.afterLayout();

			_layer.x = 0;
			_layer.y = 0;
			_layer.width = (_strand as IUIBase).width;
			_layer.height = (_strand as IUIBase).height;
		}
	}
}
