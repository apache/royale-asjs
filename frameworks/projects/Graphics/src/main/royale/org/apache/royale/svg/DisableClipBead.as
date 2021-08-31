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
package org.apache.royale.svg
{
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.core.IStrand;

	COMPILE::SWF {
		import flash.display.Graphics;
		import flash.display.Sprite;
		import flash.display.DisplayObject;
	}

	/**
	 *  The DisableClipBead bead allows you to disable
	 *  a ClipBead.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DisableClipBead implements IBead
	{
		private var _strand:IStrand;
		private var _disabled:Boolean;
		COMPILE::JS 
		{
			private var cachedClipPath:String;
		}
		COMPILE::SWF 
		{
			private var cachedMask:Sprite;
		}
		
		public function DisableClipBead()
		{
		}
		
		public function get disabled():Boolean
		{
			return _disabled;
		}
		
		public function set disabled(value:Boolean):void
		{
			_disabled = value;
			if (host)
			{
				disable();
			}
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			disable();
		}
		
		COMPILE::SWF
		private function disable():void
		{
			var element:DisplayObject = host.$displayObject as DisplayObject;
			if (disabled)
			{
				cachedMask = element.mask as Sprite;
				element.mask = null;
			} else
			{
				element.mask = cachedMask;
				cachedMask = null;
			}
		}

		COMPILE::JS
		private function disable():void
		{
			if (host.element.style["clipPath"] === undefined)
			{
				return;
			}
			if (disabled)
			{
				cachedClipPath = host.element.style["clipPath"] as String;
				host.element.style["clipPath"] = "";
			} else
			{
				host.element.style["clipPath"] = cachedClipPath;
				cachedClipPath = null;
			}
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		public function get host():IRenderedObject
		{
			return _strand as IRenderedObject;
		}
		
	}
}

