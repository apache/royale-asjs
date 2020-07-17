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
package org.apache.royale.jewel.beads.controls.table
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.utils.IClassSelectorListSupport;
	import org.apache.royale.utils.css.addDynamicSelector;
	
	/**
	 *  The TableAlternateRowColor bead is a specialty bead that can be used with
	 *  Jewel Table control to alternate the background color of every row with two colors
	 *  
	 *  Note: This bead is temporal due to a bug in the css compiler that prevent add 'nth-child' rules
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class TableAlternateRowColor implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function TableAlternateRowColor()
		{
		}

		private var _oddColor:String = "#ffffff";
		/*
		 * The odd color value to use
		 */
		public function get oddColor():String {
			return _oddColor;
		}
		public function set oddColor(value:String):void {
			_oddColor = value;
		}
		
		private var _evenColor:String = "#fafafa";
		/*
		 * The even color value to use
		 */
		public function get evenColor():String {
			return _evenColor;
		}
		public function set evenColor(value:String):void {
			_evenColor = value;
		}

		protected var ruleName:String;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function set strand(value:IStrand):void
		{
			ruleName = "alternateRowColor-" + ((new Date()).getTime() + "-" + Math.floor(Math.random()*1000));

			createAlternateRowColorRule();

			var l:IClassSelectorListSupport = value as IClassSelectorListSupport;
			l.addClass(ruleName);
		}
		
		/**
		 * create the dynamic class selector
		 */
		protected function createAlternateRowColorRule():void
		{
			addDynamicSelector(".jewel.table." + ruleName + " .jewel.tablerow:nth-child(even)", "background: " + evenColor + ";");
			addDynamicSelector(".jewel.table." + ruleName + " .jewel.tablerow:nth-child(odd)", "background: " + oddColor + ";");
		}
	}
}
