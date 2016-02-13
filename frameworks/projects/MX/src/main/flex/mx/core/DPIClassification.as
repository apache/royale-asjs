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

package mx.core
{

/**
 *  An enum of the device screen density classess.  
 *
 *  When working with DPI, Flex collapses similar DPI values into DPI classes.
 *
 *  @see spark.components.Application#applicationDPI
 *  @see spark.components.Application#runtimeDPI
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public final class DPIClassification
{
	/**
	 *  Density value for extra-low-density devices.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion ApacheFlex 4.11
	 */
	public static const DPI_120:Number = 120;
	
    /**
     *  Density value for low-density devices.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const DPI_160:Number = 160;

    /**
     *  Density value for medium-density devices.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const DPI_240:Number = 240;

	/**
	 *  Density value for high-density devices.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public static const DPI_320:Number = 320;
	
	/**
	 *  Density value for extra-high-density devices.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion ApacheFlex 4.10
	 */
	public static const DPI_480:Number = 480;
	
	/**
	 *  Density value for extra-extra-high-density devices.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion ApacheFlex 4.11
	 */
	public static const DPI_640:Number = 640;
}
}