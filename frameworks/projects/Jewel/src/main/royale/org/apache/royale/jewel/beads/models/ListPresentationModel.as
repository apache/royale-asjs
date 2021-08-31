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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.beads.layouts.IVariableRowHeight;
	import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;
	
	/**
	 *  The ListPresentationModel holds values used by list controls for presenting
	 *  their user interfaces.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ListPresentationModel extends EventDispatcher implements IListPresentationModel
	{
		public static const DEFAULT_ROW_HEIGHT:Number = 34;
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ListPresentationModel()
		{
			super();
		}
		
		private var _rowHeight:Number = NaN;
		/**
		 *  The height of each row.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        [Bindable("rowHeightChanged")]
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		public function set rowHeight(value:Number):void
		{
			if (value != _rowHeight) {
				_rowHeight = value;
				if(_strand)
					(_strand as IEventDispatcher).dispatchEvent(new Event("rowHeightChanged"));
			}
		}

		private var _align:String = "left";
		/**
		 *  How text align in the column
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		[Bindable("alignChanged")]
		public function get align():String
		{
			return _align;
		}
		public function set align(value:String):void
		{
			if (value != _align) {
				_align = value;
				if(_strand)
					(_strand as IEventDispatcher).dispatchEvent(new Event("alignChanged"));
			}
		}
		
		private var _variableRowHeight:Boolean = true;
		/**
		 *  variableRowHeight
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		[Bindable("variableRowHeightChanged")]
		public function get variableRowHeight():Boolean
		{
			return _variableRowHeight;
		}
		public function set variableRowHeight(value:Boolean):void
		{
			if (value != _variableRowHeight) {
				_variableRowHeight = value;
				if(_strand)
				{
					updateVariableRowHeight();
					(_strand as IEventDispatcher).dispatchEvent(new Event("variableRowHeightChanged"));
				}
			}
		}

		public function updateVariableRowHeight():void
		{
			if(layout)
				layout.variableRowHeight = _variableRowHeight;
		}
		
		protected var _strand:IStrand;
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
			(_strand as IEventDispatcher).addEventListener('initComplete', initCompleteHandler);
		}
		protected function initCompleteHandler(e:Event):void
		{
			(_strand as IEventDispatcher).removeEventListener('initComplete', initCompleteHandler);
			layout = _strand.getBeadByType(IBeadLayout) as IVariableRowHeight;
			updateVariableRowHeight();
		}

		private var layout:IVariableRowHeight;
	}
}
