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
	import mx.containers.TabNavigator;
	import mx.containers.ViewStack;
	import mx.core.EdgeMetrics;
	import mx.core.UIComponent;
	
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.geom.Rectangle;

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
 *  The ViewStackLayout class is for internal use only.
 */
public class ViewStackLayout extends LayoutBase
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
    public function ViewStackLayout()
    {
        super();
    }
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	private var _strand:IStrand;
	
	override public function set strand(value:IStrand):void
	{
		_strand = value;
		_target = value as UIComponent;
		super.strand = value;
		
	}
	
	private var _target:UIComponent;
	
	public function get target():UIComponent
	{
		return _target;
	}
	
	public function set target(value:UIComponent):void
	{
		_target = value;
	}

    private var _model:ISelectionModel;
    
    public function get model():ISelectionModel
    {
        return _model;
    }
    
    public function set model(value:ISelectionModel):void
    {
        _model = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

	override public function layout():Boolean
	{
        var selectedIndex:int = model.selectedIndex;
        var n:int = target.numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:UIComponent = target.getChildAt(i) as UIComponent;
            child.visible = i == selectedIndex;
            child.setWidthAndHeight(target.width, target.height);
        }
		return true;
	}
}
}

