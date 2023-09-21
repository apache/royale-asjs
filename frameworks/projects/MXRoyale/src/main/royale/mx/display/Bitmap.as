/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package mx.display
{
	COMPILE::SWF
	{
		import flash.display.DisplayObject;
		import flash.display.BitmapData;
	}
	COMPILE::JS
	{
		import mx.core.UIComponent;
		import org.apache.royale.display.BitmapData; 
		//import org.apache.royale.textLayout.dummy.BitmapData;
	}

		
	COMPILE::SWF
	public class Bitmap extends flash.display.Bitmap
	{
		public function Bitmap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false)
		{
			super();
		}
	}

	
	COMPILE::JS
	public class Bitmap extends mx.core.UIComponent
	{
		public function Bitmap(bitmapData:Object = null, pixelSnapping:String = "auto", smoothing:Boolean = false)
		{
			super();
		}
		private var	_smoothing : Boolean =  false;
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
		}
		
		private var	_bitmapData : BitmapData =  null;

		// not implemented
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}
		
	}
}
