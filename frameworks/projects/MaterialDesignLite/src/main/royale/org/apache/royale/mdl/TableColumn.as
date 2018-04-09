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
        import org.apache.royale.core.CSSClassList;
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

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }

            typeNames = "mdl-data-table__cell--non-numeric";
		}

        COMPILE::JS
        private var _classList:CSSClassList;

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
            if (_ascending != value)
            {
                _ascending = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-data-table__header--sorted-ascending";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
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
            if (_descending != value)
            {
                _descending = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-data-table__header--sorted-descending";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

        COMPILE::JS
        override protected function computeFinalClassNames():String
        {
            return _classList.compute() + super.computeFinalClassNames();
        }
    }
}
