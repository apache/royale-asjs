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
	import org.apache.royale.jewel.supportClasses.IActivable;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

	/**
	 *  The ApplicationMainContent class is a Container component capable of parenting
	 *  the other organized content that implements IActivable interface
	 *  (i.e, a SectionContent)
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class ApplicationMainContent extends Container
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function ApplicationMainContent()
		{
			super();

            typeNames = "jewel main";
		}
		
		private var _hasTopAppBar:Boolean;

        /**
         *  a boolean flag to indicate if the container needs to make some room
		 *  for a TopAppBar so content doesn't be hide
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get hasTopAppBar():Boolean
		{
            return _hasTopAppBar;
		}

		public function set hasTopAppBar(value:Boolean):void
		{
            if (_hasTopAppBar != value)
            {
                _hasTopAppBar = value;

                COMPILE::JS
                {
                    toggleClass("has-topappbar", _hasTopAppBar);
                }
            }
		}

		/**
		 *  shows a concrete content and hides the rest
		 * 
		 *  @param id, the id of the container to show
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
        public function showContent(id:String):void
        {
			try
			{
				for (var i:int = 0; i < numElements; i++)
				{
					var content:IActivable = getElementAt(i) as IActivable;
					
					if(content.id == id)
					{
						content.isActive = true;
					}
					else
					{
						content.isActive = false;
					}
				}
			}
			catch (error:Error)
			{
				throw new Error ("One or more content in ApplicationMainContent is not implementing IActivable interface.");	
			}
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'main');
        }
	}
}
