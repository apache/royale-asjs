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

import mx.core.Container;

import org.apache.royale.core.IBead;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.UIBase;
import org.apache.royale.html.beads.ContainerView;
import org.apache.royale.events.Event;

/**
 *  @private
 *  The PanelView for emulation.
 */
public class PanelInternalContainerView extends org.apache.royale.html.beads.ContainerView
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
	public function PanelInternalContainerView()
	{
		super();
	}
    
	/**
	 * Strand setter.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	override public function set strand(value:IStrand):void
	{
		super.strand = value;

		var container:Container = host as Container;
		var panel:Container = container.parent as Container;
		panel.addEventListener("widthChanged", handleSizeChanged);
		panel.addEventListener("heightChanged", handleSizeChanged);
		panel.addEventListener("sizeChanged", handleSizeChanged);
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
    override public function beforeLayout():Boolean
    {
		var container:Container = host as Container;
		var panel:Container = container.parent as Container;
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
