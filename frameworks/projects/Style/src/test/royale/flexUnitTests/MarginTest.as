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
package flexUnitTests
{
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.spacing.MarginBlock;
	import org.apache.royale.style.stylebeads.spacing.MarginInlineEnd;
	import org.apache.royale.test.asserts.*;

	public class MarginTest
	{
		[Test]
		public function testMarginShorthandSetsLogicalSides():void
		{
			var margin:Margin = new Margin("1px 2px 3px 4px");

			assertEquals("1px", margin.top);
			assertEquals("2px", margin.right);
			assertEquals("3px", margin.bottom);
			assertEquals("4px", margin.left);
			assertEquals("1px", margin.blockStart);
			assertEquals("2px", margin.inlineEnd);
			assertEquals("3px", margin.blockEnd);
			assertEquals("4px", margin.inlineStart);
			assertEquals(4, margin.getLeaves().length);
		}

		[Test]
		public function testMarginFourValuesPreservesLogicalSidesWhenValuesMatch():void
		{
			var margin:Margin = new Margin("1px 1px 1px 1px");

			assertEquals("1px", margin.blockStart);
			assertEquals("1px", margin.inlineEnd);
			assertEquals("1px", margin.blockEnd);
			assertEquals("1px", margin.inlineStart);
			assertEquals(4, margin.getLeaves().length);
		}

		[Test]
		public function testMarginSingleValueUsesBlockAndInline():void
		{
			var margin:Margin = new Margin("1px");

			assertEquals("1px", margin.top);
			assertEquals("1px", margin.right);
			assertEquals("1px", margin.bottom);
			assertEquals("1px", margin.left);
			assertEquals("1px", margin.block);
			assertEquals("1px", margin.inline);
			assertEquals(2, margin.getLeaves().length);
		}

		[Test]
		public function testMarginTwoValuesUseBlockAndInline():void
		{
			var margin:Margin = new Margin("1px 2px");

			assertEquals("1px", margin.top);
			assertEquals("2px", margin.right);
			assertEquals("1px", margin.bottom);
			assertEquals("2px", margin.left);
			assertEquals("1px", margin.block);
			assertEquals("2px", margin.inline);
			assertEquals(2, margin.getLeaves().length);
		}

		[Test]
		public function testMarginShorthandRepeatsMissingValues():void
		{
			var margin:Margin = new Margin("1px 2px 3px");

			assertEquals("1px", margin.top);
			assertEquals("2px", margin.right);
			assertEquals("3px", margin.bottom);
			assertEquals("2px", margin.left);
			assertEquals("1px", margin.blockStart);
			assertEquals("2px", margin.inline);
			assertEquals("3px", margin.blockEnd);
			assertEquals(3, margin.getLeaves().length);
		}

		[Test]
		public function testMarginLeafClassesCanBeUsedDirectly():void
		{
			var block:MarginBlock = new MarginBlock("1px");
			var inlineEnd:MarginInlineEnd = new MarginInlineEnd("2px");

			assertEquals("margin-block:1px;", block.getRule());
			assertEquals("margin-inline-end:2px;", inlineEnd.getRule());
		}
	}
}