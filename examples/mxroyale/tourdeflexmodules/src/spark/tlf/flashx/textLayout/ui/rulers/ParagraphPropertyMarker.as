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
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.tlf_internal;
	use namespace tlf_internal;
	
	public class ParagraphPropertyMarker extends RulerMarker
	{
		public function ParagraphPropertyMarker(inRuler:RulerBar, inProperty:String)
		{
			super(inRuler, 6, 13, 0, 0, 0);
			setStyle("propkind", inProperty);
			setStyle("rightToLeftPar", false);
			mProperty = inProperty;
		}
		
		public function get property():String
		{
			return mProperty;
		}
		
		override protected function get alignToRight():Boolean
		{
			switch(mProperty)
			{
			case TextLayoutFormat.textIndentProperty.name:
				return mRightToLeftPar ? true : false;
			case TextLayoutFormat.paragraphStartIndentProperty.name:
				return mRightToLeftPar;
			case TextLayoutFormat.paragraphEndIndentProperty.name:
				return !mRightToLeftPar;
			}
			return false;
		}
		
		override protected function get originPosition():Number
		{
			return mRelativeToPosition;
		}

		public function set relativeToPosition(inRelPos:Number):void
		{
			mRelativeToPosition = inRelPos;
			positionMarker();
		}
		
		override public function get hOffset():Number
		{
			switch(mProperty)
			{
			case TextLayoutFormat.textIndentProperty.name:
				return mRightToLeftPar ? -6 : 0;
			case TextLayoutFormat.paragraphStartIndentProperty.name:
				return mRightToLeftPar ? -6 : 0;
			case TextLayoutFormat.paragraphEndIndentProperty.name:
				return mRightToLeftPar ? 0 : -6;
			}
			return 0;
		}
		
		public function set rightToLeftPar(inRightToLeft:Boolean):void
		{
			if (inRightToLeft != mRightToLeftPar)
			{
				mRightToLeftPar = inRightToLeft;
				setStyle("rightToLeftPar", mRightToLeftPar);
				
				if (mProperty == TextLayoutFormat.paragraphStartIndentProperty.name)
					mProperty = TextLayoutFormat.paragraphEndIndentProperty.name;
				else if (mProperty == TextLayoutFormat.paragraphEndIndentProperty.name)
					mProperty = TextLayoutFormat.paragraphStartIndentProperty.name;
			}
		}
		
		private var mProperty:String;
		private var mRelativeToPosition:Number = 0;
		private var mRightToLeftPar:Boolean = false;
	}
}