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
import spark.layouts.VerticalLayout;
//import spark.layouts.supportClasses.LayoutBase;

//[IconFile("VGroup.png")]

[Exclude(name="layout", kind="property")]

/**
 *  The VGroup container is an instance of the Group container 
 *  that uses the VerticalLayout class.  
 *  Do not modify the <code>layout</code> property. 
 *  Instead, use the properties of the VGroup class to modify the 
 *  characteristics of the VerticalLayout class.
 *
 *  <p>The VGroup container has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
 *  </table>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;s:VGroup&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:VGroup
 *    <strong>Properties</strong>
 *    gap="6"
 *    horizontalAlign="left"
 *    padding="0"
 *    paddingBottom="0"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    paddingTop="0"
 *    requestedMaxRowCount="-1"
 *    requestedMinRowCount="-1"
 *    requestedRowCount"-1"
 *    rowHeight="no default"
 *    variableRowHeight="true"
 *    verticalAlign="top"
 *  /&gt;
 *  </pre>
 * 
 *  @see spark.layouts.VerticalLayout
 *  @includeExample examples/VGroupExample.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class VGroup extends Group
{
   // include "../core/Version.as";
    
    /**
     *  Constructor. 
     *  Initializes the <code>layout</code> property to an instance of 
     *  the VerticalLayout class.
     * 
     *  @see spark.layouts.VerticalLayout
     *  @see spark.components.HGroup
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */  
    public function VGroup():void
    {
        super();
        super.layout = new VerticalLayout();
    }
    
    private function get verticalLayout():VerticalLayout
    {
        return VerticalLayout(layout);
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
     *  @copy spark.layouts.VerticalLayout#gap
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
        return verticalLayout.gap;
    }

    /**
     *  @private
     */
    public function set gap(value:int):void
    {
        verticalLayout.gap = value;
    }
    
    //----------------------------------
    //  horizontalAlign
    //----------------------------------

    [Inspectable(category="General", enumeration="left,right,center,justify,contentJustify", defaultValue="left")]

    /**
     *  @copy spark.layouts.VerticalLayout#horizontalAlign
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
        return verticalLayout.horizontalAlign;
    }

    /**
     *  @private
     */
    public function set horizontalAlign(value:String):void
    {
        verticalLayout.horizontalAlign = value;
    }

    //----------------------------------
    //  verticalAlign
    //----------------------------------
    
    [Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="top")]
    
    /**
     *  @copy spark.layouts.VerticalLayout#verticalAlign
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
        return verticalLayout.verticalAlign;
    }
    
    /**
     *  @private
     */
    public function set verticalAlign(value:String):void
    {
        verticalLayout.verticalAlign = value;
    }
	
	//----------------------------------
	//  padding
	//----------------------------------
	
	[Inspectable(category="General", defaultValue="0.0")]
	
	/**
	 *  @copy spark.layouts.VerticalLayout#padding
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
		return verticalLayout.padding;
	} */
	
	/**
	 *  @private
	 */
	/* public function set padding(value:Number):void
	{
		verticalLayout.padding = value;
	}  */
    
    //----------------------------------
    //  paddingLeft
    //----------------------------------

    //[Inspectable(category="General", defaultValue="0.0")]

    /**
     *  @copy spark.layouts.VerticalLayout#paddingLeft
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get paddingLeft():Number
    {
        return verticalLayout.paddingLeft;
    } */

    /**
     *  @private
     */
    /* public function set paddingLeft(value:Number):void
    {
        verticalLayout.paddingLeft = value;
    }  */   
    
    //----------------------------------
    //  paddingRight
    //----------------------------------

    //[Inspectable(category="General", defaultValue="0.0")]

    /**
     *  @copy spark.layouts.VerticalLayout#paddingRight
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get paddingRight():Number
    {
        return verticalLayout.paddingRight;
    } */

    /**
     *  @private
     */
    /* public function set paddingRight(value:Number):void
    {
        verticalLayout.paddingRight = value;
    }    
     */
    //----------------------------------
    //  paddingTop
    //----------------------------------

    //[Inspectable(category="General", defaultValue="0.0")]

    /**
     *  @copy spark.layouts.VerticalLayout#paddingTop
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get paddingTop():Number
    {
        return verticalLayout.paddingTop;
    } */

    /**
     *  @private
     */
    /* public function set paddingTop(value:Number):void
    {
        verticalLayout.paddingTop = value;
    }   */  
    
    //----------------------------------
    //  paddingBottom
    //----------------------------------

    //[Inspectable(category="General", defaultValue="0.0")]

    /**
     *  @copy spark.layouts.VerticalLayout#paddingBottom
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get paddingBottom():Number
    {
        return verticalLayout.paddingBottom;
    } */

    /**
     *  @private
     */
    /* public function set paddingBottom(value:Number):void
    {
        verticalLayout.paddingBottom = value;
    }   */  
    
    //----------------------------------
    //  rowCount
    //----------------------------------

    /* [Bindable("propertyChange")]
    [Inspectable(category="General")] */

    /**
     *  @copy spark.layouts.VerticalLayout#rowCount
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get rowCount():int
    {
        return verticalLayout.rowCount;
    } */
    
    //----------------------------------
    //  requestedMaxRowCount
    //----------------------------------

    //[Inspectable(category="General")]

    /**
     *  @copy spark.layouts.VerticalLayout#requestedMaxRowCount
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4
     */
    /* public function get requestedMaxRowCount():int
    {
        return verticalLayout.requestedMaxRowCount;
    } */

    /**
     *  @private
     */
    /* public function set requestedMaxRowCount(value:int):void
    {
        verticalLayout.requestedMaxRowCount = value;
    }  */   
    
    //----------------------------------
    //  requestedMinRowCount
    //----------------------------------
    
    //[Inspectable(category="General")]
    
    /**
     *  @copy spark.layouts.VerticalLayout#requestedMinRowCount
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4
     */
    /* public function get requestedMinRowCount():int
    {
        return verticalLayout.requestedMinRowCount;
    } */
    
    /**
     *  @private
     */
    /* public function set requestedMinRowCount(value:int):void
    {
        verticalLayout.requestedMinRowCount = value;
    }  */   
    
    //----------------------------------
    //  requestedRowCount
    //----------------------------------
    
    //[Inspectable(category="General")]
    
    /**
     *  @copy spark.layouts.VerticalLayout#requestedRowCount
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get requestedRowCount():int
    {
        return verticalLayout.requestedRowCount;
    } */
    
    /**
     *  @private
     */
    /* public function set requestedRowCount(value:int):void
    {
        verticalLayout.requestedRowCount = value;
    }   */  
    
    //----------------------------------
    //  rowHeight
    //----------------------------------
    
    //[Inspectable(category="General")]

    /**
     *  @copy spark.layouts.VerticalLayout#rowHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get rowHeight():Number
    {
        return verticalLayout.rowHeight;
    } */

    /**
     *  @private
     */
    /* public function set rowHeight(value:Number):void
    {
        verticalLayout.rowHeight = value;
    } */

    //----------------------------------
    //  variableRowHeight
    //----------------------------------

    [Inspectable(category="General", defaultValue="true")]

    /**
     *  @copy spark.layouts.VerticalLayout#variableRowHeight
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
     public function get variableRowHeight():Boolean // not implemented
    {
        //return verticalLayout.variableRowHeight;
	     return false;
    } 

    /**
     *  @private
     */
    public function set variableRowHeight(value:Boolean):void // not implemented
    {
        //verticalLayout.variableRowHeight = value;
    }
    
    //----------------------------------
    //  firstIndexInView
    //----------------------------------

    /* [Bindable("indexInViewChanged")]    
    [Inspectable(category="General")] */
 
    /**
     * @copy spark.layouts.VerticalLayout#firstIndexInView
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get firstIndexInView():int
    {
        return verticalLayout.firstIndexInView;
    } */
    
    //----------------------------------
    //  lastIndexInView
    //----------------------------------

    /* [Bindable("indexInViewChanged")]    
    [Inspectable(category="General")] */

    /**
     *  @copy spark.layouts.VerticalLayout#lastIndexInView
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get lastIndexInView():int
    {
        return verticalLayout.lastIndexInView;
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
   /*  override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        switch(type)
        {
            case "indexInViewChanged":
            case "propertyChange":
                if (!hasEventListener(type))
                    verticalLayout.addEventListener(type, redispatchHandler);
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
                    verticalLayout.removeEventListener(type, redispatchHandler);
                break;
        }
    }
    
    private function redispatchHandler(event:Event):void
    {
        dispatchEvent(event);
    } */
    
}
}
