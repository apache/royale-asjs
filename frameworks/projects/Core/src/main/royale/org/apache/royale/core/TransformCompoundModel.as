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
package org.apache.royale.core
{
	import org.apache.royale.geom.Matrix;

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
					product.concat(current);
				}
				matrix = product;
			} else
			{
				matrix = null;
			}
		}
	}
}
