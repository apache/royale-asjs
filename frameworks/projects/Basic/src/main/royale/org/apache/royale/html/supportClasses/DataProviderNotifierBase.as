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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IDataProviderNotifier;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.Bead;
	
	/**
	 *  Base class for all data provider notifiers.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataProviderNotifierBase extends Bead implements IDocument, IDataProviderNotifier
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataProviderNotifierBase()
		{
		}
		
		protected var dataProvider:ArrayList;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IBeadModel
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			if (_strand[destinationPropertyName] == null) {
				var model:IBeadModel = (_strand as UIBase).model as IBeadModel;
				(model as IEventDispatcher).addEventListener(changeEventName, destinationChangedHandler);
			}
			else {
				destinationChangedHandler(null);
			}
		}
		
		protected function destinationChangedHandler(event:Event):void
		{

		}
		
		protected var document:Object;
		
		/**
		 * @private
		 */
		public function setDocument(document:Object, id:String = null):void
		{
			this.document = document;
		}
		
		private var _destinationPropertyName:String;
		
		public function get destinationPropertyName():String
		{
			return _destinationPropertyName;
		}
		public function set destinationPropertyName(value:String):void
		{
			_destinationPropertyName = value;
		}
		
		private var _changeEventName:String;
		
		public function get changeEventName():String
		{
			return _changeEventName;
		}
		public function set changeEventName(value:String):void
		{
			_changeEventName = value;
		}
		
		private var _sourceID:String;
		
		/**
		 *  The ID of the object holding the ArrayList, usually a model.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get sourceID():String
		{
			return _sourceID;
		}
		public function set sourceID(value:String):void
		{
			_sourceID = value;
		}
		
		private var _propertyName:String;
		
		/**
		 *  The property in the sourceID that is the ArrayList.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get propertyName():String
		{
			return _propertyName;
		}
		
		public function set propertyName(value:String):void
		{
			_propertyName = value;
		}
	}
}
