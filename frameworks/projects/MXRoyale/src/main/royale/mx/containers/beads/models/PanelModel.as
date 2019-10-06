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

package mx.containers.beads.models
{

import mx.core.ContainerLayout;

import org.apache.royale.html.beads.models.PanelModel;

/**
 *  @private
 *  The PanelModel for emulation.
 */
public class PanelModel extends org.apache.royale.html.beads.models.PanelModel
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
	public function PanelModel()
	{
		super();
	}


    private var _layout:String = ContainerLayout.VERTICAL;
    
	public function get layout():String
    {
        return _layout;
    }
    
    public function set layout(value:String):void
    {
        _layout = value;
    }

    private var _paddingBottom:String;
    public function get paddingBottom():String
    {
        return _paddingBottom;
    }
    
    public function set paddingBottom(value:String):void
    {
        _paddingBottom = value;
    }
    
    private var _paddingTop:String;
    public function get paddingTop():String
    {
        return _paddingTop;
    }
    public function set paddingTop(value:String):void
    {
        _paddingTop = value;
    }
    
    private var _paddingLeft:String;
    public function get paddingLeft():String
    {
        return _paddingLeft;
    }
    public function set paddingLeft(value:String):void
    {
        _paddingLeft = value;
    }
    
    private var _paddingRight:String;
    public function get paddingRight():String
    {
        return _paddingRight;
    }
    public function set paddingRight(value:String):void
    {
        _paddingRight = value;
    }
    
}

}
