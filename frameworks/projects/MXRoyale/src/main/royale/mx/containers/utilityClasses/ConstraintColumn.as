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

package mx.containers.utilityClasses
{
import org.apache.royale.core.IDocument;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;

/*
import flash.events.Event;
import flash.events.IEventDispatcher;
*/
import mx.core.IInvalidating;
import mx.core.mx_internal;
/*
import mx.core.IMXMLObject;
import flash.events.EventDispatcher;

*/
use namespace mx_internal;

/**
 *  The ConstraintColumn class partitions an absolutely
 *  positioned container in the vertical plane. 
 * 
 *  ConstraintColumn instances have 3 sizing options: fixed, percentage, and 
 *  content. These options dictate the position of the 
 *  constraint column, the amount of space the constraint column 
 *  takes in the container, and how the constraint column deals with 
 *  changes in the size of the container. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ConstraintColumn extends EventDispatcher implements IDocument//implements IMXMLObject
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
	public function ConstraintColumn()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	mx_internal var contentSize:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
    
    //----------------------------------
    //  container
    //----------------------------------
    /**
     *  @private
     */
    private var _container:IInvalidating;

    /**
     *  The container which this ConstraintColumn instance is 
     *  partitioning. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get container():IInvalidating
    {
        return _container;
    }

    /**
     *  @private
     */
    public function set container(value:IInvalidating):void
    {
        _container = value;
    }
    
    //----------------------------------
    //  id
    //----------------------------------
    /**
     *  @private
     */
    private var _id:String;

    /**
     *  ID of the ConstraintColumn instance. This value becomes the instance name of the
     *  ConstraintColumn instance and should not contain white space or special characters. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get id():String
    {
        return _id;
    }

    /**
     *  @private
     */
    public function set id(value:String):void
    {
        _id = value;
    }
    
    //----------------------------------
    //  maxWidth
    //----------------------------------
    /**
     *  @private
     *  Storage for the maxWidth property.
     */
    private var _explicitMaxWidth:Number;
	[Bindable("maxWidthChanged")]
    [Inspectable(category="Size", defaultValue="10000")]

    /**
     *  Number that specifies the maximum width of the ConstraintColumn 
     *  instance, in pixels, in the ConstraintColumn instance's coordinates.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxWidth():Number
    {
        // Since ConstraintColumn doesn't have a measuredMaxWidth, we explictly return
        // the default value of 10000 when no maxWidth is set.
        return (!isNaN(_explicitMaxWidth)) ? _explicitMaxWidth : 10000;
    }

    /**
     *  @private
     */
    public function set maxWidth(value:Number):void
    {
    	if (_explicitMaxWidth != value)
    	{
            _explicitMaxWidth = value;
			if (container)
			{
				container.invalidateSize();
				container.invalidateDisplayList();
			}
			dispatchEvent(new Event("maxWidthChanged"));
    	}
    }
    
    //----------------------------------
    //  minWidth
    //----------------------------------
    /**
     *  @private
     *  Storage for the minWidth property.
     */
    private var _explicitMinWidth:Number;
	[Bindable("minWidthChanged")]
    [Inspectable(category="Size", defaultValue="0")]
    
    /**
     *  Number that specifies the minimum width of the ConstraintColumn instance,
     *  in pixels, in the ConstraintColumn instance's coordinates.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minWidth():Number
    {
        // Since ConstraintColumn doesn't have a measuredMinWidth, we explictly return
        // the default value of 0 when no minWidth is set.
        return (!isNaN(_explicitMinWidth)) ? _explicitMinWidth : 0;
    }

    /**
     *  @private
     */
    public function set minWidth(value:Number):void
    {
    	if (_explicitMinWidth != value)
    	{
            _explicitMinWidth = value;
			if (container)
    		{
    			container.invalidateSize();
   				container.invalidateDisplayList();
   			}
        	dispatchEvent(new Event("minWidthChanged"));
     	}
    }
    
    //----------------------------------
    //  width
    //----------------------------------
    /**
     *  @private
     *  Storage for the width property.
     */
	protected var _width:Number;
	[Bindable("widthChanged")]
    [Inspectable(category="General")]
    [PercentProxy("percentWidth")]

    /**
     *  Number that specifies the width of the ConstraintColumn instance, in pixels,
     *  in the parent container's coordinates.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get width():Number
    {
        return _width;
    }

    /**
     *  @private
     */
    public function set width(value:Number):void
    {
    	if (explicitWidth != value)
    	{
    		explicitWidth = value;
    		if (_width != value)
    		{
    			_width = value;
                if (!isNaN(_width))
                    contentSize = false;
    			if (container)
    			{
    				container.invalidateSize();
    				container.invalidateDisplayList();
    			}
    			dispatchEvent(new Event("widthChanged"));
    		}
    	}
    }
    
    //----------------------------------
    //  explicitWidth
    //----------------------------------
    /**
     *  @private
     *  Storage for the explicitWidth property.
     */
    
    private var _explicitWidth:Number;
    [Inspectable(environment="none")]
    [Bindable("explicitWidthChanged")]
    
    /**
     *  Number that specifies the explicit width of the ConstraintColumn instance, 
     *  in pixels, in the ConstraintColumn instance's coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitWidth():Number
    {
    	return _explicitWidth;
    }
    
    /**
     *  @private
     */
    public function set explicitWidth(value:Number):void
    {
    	if (_explicitWidth == value)
            return;

        // width can be pixel or percent not both
        if (!isNaN(value))
            _percentWidth = NaN;

        _explicitWidth = value;
        
        if (container)
        {
        	container.invalidateSize();
        	container.invalidateDisplayList();
        }
        
        dispatchEvent(new Event("explicitWidthChanged"));
    }
    
    //----------------------------------
    //  percentWidth
    //----------------------------------
    /**
     *  @private
     *  Storage for the percentWidth property.
     */
    private var _percentWidth:Number;
    [Bindable("percentWidthChanged")]
    [Inspectable(environment="none")]

    /**
     *  Number that specifies the width of a component as a percentage of its 
     *  parent container's size. Allowed values are 0-100. The default value is NaN.
     *  Setting the <code>width</code> property resets this property to NaN.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get percentWidth():Number
    {
        return _percentWidth;
    }

    /**
     *  @private
     */
    public function set percentWidth(value:Number):void
    {
		if (_percentWidth == value)
            return;

        if (!isNaN(value))
            _explicitWidth = NaN;

        _percentWidth = value;
        if (!isNaN(_percentWidth))
            contentSize = false;
        
        if (container)
        {
        	container.invalidateSize();
        	container.invalidateDisplayList();
        }   
        
        dispatchEvent(new Event("percentWidthChanged"));
    }
    
    //----------------------------------
    //  x
    //----------------------------------
	private var _x:Number;
	[Bindable("xChanged")]

	/**
	 *  @private
     */
    public function get x():Number
    {
        return _x;
    }

    /**
     *  @private
     */
    public function set x(value:Number):void
    {
        if (value != _x)
        {
        	_x = value;
        	dispatchEvent(new Event("xChanged"));
        }
    }
 
 	//--------------------------------------------------------------------------
    //
    //  Methods: IMXMLObject
    //
    //--------------------------------------------------------------------------
 
 	/**
      *  Called automatically by the MXML compiler when the ConstraintColumn
      *  instance is created using an MXML tag.  
      *  If you create the ConstraintColumn instance through ActionScript, you 
      *  must call this method passing in the MXML document and 
      *  <code>null</code> for the <code>id</code>.
      *
      *  @param document The MXML document containing this ConstraintColumn.
      *
      *  @param id Ignored.
      *  
      *  @langversion 3.0
      *  @playerversion Flash 9
      *  @playerversion AIR 1.1
      *  @productversion Flex 3
      */
	public function initialized(document:Object, id:String):void
    {
		this.id = id;
		if (!this.width && !this.percentWidth)
			contentSize = true;
    }
    
    public function setDocument(document:Object, id:String = null):void
    {
        initialized(document, id);
    }
    
	/**
	 *  Sizes the constraint column.
	 *
	 *  @param width Width of constaint column computed during parent container
	 *  processing.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    public function setActualWidth(w:Number):void
    {
        if (_width != w)
        {
            _width = w;
            dispatchEvent(new Event("widthChanged"));
        }
    }
    
}

}
