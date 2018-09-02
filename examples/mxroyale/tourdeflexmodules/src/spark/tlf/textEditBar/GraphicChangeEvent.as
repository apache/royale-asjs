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
package textEditBar
{
	import flash.events.Event;
	
	public class GraphicChangeEvent extends Event
	{
		private var _imageLink:String;
		private var _imageWidth:Object;
		private var _imageHeight:Object;
		private var _float:String;
		private var _replaceCurrent:Boolean;	
		
		public function GraphicChangeEvent(type:String, imageLink:String, imageWidth:Object, imageHeight:Object, float:String, replaceCurrent:Boolean = false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_imageLink = imageLink;
			_imageWidth = imageWidth;
			_imageHeight = imageHeight;
			_replaceCurrent = replaceCurrent;
			_float = float;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new GraphicChangeEvent(type, _imageLink, _imageWidth, _imageHeight, _float, _replaceCurrent, bubbles, cancelable);
		}
		
		public function get imageLink():String
		{ return _imageLink; }		
		
		public function get imageWidth():Object
		{ return _imageWidth; }
		
		public function get imageHeight():Object
		{ return _imageHeight; }
		
		public function get float():String
		{ return _float; }
		
		public function get replaceCurrent():Boolean
		{ return _replaceCurrent; }
	}
}
