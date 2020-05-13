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
package org.apache.royale.jewel.beads.layouts
{
	/**
	 *  Jewel IGap is the interface used by Jewel Layouts that implement gaps.
	 */
	public interface IGap
	{
		/**
		 *  Assigns variable gap in steps of GAP_STEP. You have available GAPS*GAP_STEP gap styles
		 *  Activate "gap-{X}x{GAP_STEP}px" effect selector to set a numeric gap between elements.
		 *  i.e: gap-2x3px will result in a gap of 6px
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		function get gap():Number;
		function set gap(value:Number):void;
	}
}