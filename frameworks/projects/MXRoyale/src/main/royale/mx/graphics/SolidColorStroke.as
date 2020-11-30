/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package mx.graphics
{
    import org.apache.royale.geom.Point;
    import org.apache.royale.geom.Rectangle;
    import mx.display.Graphics;
	import mx.graphics.IStroke;
	
    public class SolidColorStroke implements IStroke
    {
		public function SolidColorStroke(color:uint = 0x000000,weight:Number = 1, alpha:Number = 1.0,
                                     pixelHinting:Boolean = false,
                                     scaleMode:String = "normal",
                                     caps:String = "round",
                                     joints:String = "round",
                                     miterLimit:Number = 3)
        {
			super();
            this.weight = weight;
            this.color = color;
            this.alpha = alpha;
		}
		
	private var _weight:Number;

    public function get weight():Number
    {
        return _weight;
    }
    public function set weight(value:Number):void
    {
        _weight = value;
    }
	// not implemented
	public function set pixelHinting(value:Boolean):void {}

	private var _color:Number;

    public function get color():Number
    {
        return _color;
    }
    public function set color(value:Number):void
    {
        _color = value;
    }

    private var _alpha:Number;
        
    public function get alpha():Number
    {
        return _alpha;
    }
    public function set alpha(value:Number):void
    {
        _alpha = value;
    }

	//----------------------------------
    //  caps
    //----------------------------------

    private var _caps:String = "round";//CapsStyle.ROUND;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General", enumeration="round,square,none", defaultValue="round")]

    /**
     *  Specifies the type of caps at the end of lines.
     *  Valid values are: <code>CapsStyle.ROUND</code>, <code>CapsStyle.SQUARE</code>,
     *  and <code>CapsStyle.NONE</code>.
     *  
     *  @default CapsStyle.ROUND
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function get caps():String
    {
        return _caps;
    }
    
    public function set caps(value:String):void
    {
        var oldValue:String = _caps;
        if (value != oldValue)
        {
            _caps = value;
            //dispatchStrokeChangedEvent("caps", oldValue, value);
        }
    }
    
    public function apply(g:Graphics, targetBounds:Rectangle = null, targetOrigin:Point = null):void
    {
        g.lineStyle(weight, color, alpha);
    }

    }
}
