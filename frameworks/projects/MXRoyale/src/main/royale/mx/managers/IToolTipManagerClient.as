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

package mx.managers
{

import mx.core.IFlexDisplayObject;

/**
 *  Components that implement IToolTipManagerClient can have tooltips and must 
 *  have a toolTip getter/setter.
 *  The ToolTipManager class manages showing and hiding the 
 *  tooltip on behalf of any component which is an IToolTipManagerClient.
 * 
 *  @see mx.controls.ToolTip
 *  @see mx.managers.ToolTipManager
 *  @see mx.core.IToolTip
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IToolTipManagerClient extends IFlexDisplayObject
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  toolTip
	//----------------------------------

	/**
	 *  The text of this component's tooltip.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get toolTip():String;
	
	/**
	 *  @private
	 */
	function set toolTip(value:String):void;

}

}
