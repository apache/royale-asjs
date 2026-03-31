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
package org.apache.royale.style
{
	import org.apache.royale.style.stylebeads.states.HasState;
	
	COMPILE::JS{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.events.Event;
	import org.apache.royale.core.IHasLabel;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.style.elements.Span;
	import org.apache.royale.style.support.TextNode;
	import org.apache.royale.style.skins.ICheckBoxSkin;
	import org.apache.royale.style.elements.I;
	import org.apache.royale.style.stylebeads.IStyleBead;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.stylebeads.utils.ScreenReader;
	/**
	 *  Dispatched when the user checks or un-checks the CheckBox.
	 *
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	public class CheckBox extends StyleUIBase implements IHasLabel
	{

		public function CheckBox()
		{
			super();
			//we want group level 'pseudo' styling
			//we could use the following for a generic name, or override getWrapperStyle with something specific
			//useWrapperStyle = true;
		}
		COMPILE::JS
		private var input:HTMLInputElement;
		
		COMPILE::JS
		private function elementClicked():void{
			// _indeterminate = input.indeterminate = false;// input.indeterminate should be resolved automatically.
			_indeterminate = false;
			_checked = input.checked;
			if(_stylesLoaded && !checkIcon)
				applyCheckSkin();
		}
		
		override protected function getTag():String
		{
			return "label";
		}
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement{
			var elem:WrappedHTMLElement = super.createElement();
			input = newElement("input") as HTMLInputElement;
			input.type = "checkbox";
			var srOnly:String = new ScreenReader().getSelector();
			input.className = ("peer " + srOnly);
			input.onclick = elementClicked;
			elem.appendChild(input);
			box = new Div();
			addElement(box);
			return elem;
		}
		private var box:Div;

		private var _label:String = "";
		public function get label():String
		{
			return _label;
		}

		private var span:Span;
		public function set label(value:String):void
		{
			COMPILE::JS
			{
				if(_label != value){
					_label = value;
					if(!span){
						span = new Span();
						addElement(span);
						if(_stylesLoaded)
						{
							applyLabelSkin();
						}
					}
					span.text = value;
					input.setAttribute("aria-label", value);
				}
			}
		}
		override protected function applySkin():void
		{
			var checkSkin:ICheckBoxSkin = skin as ICheckBoxSkin;
			assert(checkSkin, "CheckBox requires a skin that implements ICheckBoxSkin");
			var styles:Array = checkSkin.boxStyles || [];
			box.setStyles(styles);
			applyCheckSkin();
			applyIndeterminateSkin();
			applyLabelSkin();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.skins.ICheckBoxSkin
		 */
		private function applyLabelSkin():void
		{
			if(!span) return;
			var checkSkin:ICheckBoxSkin = skin as ICheckBoxSkin;
			assert(checkSkin && checkSkin.labelStyles, "CheckBox requires a skin that implements ICheckBoxSkin");
			span.setStyles(checkSkin.labelStyles);
		}
		private var _truncate:Boolean;

		public function get truncate():Boolean
		{
			return _truncate;
		}
		public function set truncate(value:Boolean):void
		{
			_truncate = value;
			COMPILE::JS
			{
				// Ideally, styles should be applied using utility classes, but we're toggling these for now.
				if(_stylesLoaded && span){
					if(value){
						span.setStyle("text-overflow","ellipsis");
						span.setStyle("overflow","hidden");
						span.setStyle("white-space","nowrap");
					} else {
						span.setStyle("text-overflow","");
						span.setStyle("overflow","");
						span.setStyle("white-space","");
					}
				}
			}
		}
		private var _invalid:Boolean;
		/**
		 * Indicates whether the current state of the CheckBox is invalid.
		 * This can be used to apply error styles to the component.
		 * 
		 * The Checkbox skin should specify invalid styles if desired.
		 * 
		 * @languageversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get invalid():Boolean
		{
			return _invalid;
		}

		public function set invalid(value:Boolean):void
		{
			COMPILE::JS
			{
				if(value != !!_invalid){
					value ? input.setAttribute("aria-invalid","") : input.removeAttribute("aria-invalid");
					toggleAttribute("data-invalid", value);
				}
			}
			_invalid = value;
		}
		private var indeterminateIcon:IStyleUIBase;
		private var _indeterminate:Boolean;
		/**
		 * Indicates whether the CheckBox is in an indeterminate state. In this state, the checkbox is neither checked nor unchecked.
		 * This is typically used to indicate a mixed state, such as when some child items are checked and others are not.
		 * When set to true, the CheckBox will display the indeterminateIcon if provided by the skin.
		 * 
		 * The Checkbox skin should specify an indeterminateIcon if it wants to support this state.
		 * If no indeterminateIcon is provided, the CheckBox will simply not display a check icon when in the indeterminate state.
		 * 
		 * @languageversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get indeterminate():Boolean
		{
			return _indeterminate;
		}

		public function set indeterminate(value:Boolean):void
		{
			COMPILE::JS
			{
				if(value != !!_indeterminate){
					_indeterminate = value;
					input.indeterminate = value;
					if(value)
						_checked = input.checked = false;
					
					if(_stylesLoaded && !indeterminateIcon)
						applyIndeterminateSkin();
				}
			}
		}
		private function applyIndeterminateSkin():void
		{
			if(!indeterminate && !indeterminateIcon) return;
			COMPILE::JS
			{
				var checkSkin:ICheckBoxSkin = skin as ICheckBoxSkin;
				assert(checkSkin, "CheckBox needs a skin");
				var icon:IStyleUIBase = checkSkin.indeterminateIcon;
				if(icon && icon != indeterminateIcon){
					if(indeterminateIcon && indeterminateIcon.parent){
						assert(indeterminateIcon.parent == this, "Indeterminate icon should be a child of this");
						removeElement(indeterminateIcon);
					}
					indeterminateIcon = icon;
					if(span)
					{
						assert(span.parent == this, "span should be a child of this");
						element.insertBefore(indeterminateIcon.element, span.element);
					}
					else
						addElement(indeterminateIcon);

				}
			}
		}

		private var _disabled:Boolean;

		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			COMPILE::JS
			{
				if(value != !!_disabled){
					input.disabled = value;
					toggleAttribute("data-disabled", value);
				}
			}
			_disabled = value;
		}
		private var checkIcon:IStyleUIBase;
		private var _checked:Boolean;
		[Bindable]
		public function get checked():Boolean
		{
			return _checked;
		}

		public function set checked(value:Boolean):void
		{
			COMPILE::JS
			{
				if(value != !!_checked){
					_checked = value;
					_indeterminate = input.indeterminate = false;
					if(_stylesLoaded && !checkIcon)
						applyCheckSkin();
					input.checked = value;
				}
			}
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.skins.ICheckBoxSkin
		 */
		private function applyCheckSkin():void
		{
			if(!checked && !checkIcon) return;
			COMPILE::JS
			{
				var checkSkin:ICheckBoxSkin = skin as ICheckBoxSkin;
				assert(checkSkin, "CheckBox needs a skin");
				var icon:IStyleUIBase = checkSkin.checkIcon;
				assert(icon || checkIcon, "CheckBox skin must provide a checkIcon for checked state");
				if(icon && icon != checkIcon){
					if(checkIcon && checkIcon.parent){
						assert(checkIcon.parent == this, "Check icon should be a child of this");
						removeElement(checkIcon);
					}
					checkIcon = icon;
					if(span)
					{
						assert(span.parent == this, "span should be a child of this");
						element.insertBefore(checkIcon.element, span.element);
					}
					else
						addElement(checkIcon);
				}
			}
		}
		private var _quiet:Boolean;
		/**
		 * When true, the CheckBox will have a quieter appearance with less visual emphasis. This can be used when the CheckBox is part of a group of related options to reduce visual noise.
		 * The Checkbox skin should specify styles for the quiet state if it should look different than the regular state. This might include things like lighter colors, smaller size, or less prominent check icons.
		 * 
		 * @languageversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get quiet():Boolean
		{
			return _quiet;
		}

		public function set quiet(value:Boolean):void
		{
			_quiet = value;
		}
		
		/**
		 *  @copy org.apache.royale.style.StyleUIBase#getWrapperStyle()
		 */
		override public function getWrapperStyle():String{
			return 'checkbox';
		}
	}
}

