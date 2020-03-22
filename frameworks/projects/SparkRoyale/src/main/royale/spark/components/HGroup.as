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

package spark.components
{
//import flash.events.Event;
import spark.layouts.HorizontalLayout;
//import spark.layouts.supportClasses.LayoutBase;

//[IconFile("HGroup.png")]

[Exclude(name="layout", kind="property")]

/**
 *  The HGroup container is an instance of the Group container 
 *  that uses the HorizontalLayout class.  
 *  Do not modify the <code>layout</code> property. 
 *  instead, use the properties of the HGroup class to modify the 
 *  characteristics of the HorizontalLayout class.
 *
 *  <p>The HGroup container has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
 *  </table>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;s:HGroup&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:HGroup
 *    <strong>Properties</strong>
 *    columnWidth="no default"
 *    gap="6"
 *    horizontalAlign="left"
 *    padding="0"
 *    paddingBottom="0"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    paddingTop="0"
 *    requestedColumnCount="-1"
 *    requestedMaxColumnCount="-1"
 *    requestedMinColumnCount="-1"
 *    variableColumnWidth"true"
 *    verticalAlign="top"
 *  /&gt;
 *  </pre>
 * 
 *  @see spark.layouts.HorizontalLayout
 *  @includeExample examples/HGroupExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class HGroup extends Group
{
   // include "../core/Version.as";

    /**
     *  Constructor. 
     *  Initializes the <code>layout</code> property to an instance of 
     *  the HorizontalLayout class.
     * 
     *  @see spark.layout.HorizontalLayout
     *  @see spark.components.VGroup
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */  
    public function HGroup():void
    {
        super();
        super.layout = new HorizontalLayout();
    }
    
    private function get horizontalLayout():HorizontalLayout
    {
        return HorizontalLayout(layout);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  gap
    //----------------------------------

    [Inspectable(category="General", defaultValue="6")]

    /**
     *  @copy spark.layouts.HorizontalLayout#gap
     * 
     *  @default 6
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get gap():int
    {
        return horizontalLayout.gap;
    }

    /**
     *  @private
     */
    public function set gap(value:int):void
    {
        horizontalLayout.gap = value;
    }

    //----------------------------------
    //  columnCount
    //----------------------------------

    /* [Bindable("propertyChange")]    
    [Inspectable(category="General")] */
        
    /**
     *  @copy spark.layouts.HorizontalLayout#columnCount
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get columnCount():int
    {
        return horizontalLayout.columnCount;
    } */
	
	//----------------------------------
	//  padding
	//----------------------------------
	
	//[Inspectable(category="General", defaultValue="0.0")]
	
	/**
	 *  @copy spark.layouts.HorizontalLayout#padding
	 *  
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 0.9.4
	 */
	/* public function get padding():Number
	{
		return horizontalLayout.padding;
	}
	 */
	/**
	 *  @private
	 */
	/* public function set padding(value:Number):void
	{
		horizontalLayout.padding = value;
	} */
    
    //----------------------------------
    //  paddingLeft
    //----------------------------------

    [Inspectable(category="General", defaultValue="0.0")]

    /**
     *  @copy spark.layouts.HorizontalLayout#paddingLeft
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    override public function get paddingLeft():Number
    {
        return horizontalLayout.paddingLeft;
    }

    /**
     *  @private
     */
    override public function set paddingLeft(value:Number):void
    {
        horizontalLayout.paddingLeft = value;
    }    
    
    //----------------------------------
    //  paddingRight
    //----------------------------------

    [Inspectable(category="General", defaultValue="0.0")]

    /**
     *  @copy spark.layouts.HorizontalLayout#paddingRight
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    override public function get paddingRight():Number
    {
        return horizontalLayout.paddingRight;
    }

    /**
     *  @private
     */
    override public function set paddingRight(value:Number):void
    {
        horizontalLayout.paddingRight = value;
    }    
    
    //----------------------------------
    //  paddingTop
    //----------------------------------

    //[Inspectable(category="General", defaultValue="0.0")]

    /**
     *  @copy spark.layouts.HorizontalLayout#paddingTop
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    override public function get paddingTop():Number
    {
        return horizontalLayout.paddingTop;
    }

    /**
     *  @private
     */
    override public function set paddingTop(value:Number):void
    {
        horizontalLayout.paddingTop = value;
    }
    
    //----------------------------------
    //  paddingBottom
    //----------------------------------

    //[Inspectable(category="General", defaultValue="0.0")]

    /**
     *  @copy spark.layouts.HorizontalLayout#paddingBottom
     *  
     *  @default 0
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    override public function get paddingBottom():Number
    {
        return horizontalLayout.paddingBottom;
    }

    /**
     *  @private
     */
    override public function set paddingBottom(value:Number):void
    {
        horizontalLayout.paddingBottom = value;
    }
    
    
    //----------------------------------
    //  requestedMaxColumnCount
    //----------------------------------
    
    //[Inspectable(category="General")]
    
    /**
     *  @copy spark.layouts.HorizontalLayout#requestedMaxColumnCount
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4
     */
    /* public function get requestedMaxColumnCount():int
    {
        return horizontalLayout.requestedMaxColumnCount;
    } */
    
    /**
     *  @private
     */
    /* public function set requestedMaxColumnCount(value:int):void
    {
        horizontalLayout.requestedMaxColumnCount = value;
    } */    
    
    //----------------------------------
    //  requestedMinColumnCount
    //----------------------------------
    
    //[Inspectable(category="General")]
    
    /**
     *  @copy spark.layouts.HorizontalLayout#requestedMinColumnCount
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4
     */
    /* public function get requestedMinColumnCount():int
    {
        return horizontalLayout.requestedMinColumnCount;
    } */
    
    /**
     *  @private
     */
    /* public function set requestedMinColumnCount(value:int):void
    {
        horizontalLayout.requestedMinColumnCount = value;
    } */    

    //----------------------------------
    //  requestedColumnCount
    //----------------------------------

    //[Inspectable(category="General")]

    /**
     *  @copy spark.layouts.HorizontalLayout#requestedColumnCount
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get requestedColumnCount():int
    {
        return horizontalLayout.requestedColumnCount;
    } */

    /**
     *  @private
     */
    /* public function set requestedColumnCount(value:int):void
    {
        horizontalLayout.requestedColumnCount = value;
    } */    
    
    //----------------------------------
    //  columnHeight
    //----------------------------------
    
    //[Inspectable(category="General")]

    /**
     * @copy spark.layouts.HorizontalLayout#columnWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get columnWidth():Number
    {
        return horizontalLayout.columnWidth;
    } */

    /**
     *  @private
     */
   /*  public function set columnWidth(value:Number):void
    {
        horizontalLayout.columnWidth = value;
    } */

    //----------------------------------
    //  variablecolumnHeight
    //----------------------------------

    //[Inspectable(category="General", enumeration="true,false", defaultValue="true")]

    /**
     * @copy spark.layouts.HorizontalLayout#variableColumnWidth
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get variableColumnWidth():Boolean
    {
        return horizontalLayout.variableColumnWidth;
    } */

    /**
     *  @private
     */
    /* public function set variableColumnWidth(value:Boolean):void
    {
        horizontalLayout.variableColumnWidth = value;
    } */
    
    //----------------------------------
    //  horizontalAlign
    //----------------------------------
    
    [Inspectable(category="General", enumeration="left,right,center", defaultValue="left")]
    
    /**
     *  @copy spark.layouts.HorizontalLayout#horizontalAlign
     *  
     *  @default "left"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get horizontalAlign():String
    {
        return horizontalLayout.horizontalAlign;
    }
    
    /**
     *  @private
     */
    public function set horizontalAlign(value:String):void
    {
        horizontalLayout.horizontalAlign = value;
    }
    
    //----------------------------------
    //  verticalAlign
    //----------------------------------

    [Inspectable(category="General", enumeration="top,bottom,middle,justify,contentJustify,baseline", defaultValue="top")]

    /**
     *  @copy spark.layouts.HorizontalLayout#verticalAlign
     *  
     *  @default "top"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get verticalAlign():String
    {
        return horizontalLayout.verticalAlign;
    }

    /**
     *  @private
     */
    public function set verticalAlign(value:String):void
    {
        horizontalLayout.verticalAlign = value;
    }
    
    //----------------------------------
    //  firstIndexInView
    //----------------------------------
 
    /* [Bindable("indexInViewChanged")]    
    [Inspectable(category="General")] */

    /**
     *  @copy spark.layouts.HorizontalLayout#firstIndexInView
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get firstIndexInView():int
    {
        return horizontalLayout.firstIndexInView;
    } */
    
    //----------------------------------
    //  lastIndexInView
    //----------------------------------
    
    /* [Bindable("indexInViewChanged")]    
    [Inspectable(category="General")] */

    /**
     * @copy spark.layouts.HorizontalLayout#lastIndexInView
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get lastIndexInView():int
    {
        return horizontalLayout.lastIndexInView;
    } */

    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  layout
    //----------------------------------    
        
    /**
     *  @private
     */
    override public function set layout(value:Object):void
    {
        //throw(new Error(resourceManager.getString("components", "layoutReadOnly")));
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    /* override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        switch(type)
        {
            case "indexInViewChanged":
            case "propertyChange":
                if (!hasEventListener(type))
                    horizontalLayout.addEventListener(type, redispatchHandler);
                break;
        }
        super.addEventListener(type, listener, useCapture, priority, useWeakReference)
    }    */ 
    
    /**
     * @private
     */
    /* override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
        super.removeEventListener(type, listener, useCapture);
        switch(type)
        {
            case "indexInViewChanged":
            case "propertyChange":
                if (!hasEventListener(type))
                    horizontalLayout.removeEventListener(type, redispatchHandler);
                break;
        }
    }
    
    private function redispatchHandler(event:Event):void
    {
        dispatchEvent(event);
    }   */    
}

}
