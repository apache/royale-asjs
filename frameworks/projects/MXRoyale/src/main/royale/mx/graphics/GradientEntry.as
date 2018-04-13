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


import org.apache.royale.graphics.GradientEntry;
/**
 *  The GradientEntry class defines the objects
 *  that control a transition as part of a gradient fill. 
 *  You use this class with the LinearGradient and RadialGradient classes
 *  to define a gradient fill. 
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;mx:GradientEntry&gt;</code> tag inherits all the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:GradientEntry
 *    <b>Properties</b>
 *    alpha="1.0"
 *    color="0x000000"
 *    ratio="NaN"
 *  /&gt;
 *  </pre>
 *  
 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class GradientEntry extends org.apache.royale.graphics.GradientEntry
{
/*     include "../core/Version.as";
 */
    /* //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    *
     *  Constructor.
     *
     *  @param color The color for this gradient entry.
     *  The default value is 0x000000 (black).
     *
     *  @param ratio Where in the graphical element the associated color is 
     *  sampled at 100%.
     *  Flex uniformly spaces any GradientEntries
     *  with missing ratio values.
     *  The default value is NaN.
     *
     *  @param alpha The alpha value for this entry in the gradient. 
     *  This parameter is optional. The default value is 1.0.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
    */
    public function GradientEntry(color:uint = 0x000000,
                                  ratio:Number = NaN,
                                  alpha:Number = 1.0)
    {
        super(color,ratio,alpha);
    }

 
}

}
