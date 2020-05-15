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
package org.apache.royale.jquery
{
    import org.apache.royale.core.Application;
	import org.apache.royale.core.IFlexInfo;
	
	
	public class Application extends org.apache.royale.core.Application implements IFlexInfo
	{
		/**
		 * The Royale Compiler will inject script elements into the index.html file.  Surround with
		 * "inject_script" tag as follows:
		 *
		 * <inject_script>
		 * var link = document.createElement("link");
		 * link.setAttribute("rel", "stylesheet");
		 * link.setAttribute("type", "text/css");
		 * link.setAttribute("href", "http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css");
		 * document.head.appendChild(link);
		 * var script = document.createElement("script");
		 * script.setAttribute("src", "http://code.jquery.com/jquery-1.9.1.js");
		 * document.head.appendChild(script);
		 * script = document.createElement("script");
		 * script.setAttribute("src", "http://code.jquery.com/ui/1.10.2/jquery-ui.js");
		 * document.head.appendChild(script);
		 * </inject_script>
		 */
		public function Application()
		{
			super();
		}
    }
}
