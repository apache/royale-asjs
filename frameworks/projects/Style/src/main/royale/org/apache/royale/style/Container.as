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
package org.apache.royale.style
{
	import org.apache.royale.binding.DataBindingBase;
	import org.apache.royale.binding.ContainerDataBinding;

	/**
	 *  Minimum container which supports binding.
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 1.0.0
	 */
	public class Container extends Group
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function Container()
		{
			super();
		}
		override public function addedToParent():void{
			if (!_bindingsInited) initBindings()
			super.addedToParent();
		}
		
		private var _bindingsInited:Boolean
		protected function initBindings():void{
			_bindingsInited = true;
			if ('_bindings' in this && !getBeadByType(DataBindingBase)) {
				addBead(new ContainerDataBinding());
			}
		}

	}
}