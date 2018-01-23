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
package org.apache.royale.text.ime
{

/**
 *  The IIMESupport interface defines the interface for any component that supports IME 
 *  (input method editor).
 *  IME is used for entering characters in Chinese, Japanese, and Korean.
 * 
 *  @see org.apache.royale.text.ime.IME
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 1.0.0
 */
public interface IIMESupport
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  enableIME
	//----------------------------------

	/**
     *  Specifies whether the IME should be enabled when
     *  this component has focus.  Even if a component
     *  uses the IME, it may not in all configurations.
     *  For example, TextArea will set enableIME to false
     *  if its <code>editable</code> is <code>false</code> since no
     *  input is allowed in that configuration.  Similarly
     *  DataGrid always sets enableIME to false.  If
     *  the DataGrid puts up an ItemEditor, its editor
     *  will have <code>enableIME</code> set to <code>true</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	function get enableIME():Boolean;

	//----------------------------------
	//  imeMode
	//----------------------------------

	/**
	 *  The IME mode of the component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 */
	function get imeMode():String;

	/**
	 *  @private
	 */
	function set imeMode(value:String):void;


}

}
