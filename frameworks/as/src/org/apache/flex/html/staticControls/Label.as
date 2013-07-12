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
package org.apache.flex.html.staticControls
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.ITextBead;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  Label probably should extend TextField directly,
	 *  but the player's APIs for TextLine do not allow
	 *  direct instantiation, and we might want to allow
	 *  Labels to be declared and have their actual
	 *  view be swapped out.
	 */
	public class Label extends UIBase implements IInitSkin
	{
		public function Label()
		{
			super();
		}
		
		public function get text():String
		{
			return ITextModel(model).text;
		}
		public function set text(value:String):void
		{
			ITextModel(model).text = value;
		}
		
		public function get html():String
		{
			return ITextModel(model).html;
		}
		public function set html(value:String):void
		{
			ITextModel(model).html = value;
		}
				
		public function initSkin():void
		{
			if (getBeadByType(ITextBead) == null)
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iTextBead")) as IBead);			
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			IEventDispatcher(model).dispatchEvent( new Event("widthChanged") );
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			IEventDispatcher(model).dispatchEvent( new Event("heightChanged") );
		}
	}
}