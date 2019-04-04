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

import org.apache.royale.core.IBead;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.UIBase;
import org.apache.royale.html.beads.ContainerView;

/**
 *  @private
 *  The SkinnableContainerView for emulation.
 */
public class SkinnableContainerView extends ContainerView
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

    /**
     */
    override public function set strand(value:IStrand):void
    {
        super.strand = value;
        var host:SkinnableContainer = _strand as SkinnableContainer;
        var g:GroupBase = (contentView as GroupBase);
        g.layout = host.layout;
        
        if (!host.isWidthSizedToContent())
            g.percentWidth = 100;
        if (!host.isHeightSizedToContent())
            g.percentHeight = 100;

    }
    
}

}
