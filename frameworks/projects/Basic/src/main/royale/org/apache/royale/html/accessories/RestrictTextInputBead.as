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
package org.apache.royale.html.accessories
{
	COMPILE::JS
	{
		import goog.events.BrowserEvent;
	}
	COMPILE::SWF
	{
		import flash.events.TextEvent;
		import org.apache.royale.html.beads.ITextFieldView;			
		import org.apache.royale.core.CSSTextField;			
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IRenderedObject;
	
	/**
	 *  The RestrictTextInputBead class is a specialty bead that can be used with
	 *  any TextInput control. The bead prevents certain characters from being 
     *  entered into the text input
	 *  area.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class RestrictTextInputBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function RestrictTextInputBead()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::SWF
			{
				IEventDispatcher(value).addEventListener("viewChanged",viewChangeHandler);					
			}
			COMPILE::JS
			{
				var host:IRenderedObject = _strand as IRenderedObject;
				host.element.addEventListener("keypress", validateKeypress, false);
				host.element.addEventListener("input", validateInput, false);
			}
		}
		
		private var _restrict:String;
		COMPILE::JS
		private var _restrictProcessed:Array;

		COMPILE::JS
		private function regexTest(val:String):String{
			var result:String = val;
			var passes:uint;
			var passed:Boolean = true;
			var lastPass:uint;
			if (_restrictProcessed) {
				for each(var regexp:RegExp in _restrictProcessed) {
					passed = false;
					if (!regexp.test(result)) {
						var check:String = val.toUpperCase();
						if (check != val) {
							if (regexp.test(check)) {
								result = check;
								passed = true;
							}
						} else {
							check = val.toLowerCase();
							if (check != val && regexp.test(check))  {
								result = check;
								passed = true;
							}
						}
					} else {
						passed = true;
					}

					if (passed) {
						passes++;
						lastPass = _restrictProcessed.indexOf(regexp);
					}
					if (!result) trace('failed:'+regexp.source);
				}
			}

			if (!passes || passes <  _restrictProcessed.length/2) {
				result = '';
			}

			return result;
		}
		
		/**
		 *  The characters allowed or denied.  Uses flash.text.TextField.restrict syntax
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get restrict():String
		{
			return _restrict;
		}
		public function set restrict(value:String):void
		{
			if (_restrict != value) {
				_restrict = value;

				COMPILE::JS{
					if (value) {
						_restrictProcessed = [];
						var processedString:String = '';
						var l:uint = value.length;
						var escaped:Boolean;
						var inverted:Boolean = l && value.charAt(0) == '^';

						for (var i:uint=0;i<l;i++) {
							var char:String = value.charAt(i);
							if (char == '\\') {
								escaped = !escaped
							} else {
								if (char == ']' && !escaped) {
									//escape it
									processedString += '\\';
								}
								if(i > 0 && char == '^' && !escaped) {
									_restrictProcessed.push(new RegExp("[" + processedString + "]"));
									processedString = '';
									inverted = !inverted;
									if (!inverted) continue;
								}
								escaped = false;
							}
							processedString += char;
						}
						if (processedString) {
							_restrictProcessed.push(new RegExp("[" + processedString + "]"));
						}

					} else _restrictProcessed = null;
				}
			}
		}
		

        /**
		 * @private
		 */
		COMPILE::SWF
		private function viewChangeHandler(event:Event):void
		{			
			// get the ITextFieldView bead, which is required for this bead to work
			var textView:ITextFieldView = _strand.getBeadByType(ITextFieldView) as ITextFieldView;
			if (textView) {
				var textField:CSSTextField = textView.textField;
				textField.restrict = restrict;
			}
			else {
				// throw new Error("RestrictTextInputBead requires strand to have an ITextFieldView bead");
			}
		}
		COMPILE::JS
		private var beforeChange:String;

		COMPILE::JS
		private var beforeSelectBegin:int=-1;

		COMPILE::JS
		private var beforeSelectEnd:int=-1;

		/**
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		COMPILE::JS
		private function validateKeypress(event:BrowserEvent):void
		{
			var code:int = event.charCode;

			var key:String = String.fromCharCode(code);
			var prevent:Boolean = _restrict == ''; //empty string is 'restrict all', null is 'allow all'
			if (!prevent && _restrictProcessed)
			{
				//var regex:RegExp = _restrictProcessed;//new RegExp("[" + restrict + "]");
				if (!regexTest(key)) {
					/*var altKey:String = caseVariationCheck(/!*regex,*!/key);
					if (!altKey) {*/
						prevent = true;
					//}
				}
			}

			if (prevent) {
				event["returnValue"] = false;
				if (event.preventDefault) event.preventDefault();
			} else {
				beforeChange = ((_strand as IRenderedObject).element as HTMLInputElement).value;
				beforeSelectBegin = ((_strand as IRenderedObject).element as HTMLInputElement).selectionStart
				beforeSelectEnd = ((_strand as IRenderedObject).element as HTMLInputElement).selectionEnd
			}
		}


		/*COMPILE::JS
		private function caseVariationCheck(/!*regex:RegExp, *!/inputChar:String):String{
			var check:String = inputChar.toUpperCase();
			if (check != inputChar) {
				if (regexTest(check)) return check;
			} else {
				check = inputChar.toLowerCase();
				if (check != inputChar && regexTest(check)) return check;
			}
			return '';
		}*/
        
		/**
		 *  @royaleignorecoercion HTMLInputElement 
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		COMPILE::JS
		private function validateInput(event:BrowserEvent):void
		{
			//note this does not discriminate between text that may have been entered under more lenient restrictions previously, or which
			//was set programatically. 'data' below should only apply to the current 'batch' of text being inserted through user interaction.
			//@todo figure out the above.
			var host:IRenderedObject = _strand as IRenderedObject;
			var latest:String = (host.element as HTMLInputElement).value;
			var data:String;
			var out:String = '';
			var i:int;
			var n:int;
			var post:String = '';
			var sel:uint = (host.element as HTMLInputElement).selectionEnd;

			if (beforeChange && latest) {
				n=beforeChange.length;
				var n2:int = latest.length;
				var diff:int = n2 -n;
				for (i=0;i<n;i++) {
					 if (beforeChange.charCodeAt(i) !=latest.charCodeAt(i)) {
						 break;
					 }
				}
				out = beforeChange.substr(0,i);
				if (diff > 0) {
					data = latest.substr(i, diff);
					post = latest.substr(i+diff);
					//sel = i+diff;
				} else {
					//@todo needs more work here for when a range is overtyped with less chars
					/*for (var ii:uint=0;ii<n-i;ii--) {
						if (beforeChange.charCodeAt(ii) !=latest.charCodeAt(ii)) {
							break;
						}
					}*/
					data = latest.substr(i);
				}

			} else data = latest;
			beforeChange = null;
			//var data:String = (host.element as HTMLInputElement).value;
			var blocked:Boolean = _restrict == '';

			if (!blocked && _restrictProcessed && data != null && data.length > 0)
			{
				//var regex:RegExp = _restrictProcessed;//new RegExp("[" + restrict + "]");

				n = data.length;

				for (i = 0; i < n; i++)
				{
					var key:String = data.charAt(i);
					var result:String = regexTest(key);
					if (result!=key) {
						blocked = true;
					}
					out += result;
					/*if (regexTest(key)) {
						out += key;
					}
					else {
						key = caseVariationCheck(/!*regex,*!/key);
						if (key) {
							out += key;
						}
						blocked = true;
					}*/
				}
			}
			if (blocked)
			{
				event["returnValue"] = false;
				if (event.preventDefault) event.preventDefault();
				(host.element as HTMLInputElement).value = out + post;
				if (sel) {
					(host.element as HTMLInputElement).setSelectionRange(sel,sel);
				}
			}
		}
	}
}
