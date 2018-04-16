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
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }
	
	/**
	 * The ASFCopyrightAttributionAndLinks displays an 
     * attribution for the Apache Software Foundation.
	 * It is used at the very bottom of each page on the Apache Royale site
	 * where it says 'Copyright © 2017 The Apache Software Foundation, 
	 * Licensed under the Apache License, Version 2.0.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ASFCopyrightAttributionAndLinks extends UIBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ASFCopyrightAttributionAndLinks()
		{
			super();
			
			typeNames = "ASFCopyrightAttributionAndLinks";
		}
		
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			super.createElement();
			element.innerHTML = "Copyright © 2018 <a href='http://www.apache.org'>The Apache Software Foundation</a>, Licensed under the <a href='http://www.apache.org/licenses/LICENSE-2.0'>Apache License, Version 2.0</a>";
			return element;
		}
		
	}
}
