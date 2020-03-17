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
import mx.core.Container;
import mx.core.ContainerLayout;
import mx.core.UIComponent;

import org.apache.royale.core.IBead;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.UIBase;
import org.apache.royale.html.beads.PanelView;
import org.apache.royale.html.beads.layouts.VerticalFlexLayout;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;

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
     * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
     */
    override public function set strand(value:IStrand):void
    {
        titleBar = new PanelTitleBar();
		var panel:IEventDispatcher = value as IEventDispatcher;
		panel.addEventListener("widthChanged", handleSizeChanged);
		panel.addEventListener("heightChanged", handleSizeChanged);
		panel.addEventListener("sizeChanged", handleSizeChanged);
        super.strand = value;
	}
	
	private var sawSizeChanged:Boolean;
	
	private function handleSizeChanged(event:Event):void
	{
		sawSizeChanged = true;
	}
	    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion org.apache.royale.core.UIBase
     * @royaleignorecoercion mx.containers.beads.models.PanelModel 
     */
    override protected function setupContentAreaLayout():void
    {
        var host:UIBase = _strand as UIBase;
        var model:PanelModel = host.model as PanelModel;
        var _layout:String = model.layout;
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
            
        var layoutObject:IBead;
        if (_layout == ContainerLayout.ABSOLUTE)
            layoutObject = new CanvasLayout();
        else
        {
            layoutObject = new BoxLayout();
            
            if (_layout == ContainerLayout.VERTICAL)
                BoxLayout(layoutObject).direction
                    = BoxDirection.VERTICAL;
            else
                BoxLayout(layoutObject).direction
                    = BoxDirection.HORIZONTAL;
        }
        
        (contentArea as Container).horizontalAlign = (host as Container).horizontalAlign;
        
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
        var boxLayout:BoxLayout = new BoxLayout();
        boxLayout.direction = "vertical";
        _strand.addBead(boxLayout);
    }

	/**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion org.apache.royale.core.UIBase
     * @royaleignorecoercion mx.containers.beads.models.PanelModel 
     */
    override public function beforeLayout():Boolean
    {
		var panel:Container = host as Container;
		if (!isNaN(panel.explicitWidth) && !isNaN(panel.explicitHeight))
			return true;
		if (!panel.isWidthSizedToContent() || !panel.isHeightSizedToContent())
		{
			return sawSizeChanged;
		}
        return true;
    }

}

}
