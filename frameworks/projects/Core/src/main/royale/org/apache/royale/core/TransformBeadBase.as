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
	import org.apache.royale.geom.Matrix;

	COMPILE::SWF {
		import flash.display.Sprite;
		import flash.geom.Matrix;
	}
	
	public class TransformBeadBase implements IBead
	{
		protected var _strand:IStrand;
		
		public function TransformBeadBase()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			host.addEventListener(TransformModel.CHANGE, changeHandler);
			var model:ITransformModel = transformModel;
			if (model && model.matrix)
			{
				transform();
			}
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.core.ITransformModel
		 */
		public function get transformModel():ITransformModel
		{
			return host.getBeadByType(ITransformModel) as ITransformModel;
		}
				
		COMPILE::SWF
		public function transform():void
		{
			if (!transformModel || !transformModel.matrix)
			{
				return;
			}
			var element:Sprite = host.transformElement as Sprite;
			var fjsm:org.apache.royale.geom.Matrix = transformModel.matrix;
			var flashMatrix:flash.geom.Matrix = new flash.geom.Matrix(fjsm.a, fjsm.b, fjsm.c, fjsm.d, fjsm.tx, fjsm.ty);
			element.transform.matrix = flashMatrix;
		}
		/**
		 * @royaleignorecoercion HTMLElement
		 */
		COMPILE::JS
		public function transform():void
		{
			// implementors should override this
		}
		
		private function changeHandler(e:Event):void
		{
			transform();
		}
		
		/**
		 *  The host component. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.ITransformHost
		 */
		public function get host():ITransformHost
		{
			return _strand as ITransformHost;
		}
	}
}
