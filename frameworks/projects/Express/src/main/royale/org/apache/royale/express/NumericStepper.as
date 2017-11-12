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
package org.apache.royale.express
{
    import org.apache.royale.html.NumericStepper;

	/**
	 *  The NumericStepper class is a component that displays a numeric
	 *  value and up/down controls (using a org.apache.royale.html.Spinner) to
	 *  increase and decrease the value by specific amounts. The NumericStepper uses the following beads:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model for the component of type org.apache.royale.core.IRangeModel.
	 *  org.apache.royale.core.IBeadView: constructs the parts of the component.
	 *  org.apache.royale.core.IBeadController: handles the input events.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class NumericStepper extends org.apache.royale.html.NumericStepper
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function NumericStepper()
		{
			super();
		}

		override public function set minimum(value:Number):void
		{
            super.minimum = value;
            if(value > this.value)
                this.value = value;
		}

	}
}
