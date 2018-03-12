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
    import org.apache.royale.html.RadioButton;

    COMPILE::SWF
    {
        import flash.display.DisplayObject;
    }

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.jewel.supportClasses.RadioButtonIcon;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    /**
	 *  The RadioButton class is a component that displays a selectable Button. RadioButtons
	 *  are typically used in groups, identified by the groupName property. RadioButton use
	 *  the following beads:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the groupName.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the RadioButton..
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    COMPILE::SWF
	public class RadioButton extends org.apache.royale.html.RadioButton
    {
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function RadioButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
		}
    }

    COMPILE::JS
    public class RadioButton extends org.apache.royale.html.RadioButton
    {
        /**
         * @private
         * 
         *  @royalesuppresspublicvarwarning
         */
        public static var radioCounter:int = 0;

        private var labelFor:HTMLLabelElement;
        private var textNode:Text;
        private var icon:RadioButtonIcon;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLInputElement
         * @royaleignorecoercion HTMLLabelElement
         * @royaleignorecoercion Text
         */
        override protected function createElement():WrappedHTMLElement
        {
            

            icon = new RadioButtonIcon()
            icon.id = '_radio_' + org.apache.royale.jewel.RadioButton.radioCounter++;

            textNode = document.createTextNode('') as Text;

            labelFor = addElementToWrapper(this,'label') as HTMLLabelElement;
            labelFor.appendChild(icon.element);
            labelFor.appendChild(textNode);
            
            (textNode as WrappedHTMLElement).royale_wrapper = this;
			(icon.element as WrappedHTMLElement).royale_wrapper = this;

            typeNames = 'RadioButton';

            return element;
        }
    }
}