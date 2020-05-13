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

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

import org.apache.royale.core.IBead;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.UIBase;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.html.beads.GroupView;

/**
 *  @private
 *  The PanelView for emulation.
 */
public class GroupView extends org.apache.royale.html.beads.GroupView
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
	public function GroupView()
	{
		super();
	}

    /**
     *  Adjusts the size of the host after the layout has been run if needed
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royaleignorecoercion org.apache.royale.core.UIBase
     */
    override public function beforeLayout():Boolean
    {
        var host:GroupBase = _strand as GroupBase;
        // some Groups have left/right but are still sized to content.
        // the left/right create padding instead.  So isntead of
        // isWidthSizedToContent, we only check explicit and percent
        if (host.isWidthSizedToContent() || host.isHeightSizedToContent())
        {
            host.layout.measure();
        }
		return true;
    }
    
    /**
     *  Adjusts the size of the host after the layout has been run if needed
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royaleignorecoercion org.apache.royale.core.UIBase
     */
    override public function afterLayout():void
    {
        var host:UIBase = _strand as UIBase;
        if (host.isWidthSizedToContent() || host.isHeightSizedToContent())
        {
            // request re-run layout on the parent.  In theory, we should only
            // end up in afterLayout if the content size changed.
            if (host.parent)
            {
                (host.parent as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));   
            }
        }
    }


}

}

