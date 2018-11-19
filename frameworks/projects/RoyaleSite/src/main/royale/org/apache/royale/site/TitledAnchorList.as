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
package org.apache.royale.site
{	
	import org.apache.royale.core.UIBase;
    import org.apache.royale.site.data.AnchorListData;
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }
	
    [DefaultProperty("list")]
    
	/**
	 * The TitledAnchorList displays a title with a
	 * list of anchors below it.
	 * It is used on the home page of the Apache Royale site.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TitledAnchorList extends UIBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function TitledAnchorList()
		{
			super();
			
			typeNames = "TitledAnchorList";
		}
		
		private var _title:String;
		
		/**
		 * the title for the tile.
		 */
		public function get title():String
		{
			return _title;
		}
		public function set title(value:String):void
		{
			_title = value;
		}

        private var _titleClassName:String;
        
        /**
         * the className for the tile.
         */
        public function get titleClassName():String
        {
            return _titleClassName;
        }
        public function set titleClassName(value:String):void
        {
            _titleClassName = value;
        }
        
		private var _list:Array;
		
		/**
		 * the array of AnchorListData for the list.
		 */
		public function get list():Array
		{
			return _list;
		}
		public function set list(value:Array):void
		{
            _list = value;
		}
		
        /**
         * @return The actual element to be parented.
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLUListElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            var ul:HTMLUListElement = document.createElement("ul") as HTMLUListElement;
            element = ul as WrappedHTMLElement;
            return element;
        }
        
        /**
         * @royaleignorecoercion HTMLAnchorElement
         * @royaleignorecoercion HTMLLIElement
         */
        COMPILE::JS
		override public function addedToParent():void
		{
			super.addedToParent();
            var li:HTMLLIElement = document.createElement("li") as HTMLLIElement;
            li.className = titleClassName;
            li.innerHTML = title;
            element.appendChild(li);
            var n:int = list.length;
            for (var i:int = 0; i < n; i++)
            {
                var data:AnchorListData = list[i] as AnchorListData;
                li = document.createElement("li") as HTMLLIElement;
                var anchor:HTMLAnchorElement = document.createElement("a") as HTMLAnchorElement;
                anchor.href = data.href;
                anchor.innerHTML = data.htmlText;
                anchor.className = "AnchorListContent";
                li.appendChild(anchor);
                element.appendChild(li);
            }                
		}
		
	}
}
