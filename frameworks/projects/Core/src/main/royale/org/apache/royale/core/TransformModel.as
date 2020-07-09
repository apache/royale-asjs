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
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.geom.Matrix;
	import org.apache.royale.utils.sendStrandEvent;
	
	public class TransformModel extends EventDispatcher implements ITransformModel
	{
		
		public static const CHANGE:String = "transferModelChange";
		
		private var _matrix:Matrix;
		protected var _strand:IStrand;
		
		public function TransformModel()
		{
		}
		
		public function get matrix():Matrix
		{
			return _matrix;
		}

		private function dispatchModelChangeEvent():void
		{
			sendStrandEvent(_strand,CHANGE);
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.core.ITransformHost
		 */
		private function get host():ITransformHost
		{
			return _strand as ITransformHost;
		}
		
		public function set matrix(value:Matrix):void
		{
			_matrix = value;
			if (_strand)
			{
				dispatchModelChangeEvent();
			}
		}
		
		public function set strand(value:IStrand):void 
		{
			_strand = value;
			dispatchModelChangeEvent();
		}

	}
}
