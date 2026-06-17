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
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.spacing.PaddingBlock;
	import org.apache.royale.style.stylebeads.spacing.PaddingInlineEnd;
	import org.apache.royale.test.asserts.*;

	public class PaddingTest
	{
		[Test]
		public function testPaddingShorthandSetsLogicalSides():void
		{
			var padding:Padding = new Padding("1px 2px 3px 4px");

			assertEquals("1px", padding.top);
			assertEquals("2px", padding.right);
			assertEquals("3px", padding.bottom);
			assertEquals("4px", padding.left);
			assertEquals("1px", padding.blockStart);
			assertEquals("2px", padding.inlineEnd);
			assertEquals("3px", padding.blockEnd);
			assertEquals("4px", padding.inlineStart);
			assertEquals(4, padding.getLeaves().length);
		}

		[Test]
		public function testPaddingFourValuesPreservesLogicalSidesWhenValuesMatch():void
		{
			var padding:Padding = new Padding("1px 1px 1px 1px");

			assertEquals("1px", padding.blockStart);
			assertEquals("1px", padding.inlineEnd);
			assertEquals("1px", padding.blockEnd);
			assertEquals("1px", padding.inlineStart);
			assertEquals(4, padding.getLeaves().length);
		}

		[Test]
		public function testPaddingSingleValueUsesBlockAndInline():void
		{
			var padding:Padding = new Padding("1px");

			assertEquals("1px", padding.top);
			assertEquals("1px", padding.right);
			assertEquals("1px", padding.bottom);
			assertEquals("1px", padding.left);
			assertEquals("1px", padding.block);
			assertEquals("1px", padding.inline);
			assertEquals(2, padding.getLeaves().length);
		}

		[Test]
		public function testPaddingTwoValuesUseBlockAndInline():void
		{
			var padding:Padding = new Padding("1px 2px");

			assertEquals("1px", padding.top);
			assertEquals("2px", padding.right);
			assertEquals("1px", padding.bottom);
			assertEquals("2px", padding.left);
			assertEquals("1px", padding.block);
			assertEquals("2px", padding.inline);
			assertEquals(2, padding.getLeaves().length);
		}

		[Test]
		public function testPaddingShorthandRepeatsMissingValues():void
		{
			var padding:Padding = new Padding("1px 2px 3px");

			assertEquals("1px", padding.top);
			assertEquals("2px", padding.right);
			assertEquals("3px", padding.bottom);
			assertEquals("2px", padding.left);
			assertEquals("1px", padding.blockStart);
			assertEquals("2px", padding.inline);
			assertEquals("3px", padding.blockEnd);
			assertEquals(3, padding.getLeaves().length);
		}

		[Test]
		public function testPaddingLeafClassesCanBeUsedDirectly():void
		{
			var block:PaddingBlock = new PaddingBlock("1px");
			var inlineEnd:PaddingInlineEnd = new PaddingInlineEnd("2px");

			assertEquals("padding-block:1px;", block.getRule());
			assertEquals("padding-inline-end:2px;", inlineEnd.getRule());
		}
	}
}