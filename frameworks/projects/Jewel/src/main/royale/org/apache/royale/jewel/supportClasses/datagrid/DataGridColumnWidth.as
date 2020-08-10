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
package org.apache.royale.jewel.supportClasses.datagrid {

	COMPILE::JS{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.core.HTMLElementWrapper
	}

	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.ILayoutChild;

	/**
	 * internal use only
	 *
	 *  @langversion 3.0
	 *  @royalesuppressexport
	 */
	public class DataGridColumnWidth {
		public static const DEFAULT:String = null;
		public static const EXPLICIT_PERCENT:String = '%';
		public static const EXPLICIT_PIXELS:String = '#';


		public static function createFromColumn(size:Number, type:String, denominator:DataGridWidthDenominator):DataGridColumnWidth{
			var ret:DataGridColumnWidth = new DataGridColumnWidth();
			ret._value = size;
			ret.widthType = type;
			ret.denominator = denominator;
			return ret;
		}


		//public var value:Number = 0;
		private var _value:Number = 0;

		public var widthType:String;
		public var denominator:DataGridWidthDenominator;

		public var column:IDataGridColumn;

		public function isPixel():Boolean {
			return widthType == EXPLICIT_PIXELS;
		}

		public function isPercent():Boolean {
			return widthType == EXPLICIT_PERCENT;
		}

		public function isDefault():Boolean {
			return widthType == DEFAULT;
		}

		public function getValue():Number {
			if (isPercent() && denominator && denominator.value > 0) {
				return _value * 0.01 * denominator.value;
			}
			return _value;
		}

		public function setFrom(other:DataGridColumnWidth):void{
			if (other) {
				_value = other._value;
				widthType = other.widthType;
				denominator = other.denominator;
			}
		}


		COMPILE::JS
		/**
		 * @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper;
		 * @royaleignorecoercion HTMLElement;
		 */
		public function configureWidth(content:ILayoutChild/*, header:Boolean*/):void{
			//this is necessary to
			var targetElement:HTMLElement = (content as HTMLElementWrapper).element;

			if (isPercent() && denominator && denominator.value > 0){
				var assigned:Number = uint(_value);//value/100 * denominator.value;
				targetElement.style['flex'] = assigned + ' ' + assigned + ' 0px';
				targetElement.style['minWidth'] = '';
				targetElement.style['maxWidth'] = '';
				content.width = NaN;
			} else if (isPixel()) {
				targetElement.style['flex'] =  '0 0 '  + _value +'px';
				targetElement.style['minWidth'] =  _value +'px';
				targetElement.style['maxWidth'] =  _value +'px';
				content.width = _value;
			} else if (isDefault()) {
				content.width = NaN;
				if (_value) {
					targetElement.style['flex'] = '0 1 ' + _value +'px';
					targetElement.style['minWidth'] = '';
					targetElement.style['maxWidth'] = '';
				} else {
					targetElement.style['flex'] = '';
					targetElement.style['minWidth'] = '';
					targetElement.style['maxWidth'] = '';
				}

			}
		}

		COMPILE::SWF
		public function configureWidth(content:ILayoutChild):void{
			//only for option-with-swf compilation of Jewel, for now.
		}


		COMPILE::JS
		public function applyRightOffset(content:ILayoutChild, offset:Number):void{
			//this is to support the rightmost button width variation when the list area has a vertical scrollbar
			var targetElement:HTMLElement = (content as HTMLElementWrapper).element;
			if (!offset) {
				configureWidth(content);
				targetElement.style['paddingRight'] = '';
				return;
			}
			var orig:Number = _value;
			if (isPixel() || isDefault()) {
				_value = _value + offset;
				configureWidth(content);
				_value = orig;
			}
			targetElement.style['paddingRight'] = offset + 'px'

			/*} else {
				console.log('todo...investigate rightmost');
			}*/

		}


		public function get value():Number {
			return _value;
		}

		public function set value(value:Number):void {
			_value = value;
		}
	}

}
