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

package spark.primitives
{

	import mx.core.UIComponent;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;

	/**
	 *  The Ellipse class is a filled graphic element that draws an ellipse.
	 *  To draw the ellipse, this class calls the <code>Graphics.drawEllipse()</code> 
	 *  method.
	 *  
	 *  @see mx.display.Graphics
	 *  
	 *  @includeExample examples/EllipseExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class Ellipse extends UIComponent
	{
	    //include "../core/Version.as";

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
	    public function Ellipse()
	    {
		super();
	    }
	
	    public function set stroke(value:IStroke):void {}
	    public function set fill(value:IFill):void {}
	}    

}
