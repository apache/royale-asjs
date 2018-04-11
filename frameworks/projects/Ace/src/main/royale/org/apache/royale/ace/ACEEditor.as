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
package org.apache.royale.ace
{
	import org.apache.royale.core.UIBase;

	COMPILE::JS {
		import ace.Editor;
		import ace.Document;
	}

	COMPILE::SWF
	public class ACEEditor extends org.apache.royale.core.UIBase
	{
	}
	
	COMPILE::JS
	public class ACEEditor extends org.apache.royale.core.UIBase
	{
		/**
		 * <inject_html>
		 * <script src="https://cdn.rawgit.com/ajaxorg/ace-builds/master/src-min-noconflict/ace.js"></script>
		 * </inject_html>
		 */
		public function ACEEditor()
		{
			super();
		}
		private var editor:Editor; 			

		override public function addedToParent():void 
		{ 
			super.addedToParent(); 
			editor = ace["edit"](id); 
		} 

		private var _theme:String; 
		public function get theme():String 
		{ 
			return _theme; 
		} 

		public function set theme(value:String):void 
		{ 
			_theme = value; 
			editor.setTheme(value); 
		} 
	}
}
