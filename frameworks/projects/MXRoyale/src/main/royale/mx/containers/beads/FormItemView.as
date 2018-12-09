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

package mx.containers.beads
{

import mx.containers.BoxDirection;
import mx.containers.Panel;
import mx.containers.PanelTitleBar;
import mx.containers.beads.BoxLayout;
import mx.containers.beads.CanvasLayout;
import mx.containers.beads.models.PanelModel;
import mx.core.ContainerLayout;
import mx.core.UIComponent;

import org.apache.royale.core.IBead;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.IViewport;
import org.apache.royale.core.UIBase;
import org.apache.royale.html.beads.ContainerView;
import org.apache.royale.html.beads.layouts.VerticalFlexLayout;

/**
 *  @private
 *  The FormItemView for emulation.
 */
public class FormItemView extends org.apache.royale.html.beads.ContainerView
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
	public function FormItemView()
	{
		super();
	}

    /**
     * The content area of the formItem.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     * 
     *  @royaleignorecoercion org.apache.royale.core.UIBase;
     *  @royaleignorecoercion org.apache.royale.core.IViewport;
     */
    public function get contentArea():UIBase
    {
        return (_strand.getBeadByType(IViewport) as IViewport).contentView as UIBase;
    }

}

}
