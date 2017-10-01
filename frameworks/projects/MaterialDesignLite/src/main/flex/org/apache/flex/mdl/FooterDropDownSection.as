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
package org.apache.flex.mdl
{
	import org.apache.flex.html.Group;
	import org.apache.flex.mdl.supportClasses.IFooterSection;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.util.addElementToWrapper;
    }

	/**
	 *  The FooterDropDownSection class is a footer drop-down container (vertical)
	 *  content area.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class FooterDropDownSection extends Group implements IFooterSection
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function FooterDropDownSection()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-mega-footer__drop-down-section";
			return addElementToWrapper(this,'div');
        }

		/**
         *  Configuration depends on parent Footer.
		 *  Check to see if is mega or mini.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8

		COMPILE::JS
		override public function addedToParent():void
        {
			super.addedToParent();

			if(parent is FooterMiddleSection)
			{
				element.classList.remove(typeNames);
				if(!Footer(parent).mini)
				{
					typeNames = "mdl-mega-footer__drop-down-section";
				} else
				{
					typeNames = "mdl-mini-footer__drop-down-section";
				}
				element.classList.add(typeNames);
			}
			else
			{
				throw new Error("FooterDropDownSection can not be used if parent is not a MDL FooterMiddleSection component.");
			}
        }*/
	}
}
