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
package org.apache.royale.jewel.itemRenderers
{
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
	}
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.ILabelFunction;
    import org.apache.royale.core.StyledMXMLItemRenderer;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.util.getLabelFromData;
    import org.apache.royale.jewel.beads.controls.TextAlign;
    import org.apache.royale.jewel.beads.itemRenderers.IAlignItemRenderer;
    import org.apache.royale.jewel.beads.itemRenderers.ITextItemRenderer;
    import org.apache.royale.jewel.beads.layouts.StyledLayoutBase;
    import org.apache.royale.utils.loadBeadFromValuesManager;
	
	/**
	 *  The ListItemRenderer defines the basic Item Renderer for a Jewel List Component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ListItemRenderer extends StyledMXMLItemRenderer implements ITextItemRenderer, IAlignItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ListItemRenderer()
		{
			super();

			typeNames = "jewel item";
		}

		private var _text:String = "";

		[Bindable(event="textChange")]
        /**
         *  The text of the renderer
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get text():String
		{
            return _text;
		}

		public function set text(value:String):void
		{
            if(value != _text) {
				_text = value;
				COMPILE::JS
				{
				if(MXMLDescriptor == null)
				{
					element.innerHTML = _text;
				}
				}
				dispatchEvent(new Event('textChange'));
			}
		}

        protected var textAlign:TextAlign;

		/**
		 *  How text align in the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get align():String
		{
			return textAlign.align;
		}

		public function set align(value:String):void
		{
			if(!textAlign)
			{
				textAlign = new TextAlign();
				addBead(textAlign);
			}
			textAlign.align = value;
		}

		protected var _labelFunctionBead:ILabelFunction;
		/**
		 * Get the ILabelFunction bead if provided
		 */
		public function get labelFunctionBead():ILabelFunction {
			if(!_labelFunctionBead) {
				_labelFunctionBead = itemRendererOwnerView.host.getBeadByType(ILabelFunction) as ILabelFunction;
			}
			return _labelFunctionBead;
		}

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 *  If the user provided a LabelFunction bead and set a custom labelFunction, then use it instead
		 * 
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        override public function set data(value:Object):void
        {
			if(labelFunctionBead && labelFunctionBead.labelFunction)
				text = labelFunctionBead.labelFunction(value);
			else
            	text = getLabelFromData(this, value);
			
			if (value != data)
            {
                _data = value;
                dispatchEvent(new Event("dataChange"));
            }
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this, 'li');
			// tabIndex = -1;
            return element;
        }


		/**
		 *  The method called when added to a parent.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override protected function loadBeads():void
		{
			super.loadBeads();
			addLayoutBead();
		}

		protected var layout:StyledLayoutBase;
		/**
		 *  load the bead layout for this renderer
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function addLayoutBead():void {
			layout = loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this) as StyledLayoutBase;
		}
	}
}
