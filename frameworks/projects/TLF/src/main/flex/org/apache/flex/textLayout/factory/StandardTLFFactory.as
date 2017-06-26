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
package org.apache.flex.textLayout.factory {
	import org.apache.flex.svg.GraphicContainer;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.svg.Rect;
	import org.apache.flex.svg.CompoundGraphic;
	import org.apache.flex.textLayout.factory.ITLFFactory;
	import org.apache.flex.graphics.ICompoundGraphic;
	import org.apache.flex.graphics.IRect;
	import org.apache.flex.text.engine.ITextFactory;
	import org.apache.flex.text.html.HTMLTextFactory;

	public class StandardTLFFactory implements ITLFFactory {
		public function getRect(blendMode:String="") : IRect {
			return new Rect();
		}

		public function getCompoundGraphic(blendMode:String="") : ICompoundGraphic {
			return new CompoundGraphic();
		}
		
		public function getContainer():IParentIUIBase
		{
			return new GraphicContainer();
		}
		private static var factory:ITextFactory;
		public function get textFactory() : ITextFactory {
			if(!factory)
				factory = new HTMLTextFactory();
			factory.currentContainer = currentContainer;
			return factory;
		}
		
		private var _currentContainer:IParentIUIBase;
		public function get currentContainer():IParentIUIBase
		{
			return _currentContainer;
		}
		public function set currentContainer(value:IParentIUIBase):void
		{
			_currentContainer = value;
		}
		public function getBlendMode(obj:Object):String
		{
			return "normal";
		}

		public function setBlendMode(obj:Object,value:String):void
		{
			
		}
	}
}