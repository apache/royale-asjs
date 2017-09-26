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
package org.apache.flex.html
{
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }
	
	/**
	 *  The TableCell class defines a table data cell in the Table component. This element
	 *  may have nearly any type of FlexJS component as children.
     *  
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TableCell extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function TableCell()
		{
			super();
			
			className = "TableCell";
		}
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			return addElementToWrapper(this,'td');
		}
    }
}
