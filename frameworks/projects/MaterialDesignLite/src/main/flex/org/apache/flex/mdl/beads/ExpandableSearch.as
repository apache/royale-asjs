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
package org.apache.flex.mdl.beads
{	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;

    import org.apache.flex.mdl.TextField;
	import org.apache.flex.mdl.materialIcons.MaterialIconType;
	import org.apache.flex.mdl.materialIcons.MaterialIcon;
	
	/**
	 *  The ExpandableSearch bead class is a specialty bead that can be used to decorate a TextField MDL control.
     *  It makes the TextField to expand when user clicks the associated search icon.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class ExpandableSearch implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function ExpandableSearch()
		{
		}
		
        /**
         * Provides unique name
         */
        private static var tfCounter:int = 0;

		private var _strand:IStrand;		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 *  @flexjsignorecoercion org.apache.flex.mdl.TextInput;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS
			{
				var host:UIBase = value as UIBase;
				
				if (host is TextField)
				{
                    var searchId:String = '_searchId_' + ExpandableSearch.tfCounter++;

					host.positioner.classList.add("mdl-textfield--expandable");

                    var label:HTMLLabelElement = document.createElement('label') as HTMLLabelElement;
                    label.className = "mdl-button mdl-js-button mdl-button--icon";
                    label.setAttribute('for', searchId);
                    
                    var searchIcon:MaterialIcon = new MaterialIcon();
					searchIcon.text = MaterialIconType.SEARCH;
					label.appendChild(searchIcon.element);
                    
                    host.positioner.appendChild(label);

                    var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
                    div.className = "mdl-textfield__expandable-holder";

                    host.positioner.appendChild(div);

                    div.appendChild(TextField(host).input);
                    div.appendChild(TextField(host).label);

                    TextField(host).input.setAttribute('id', searchId);
				}
				else
				{
					throw new Error("Host component must be an MDL TextField.");
				}
			}
		}
	}
}
