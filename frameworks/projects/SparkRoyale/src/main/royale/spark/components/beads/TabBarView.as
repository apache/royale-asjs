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

package spark.components.beads
{

import spark.components.SkinnableContainer;
import org.apache.royale.events.Event;
import org.apache.royale.core.IStrand;
import spark.core.IGapLayout;

/**
 *  @private
 *  The SkinnableContainerView for emulation.
 */
public class TabBarView extends SkinnableContainerView
{
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
	 *  @productversion Flex 3
	 */
	public function TabBarView()
	{
		super();
	}

	override protected function handleInitComplete(event:Event):void
	{
		super.handleInitComplete();
		var gapLayout:IGapLayout = (contentView as IStrand).getBeadByType(IGapLayout) as IGapLayout;
		if (gapLayout)
		{
			gapLayout.gap = 0;
		}
	}
    
}

}
