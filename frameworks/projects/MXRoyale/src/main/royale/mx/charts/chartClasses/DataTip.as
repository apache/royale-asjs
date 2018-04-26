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

package mx.charts.chartClasses
{

//import flash.display.DisplayObject;
//import flash.display.Graphics;
//import flash.geom.Rectangle;
//import flash.text.TextFieldAutoSize;
//import flash.text.TextFormat;
//import flash.utils.Dictionary;

import mx.charts.HitData;
//import mx.charts.styles.HaloDefaults;
import mx.core.IDataRenderer;
//import mx.core.IUITextField;
import mx.core.UIComponent;
//import mx.core.UITextField;
import mx.events.FlexEvent;
import mx.graphics.IFill;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
//import mx.styles.CSSStyleDeclaration;
//import mx.core.IFlexModuleFactory;


/**
 *  The DataTip control provides information
 *  about a data point to chart users.
 *  When a user moves their mouse over a graphical element, the DataTip
 *  control displays text that provides information about the element.
 *  You can use DataTip controls to guide users as they work with your
 *  application or customize the DataTips to provide additional functionality.
 *
 *  <p>To enable DataTips on a chart, set its <code>showDataTips</code>
 *  property to <code>true</code>.</p>
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DataTip extends UIComponent implements IDataRenderer
{
/*     include "../../core/Version.as";
 */	
   
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
    public function DataTip()
    {
        super();

       // mouseChildren = false;
       // mouseEnabled = false;
    }

  
   
  
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  data
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The HitData structure describing the data point
     *  that the DataTip is rendering.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get data():Object
    {
      return super.data();
    }

    /**
     *  @private
     */
    public function set data(value:Object):void
    {
      super.data(value);
        
        invalidateDisplayList();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

	
	
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function createChildren():void
    {
        super.createChildren();

    }

   
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

      
    }

    
}

}
