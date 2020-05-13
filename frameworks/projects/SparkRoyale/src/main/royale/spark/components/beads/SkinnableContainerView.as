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
import spark.components.supportClasses.GroupBase;
import spark.components.supportClasses.SkinnableComponent;
import spark.components.supportClasses.Skin;
import spark.layouts.BasicLayout;

import org.apache.royale.core.IBead;
import org.apache.royale.core.IContainer;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.UIBase;

/**
 *  @private
 *  The SkinnableContainerView for emulation.
 */
public class SkinnableContainerView extends SparkContainerView
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
	public function SkinnableContainerView()
	{
		super();
	}

    override protected function prepareContentView():void
    {
        var host:SkinnableContainer = _strand as SkinnableContainer;
        if (host.skin)
        {
            if (!host.isWidthSizedToContent())
                host.skin.percentWidth = 100;
            if (!host.isHeightSizedToContent())
                host.skin.percentHeight = 100;            
        }
        else
            super.prepareContentView();
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
        var host:SkinnableContainer = _strand as SkinnableContainer;
        if (host.isWidthSizedToContent() || host.isHeightSizedToContent())
        {
            if (host.skin)
            {
                (host.skin as Skin).layout.measure();
                host.measuredHeight = host.skin.measuredHeight;
                host.measuredWidth = host.skin.measuredWidth;
            }
            else 
            {
                if (host.layout == null)
                    host.layout = new BasicLayout();
                host.layout.measure();
            }
        }
        else
        {
            if (host.skin)
            {
                host.skin.setLayoutBoundsSize(host.width, host.height);
            }
            else
            {
                (viewport.contentView as ILayoutChild).setWidthAndHeight(host.width, host.height);
            }
                
        }
		return true;
    }
    
    override protected function addViewport():void
    {
        var chost:IContainer = host as IContainer;
        var skinhost:SkinnableComponent = host as SkinnableComponent;
        if (chost != null && chost != viewport.contentView && skinhost.skin) {
            chost.addElement(skinhost.skin);
        }
        else
            super.addViewport();
    }

}

}
