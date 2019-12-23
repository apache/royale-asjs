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
use namespace mx_internal;
/*
import mx.core.IMXMLObject;
import flash.events.EventDispatcher;

*/
	
/**
 *  ConstraintRow class partitions an absolutely
 *  positioned container in the horizontal plane. 
 * 
 *  ConstraintRow instances have 3 sizing options: fixed, percentage,  
 *  and content. These options dictate the position of the constraint row, 
 *  the amount of space the constraint row takes in the container, and 
 *  how the constraint row deals with a change in the size of the container. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ConstraintRow extends EventDispatcher //implements IMXMLObject
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
	public function ConstraintRow()
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
    //  baseline
    //----------------------------------
        
    /**
     *  @private
     *  Storage for the baseline property.
     */
    private var _baseline:Object = "maxAscent:0";
    [Bindable("baselineChanged")]
    [Inspectable(category="General")]
    
    /**
     *  Number that specifies the baseline of the ConstraintRow instance, in pixels,
     *  either relative to the top edge of the row or to the max ascent of the 
     *  elements contained in this row.
     * 
     *  @default "maxAscent:0"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get baseline():Object
    {
        return _baseline;
    }
    
    /**
     *  @private
     */
    public function set baseline(value:Object):void
    {
        if (_baseline != value)
        {
            _baseline = value;
            
            if (container)
            {
                container.invalidateSize();
                container.invalidateDisplayList();
            }
            dispatchEvent(new Event("baselineChanged"));
        }
    }
    
	//----------------------------------
    //  container
    //----------------------------------

    /**
     *  @private
     */
    private var _container:IInvalidating;

    /**
     *  The container being partitioned by this ConstraintRow instance.
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
    //  height
    //----------------------------------

    /**
     *  @private
     *  Storage for the height property.
     */
    protected var _height:Number;
	[Bindable("heightChanged")]
    [Inspectable(category="General")]
    [PercentProxy("percentHeight")]

    /**
     *  Number that specifies the height of the ConstraintRow instance, in pixels,
     *  in the parent's coordinates.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get height():Number
    {
        return _height;
    }

    /**
     *  @private
     */
    public function set height(value:Number):void
    {
		if (explicitHeight != value)
    	{
    		explicitHeight = value;
    		if (_height != value)
    		{
    			_height = value;
                if (!isNaN(_height))
                    contentSize = false;
    			if (container)
    			{
    				container.invalidateSize();
    				container.invalidateDisplayList();
    			}
    			dispatchEvent(new Event("heightChanged"));
    		}
    	}
    }
	
	//----------------------------------
    //  explicitHeight
    //----------------------------------
    /**
     *  @private
     *  Storage for the explicitHeight property.
     */
    
    private var _explicitHeight:Number;
    [Inspectable(environment="none")]
    [Bindable("explicitHeightChanged")]
    
    /**
     *  Number that specifies the explicit height of the 
     *  ConstraintRow instance, in pixels, in the ConstraintRow 
     *  instance's coordinates.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitHeight():Number
    {
    	return _explicitHeight;
    }
    
    /**
     *  @private
     */
    public function set explicitHeight(value:Number):void
    {
    	if (_explicitHeight == value)
            return;

        // height can be pixel or percent not both
        if (!isNaN(value))
            _percentHeight = NaN;

        _explicitHeight = value;
        
        if (container)
        {
        	container.invalidateSize();
        	container.invalidateDisplayList();
        }
        
        dispatchEvent(new Event("explicitHeightChanged"));
    }
	
	//----------------------------------
    //  id
    //----------------------------------

    /**
     *  @private
     */
    private var _id:String;

    /**
     *  ID of the ConstraintRow instance. This value becomes the instance name 
     *  of the constraint row and should not contain white space or special 
     *  characters. 
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
    //  maxHeight
    //----------------------------------
    /**
     *  @private
     *  Storage for the maxHeight property.
     */
    private var _explicitMaxHeight:Number;
	[Bindable("maxHeightChanged")]
    [Inspectable(category="Size", defaultValue="10000")]

    /**
     *  Number that specifies the maximum height of the ConstraintRow instance,
     *  in pixels, in the ConstraintRow instance's coordinates.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxHeight():Number
    {
        // Since ConstraintRow doesn't have a measuredMaxHeight, we explictly return
        // the default value of 10000 when no maxHeight is set.
        return (!isNaN(_explicitMaxHeight)) ? _explicitMaxHeight : 10000;
    }

    /**
     *  @private
     */
    public function set maxHeight(value:Number):void
    {
    	if (_explicitMaxHeight != value)
    	{
            _explicitMaxHeight = value;
			if (container)
			{
            	container.invalidateSize();
   				container.invalidateDisplayList();
   			}
   			dispatchEvent(new Event("maxHeightChanged"));
    	}
    }
    
    //----------------------------------
    //  minHeight
    //----------------------------------
    /**
     *  @private
     *  Storage for the minHeight property.
     */
    private var _explicitMinHeight:Number;
	[Bindable("minHeightChanged")]
    [Inspectable(category="Size", defaultValue="0")]
    
    /**
     *  Number that specifies the minimum height of the ConstraintRow instance,
     *  in pixels, in the ConstraintRow instance's coordinates.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minHeight():Number
    {
        // Since ConstraintRow doesn't have a measuredMinHeight, we explictly return
        // the default value of 0 when no minHeight is set.
        return (!isNaN(_explicitMinHeight)) ? _explicitMinHeight : 0;
    }

    /**
     *  @private
     */
    public function set minHeight(value:Number):void
    {
    	if (_explicitMinHeight != value)
    	{
            _explicitMinHeight = value;
         	if (container)
			{
            	container.invalidateSize();
   				container.invalidateDisplayList();
   			}   
			dispatchEvent(new Event("minHeightChanged"));
    	}
    }
    
    //----------------------------------
    //  percentHeight
    //----------------------------------
    /**
     *  @private
     *  Storage for the percentHeight property.
     */
    private var _percentHeight:Number;
    [Bindable("percentHeightChanged")]
    [Inspectable(environment="none")]

    /**
     *  Number that specifies the height of a component as a percentage
     *  of its parent's size. Allowed values are 0-100. The default value is NaN.
     *  Setting the <code>width</code> property resets this property to NaN.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get percentHeight():Number
    {
        return _percentHeight;
    }

    /**
     *  @private
     */
    public function set percentHeight(value:Number):void
    {
        if (_percentHeight == value)
            return;

        if (!isNaN(value))
            _explicitHeight = NaN;

        _percentHeight = value;
        if (!isNaN(_percentHeight))
            contentSize = false;
        
        if (container)
        {
        	container.invalidateSize();
        	container.invalidateDisplayList();
        }   
    }
    
    //----------------------------------
    //  y
    //----------------------------------
	private var _y:Number;
	[Bindable("yChanged")]
	
    /**
	 *  @private
     */
    public function get y():Number
    {
        return _y;
    }

    /**
     *  @private
     */
    public function set y(value:Number):void
    {
        if (value != _y)
        {
        	_y = value;
        	dispatchEvent(new Event("yChanged"));
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMXMLObject
    //
    //--------------------------------------------------------------------------
    
    /**
      *  Called automatically by the MXML compiler when the ConstraintRow
      *  instance is created using an MXML tag.  
      *  If you create the constraint row through ActionScript, you 
      *  must call this method passing in the MXML document and 
      *  <code>null</code> for the <code>id</code>.
      *
      *  @param document The MXML document containing this ConstraintRow.
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
		if (!this.height && !this.percentHeight)
			contentSize = true;
    }
    
    public function setDocument(document:Object, id:String = null):void
    {
        initialized(document, id);
    }
    
    /**
     *  Sizes the ConstraintRow
     *
     *  @param height Height of constaint row computed during parent container
     *  processing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setActualHeight(h:Number):void
    {
        if (_height != h)
        {
            _height = h;
            dispatchEvent(new Event("heightChanged"));
        }
    }
    
}

}
