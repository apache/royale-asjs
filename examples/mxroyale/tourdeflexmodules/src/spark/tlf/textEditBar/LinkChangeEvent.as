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
	
	public class LinkChangeEvent extends Event
	{
		private var _linkText:String;
		private var _targetText:String;
		private var _extendToOverlappingLinks:Boolean;
		
		public function LinkChangeEvent(type:String, linkText:String, targetText:String, extendToOverlappingLinks:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_linkText = linkText;
			_targetText = targetText;
			_extendToOverlappingLinks = extendToOverlappingLinks;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new LinkChangeEvent(type, _linkText, _targetText, _extendToOverlappingLinks, bubbles, cancelable);
		}
		
		public function get linkText():String
		{ return _linkText; }		
		
		public function get linkTarget():String
		{ return _targetText; }
		
		public function get extendToOverlappingLinks():Boolean
		{ return _extendToOverlappingLinks; }
	}
}
