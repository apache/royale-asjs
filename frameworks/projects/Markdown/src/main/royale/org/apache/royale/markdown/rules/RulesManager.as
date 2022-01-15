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
	public class RulesManager
	{
		/**
		 * Enable all rules
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.9
		 */
		public static function enableAll():void
		{
			var coreRules:Array = ['block','abbr','references','inline','footnote_tail',
				'abbr2','replacements','smartquotes'];
			var blockRules:Array = ['code','fences','blockquote','hr','list','footnote',
				'heading','lheading','htmlblock','table','deflist','paragraph'];
			var inlineRules:Array = ['text','newline','escape','backticks','del','ins','mark','emphasis',
				'sub','sup','links','footnote_inline','footnote_ref','autolink','htmltag','entity'];

		}

		/**
		 * Sets rules to standard set which is the defaults in Remarkable
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.9
		 */
		public static function enableStandard():void
		{
			var coreRules:Array = ['block','references','inline','footnote_tail','abbr2','replacements','smartquotes'];
			var blockRules:Array = ['code','fences','blockquote','hr','list','footnote',
			'heading','lheading','htmlblock','table','paragraph'];

			var inlineRules:Array = ['text','newline','escape','backticks','del','emphasis',
			'links','footnote_ref','autolink','htmltag','entity'];

		}
		/**
		 * Sets rules to commonmark compatibility
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.9
		 */
		public static function enableCommonMark():void
		{
			var coreRules:Array = ['block','references','inline','abbr2'];
			var blockRules:Array = ['code','fences','blockquote','hr','list','heading','htmlblock','paragraph'];
			var inlineRules:Array = ['text','newline','escape','backticks','emphasis','links','autolink','htmltag','entity'];
		}
		
		private static var enabledCoreRules:Array;
		private static var enabledBlockRules:Array;
		private static var enabledInlineRules:Array;

		private static var coreRules:Array;
		private static var blockRules:Array;
		private static var inlineRules:Array;
		
/**
 * 
Core
  [ 'block',          block          ], commonmark
  [ 'abbr',           abbr           ],
  [ 'references',     references     ], commonmark
  [ 'inline',         inline         ], commonmark
  [ 'footnote_tail',  footnote_tail  ], defaults
  [ 'abbr2',          abbr2          ], commonmark
  [ 'replacements',   replacements   ], defaults
  [ 'smartquotes',    smartquotes    ], defaults

Block
  [ 'code',       code ], commonmark
  [ 'fences',     fences,     [ 'paragraph', 'blockquote', 'list' ] ], commonmark
  [ 'blockquote', blockquote, [ 'paragraph', 'blockquote', 'list' ] ], commonmark
  [ 'hr',         hr,         [ 'paragraph', 'blockquote', 'list' ] ], commonmark
  [ 'list',       list,       [ 'paragraph', 'blockquote' ] ], commonmark
  [ 'footnote',   footnote,   [ 'paragraph' ] ], defaults
  [ 'heading',    heading,    [ 'paragraph', 'blockquote' ] ], commonmark
  [ 'lheading',   lheading ], commonmark
  [ 'htmlblock',  htmlblock,  [ 'paragraph', 'blockquote' ] ], commonmark
  [ 'table',      table,      [ 'paragraph' ] ], defaults
  [ 'deflist',    deflist,    [ 'paragraph' ] ],
  [ 'paragraph',  paragraph ] commonmark

Inline
  [ 'text',            text ], commonmark
  [ 'newline',         newline ], commonmark
  [ 'escape',          escape ], commonmark
  [ 'backticks',       backticks ], commonmark
  [ 'del',             del ], defaults
  [ 'ins',             ins ],
  [ 'mark',            mark ],
  [ 'emphasis',        emphasis ], commonmark
  [ 'sub',             sub ],
  [ 'sup',             sup ],
  [ 'links',           links ], commonmark
  [ 'footnote_inline', footnote_inline ],
  [ 'footnote_ref',    footnote_ref ], defaults
  [ 'autolink',        autolink ], commonmark
  [ 'htmltag',         htmltag ], commonmark
  [ 'entity',          entity ] commonmark
 * 
 */
		
		
		private static var initialized:Boolean = false;
		private static function initialize():void
		{
			initialized = true;
		}
		private static function getCoreRules():Array
		{
			//TODO build the rules from the settings
			return null;
		}
		public static function runCoreRules(state:CoreState):void
		{
			if(!initialized)
				initialize();
			
			var rules:Array = getCoreRules();
			for each(var rule:IRule in rules)
			{
				rule.parse(state);
			}
		}

		/**
		 * RulesManager is a static-only class
		 */
		private function RulesManager(){}

	}
}