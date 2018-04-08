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
package org.apache.royale.file.beads
{
	COMPILE::SWF 
	{
		import flash.net.FileFilter;
	}
	
	/**
	 *  The FileBrowserWithFilter adds a filtering option to FileBrowser
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class FileBrowserWithFilter extends FileBrowser
	{
        private var _filter:String = "";
        /**
         *  The filter for the FileBrowser
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get filter():String
        {
            return _filter;
        }
        public function set filter(value:String):void
        {
            _filter = value;
        }
		
		/**
		 *  @copy org.apache.royale.file.beads.FileBrowser#browse()
		 *  @royaleignorecoercion HTMLInputElement
		 *
		 *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
		 */
		override public function browse():void
		{
			COMPILE::JS
			{
				(delegate as HTMLInputElement).accept = filter;
				super.browse();
			}
			COMPILE::SWF
			{
				// TODO translate mime types too
				var flashFilter:String = filter.replace(/,/g, ";");
				flashFilter = flashFilter.replace(/\./g, "*.");
				var fileFilter:FileFilter = new FileFilter(filter, flashFilter);
				delegate.browse([fileFilter]);
			}
		}

	}
}
