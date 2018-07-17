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

import mx.core.ContainerLayout;
import mx.containers.BoxDirection;
import mx.containers.beads.BoxLayout;
import mx.containers.beads.CanvasLayout;
import mx.containers.beads.models.PanelModel;

import org.apache.royale.html.beads.PanelView;
import org.apache.royale.core.IBead;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.UIBase;

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
     * @royaleignorecoercion org.apache.royale.core.UIBase; 
     * @royaleignorecoercion mx.containers.beads.models.PanelModel; 
     */
    override public function set strand(value:IStrand):void
    {
        super.strand = value;
        var model:PanelModel = (value as UIBase).model as PanelModel;
        var _layout:String = model.layout;
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
            
        if (layoutObject)
            contentArea.addBead(layoutObject);            
    }
}

}
