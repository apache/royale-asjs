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
import mx.containers.TabNavigator;
import mx.containers.ViewStack;
import mx.containers.beads.BoxLayout;
import mx.containers.beads.ViewStackLayout;
import mx.controls.TabBar;
import mx.core.ContainerLayout;
import mx.core.INavigatorContent;
import mx.core.UIComponent;

import org.apache.royale.core.IBead;
import org.apache.royale.core.IChild;
import org.apache.royale.core.IContainerBaseStrandChildrenHost;
import org.apache.royale.core.ILayoutView;
import org.apache.royale.core.ISelectionModel;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.UIBase;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.html.beads.GroupView;
import org.apache.royale.html.supportClasses.PanelLayoutProxy;


/**
 *  @private
 *  The TabNavigatorView for emulation.
 */
public class TabNavigatorView extends GroupView
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
	public function TabNavigatorView()
	{
		super();
	}

    private var _tabBar:UIBase;
    
    /**
     *  The org.apache.royale.html.ButtonBar component of the
     *  mx.containers.TabNavigator.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    public function get tabBar():UIBase
    {
        return _tabBar;
    }
    
    /**
     *  @private
     */
    public function set tabBar(value:UIBase):void
    {
        _tabBar = value;
    }

    private var _contentArea:UIBase;
    
    /**
     * The content area of the TabNavigator.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public function get contentArea():UIBase
    {
        return _contentArea;
    }
    public function set contentArea(value:UIBase):void
    {
        _contentArea = value;
    }

    /**
     * @royaleignorecoercion org.apache.royale.core.UIBase; 
     * @royaleignorecoercion mx.containers.beads.models.PanelModel; 
     */
    override public function set strand(value:IStrand):void
    {
        super.strand = value;
        
        tabBar = new TabBar();
        tabBar.percentWidth = 100;
        tabBar.addEventListener("change", tabChangeHandler);
        addEventListener("change", tabChangeHandler);
        if (tabBar.parent == null) {
            (_strand as IContainerBaseStrandChildrenHost).$addElement(tabBar);
        }
            
        if (!_contentArea) {
            var cls:Class = ValuesManager.valuesImpl.getValue(_strand, "iTabNavigatorContentArea");
            var viewportClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iViewport");
            _contentArea = new cls() as UIBase;
            if (viewportClass)
            {
                _contentArea.addBead((new viewportClass()) as IBead)
            }
            _contentArea.id = "tabNavigatorContent";
            _contentArea.typeNames = "TabNavigatorContent";
        }
        contentArea.percentWidth = 100;
        contentArea.percentHeight = 100;
        // try to listen for childrenAdded before ViewStackLayout listens for childrenAdded
        // so we can update the selection before the layout picks the visible child
        (_strand as IEventDispatcher).addEventListener("childrenAdded", childrenAddedHandler);
        contentArea.addEventListener("childrenAdded", childrenAddedHandler);
        var vsl:ViewStackLayout = new ViewStackLayout();
        vsl.target = contentArea as UIComponent;
        vsl.model = tabBar.model as ISelectionModel;
        contentArea.addBead(vsl);
        if (contentArea.parent == null) {
            (_strand as IContainerBaseStrandChildrenHost).$addElement(contentArea as IChild);
        }
        
        // Now give the TabNavigator its own layout
        var boxLayout:BoxLayout = new BoxLayout();
        boxLayout.direction = "vertical";
        _strand.addBead(boxLayout);
        
    }
    
    private var tabDP:Array = [];
    
    private function childrenAddedHandler(event:Event):void
    {
        tabDP = [];
        var n:int = contentArea.numElements;
        for (var i:int = 0; i < n; i++)
        {
            var child:INavigatorContent = contentArea.getElementAt(i) as INavigatorContent;
            tabDP.push({ label: child.label});
            // run this again if the label changes
            child.addEventListener("labelChanged", childrenAddedHandler);
        }
        (tabBar as TabBar).dataProvider = tabDP;
        if ((tabBar.model as ISelectionModel).selectedIndex == -1 && n > 0)
        {
            (tabBar.model as ISelectionModel).selectedIndex = 0;
            var tabNavigator:TabNavigator = _strand as TabNavigator;
            if (tabNavigator)
            {
                tabNavigator.selectedIndex = 0;
            }
        }
    }
    
    private var _panelLayoutProxy:PanelLayoutProxy;
    
    /**
     * The sub-element used as the parent of the container's elements. This does not
     * include the chrome elements.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    override public function get contentView():ILayoutView
    {
        // we want to return a proxy for the host which will have numElements, getElementAt, etc.
        // functions that will use the host.$numElements, host.$getElementAt, etc. functions
        if (_panelLayoutProxy == null) {
            _panelLayoutProxy = new PanelLayoutProxy(_strand);
        }
        return _panelLayoutProxy;
    }
    
    private function tabChangeHandler(event:Event):void
    {
        (_strand as TabNavigator).selectedIndex = (tabBar as TabBar).selectedIndex;
    }

}

}