/**
 
    <label
      data-size="sm"
      class="checkbox inline-grid cursor-pointer grid-cols-[var(--box)_auto] items-center gap-x-[var(--gap)] select-none [&:has(input:disabled)]:cursor-auto"
    >
        <input
          id="newsletter"
          type="checkbox"
          class="peer sr-only"
          aria-label="Click this awesome button"
        />

        <div class="checkbox-box col-start-1 row-start-1 h-[var(--box)] w-[var(--box)] rounded border-2 border-slate-500 transition peer-focus-visible:outline peer-focus-visible:outline-2 peer-focus-visible:outline-orange-500 peer-focus-visible:outline-offset-2 peer-checked:border-orange-500 peer-checked:bg-orange-500 peer-indeterminate:border-orange-500 peer-indeterminate:bg-orange-500 peer-disabled:border-slate-300 peer-disabled:bg-slate-100 dark:border-slate-400 dark:peer-disabled:border-slate-600 dark:peer-disabled:bg-slate-800"></div>
        <div class="check-icon col-start-1 row-start-1 h-[var(--tick-h)] w-[var(--tick-w)] place-self-center -translate-y-[8%] rotate-45 border-b-[3px] border-r-[3px] border-white opacity-0 transition peer-checked:opacity-100 peer-indeterminate:opacity-0 peer-disabled:border-slate-300 dark:peer-disabled:border-slate-500"></div>
        <div class="col-start-1 row-start-1 h-[14%] w-[var(--minus-w)] place-self-center rounded bg-white opacity-0 transition peer-indeterminate:opacity-100 peer-disabled:bg-slate-300 dark:peer-disabled:bg-slate-500"></div>
        <span class="col-start-2 row-start-1 text-[length:var(--size)] font-semibold text-slate-800 dark:text-slate-100 peer-disabled:text-slate-400 dark:peer-disabled:text-slate-500">Click this awesome button</span>
    </label>

 */