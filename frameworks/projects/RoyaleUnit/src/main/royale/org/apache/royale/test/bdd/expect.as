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
package org.apache.royale.test.bdd
{
	/**
	 * Allows chaining of BDD-style assertions using natural language.
	 */
	public function expect(value:*):IExpect
	{
		return new Expect(value);
	}
}

import org.apache.royale.test.bdd.IExpect;
import org.apache.royale.test.Assert;

class Expect implements IExpect
{
	public function Expect(value:*)
	{
		_value = value;
	}

	private var _value:*;
	private var _not:Boolean;

	public function equal(value:*, message:String = null):IExpect
	{
		if (_not)
		{
			Assert.assertNotEquals(_value, value, message);
		}
		else
		{
			Assert.assertEquals(_value, value, message);
		}
		return this;
	}

	public function equals(value:*, message:String = null):IExpect
	{
		return equal(value, message);
	}

	public function eq(value:*, message:String = null):IExpect
	{
		return equal(value, message);
	}

	public function strictlyEqual(value:*, message:String = null):IExpect
	{
		if (_not)
		{
			Assert.assertNotStrictlyEquals(_value, value, message);
		}
		else
		{
			Assert.assertStrictlyEquals(_value, value, message);
		}
		return this;
	}

	public function strictlyEquals(value:*, message:String = null):IExpect
	{
		return strictlyEqual(value, message);
	}

	public function within(minimum:Number, maximum:Number, message:String = null):IExpect
	{
		if (_not)
		{
			Assert.assertNotWithin(_value, minimum, maximum, message);
		}
		else
		{
			Assert.assertWithin(_value, minimum, maximum, message);
		}
		return this;
	}

	public function lessThan(other:Number, message:String = null):IExpect
	{
		if (_not)
		{
			Assert.failLessThan(_value, other, message);
		}
		else
		{
			Assert.assertLessThan(_value, other, message);
		}
		return this;
	}

	public function greaterThan(other:Number, message:String = null):IExpect
	{
		if (_not)
		{
			Assert.failGreaterThan(_value, other, message);
		}
		else
		{
			Assert.assertGreaterThan(_value, other, message);
		}
		return this;
	}

	public function lessThanOrEqual(other:Number, message:String = null):IExpect
	{
		if (_not)
		{
			Assert.failLessThanOrEqual(_value, other, message);
		}
		else
		{
			Assert.assertLessThanOrEqual(_value, other, message);
		}
		return this;
	}

	public function greaterThanOrEqual(other:Number, message:String = null):IExpect
	{
		if (_not)
		{
			Assert.failGreaterThanOrEqual(_value, other, message);
		}
		else
		{
			Assert.assertGreaterThanOrEqual(_value, other, message);
		}
		return this;
	}

	public function lt(other:Number, message:String = null):IExpect
	{
		return lessThan(other, message);
	}

	public function lte(other:Number, message:String = null):IExpect
	{
		return lessThanOrEqual(other, message);
	}

	public function gt(other:Number, message:String = null):IExpect
	{
		return greaterThan(other, message);
	}

	public function gte(other:Number, message:String = null):IExpect
	{
		return greaterThanOrEqual(other, message);
	}

	public function get not():IExpect
	{
		_not = !_not;
		return this;
	}

	public function get true():IExpect
	{
		if (_not)
		{
			Assert.failTrue(_value);
		}
		else
		{
			Assert.assertTrue(_value);
		}
		return this;
	}

	public function get false():IExpect
	{
		if (_not)
		{
			Assert.failFalse(_value);
		}
		else
		{
			Assert.assertFalse(_value);
		}
		return this;
	}

	public function get null():IExpect
	{
		if (_not)
		{
			Assert.assertNotNull(_value);
		}
		else
		{
			Assert.assertNull(_value);
		}
		return this;
	}

	public function get NaN():IExpect
	{
		if (_not)
		{
			Assert.failNaN(_value);
		}
		else
		{
			Assert.assertNaN(_value);
		}
		return this;
	}

	public function get to():IExpect
	{
		return this;
	}

	public function get be():IExpect
	{
		return this;
	}

	public function get been():IExpect
	{
		return this;
	}

	public function get is():IExpect
	{
		return this;
	}

	public function get that():IExpect
	{
		return this;
	}

	public function get which():IExpect
	{
		return this;
	}

	public function get and():IExpect
	{
		return this;
	}

	public function get has():IExpect
	{
		return this;
	}

	public function get have():IExpect
	{
		return this;
	}

	public function get with():IExpect
	{
		return this;
	}

	public function get at():IExpect
	{
		return this;
	}

	public function get of():IExpect
	{
		return this;
	}

	public function get same():IExpect
	{
		return this;
	}

	public function get but():IExpect
	{
		return this;
	}

	public function get does():IExpect
	{
		return this;
	}
}