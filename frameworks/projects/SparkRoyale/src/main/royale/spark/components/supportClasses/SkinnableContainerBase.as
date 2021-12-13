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

package spark.components.supportClasses
{
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
// import flash.display.DisplayObject;

// import mx.core.ContainerGlobals;
import mx.core.IFlexDisplayObject;
	import mx.core.IUIComponent;
import mx.managers.IFocusManagerContainer;
	import spark.core.ISparkLayoutHost;

/**
 *  Normal State
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("normal")]

/**
 *  Disabled State
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("disabled")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="focusBlendMode", kind="style")]
[Exclude(name="focusThickness", kind="style")]

/**
 *  Base class for skinnable container components.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class SkinnableContainerBase extends SkinnableComponent implements IFocusManagerContainer, ILayoutParent
{
    // include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function SkinnableContainerBase()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties 
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  defaultButton
    //----------------------------------

    /**
     *  @private
     *  Storage for the defaultButton property.
     */
    private var _defaultButton:IFlexDisplayObject;

    [Inspectable(category="General")]

    /**
     *  The Button control designated as the default button for the container.
     *  When controls in the container have focus, pressing the
     *  Enter key is the same as clicking this Button control.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get defaultButton():IFlexDisplayObject
    {
        return _defaultButton;
    }

    /**
     *  @private
     */
    public function set defaultButton(value:IFlexDisplayObject):void
    {
        _defaultButton = value;
        // ContainerGlobals.focusedContainer = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
 
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override protected function getCurrentSkinState():String
    {
        return enabled ? "normal" : "disabled";
    }

    /**
     * Returns the ILayoutHost which is its view. From ILayoutParent.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public function getLayoutHost():ILayoutHost
    {
        return view as ILayoutHost;
    }

		//
		// Delegate to displayView
		//

		override public function get measuredWidth():Number
		{
			var lh:ISparkLayoutHost = getLayoutHost() as ISparkLayoutHost;
			var g:IUIComponent = (lh ? lh.displayView as IUIComponent : null);
			return g ? g.measuredWidth : super.measuredWidth;
		}
		
		override public function get measuredHeight():Number
		{
			var lh:ISparkLayoutHost = getLayoutHost() as ISparkLayoutHost;
			var g:IUIComponent = (lh ? lh.displayView as IUIComponent : null);
			return g ? g.measuredHeight : super.measuredHeight;
		}

		override public function setActualSize(w:Number, h:Number):void
		{
			super.setActualSize(w, h);

			var lh:ISparkLayoutHost = getLayoutHost() as ISparkLayoutHost;
			var g:IUIComponent = (lh ? lh.displayView as IUIComponent : null);
			if (g && g != this)
			{
				g.setActualSize(w, h);
				// TODO: See note in Spark Application.setActualSize().
//				g.width = w;
//				g.height = h;
			}
		}
}
}