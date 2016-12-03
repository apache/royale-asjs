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
package itemRenderers
{
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.beads.controllers.ItemRendererMouseController;        
    }
    import org.apache.flex.events.Event;
    import org.apache.flex.html.beads.ITextItemRenderer;

    import org.apache.flex.html.supportClasses.DataItemRenderer;
    
	/**
	 *  The StringItemRenderer class displays data in string form using the data's toString()
	 *  function.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ListItemRenderer extends DataItemRenderer implements ITextItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ListItemRenderer()
		{
			super();
			
            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
        private var _text:String = "";
		/**
		 *  The text currently displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get text():String
		{
            return _text;

            COMPILE::JS
            {
                return this.element.innerHTML;
            }
		}
		
		public function set text(value:String):void
		{
            _text = value;                    
            
            COMPILE::JS
            {
                this.element.innerHTML = value;
            }
		}
		
		/**
		 *  Sets the data value and uses the String version of the data for display.
		 * 
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
            var text:String;
			if (labelField) {
                text = String(value[labelField]);
            } else if (dataField) {
                text = String(value[dataField]);
            } else {
                text = String(value);
            }
            
            trace("the text: " + text);
            this.text = text;
		}
		
        COMPILE::JS
        private var controller:ItemRendererMouseController;
            
        COMPILE::JS
        private var backgroundView:WrappedHTMLElement;
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-list__item";

            element = document.createElement('li') as WrappedHTMLElement;
            
            positioner = element;
            element.flexjs_wrapper = this;
            
            // itemRenderers should provide something for the background to handle
            // the selection and highlight
            backgroundView = element;
            
            return element;
        }

	}
}
