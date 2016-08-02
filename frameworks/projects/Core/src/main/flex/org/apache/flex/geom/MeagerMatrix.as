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
package org.apache.flex.geom
{
	
	public class MeagerMatrix implements IMatrix
	{
		public function MeagerMatrix(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0)
		{
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			this.tx = tx;
			this.ty = ty;
			
		}
		private var _a:Number;
		private var _b:Number;
		private var _c:Number;
		private var _d:Number;
		private var _tx:Number;
		private var _ty:Number;
		
		public function get ty():Number
		{
			return _ty;
		}
		
		public function set ty(value:Number):void
		{
			_ty = value;
		}
		
		public function get tx():Number
		{
			return _tx;
		}
		
		public function set tx(value:Number):void
		{
			_tx = value;
		}
		
		public function get d():Number
		{
			return _d;
		}
		
		public function set d(value:Number):void
		{
			_d = value;
		}
		
		public function get c():Number
		{
			return _c;
		}
		
		public function set c(value:Number):void
		{
			_c = value;
		}
		
		public function get b():Number
		{
			return _b;
		}
		
		public function set b(value:Number):void
		{
			_b = value;
		}
		
		public function get a():Number
		{
			return _a;
		}
		
		public function set a(value:Number):void
		{
			_a = value;
		}
		
		public function clone():IMatrix
		{
			return new MeagerMatrix(a, b, c, d, tx, ty);
		}
	}
}
