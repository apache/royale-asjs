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
package org.apache.flex.html.staticControls.beads.models
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITitleBarModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	
	public class TitleBarModel extends EventDispatcher implements IBead, ITitleBarModel
	{
		public function TitleBarModel()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _title:String;
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			if( value != _title ) {
				_title = value;
				dispatchEvent( new Event('titleChange') );
			}
		}
		
		private var _htmlTitle:String;
		public function get htmlTitle():String
		{
			return _htmlTitle;
		}
		
		public function set htmlTitle(value:String):void
		{
			if( value != _htmlTitle ) {
				_htmlTitle = value;
				dispatchEvent( new Event('htmlTitleChange') );
			}
		}
		
		private var _showCloseButton:Boolean = false;
		public function get showCloseButton():Boolean
		{
			return _showCloseButton;
		}
		
		public function set showCloseButton(value:Boolean):void
		{
			if( value != _showCloseButton ) {
				_showCloseButton = value;
				dispatchEvent( new Event('showCloseButtonChange') );
			}
		}
	}
}