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
	import org.apache.flex.html.TextButton;
	import org.apache.flex.mdl.supportClasses.IFooterSection;
	import org.apache.flex.core.UIBase;
    
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The FooterSocialButton class is a Container component capable of parenting other
	 *  components 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class FooterSocialButton extends TextButton
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function FooterSocialButton()
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
			typeNames = "mdl-mega-footer__social-btn";

            element = document.createElement('button') as WrappedHTMLElement;
            
            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }

		/**
         *  Configuration depends on parent Footer.
		 *  Check to see if is mega or mini.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
        */ 
		COMPILE::JS
		override public function addedToParent():void
        {
			super.addedToParent();

			if(parent is IFooterSection)
			{
				var parentSection:IFooterSection = parent as IFooterSection;
				if(UIBase(parentSection).parent is Footer)
				{
					element.classList.remove(typeNames);
					if(!Footer(UIBase(parentSection).parent).mini)
					{
						typeNames = "mdl-mega-footer__social-btn";
					} else
					{
						typeNames = "mdl-mini-footer__social-btn";
					}
					element.classList.add(typeNames);
				}
			}
			else
			{
				throw new Error("FooterSocialButton can not be used if parent is not a MDL Footer component.");
			}			
        }
	}
}
