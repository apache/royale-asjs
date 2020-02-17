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
package org.apache.royale.crux.storage
{
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.storage.AMFStorage;
	import org.apache.royale.events.Event;
	
	public class AMFStorageBean extends EventDispatcher implements IAMFStorageBean
	{
		private var storage:AMFStorage;
		
		private var _path:String = "crux";
		private var _name:String = "cruxAMFStorage";
		
		/**
		 * @inheritDoc
		 */
		public function set localPath( path:String ):void
		{
			_path = path;
			invalidate();
		}
		
		/**
		 * @inheritDoc
		 */
		public function set name( name:String ):void
		{
			_name = name;
			invalidate();
		}
		
		/**
		 * @inheritDoc
		 */
		// public function get size():Number
		// {
		// 	if( storage != null )
		// 	{
		// 		return storage.size
		// 	}
		// 	return NaN;
		// }
		
		public function AMFStorageBean()
		{
			super();
			invalidate();
		}
		
		protected function invalidate():void
		{
			storage = AMFStorage.getLocal( _name, _path );
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			storage.clear();
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasValue( name:String ):Boolean
		{
			return storage.data[name] != undefined;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getValue( name:String, initValue:* = null ):*
		{
			var o:Object = storage.data;
			if( o[name] == null && initValue != null )
			{
				o[name] = initValue;
				storage.save();
			}
			
			return o[name];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValue( name:String, value:* ):void
		{
			var o:Object = storage.data;
			o[name] = value;
			storage.save();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getString( name:String, initValue:String = null ):String
		{
			var o:Object = storage.data;
			if( o[name] == null && initValue != null )
			{
				o[name] = initValue;
				storage.save();
			}
			
			return o[name];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setString( name:String, value:String ):void
		{
			var o:Object = storage.data;
			o[name] = value;
			storage.save();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getBoolean( name:String, initValue:Boolean = false ):Boolean
		{
			var o:Object = storage.data;
			if( o[name] == null )
			{
				o[name] = initValue;
				storage.save();
			}
			
			return o[name];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setBoolean( name:String, value:Boolean ):void
		{
			var o:Object = storage.data;
			o[name] = value;
			storage.save();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getNumber( name:String, initValue:Number = NaN ):Number
		{
			var o:Object = storage.data;
			if( o[name] == null )
			{
				o[name] = initValue;
				storage.save();
			}
			
			return o[name];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setNumber( name:String, value:Number ):void
		{
			var o:Object = storage.data;
			o[name] = value;
			storage.save();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getInt( name:String, initValue:int = -1 ):int
		{
			var o:Object = storage.data;
			if( o[name] == null )
			{
				o[name] = initValue;
				storage.save();
			}
			
			return o[name];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setInt( name:String, value:int ):void
		{
			var o:Object = storage.data;
			o[name] = value;
			storage.save();
			dispatchEvent( new Event( "intChange" ) );
		}
	}
}