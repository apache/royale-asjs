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
		public static const PERCENT:String = '%';
		public static const PIXELS:String = '#';

		private static const DEFAULT_WIDTH:uint = 80;


		public static function createFromColumn(size:Number, type:String, denominator:DataGridWidthDenominator):DataGridColumnWidth{
			var ret:DataGridColumnWidth = new DataGridColumnWidth();
			ret.value = size;
			ret.widthType = type;
			ret.denominator = denominator;
			return ret;
		}


		public var value:Number = 0;

		public var widthType:String;
		private var _default:Boolean;
		public var denominator:DataGridWidthDenominator;

		public var column:IDataGridColumn;

		public function isPixel():Boolean {
			return widthType == PIXELS;
		}

		public function isPercent():Boolean {
			return widthType == PERCENT;
		}

		public function isDefault():Boolean {
			return _default;
		}

		public function setDefault():void {
			_default = true;
		}


		public function setFrom(other:DataGridColumnWidth):void{
			if (other) {
				value = other.value;
				_default = other._default;
				widthType = other.widthType;
				denominator = other.denominator;
			}
		}


		COMPILE::JS
		/**
		 * @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 */
		public function configureWidth(content:ILayoutChild):void{
			//this is necessary to
			var targetElement:HTMLElement = (content as HTMLElementWrapper).element;
			var assigned:Number;
			if (_default) {
				content.width = NaN;
				if (value) {
					if (isPercent() && denominator && denominator.value > 0){
						assigned = uint(value);
						targetElement.style['flex'] = assigned + ' ' + assigned + ' 0px';
						targetElement.style['minWidth'] = '0';
						targetElement.style['maxWidth'] = '';
						content.width = NaN;
					} else  {
						targetElement.style['flex'] =  '0 0 '  + value +'px';
						targetElement.style['minWidth'] =  value +'px';
						targetElement.style['maxWidth'] =  value +'px';
						content.width = value;
					}
				} else {
					targetElement.style['flex'] =  '0 0 '  + DEFAULT_WIDTH +'px';
					targetElement.style['minWidth'] =  DEFAULT_WIDTH +'px';
					targetElement.style['maxWidth'] =  DEFAULT_WIDTH +'px';
					content.width = value;
				}
			} else {
				if (isPercent() /*&& denominator && denominator.value > 0*/){
					assigned = uint(value);
					targetElement.style['flex'] = assigned + ' ' + assigned + ' 0px';
					targetElement.style['minWidth'] = '0';
					targetElement.style['maxWidth'] = '';
					content.width = NaN;
				} else {
					targetElement.style['flex'] =  '0 0 '  + value +'px';
					targetElement.style['minWidth'] =  value +'px';
					targetElement.style['maxWidth'] =  value +'px';
					content.width = value;
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
			var orig:Number = value;
			if (isPixel()/* || isDefault()*/) {
				value = value + offset;
				configureWidth(content);
				value = orig;
			}
			targetElement.style['paddingRight'] = offset + 'px';
		}

	}

}
