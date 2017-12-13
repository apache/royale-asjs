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
package org.apache.royale.mdl
{
    import org.apache.royale.html.TableHeader;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }

	/**
	 *  The TableColumn class represents an HTML <th> element that
     *  be inside a <thead> in a MLD Table
     *  Use instances of this class in columns Array property MDL Table
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class TableColumn extends TableHeader
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function TableColumn()
		{
			super();

			className = "";
		}

        private var _headerText:String = "";

        /**
         *  The text of the th
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function get headerText():String
		{
            return _headerText;
		}
		public function set headerText(value:String):void
		{
            _headerText = value;

			COMPILE::JS
			{
                if(textNode == null)
                {
                    textNode = document.createTextNode('') as Text;
                    element.appendChild(textNode);
                }

                textNode.nodeValue = value;
			}
		}

        COMPILE::JS
        protected var textNode:Text;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-data-table__cell--non-numeric";

            return super.createElement();;
        }
		
        protected var _ascending:Boolean;
        /**
		 *  A boolean flag to activate "mdl-data-table__header--sorted-ascending" effect selector.
		 *  Applies visual styling to indicate the column is sorted in ascending order
		 *  Optional;
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get ascending():Boolean
        {
            return _ascending;
        }
        public function set ascending(value:Boolean):void
        {
			_ascending = value;

			COMPILE::JS
			{
				element.classList.toggle("mdl-data-table__header--sorted-ascending", _ascending);
				typeNames = element.className;
			}
        }

        protected var _descending:Boolean;
        /**
		 *  A boolean flag to activate "mdl-data-table__header--sorted-descending" effect selector.
		 *  Applies visual styling to indicate the column is sorted in descending order
		 *  Optional;
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get descending():Boolean
        {
            return _descending;
        }
        public function set descending(value:Boolean):void
        {
			_descending = value;

			COMPILE::JS
			{
				element.classList.toggle("mdl-data-table__header--sorted-descending", _descending);
				typeNames = element.className;
			}
        }
    }
}
