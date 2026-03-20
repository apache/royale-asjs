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
package org.apache.royale.style.support
{
	import org.apache.royale.style.Container;
	import org.apache.royale.debugging.assert;

	/**
	 * This is a base class for flex and grid containers for shared properties.
	 */
	public class ContentContainerBase extends Container
	{
		public function ContentContainerBase()
		{
			super();
			assert(displayType != null, "Subclasses of ContentContainerBase must set layoutStyleName to the name of the layout style they use");
			setStyle("display",displayType);
		}
		protected var displayType:String;

		private var _inline:Boolean;
		/**
		 * Whether to use inline version of the layout style instead of the block version.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get inline():Boolean
		{
			return _inline;
		}

		public function set inline(value:Boolean):void
		{
			_inline = value;
			setStyle("display",value ? "inline-" + displayType : displayType);
		}

		/**
		 *  Returns the align-content style value.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get alignContent():String{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style.alignContent;}
		}
		public function set alignContent(value:String):void{
			setStyle("alignContent",value);
		}
		/**
		 *  Returns the align-items style value.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get alignItems():String{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style.alignItems;}
		}
		public function set alignItems(value:String):void{
			setStyle("alignItems",value);
		}
		
		/**
		 *  Returns the justify-content style value.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get justifyContent():String{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style.justifyContent;}
		}
		public function set justifyContent(value:String):void{
			setStyle("justifyContent",value);
		}
		
		private var _gap:String;
		/**
		 *  Returns the gap style value.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
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

		/**
		 *  Returns the column-gap style value.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
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

		/**
		 *  Returns the row-gap style value.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
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