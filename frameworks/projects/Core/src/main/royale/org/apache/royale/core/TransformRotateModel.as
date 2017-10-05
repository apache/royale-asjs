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
	
	
	public class TransformRotateModel extends TransformModel
	{
		private var _angle:Number;
		
		public function TransformRotateModel()
		{
		}
		
		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle = value;
			var radians:Number = value * Math.PI/180;
			matrix = new Matrix(Math.cos(radians), Math.sin(radians), -Math.sin(radians), Math.cos(radians));
		}


	}
}
