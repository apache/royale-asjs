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
package org.apache.flex.mdl.supportClasses
{
	import org.apache.flex.core.ContainerBase;
    
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The CardInner class is a Container component capable of parenting other
	 *  four components (CardTitle, CardMedia, CardSupportingText and CardActions. 
     *  The Panel uses the following bead types:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model for the Card.
	 *  org.apache.flex.core.IBeadView: creates the parts of the Card.
	 *  
	 *  @see PanelWithControlBar
	 *  @see ControlBar
	 *  @see TitleBar
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class CardInner extends ContainerBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function CardInner()
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
            element = document.createElement('div') as WrappedHTMLElement;
            
            positioner = element;
            
            // absolute positioned children need a non-null
            // position value in the parent.  It might
            // get set to 'absolute' if the container is
            // also absolutely positioned
            element.flexjs_wrapper = this;

            return element;
        }

		private var _border:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-card--border" effect selector.
		 *  Adds a border to the card section that it's applied to
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get border():Boolean
        {
            return _border;
        }
        public function set border(value:Boolean):void
        {
			_border = value;

            className += (_border ? " mdl-card--border" : "");  
        }

		private var _expand:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-card--expand" effect selector.
		 *  Makes the container grows all available space. Is flex css dependant
		 *  It seems it will be deprecated in new MDL versions.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get expand():Boolean
        {
            return _expand;
        }
        public function set expand(value:Boolean):void
        {
			_expand = value;

            className += (_expand ? " mdl-card--expand" : "");  
        } 
	}
}
