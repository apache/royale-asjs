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
	import org.apache.royale.binding.ContainerDataBinding;
	import org.apache.royale.binding.DataBindingBase;
	
	
	public class FlexContainer extends Group
	{
		public function FlexContainer()
		{
			super();
			setStyle("display","flex");
		}
		
		override public function addedToParent():void{
			if (!_bindingsInited) initBindings()
			super.addedToParent();
		}
		
		private var _bindingsInited:Boolean
		protected function initBindings():void{
			_bindingsInited = true;
			if ('_bindings' in this && !getBeadByType(DataBindingBase)) {
				addBead(new ContainerDataBinding());
			}
		}
		
		public function get alignContent():String{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style.alignContent;}
		}
		/**
		 * Takes any of the values accepted by flexbox align-content
		 */
		public function set alignContent(value:String):void{
			setStyle("alignContent",value);
		}
		public function get alignItems():String{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style.alignItems;}
		}
		/**
		 * Takes any of the values accepted by flexbox align-items
		 */
		public function set alignItems(value:String):void{
			setStyle("alignItems",value);
		}
		
		public function get justifyContent():String{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style.justifyContent;}
		}
		/**
		 * Takes any of the values accepted by flexbox justify-content
		 */
		public function set justifyContent(value:String):void{
			setStyle("justifyContent",value);
		}
		
		private var _vertical:Boolean = false;
		
		public function get vertical():Boolean
		{
			return _vertical;
		}
		
		public function set vertical(value:Boolean):void
		{
			_vertical = value;
			computeDirection();
		}
		
		private var _reverse:Boolean;
		
		public function get reverse():Boolean
		{
			return _reverse;
		}
		
		public function set reverse(value:Boolean):void
		{
			_reverse = value;
			computeDirection();
		}
		private function computeDirection():void{
			var direction:String = vertical ? "column" : "row";
			if(reverse){
				direction += "-reverse";
			}
			setStyle("flexDirection",direction);
		}
		
		private var _wrap:Boolean;
		
		public function get wrap():Boolean
		{
			return _wrap;
		}
		
		public function set wrap(value:Boolean):void
		{
			_wrap = value;
			if(value){
				_reverseWrap = false;
			}
			setWrap();
		}
		
		private var _reverseWrap:Boolean;
		
		public function get reverseWrap():Boolean
		{
			return _reverseWrap;
		}
		
		public function set reverseWrap(value:Boolean):void
		{
			_reverseWrap = value;
			if(value){
				_wrap = false;
			}
			setWrap();
		}
		
		private function setWrap():void{
			var wrapVal:String;
			if(_wrap){
				wrapVal = "wrap";
			} else if(_reverseWrap){
				wrapVal = "wrap-reverse";
			} else {
				wrapVal = "nowrap";
			}
			setStyle("flexWrap",wrapVal);
		}

		private var _gap:String;

		public function get gap():String
		{
			return _gap;
		}

		public function set gap(value:String):void
		{
			_gap = value;
			setStyle("gap",value);
		}
		private var _columnGap:String;

		public function get columnGap():String
		{
			return _columnGap;
		}

		public function set columnGap(value:String):void
		{
			_columnGap = value;
			setStyle("columnGap",value);
		}
		private var _rowGap:String;

		public function get rowGap():String
		{
			return _rowGap;
		}

		public function set rowGap(value:String):void
		{
			_rowGap = value;
			setStyle("rowGap",value);
		}
	}
}