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

package org.apache.royale.graphics.utils.shaderClasses
{
import flash.display.Shader;

/**
 *  Creates a blend shader that is equivalent 
 *  to the luminosity masking option (also known as soft masking) available  
 *  in Adobe Creative Suite tools. This mask type is not native to Flash, 
 *  but is available in tools like Adobe Illustrator and Adobe Photoshop. 
 * 
 *  <p>A luminosity mask type can be set on Flex groups and graphic  
 *  elements. The visual appearance in tools like Adobe Illustrator and 
 *  Adobe Photoshop will be mimicked through this blend shader.</p>
 *  
 *  @see spark.primitives.supportClasses.GraphicElement#maskType
 *  @see spark.components.supportClasses.GroupBase#maskType 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 1.0.0
 *  
 *  @includeExample examples/LuminosityMaskShaderExample.mxml
 */

public class LuminosityMaskShader extends Shader
{
    [Embed(source="LuminosityMaskFilter.pbj", mimeType="application/octet-stream")]
    private static var ShaderClass:Class;

	/**
	 *  Constructor. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
    public function LuminosityMaskShader()
    {
        super(new ShaderClass());
    }

    /**
     *  A convenience field that takes into account whether luminosityClip and/or
     *  luminosityInvert are on or off. 
     * 
     *  <ul>
     *   <li>mode 0 = luminosityClip off, luminosityInvert off</li>
     *   <li>mode 1 = luminosityClip off, luminosityInvert on</li>
     *   <li>mode 2 = luminosityClip on, luminosityInvert off</li>
     *   <li>mode 3 = luminosityClip on, luminosityInvert on </li>
     *  </ul>
     * 
     *  @see spark.primitives.supportClasses.GraphicElement#luminosityClip
     *  @see spark.primitives.supportClasses.GraphicElement#luminosityInvert
     *  @see spark.components.supportClasses.GroupBase#luminosityClip 
     *  @see spark.components.supportClasses.GroupBase#luminosityInvert
	 * 
	 *  @langversion 3.0
 	 *  @playerversion Flash 10
 	 *  @playerversion AIR 1.5
 	 *  @productversion Royale 1.0.0
     */
    public function get mode():int
    {
        return this.data.mode.value;
    }

    public function set mode(v:int):void
    {
		if (mode ==-1)
				return; 
        this.data.mode.value=[v];
    }
}
}
