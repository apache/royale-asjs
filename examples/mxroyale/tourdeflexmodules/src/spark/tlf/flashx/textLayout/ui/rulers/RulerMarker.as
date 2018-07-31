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
	import mx.containers.Canvas;

	public class RulerMarker extends Canvas
	{
		public function RulerMarker(inRuler:RulerBar, inWidth:Number, inHeight:Number, inHOffset:Number, inVOffset:Number, inPos:Number)
		{
			super();
			width = inWidth;
			height = inHeight;
			mHOffset = inHOffset;
			mVOffset = inVOffset;
			mPos = inPos;
			mRuler = inRuler;
		}
		
		override public function initialize():void
		{
			super.initialize();
			positionMarker();
		}
		
		protected function positionMarker():void
		{
			if (parent)
			{
				if (alignToRight)
				{
					x = parent.width - originPosition - pos + hOffset;
					y = parent.height - height + vOffset;
				}
				else
				{
					x = originPosition + pos + hOffset;
					y = parent.height - height + vOffset;
				}
			}
		}
		
		protected function get alignToRight():Boolean
		{
			return ruler.rightToLeft;
		}
		
		protected function get originPosition():Number
		{
			return 0;
		}

		public function set pos(inPos:Number):void
		{
			mPos = inPos;
			positionMarker();
		}
		
		public function get pos():Number
		{
			return mPos;
		}
		
		public function set hOffset(inOffset:Number):void
		{
			mHOffset = inOffset;
			positionMarker();
		}
		
		public function get hOffset():Number
		{
			return mHOffset;
		}
		
		public function set vOffset(inOffset:Number):void
		{
			mVOffset = inOffset;
			positionMarker();
		}
		
		public function get vOffset():Number
		{
			return mVOffset;
		}
		
		public function get ruler():RulerBar
		{
			return mRuler;
		}
		
		public function set markerLeft(inNewLeft:Number):void
		{
			if (parent)
			{
				if (alignToRight)
					pos = parent.width - (inNewLeft + hOffset > parent.width ? parent.width : inNewLeft + hOffset)  - originPosition;
				else
					pos = (inNewLeft < 0 ? 0 : inNewLeft) - originPosition - hOffset;
			}
		}

		private var mPos:Number;
		private var mHOffset:Number;
		private var mVOffset:Number;
		private var mRuler:RulerBar = null;
	}
}