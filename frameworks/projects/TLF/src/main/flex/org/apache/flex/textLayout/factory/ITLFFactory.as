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
package org.apache.royale.textLayout.factory {
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.graphics.ICompoundGraphic;
	import org.apache.royale.graphics.IRect;
	import org.apache.royale.text.engine.ITextFactory;
	public interface ITLFFactory {
		function get textFactory():ITextFactory;
		function getRect(blendMode:String=""):IRect;
		function getCompoundGraphic(blendMode:String=""):ICompoundGraphic;
		function getContainer():IParentIUIBase;
		
		// in JS, in order to measure text, TextLines need to be put
		// in the DOM early, so you need to pick one DOM widget to use as
		// at least a temporary parent.
		// in SWF, this isn't really needed since FTE is given all
		// of the font information it needs
		function get currentContainer():IParentIUIBase;
		function set currentContainer(value:IParentIUIBase):void
		function getBlendMode(obj:Object):String;
		function setBlendMode(obj:Object,value:String):void;
	}
}
