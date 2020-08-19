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
package org.apache.royale.jewel.beads.controls.list
{
	COMPILE::JS
	{
	import org.apache.royale.utils.html.getClassStyle;
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStyledUIBase;
	import org.apache.royale.utils.IClassSelectorListSupport;
	import org.apache.royale.utils.css.addDynamicSelector;
	
	/**
	 *  The ListAlternateRowColor bead is a specialty bead that can be used with
	 *  Jewel List control to alternate the background color of every row with two colors
	 * 
	 *  Note: This bead is temporal due to a bug in the css compiler that prevent add 'nth-child' rules
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class ListAlternateRowColor implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function ListAlternateRowColor()
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
		protected var _strand:IStyledUIBase;
		
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
			_strand = value as IStyledUIBase;

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
			var emphasis:String =  _strand.emphasis ? "." + _strand.emphasis : ".primary";
			var bgColor:String;

			var style:String = "." + ruleName + " .jewel.item:nth-child(even)";
			addDynamicSelector(style, "background: " + evenColor + ";");
			
			style = "." + ruleName + " .jewel.item:nth-child(odd)";
			addDynamicSelector(style, "background: " + oddColor + ";");

			style = "." + ruleName + " .jewel.item" + emphasis + ".hovered";
			COMPILE::JS
			{
			var styles:Object = getClassStyle(".jewel.item" + emphasis + ".hovered");
			bgColor = styles.background;
			}
			addDynamicSelector(style, "background: " + bgColor + ";");
			
			style = "." + ruleName + " .jewel.item" + emphasis + ".selected";
			COMPILE::JS
			{
			styles = getClassStyle(".jewel.item" + emphasis + ".selected");
			bgColor = styles.background;
			}
			addDynamicSelector(style, "background: " + bgColor + ";");
		}
	}
}
