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

package mx.controls
{

/**
 *  The ProgressBarMode class defines the values for the <code>mode</code> property
 *  of the ProgressBar class.
 *
 *  @see mx.controls.ProgressBar
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public final class ProgressBarMode
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The control specified by the <code>source</code> property must
	 *  dispatch <code>progress</code> and <code>completed</code> events. 
	 *  The ProgressBar uses these events to update its status.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const EVENT:String = "event";

	/**
	 *  You manually update the ProgressBar status. In this mode, you
	 *  specify the <code>maximum</code> and <code>minimum</code>
	 *  properties and use the <code>setProgress()</code> method
	 *  to specify the status. This mode is often used when the
	 *  <code>indeterminate</code> property is <code>true</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const MANUAL:String = "manual";

	/**
	 *  The <code>source</code> property must specify an object that
	 *  exposes the <code>getBytesLoaded()</code> and
	 *  <code>getBytesTotal()</code> methods.  The ProgressBar control
	 *  calls these methods to update its status.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const POLLED:String = "polled";
}

}