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

package mx.graphics
{

import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import mx.core.mx_internal;
import mx.display.Graphics;
import mx.graphics.IFill;
import mx.geom.Matrix;
import org.apache.royale.graphics.GradientBase;

use namespace mx_internal;

[DefaultProperty("entries")]

public class LinearGradient extends org.apache.royale.graphics.GradientBase implements IFill
{
	//----------------------------------
    //  scaleX
    //----------------------------------
    
    private var _scaleX:Number;
	public function get scaleX():Number
	{
		return _scaleX;
	}
    public function set scaleX(value:Number):void
	{
		_scaleX = value;
	}
	
    public function begin(g:Graphics,targetBounds:Rectangle,targetOrigin:Point):void
    {
        var m:Matrix = null;
        if (rotation == 90)
            m = Graphics.MATRIX_ROTATE90;
        g.beginGradientFill('linearGradient', entries, null, null, m);
    }
    
    public function end(g:Graphics):void
    {
    }

    

    public function set interpolationMethod(value:String):void {}

}

}
