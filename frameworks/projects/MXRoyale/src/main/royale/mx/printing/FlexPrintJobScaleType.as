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

package mx.printing
{

/**
 *  Values for the <code>scaleType</code> property
 *  of the FlexPrintJob.addObject() method parameter.
 * 
 *  @see FlexPrintJob#addObject()
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public final class FlexPrintJobScaleType
{
/* 	include "../core/Version.as";
 */
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  Scales the object to fill at least one page completely; 
	 *  that is, it selects the larger of the MATCH_WIDTH or MATCH_HEIGHT 
	 *  scale types.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	//public static const FILL_PAGE:String = "fillPage";
	
	/**
	 *  Scales the object to fill the available page height. 
	 *  If the resulting object width exceeds the page width, the output 
	 *  spans multiple pages.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	//public static const MATCH_HEIGHT:String = "matchHeight";

	/**
	 *  Scales the object to fill the available page width. 
	 *  If the resulting object height exceeds the page height, the output 
	 *  spans multiple pages.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	//public static const MATCH_WIDTH:String = "matchWidth";
	
	/**
	 *  Does not scale the output. 
	 *  The printed page has the same dimensions as the object on the screen. 
	 *  If the object height, width, or both dimensions exceed the page width 
	 *  or height, the output spans multiple pages.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	//public static const NONE:String = "none";

	/**
	 *  Scales the object to fit on a single page, filling one dimension; 
	 *  that is, it selects the smaller of the MATCH_WIDTH or MATCH_HEIGHT 
	 *  scale types.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public static const SHOW_ALL:String = "showAll";
	public static const MATCH_WIDTH:String = "matchWidth";
}

}

