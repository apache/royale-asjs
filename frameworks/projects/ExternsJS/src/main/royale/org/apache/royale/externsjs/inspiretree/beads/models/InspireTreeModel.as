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
package org.apache.royale.externsjs.inspiretree.beads.models
{
	import org.apache.royale.html.beads.models.ArrayListSelectionModel;
	import org.apache.royale.externsjs.inspiretree.vos.OptionsTree;
	import org.apache.royale.externsjs.inspiretree.vos.ConfigDOM;
	import org.apache.royale.core.HTMLElementWrapper;
	import org.apache.royale.utils.sendEvent;
	import org.apache.royale.collections.IArrayList;
	import org.apache.royale.externsjs.inspiretree.IInspireTree;
	import org.apache.royale.events.IEventDispatcher;
	
	//COMPILE::JS
	public class InspireTreeModel extends ArrayListSelectionModel
	{
		/**
		 *  Constructor.
		 */
		public function InspireTreeModel()
		{
			super();
		}

		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.collections.IArrayList
		 */
		override public function set dataProvider(value:Object):void
		{
			super.dataProvider = value;

			if(value is IArrayList)
				treeData = (_strand as IInspireTree).prepareTreeDataFromArray(IArrayList(value).source);
			else
				treeData = (_strand as IInspireTree).prepareTreeDataFromArray(value as Array);

			(_strand as IEventDispatcher).dispatchEvent("onPrepareTreeDataComplete");
		}

		private var _dataProviderTree:Array = new Array();
		/**
		 * Original DataProvider formatted as expected by Tree
		 */
		public function get dataProviderTree():Array
		{
			if(dataProvider is IArrayList)
				return (_strand as IInspireTree).prepareTreeDataFromArray(IArrayList(dataProvider).source);
			else
				return (_strand as IInspireTree).prepareTreeDataFromArray(dataProvider as Array);
		}
		
		private var _treeData:Array = new Array();
		/**
		 * DataProvider assigned to the Tree. It undergoes the same changes as the JS object.
		 */
		public function get treeData():Array { return _treeData; }
		public function set treeData(value:Array):void
		{ 
			if (value == _treeData) return;

			_treeData = value;
			//Se realiza un mapeo-binding entre el objeto js y el objeto as.
			configOption.data = _treeData;
			dispatchEvent(new Event("treeDataChanged"));
		}

		private var _childrenField:String = "children";
		/**
		 * Name of the attribute, in the dataProvider, where the child nodes are specified
		 */
		public function get childrenField():String { return _childrenField; }
		public function set childrenField(value:String):void
		{
			if (value != _childrenField) {
				_childrenField = value;
				dispatchEvent(new Event("childrenFieldChanged"));
			}
		}
		
		private var _boundField:String = "";
		/**
		 * When a non-hierarchical dataProvider is set, 'boundField', shall indicate the grouping attribute
		 */
		public function get boundField():String { return _boundField; }
		public function set boundField(value:String):void
		{
			if (value != _boundField) {
				_boundField = value;
				dispatchEvent(new Event("boundFieldChanged"));
			}
		}
		/**
		 * Function to obtain the description of the parent nodes.
		 * <p>The <code>labelFunctionParent</code> property takes a reference to a function. 
     	 * The function takes a single argument which is the item in the data provider and returns a String:</p>
    	 * 
		 *  <pre>myLabelFunction(item:Object):String</pre>
      	 * 
     	 *  @param item The data item. Null items return the empty string. 
		 */
		private var _labelFunctionParent:Function = null;
		public function get labelFunctionParent():Function
		{
			if(!_labelFunctionParent) 
				return itemToLabel;
			else
				return _labelFunctionParent; 
		}
		public function set labelFunctionParent(value:Function):void{ _labelFunctionParent = value; }
		/**
		 * Function to obtain the description of the parent nodes.
		 * <p>The <code>labelFunctionChild</code> property takes a reference to a function. 
     	 * The function takes a single argument which is the item in the data provider and returns a String:</p>
    	 * 
		 *  <pre>myLabelFunction(item:Object):String</pre>
      	 * 
     	 *  @param item The data item. Null items return the empty string. 
		 */
		private var _labelFunctionChild:Function = null;
		public function get labelFunctionChild():Function
		{
			if(!_labelFunctionChild) 
				return itemToLabel;
			else
				return _labelFunctionChild; 
		}
		public function set labelFunctionChild(value:Function):void{ _labelFunctionChild = value; }

		private var _checkboxMode:Boolean = false;
		public function get checkboxMode():Boolean { return _checkboxMode; }
		/** 
		 * Show checkbox on each node
		*/
		public function set checkboxMode(value:Boolean):void
		{
			if(_checkboxMode != value)
			{
				_checkboxMode = value;
				if( value )
					configOption.selection.mode = 'checkbox';
				else
					configOption.selection.mode = 'tree'; //default
                sendEvent(this,"checkboxModeChanged");
			}
		}

		private var _showCheckboxes:Boolean = false;
		public function get showCheckboxes():Boolean { return _showCheckboxes; }
		/** 
		 * Show checkbox on each node
		*/
		public function set showCheckboxes(value:Boolean):void
		{
			if(_showCheckboxes != value)
			{
				//configOption.showCheckboxes = value;
				checkboxMode = value;
				configOptionView.showCheckboxes = value;
				_showCheckboxes = value;
                sendEvent(this,"showCheckboxesChanged");
			}
		}
		/**
		 * Allow Drag and Drop
		 */
		private var _allowDragAndDrop:Boolean = false;
		public function get allowDragAndDrop():Boolean { return _allowDragAndDrop; }
		public function set allowDragAndDrop(value:Boolean):void
		{ 
			if(_allowDragAndDrop != value)
			{
				_allowDragAndDrop = value;
				configOptionView.dragAndDrop = _allowDragAndDrop;
                sendEvent(this,"allowDragAndDropChanged");
			}
		}
		/**
		 * Show paginated nodes.
		 * By default 10 nodes per page will be displayed, to change this, set the 'numNodesPage' property.
		 */
		private var _paginate:Boolean = false;
		public function get paginate():Boolean{ return _paginate; }
		public function set paginate(value:Boolean):void
		{ 
			if(_paginate != value)
			{			
				_paginate = value;
                sendEvent(this,"paginateChanged");
			}
		}
        /**
         *  How many nodes are rendered/loaded at once. 
         *  Used with deferrals. Defaults to nodes which fit in the container.
         */
        private var _numNodesPage:Number = -1;
        public function get numNodesPage():Number{ return _numNodesPage; }
        public function set numNodesPage(value:Number):void
		{ 
			if(_numNodesPage != value)
			{
				_numNodesPage = value;	
				if(isNaN(_numNodesPage))
					_numNodesPage = 10;
                sendEvent(this,"numNodesPageChanged");
			}
		}

		private var _configOption:OptionsTree;
		public function get configOption():OptionsTree
		{
			if(!_configOption) 
			{
				_configOption = new OptionsTree();
				_configOption.selection = {
					//allowLoadEvents:['selected'],
					autoDeselect: true, 
					autoSelectChildren: false,
					disableDirectDeselection: true,
					mode: 'tree',
					multiple: false,
					require: false,
					unlinkCheckSelect: true
				};
				//_configOption.showCheckboxes = false;
			}
			return _configOption; 
		}
		public function set configOption(value:OptionsTree):void		
		{
			if(_configOption != value)
			{
				_configOption = value; 	
                sendEvent(this,"ConfigOptionChanged");
			}
		}

		private var _configOptionView:ConfigDOM;
		public function get configOptionView():ConfigDOM
		{ 
			if(!_configOptionView)
			{
				_configOptionView = new ConfigDOM();
				_configOptionView.target = (_strand as HTMLElementWrapper).element;
				_configOptionView.nodeHeight = 35;
				_configOptionView.deferredRendering = false;
				_configOptionView.dragAndDrop = false;
			}
			return _configOptionView; 
		}
		public function set configOptionView(value:ConfigDOM):void
		{
			if(_configOptionView != value)
			{
				_configOptionView = value; 	
                sendEvent(this,"ConfigOptionViewChanged");
			}
		}

		private function itemToLabel(item:Object):String
		{
			if(!item || item==null)
				return '';

			if(labelField && item.hasOwnProperty(labelField))
				return item[labelField];
			
			return '';
		}
		
		
	}

}
