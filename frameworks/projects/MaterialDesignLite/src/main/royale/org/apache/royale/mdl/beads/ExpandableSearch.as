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
package org.apache.royale.mdl.beads
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;

	import org.apache.royale.mdl.TextField;
	import org.apache.royale.mdl.materialIcons.MaterialIcon;
	
	/**
	 *  The ExpandableSearch bead class is a specialty bead that can be used to decorate a TextField MDL control.
     *  It makes the TextField to expand when user clicks the associated search icon.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class ExpandableSearch implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function ExpandableSearch()
		{
		}

		private var _strand:IStrand;
		private var _host:UIBase;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion HTMLDivElement
		 *  @royaleignorecoercion HTMLLabelElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.mdl.TextInput
		 *  @royaleignorecoercion org.apache.royale.mdl.TextField
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS
			{
				var host:UIBase = value as UIBase;
				if (host is TextField)
				{
					var searchId:String = '_searchId_' + Math.random();

					var label:HTMLLabelElement = document.createElement('label') as HTMLLabelElement;
					label.className = "mdl-button mdl-js-button mdl-button--icon";
					label.setAttribute('for', searchId);

					var i:Element = document.createElement("i");
					i.className = "material-icons";
					var textNode:Text = document.createTextNode("search");
					i.appendChild(textNode); 
					label.appendChild(i);

					host.positioner.appendChild(label);

					var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
					div.className = "mdl-textfield__expandable-holder";

					host.positioner.appendChild(div);

					div.appendChild((host as TextField).input);
					div.appendChild((host as TextField).label);

					(host as TextField).input.setAttribute('id', searchId);
				}
				else
				{
					throw new Error("Host component must be an MDL TextField.");
				}
			}
		}
	}
}
