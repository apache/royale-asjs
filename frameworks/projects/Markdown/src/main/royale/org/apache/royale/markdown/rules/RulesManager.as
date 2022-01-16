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
	import org.apache.royale.utils.array.arraysMatch;

	public class RulesManager
	{
		/**
		 * Enable all rules
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.9
		 */
		public function enableAll():void
		{
			var coreRules:Array = ['block','abbr','references','inline','footnote_tail',
				'abbr2','replacements','smartquotes'];
			var blockRules:Array = ['code','fences','blockquote','hr','list','footnote',
				'heading','lheading','htmlblock','table','deflist','paragraph'];
			var inlineRules:Array = ['text','newline','escape','backticks','del','ins','mark','emphasis',
				'sub','sup','links','footnote_inline','footnote_ref','autolink','htmltag','entity'];
			
			if(!checkCore(coreRules) || !checkBlock(blockRules) || !checkInline(inlineRules))
			{
				enabledCoreRules = coreRules.slice();
				enabledBlockRules = blockRules.slice();
				enabledInlineRules = inlineRules.slice();
				initialized = false;
			}

		}

		/**
		 * Sets rules to standard set which is the defaults in Remarkable
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.9
		 */
		public function enableStandard():void
		{
			var coreRules:Array = ['block','references','inline','footnote_tail','abbr2','replacements','smartquotes'];
			var blockRules:Array = ['code','fences','blockquote','hr','list','footnote',
			'heading','lheading','htmlblock','table','paragraph'];

			var inlineRules:Array = ['text','newline','escape','backticks','del','emphasis',
			'links','footnote_ref','autolink','htmltag','entity'];

			if(!checkCore(coreRules) || !checkBlock(blockRules) || !checkInline(inlineRules))
			{
				enabledCoreRules = coreRules.slice();
				enabledBlockRules = blockRules.slice();
				enabledInlineRules = inlineRules.slice();
				initialized = false;
			}

		}
		/**
		 * Sets rules to commonmark compatibility
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.9
		 */
		public function enableCommonMark():void
		{
			var coreRules:Array = ['block','references','inline','abbr2'];
			var blockRules:Array = ['code','fences','blockquote','hr','list','heading','htmlblock','paragraph'];
			var inlineRules:Array = ['text','newline','escape','backticks','emphasis','links','autolink','htmltag','entity'];

			if(!checkCore(coreRules) || !checkBlock(blockRules) || !checkInline(inlineRules))
			{
				enabledCoreRules = coreRules.slice();
				enabledBlockRules = blockRules.slice();
				enabledInlineRules = inlineRules.slice();
				initialized = false;
			}

		}
		
		private function checkCore(toCheck:Array):Boolean
		{
			return arraysMatch(toCheck,enabledCoreRules);
		}
		private function checkBlock(toCheck:Array):Boolean
		{
			return arraysMatch(toCheck,enabledBlockRules);
		}
		private function checkInline(toCheck:Array):Boolean
		{
			return arraysMatch(toCheck,enabledInlineRules);
		}

		public function disableRule(name:String):void
		{
			if(enabledCoreRules.indexOf(name) != -1)
			{
				enabledCoreRules.splice(enabledCoreRules.indexOf(name),1);
				initialized = false;
			}
			else if(enabledBlockRules.indexOf(name) != -1)
			{
				enabledBlockRules.splice(enabledBlockRules.indexOf(name),1);
				initialized = false;
			}
			else if(enabledInlineRules.indexOf(name) != -1)
			{
				enabledInlineRules.splice(enabledInlineRules.indexOf(name),1);
				initialized = false;
			}
		}

		private var enabledCoreRules:Array;
		private var enabledBlockRules:Array;
		private var enabledInlineRules:Array;

		private var coreRules:Vector.<IRule>;
		private var blockRules:Vector.<IRule>;
		private var inlineRules:Vector.<IRule>;

		private var paragraphRules:Vector.<IRule>;
		private var blockquoteRules:Vector.<IRule>;
		private var listRules:Vector.<IRule>;
		
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
//TODO figure out a cleaner way to get the sub-rules
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
		
		
		private var initialized:Boolean = false;
		private function initialize():void
		{
			initialized = true;
			coreRules = new Vector.<IRule>();
			for each(var rule:String in enabledCoreRules)
			{
				switch(rule)
				{
					case 'block':
						coreRules.push(Block.get());
						break;
					case 'abbr':
						coreRules.push(Abbr.get());
						break;
					case 'references':
						coreRules.push(References.get());
						break;
					case 'inline':
						coreRules.push(Inline.get());
						break;
					case 'footnote_tail':
						coreRules.push(Footnote_tail.get());
						break;
					case 'abbr2':
						coreRules.push(Abbr2.get());
						break;
					case 'replacements':
						coreRules.push(Replacements.get());
						break;
					case 'smartquotes':
						coreRules.push(Smartquotes.get());
						break;
					default:
						break;
				}
			}

			blockRules = new Vector.<IRule>();
			paragraphRules = new Vector.<IRule>();
			blockquoteRules = new Vector.<IRule>();
			listRules = new Vector.<IRule>();

			for each(rule in enabledBlockRules)
			{
				switch(rule)
				{

					case 'code':
						blockRules.push(Code.get());
						break;
					case 'fences':
						blockRules.push(Fences.get());
						paragraphRules.push(Fences.get());
						blockquoteRules.push(Fences.get());
						listRules.push(Fences.get());
						break;
					case 'blockquote':
						blockRules.push(BlockQuote.get());
						paragraphRules.push(BlockQuote.get());
						blockquoteRules.push(BlockQuote.get());
						listRules.push(BlockQuote.get());
						break;
					case 'hr':
						blockRules.push(Hr.get());
						paragraphRules.push(Hr.get());
						blockquoteRules.push(Hr.get());
						listRules.push(Hr.get());
						break;
					case 'list':
						blockRules.push(List.get());
						paragraphRules.push(List.get());
						blockquoteRules.push(List.get());
						break;
					case 'footnote':
						blockRules.push(Footnote.get());
						paragraphRules.push(Footnote.get());
						break;
					case 'heading':
						blockRules.push(Heading.get());
						paragraphRules.push(Heading.get());
						blockquoteRules.push(Heading.get());
						break;
					case 'lheading':
						blockRules.push(Lheading.get());
						break;
					case 'htmlblock':
						blockRules.push(Htmlblock.get());
						paragraphRules.push(Htmlblock.get());
						blockquoteRules.push(Htmlblock.get());
						break;
					case 'table':
						blockRules.push(Table.get());
						paragraphRules.push(Table.get());
						break;
					case 'deflist':
						blockRules.push(Deflist.get());
						paragraphRules.push(Deflist.get());
						break;
					case 'paragraph':
						blockRules.push(Paragraph.get());
						break;
					default:
						break;

				}
			}

			inlineRules = new Vector.<IRule>();

			for each(rule in enabledBlockRules)
			{
				switch(rule)
				{
					case 'text':
						inlineRules.push(Text.get());
						break;
					case 'newline':
						inlineRules.push(Newline.get());
						break;
					case 'escape':
						inlineRules.push(Escape.get());
						break;
					case 'backticks':
						inlineRules.push(Backticks.get());
						break;
					case 'del':
						inlineRules.push(Del.get());
						break;
					case 'ins':
						inlineRules.push(Ins.get());
						break;
					case 'mark':
						inlineRules.push(Mark.get());
						break;
					case 'emphasis':
						inlineRules.push(Emphasis.get());
						break;
					case 'sub':
						inlineRules.push(Sub.get());
						break;
					case 'sup':
						inlineRules.push(Sup.get());
						break;
					case 'links':
						inlineRules.push(Links.get());
						break;
					case 'footnote_inline':
						inlineRules.push(InlineFootnote.get());
						break;
					case 'footnote_ref':
						inlineRules.push(FootnoteRef.get());
						break;
					case 'autolink':
						inlineRules.push(Autolink.get());
						break;
					case 'htmltag':
						inlineRules.push(Htmltag.get());
						break;
					case 'entity':
						inlineRules.push(Entity.get());
						break;
					default:
						break;

				}
			}
		}
		private function getCoreRules():Vector.<IRule>
		{
			if(!coreRules)
				initialize();

			return coreRules;
		}
		public function runCoreRules(state:CoreState):void
		{
			if(!initialized)
				initialize();
			
			var rules:Vector.<IRule> = getCoreRules();
			for each(var rule:IRule in rules)
			{
				rule.parse(state);
			}
		}

		private function getBlockRules():Vector.<IRule>
		{
			if(!blockRules)
				initialize();

			return blockRules;
		}
		public function runBlockRules(state:BlockState,silent:Boolean,firstLine:int,lastLine:int):Boolean
		{
			var rules:Vector.<IRule> = getBlockRules();
			for each(var rule:IRule in rules)
			{
				if(rule.parse(state,silent,firstLine,lastLine))
					return true;
			}
			return false;
		}

		public function getInlineRules():Vector.<IRule>
		{
			if(!inlineRules)
				initialize();

			return inlineRules;
		}
		public function runInlineRules(state:InlineState,silent:Boolean,position:int):Boolean
		{
			var rules:Vector.<IRule> = getInlineRules();
			for each(var rule:IRule in rules)
			{
				if(rule.parse(state,silent))
				{
					if(silent)
						state.cacheSet(position, state.position);
					
					return true;
				}
			}
			return false;
		}

		public function runBlockquotes(state:BlockState,firstLine:int,lastLine:int):Boolean
		{
			var rules:Vector.<IRule> = blockquoteRules;
			for each(var rule:IRule in rules)
			{
			if (rule.parse(state,true, firstLine, lastLine))
				return true;
			}
			return false;
		}

		public function runLists(state:BlockState,firstLine:int,lastLine:int):Boolean
		{
			var rules:Vector.<IRule> = listRules;
			for each(var rule:IRule in rules)
			{
			if (rule.parse(state,true, firstLine, lastLine))
				return true;
			}
			return false;
		}

		public function runParagraphs(state:BlockState,firstLine:int,lastLine:int):Boolean
		{
			var rules:Vector.<IRule> = paragraphRules;
			for each(var rule:IRule in rules)
			{
			if (rule.parse(state,true, firstLine, lastLine))
				return true;
			}
			return false;
		}

		public var options:MarkdownOptions;
		/**
		 * Each Parser needs a RulesManager which holds the current set of rules
		 */
		public function RulesManager(){
			options = new MarkdownOptions();
		}

	}
}