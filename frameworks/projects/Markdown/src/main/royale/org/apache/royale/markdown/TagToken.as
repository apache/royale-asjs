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
package org.apache.royale.markdown
{
	/**
	 * Tag tokens are used to represent markdown syntax. Each tag token represents a
	 * special markdown syntax in the original markdown source. They are usually used
	 * for the open and close tokens. For example the "\`\`\`" at the begining of a
	 * fenced block code, the start of an item list or the end of a emphasized part of
	 * a line.
	 * 
	 * Tag tokens have a variety of types and each is associated to a rendering rule.
	 * 
	 */
	public class TagToken extends Token
	{

		/**
		 * blockquote (open/close)
		 * code
		 * fence
		 * heading (open/close)
		 * hr
		 * bullet_list (open/close)
		 * list_item (open/close)
		 * ordered_list (open/close)
		 * paragraph (open/close)
		 * link (open/close)
		 * image
		 * table (open/close)
		 * thead (open/close)
		 * tbody (open/close)
		 * tr (open/close)
		 * th (open/close)
		 * td (open/close)
		 * strong (open/close)
		 * em (open/close)
		 * del (open/close)
		 * in (open/close)
		 * mark (open/close)
		 * sub (open/close)
		 * hardbreak
		 * softbreak
		 * text (well, not really a tag...)
		 * htmlblock (not tag)
		 * htmltag (not tag -- what is this?)
		 * abbr (open/close)
		 * footnote_ref (is this a tag?)
		 * footnote_block (open/close)
		 * footnote (open/close)
		 * footnote_anchor
		 * dl (open/close)
		 * dt (open/close)
		 * dd (open/close)
		 * 
		 */
		public function TagToken(type:String,level:int=0)
		{
			super(type);
			this.level = level;
		}

		public var openTag:Boolean;
		public var closeTag:Boolean;


	}
}