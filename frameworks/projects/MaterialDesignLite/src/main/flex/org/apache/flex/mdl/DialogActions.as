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

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.util.addElementToWrapper;
    }

	/**
	 *  The DialogActions class is a container to use inside Dialog class
	 *  that holds buttons or other components to perform user actions
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class DialogActions extends Group
	{
		/**
		 *  constructor.
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function DialogActions()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        /**
         * @royaleignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-dialog__actions";
			return addElementToWrapper(this,'div');
        }

		protected var _fullWidth:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-dialog__actions--full-width" effect selector.
		 *  Modifies the actions to each take the full width of the container.
		 *  This makes each take their own line.
		 *  Optional on action container.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get fullWidth():Boolean
        {
            return _fullWidth;
        }
        public function set fullWidth(value:Boolean):void
        {
			_fullWidth = value;

			COMPILE::JS
            {
				positioner.classList.toggle("mdl-dialog__actions--full-width", _fullWidth);
				typeNames = positioner.className;
			}
        }
	}
}
