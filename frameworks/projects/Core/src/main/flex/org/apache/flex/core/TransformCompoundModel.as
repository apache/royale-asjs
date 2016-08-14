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
package org.apache.flex.core
{
	import org.apache.flex.geom.Matrix;

	[DefaultProperty("transformModels")]
	public class TransformCompoundModel extends TransformModel
	{
		public function set transformModels(value:Array):void
		{
			if (value && value.length > 0)
			{
				var length:int = value.length;
				var product:Matrix = (value[0] as ITransformModel).matrix.clone();
				for (var i:int = 1; i < length; i++)
				{
					var current:Matrix = (value[i] as ITransformModel).matrix;
					concat(product, current);
				}
				matrix = product;
			} else
			{
				matrix = null;
			}
		}
		
		private function concat(product:Matrix, factor:Matrix):void
		{
			var result_a:Number = product.a * factor.a;
			var result_b:Number = 0.0;
			var result_c:Number = 0.0;
			var result_d:Number = product.d * factor.d;
			var result_tx:Number = product.tx * factor.a + factor.tx;
			var result_ty:Number = product.ty * factor.d + factor.ty;
			if (product.b != 0.0 || product.c != 0.0 || factor.b != 0.0 || factor.c != 0.0)
			{
				result_a = result_a + product.b * factor.c;
				result_d = result_d + product.c * factor.b;
				result_b = result_b + (product.a * factor.b + product.b * factor.d);
				result_c = result_c + (product.c * factor.a + product.d * factor.c);
				result_tx = result_tx + product.ty * factor.c;
				result_ty = result_ty + product.tx * factor.b;
			}
			product.a = result_a;
			product.b = result_b;
			product.c = result_c;
			product.d = result_d;
			product.tx = result_tx;
			product.ty = result_ty;
		}
		
	}
}