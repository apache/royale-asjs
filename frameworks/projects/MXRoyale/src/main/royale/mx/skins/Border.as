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

package mx.skins
{

import mx.core.EdgeMetrics;
import org.apache.royale.html.supportClasses.Border;

/**
 *  The Border class is an abstract base class for various classes that
 *  draw borders, either rectangular or non-rectangular, around UIComponents.
 *  This class does not do any actual drawing itself.
 *
 *  <p>If you create a new non-rectangular border class, you should extend
 *  this class.
 *  If you create a new rectangular border class, you should extend the
 *  abstract subclass RectangularBorder.</p>
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class Border extends org.apache.royale.html.supportClasses.Border 
{
	//include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function Border()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  borderMetrics
	//----------------------------------

	/**
	 *  The thickness of the border edges.
	 *
	 *  @return EdgeMetrics with left, top, right, bottom thickness in pixels
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function get borderMetrics():EdgeMetrics
	{
		return EdgeMetrics.EMPTY;
	}
}

}
