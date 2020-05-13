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

import spark.components.Panel;
import spark.components.SkinnableContainer;
import mx.containers.PanelTitleBar;
import mx.containers.beads.models.PanelModel;
import mx.core.UIComponent;
import spark.layouts.BasicLayout;
import spark.layouts.VerticalLayout;

import org.apache.royale.core.IBead;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.UIBase;
import org.apache.royale.html.beads.PanelView;

/**
 *  @private
 *  The PanelView for emulation.
 */
public class PanelView extends org.apache.royale.html.beads.PanelView
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
	public function PanelView()
	{
		super();
	}

    /**
     */
    override public function set strand(value:IStrand):void
    {
        titleBar = new PanelTitleBar();
        super.strand = value;
    }
    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion org.apache.royale.core.UIBase
     * @royaleignorecoercion mx.containers.beads.models.PanelModel 
     */
    override protected function setupContentAreaLayout():void
    {
        var host:SkinnableContainer = _strand as SkinnableContainer;
        var model:PanelModel = host.model as PanelModel;
        if (model.paddingBottom)
            (contentArea as UIComponent).paddingBottom = model.paddingBottom;
        if (model.paddingTop)
            (contentArea as UIComponent).paddingTop = model.paddingTop;
        if (model.paddingLeft)
            (contentArea as UIComponent).paddingLeft = model.paddingLeft;
        if (model.paddingRight)
            (contentArea as UIComponent).paddingRight = model.paddingRight;
        
        if (!host.isWidthSizedToContent())
            contentArea.percentWidth = 100;
        if (!host.isHeightSizedToContent())
            contentArea.percentHeight = 100;
            
        var layoutObject:IBead = host.layout as IBead;
        if (layoutObject)
            contentArea.addBead(layoutObject);            
        
    }
    
    override protected function setupLayout():void
    {
        titleBar.percentWidth = 100;
            
        var panel:ILayoutChild = host as ILayoutChild;
        if (!panel.isWidthSizedToContent())
            contentArea.percentWidth = 100;
        if (!panel.isHeightSizedToContent())
            contentArea.percentHeight = 100;
        
        // Now give the Panel its own layout
        var layout:PanelLayout = new PanelLayout();
        _strand.addBead(layout);
    }
}

}

import mx.core.UIComponent;
import spark.components.Panel;
import org.apache.royale.core.LayoutBase;

class PanelLayout extends LayoutBase
{
    override public function layout():Boolean
    {
        var panel:Panel = host as Panel;
        var titleBar:UIComponent = panel.$getElementAt(0) as UIComponent;
        var content:UIComponent = panel.$getElementAt(1) as UIComponent;
        var w:Number = panel.width;
        var h:Number = panel.height;
        if (panel.isWidthSizedToContent())
            w = content.width + 2;
        if (panel.isHeightSizedToContent())
            h = content.height + 2 + titleBar.getExplicitOrMeasuredHeight();
        titleBar.setActualSize(w - 2, titleBar.getExplicitOrMeasuredHeight());
        content.setActualSize(w - 2, h - titleBar.height - 2 - 1);
        content.move(0, titleBar.height + 1);
        return false;
    }
}
