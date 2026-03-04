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
package org.apache.royale.style.stylebeads.states
{
	import org.apache.royale.style.util.StyleManager;
	import org.apache.royale.style.stylebeads.IStyleBead;

	public class QueryBaseStyle extends StyleStateBase
	{
		public function QueryBaseStyle()
		{
			super();
		}
		/**
		 * Change in subclasses for other query types such as `container` or `supports`.
		 */
		protected var queryType:String = "media";
		/**
		 * TODO handle "not", etc. in here.
		 */
		public var queryPrefix:String = "";
		/**
		 * That part inside the parenthesis in a media query, for example, "(min-width: 500px)".
		 */
		protected var queryBody:String = "";
		protected var querySelector:String;
		
		override protected function preprocessStyle():void
		{
			if(StyleManager.hasQuery(querySelector))
			{
				return;
			}
			var parentId:String;
			var parent:IStyleBead = parentStyle;
			while(parent){
				if(parent is QueryBaseStyle)
				{
					parentId = (parent as QueryBaseStyle).querySelector;
					break;
				}
				parent = parent.parentStyle;
			}
			var rule:String = "@" + queryType + queryPrefix + " " + queryBody + " { }";
			StyleManager.addQuery(querySelector,rule, parentId);
		}

	}
}