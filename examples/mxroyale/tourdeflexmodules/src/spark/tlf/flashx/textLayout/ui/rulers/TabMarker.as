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

package flashx.textLayout.ui.rulers
{
	import mx.messaging.management.Attribute;
	
	import flashx.textLayout.formats.ITabStopFormat;
	
	public class TabMarker extends RulerMarker implements ITabStopFormat
	{
		public function TabMarker(inRuler:RulerBar, tabAttrs:ITabStopFormat)
		{
			super(inRuler, 9, 10, -4, 0, Number(tabAttrs.position));
			mTabKind = tabAttrs.alignment;
			mAlignmentToken = tabAttrs.decimalAlignmentToken;
			setStyle("tabkind", mTabKind);
		}
		
		public function get alignment():*
		{
			return mTabKind;
		}
		
		public function set alignment(inAlignment:String):void
		{
			mTabKind = inAlignment;
			setStyle("tabkind", mTabKind);
		}
		
		public function get decimalAlignmentToken():*
		{
			return mAlignmentToken;
		}
		
		public function set decimalAlignmenyToken(inToken:String):void
		{
			mAlignmentToken = inToken;
		}
		
		public function set decimalAlignmentToken(inToken:String):void
		{
			mAlignmentToken = inToken;
		}
		
		public function get position():*
		{
			return pos;
		}
		
		public function set position(inPosition:Object):void
		{
			pos = inPosition as Number;
		}
		
		
		public function isDifferentPosition(element:*, index:int, arr:Array):Boolean
		{
			var other:TabMarker = element as TabMarker;
			if (other)
				return other.position != position;
			else
				return true;
		}
		

		private var mTabKind:String;
		private var mAlignmentToken:String = null;
	}
}