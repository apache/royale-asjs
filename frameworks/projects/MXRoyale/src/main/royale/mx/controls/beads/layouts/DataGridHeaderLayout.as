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

package mx.controls.beads.layouts
{
    import mx.controls.dataGridClasses.DataGridHeaderRenderer;
	import mx.core.EdgeMetrics;
	import mx.core.UIComponent;
	
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.geom.Rectangle;
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.ILayoutChild;
    import org.apache.royale.core.ILayoutView;
    import org.apache.royale.core.IStyleableObject;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModel;
    import org.apache.royale.html.beads.models.ButtonBarModel;
	import org.apache.royale.events.Event;

/*
import mx.core.mx_internal;
import mx.events.ChildExistenceChangedEvent;
import mx.events.MoveEvent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import flash.utils.Dictionary;

use namespace mx_internal;
*/

/**
 *  @private
 *  The mx DataGridHeaderLayout class is for internal use only.
 */
public class DataGridHeaderLayout extends LayoutBase
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
    public function DataGridHeaderLayout()
    {
        super();
    }
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	private var _strand:IStrand;
	
    /**
     *  @royaleignorecoercion org.apache.royale.core.IStrandWithModel
     */
	override public function set strand(value:IStrand):void
	{
		_strand = value;
		super.strand = value;
		(host as IStrandWithModel).model.addEventListener("dataProviderChanged", dataProviderChangedHandler);
	}
	
	private var sawDPChanged:Boolean;
	
	private function dataProviderChangedHandler(event:Event):void
	{
		sawDPChanged = true;
	}
	
    private var _buttonWidths:Array = null;
    
    /**
     *  An array of widths (Number), one per button. These values supersede the
     *  default of equally-sized buttons.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    public function get buttonWidths():Array
    {
        return _buttonWidths;
    }
    public function set buttonWidths(value:Array):void
    {
        _buttonWidths = value;
    }
    

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

	override public function layout():Boolean
	{
		// ignore other lifecycle layouts until the DP is set
		if (!sawDPChanged) 
			return true;
		
        var contentView:ILayoutView = layoutView;
        
        var model:ButtonBarModel = (host as IStrand).getBeadByType(ButtonBarModel) as ButtonBarModel;
        if (model) {
            buttonWidths = model.buttonWidths;
        }

        var n:int = contentView.numElements;
        if (n <= 0) return false;
        
        var xx:Number = 0;
        
        for (var i:int=0; i < n; i++)
        {	
            var ilc:ILayoutChild = contentView.getElementAt(i) as ILayoutChild;
            if (ilc == null || !ilc.visible) continue;
            if (!(ilc is DataGridHeaderRenderer)) continue;
            
            COMPILE::SWF {
                if (buttonWidths) {
                    var widthValue:* = buttonWidths[i];
                    
                    if (widthValue != null) ilc.width = Number(widthValue);
                    ilc.x = xx;
                    xx += ilc.width;
                }
            }
                
            COMPILE::JS {
                if (!host.isHeightSizedToContent())
                    ilc.height = contentView.height;
                if (buttonWidths) {
                    var widthValue:* = buttonWidths[i];
                    if (widthValue != null) ilc.width = Number(widthValue);
                    ilc.x = xx;
                    xx += ilc.width;
                }                
            }
        }
        
        return true;
	}
}
}

