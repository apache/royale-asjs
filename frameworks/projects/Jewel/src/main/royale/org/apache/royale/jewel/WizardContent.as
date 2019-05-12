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
package org.apache.royale.jewel
{
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.jewel.supportClasses.ISelectableContent;

	/**
	 *  The WizardContent class is a Container component capable of parenting
	 *  the other organized content that implements ISelectableContent interface
	 *  (i.e, a SectionContent)
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class WizardContent extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function WizardContent()
		{
			super();

            typeNames = "jewel wizardcontent";
		}

		private var _selectedContent:String;
		/**
		 *  shows a concrete content and hides the rest
		 * 
		 *  @param name, the name of the container to show
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get selectedContent():String
        {
			return _selectedContent;
		}
        public function set selectedContent(name:String):void
        {
			if(_selectedContent != name)
			{
				_selectedContent = name;

				selectContent();
			}
		}

		public function selectContent():void
		{	
			try
			{
				for (var i:int = 0; i < numElements; i++)
				{
					var content:ISelectableContent = getElementAt(i) as ISelectableContent;
					content.isSelected = content.name == _selectedContent ? true : false;
				}
			}
			catch (error:Error)
			{
				throw new Error ("One or more content in WizardContent is not implementing ISelectableContent interface.");	
			}
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this, 'div');
        }

		/**
		 *  The method called when added to a parent.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			
			selectContent();
		}
	}
}
