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

package org.apache.royale.effects
{

COMPILE::SWF
{
    import flash.geom.Rectangle;
}

import org.apache.royale.geom.Rectangle;
import org.apache.royale.core.IDocument;
import org.apache.royale.core.IUIBase;
import org.apache.royale.core.IRenderedObject;


/**
 *  Helper class for Wipe effects.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class PlatformWiper
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
     *  @productversion Royale 1.0.0
     */
    public function PlatformWiper()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 *  The target.
	 */
	private var _target:IUIBase;
      
    /**
     *  @private
     *  The old overflow value.
     */
    private var _overflow:String;
    
    /**
     *  The object that will be clipped.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public function set target(value:IUIBase):void
    {
        COMPILE::SWF
        {
            if (value == null)
                (_target as IRenderedObject).$displayObject.scrollRect = null;
            _target = value;                
        }
        COMPILE::JS
        {
            if (_target && value != _target)
            {
                if (_overflow == null)
                    delete _target.positioner.style["overflow"];
                else
                    _target.positioner.style.overflow = _overflow;
            }
            _target = value;
            if (value != null) {
                _overflow = _target.positioner.style.overflow;
            }
        }
    }
    
    /**
     *  The visible rectangle.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public function set visibleRect(value:org.apache.royale.geom.Rectangle):void
    {
        COMPILE::SWF
        {
            (_target as IRenderedObject).$displayObject.scrollRect = new flash.geom.Rectangle(value.x,value.y,value.width,value.height);                
        }
        COMPILE::JS
        {
            _target.positioner.style.height = value.height.toString() + 'px';
            _target.positioner.style.overflow = 'hidden';
        }
    }
}

}
