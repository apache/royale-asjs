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
package org.apache.royale.externsjs.inspiretree.beads
{	
	
	/**  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	COMPILE::JS{
	import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.Strand;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.externsjs.inspiretree.beads.models.InspireTreeModel;
    import org.apache.royale.externsjs.inspiretree.supportClasses.IInspireTree;
	}
    COMPILE::JS
	public class InspireTreePaginateBead  extends Strand implements IBead
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */

		public function InspireTreePaginateBead()
		{
			super();
		}
        private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get strand():IStrand
        {
            return _strand;
        }
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set strand(value:IStrand):void
		{
            _strand = value;
			
			IEventDispatcher(_strand).addEventListener("onBeforeCreation", init);
		} 
		
		private var treeModel:InspireTreeModel;

		private function init(event:Event):void
		{
			treeModel = _strand.getBeadByType(IBeadModel) as InspireTreeModel;
			if(treeModel)
			{
				treeModel.addEventListener("paginateChanged", updateHost);
				treeModel.addEventListener("numNodesPageChanged", updateHost);
				updateHost(null);
			}
		}

		private var _paginate:Boolean = false;
		/**
		 * Show paginated nodes.
		 * By default 10 nodes per page will be displayed, to change this, set the 'numNodesPage' property.
		 */
        [Bindable("paginateChanged")]
		public function get paginate():Boolean{ return _paginate; }
		public function set paginate(value:Boolean):void
		{ 
			_paginate = value;
			if(treeModel)
			{
				if(value == treeModel.paginate) return;
				treeModel.paginate = value;
			}
		}

        /**
         *  How many nodes are rendered/loaded at once. 
         *  Used with deferrals. Defaults to nodes which fit in the container.
         */
        private var _numNodesPage:Number = -1;
        [Bindable("numNodesPageChanged")]
        public function get numNodesPage():Number
		{ 
			if( isNaN(_numNodesPage) || _numNodesPage == -1)
				return 10; 
			else
				return _numNodesPage;
		}
        public function set numNodesPage(value:Number):void
		{ 
			_numNodesPage = value;
			if(treeModel)
			{
				if(value == treeModel.numNodesPage) return;
				treeModel.numNodesPage = value;
			}
		}

		private function updateHost(event:Event):void
		{
			if(treeModel.paginate)
			{
				treeModel.configOptionView.nodeHeight = 35;
				treeModel.configOptionView.deferredRendering = true;
				treeModel.configOptionView.autoLoadMore = true;
				
				treeModel.configOption.pagination = {limit: numNodesPage};		
			}else
			{
				treeModel.configOptionView.deferredRendering = false;
				treeModel.configOptionView.autoLoadMore = false;
				treeModel.configOption.pagination = {limit: -1};	
			}
			if(event) 
				IInspireTree(_strand).reCreateViewTree();
		}


	}

    COMPILE::SWF
	public class InspireTreePaginateBead
	{
    }
}
