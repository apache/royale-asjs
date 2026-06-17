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
	import org.apache.royale.style.stylebeads.ILeafStyleBead;
	import org.apache.royale.style.stylebeads.border.Outline;
	import org.apache.royale.test.asserts.*;

	public class OutlineTest
	{
		[Test]
		public function testConstructorSetsOptionalArguments():void
		{
			var outline:Outline = new Outline("2px", "solid", "red", "1px");
			var leaves:Array = outline.getLeaves();

			assertEquals("2px", outline.width);
			assertEquals("solid", outline.style);
			assertEquals("red", outline.color);
			assertEquals("1px", outline.offset);
			assertEquals(4, leaves.length);
			assertEquals("outline-width:2px;", ILeafStyleBead(leaves[0]).getRule());
			assertEquals("outline-style:solid;", ILeafStyleBead(leaves[1]).getRule());
			assertEquals("outline-color:red;", ILeafStyleBead(leaves[2]).getRule());
			assertEquals("outline-offset:1px;", ILeafStyleBead(leaves[3]).getRule());
		}

		[Test]
		public function testConstructorSkipsNullOptionalArguments():void
		{
			var outline:Outline = new Outline(null, "dashed");

			assertNull(outline.width);
			assertEquals("dashed", outline.style);
			assertNull(outline.color);
			assertNull(outline.offset);
			assertEquals(1, outline.getLeaves().length);
		}
	}
}