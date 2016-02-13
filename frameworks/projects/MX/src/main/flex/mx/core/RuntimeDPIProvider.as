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

package mx.core
{
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.system.Capabilities;

import mx.core.mx_internal;
import mx.managers.SystemManager;
import mx.utils.Platform;

use namespace mx_internal;

/**
 *  The RuntimeDPIProvider class provides the default mapping of
 *  similar device DPI values into predefined DPI classes.
 *  An Application may have its runtimeDPIProvider property set to a
 *  subclass of RuntimeDPIProvider to override Flex's default mappings.
 *  Overriding Flex's default mappings will cause changes in the Application's
 *  automatic scaling behavior.
 * 
 *  <p>Overriding Flex's default mappings is usually only necessary for devices
 *  that incorrectly report their screenDPI and for devices that may scale better
 *  in a different DPI class.</p>
 * 
 *  <p>Flex's default mappings are:
 *     <table class="innertable">
 *        <tr><td>160 DPI</td><td>&lt;140 DPI</td></tr>
 *        <tr><td>160 DPI</td><td>&gt;=140 DPI and &lt;=200 DPI</td></tr>
 *        <tr><td>240 DPI</td><td>&gt;=200 DPI and &lt;=280 DPI</td></tr>
 *        <tr><td>320 DPI</td><td>&gt;=280 DPI and &lt;=400 DPI</td></tr>
 *        <tr><td>480 DPI</td><td>&gt;=400 DPI and &lt;=560 DPI</td></tr>
 *        <tr><td>640 DPI</td><td>&gt;=640 DPI</td></tr>
 *     </table>
 *  </p>
 *
 *
 * 
 *  <p>Subclasses of RuntimeDPIProvider should only depend on runtime APIs
 *  and should not depend on any classes specific to the Flex framework except
 *  <code>mx.core.DPIClassification</code>.</p>
 *  
 *  @includeExample examples/RuntimeDPIProviderApp.mxml -noswf
 *  @includeExample examples/RuntimeDPIProviderExample.as -noswf
 *  @includeExample examples/views/RuntimeDPIProviderAppView.mxml -noswf
 *  
 *  @see mx.core.DPIClassification
 *  @see spark.components.Application#applicationDPI
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public class RuntimeDPIProvider
{

    mx_internal static const IPAD_MAX_EXTENT:int = 1024;
    mx_internal static const IPAD_RETINA_MAX_EXTENT: int = 2048;

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function RuntimeDPIProvider()
    {
    }

    /**
     *  Returns the runtime DPI of the current device by mapping its
     *  <code>flash.system.Capabilities.screenDPI</code> to one of several DPI
     *  values in <code>mx.core.DPIClassification</code>.
     *
     *  A number of devices can have slightly different DPI values and Flex maps these
     *  into the several DPI classes.
     *
     *  Flex uses this method to calculate the current DPI value when an Application
     *  authored for a specific DPI is adapted to the current one through scaling.
     *
     *  <p> Exceptions: </p>
     *  <ul>
     *      <li>All non-retina iPads  receive 160 DPI </li>
     *      <li>All retina iPads  receive 320 DPI </li>
     *   </ul>
     *
     *  @param dpi The DPI value.
     *  @return The corresponding <code>DPIClassification</code> value.
     *                                                                               isI
     *  @see flash.system.Capabilities
     *  @see mx.core.DPIClassification
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */

    public function get runtimeDPI():Number
	{
		if (Platform.isIOS) // as isIPad returns false in the simulator
		{
			var scX:Number = Capabilities.screenResolutionX;
			var scY:Number = Capabilities.screenResolutionY;
					
			// Use the stage width/height only when debugging, because Capabilities reports the computer resolution
			if (Capabilities.isDebugger)
			{
				var root:DisplayObject = SystemManager.getSWFRoot(this);
				if (root && root.stage)
				{
					scX = root.stage.fullScreenWidth;
					scY = root.stage.fullScreenHeight;
				}
			}
					
			/*  as of Dec 2013,  iPad (resp. iPad retina) are the only iOS devices to have 1024 (resp. 2048) screen width or height
			cf http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density#Apple
			* */
			if (scX == IPAD_MAX_EXTENT || scY == IPAD_MAX_EXTENT)
				return DPIClassification.DPI_160;
			else if ((scX == IPAD_RETINA_MAX_EXTENT || scY == IPAD_RETINA_MAX_EXTENT))
				return DPIClassification.DPI_320;
		}
				
		return classifyDPI(Capabilities.screenDPI);
	}
    
    /**
     *  @private
     *  Matches the specified DPI to a <code>DPIClassification</code> value.
     *  A number of devices can have slightly different DPI values and classifyDPI
     *  maps these into the several DPI classes.
     * 
     *  This method is specifically kept for Design View. Flex uses RuntimeDPIProvider
     *  to calculate DPI classes.
     *  
     *  @param dpi The DPI value.  
     *  @return The corresponding <code>DPIClassification</code> value.
     */
    mx_internal static function classifyDPI(dpi:Number):Number
    {
		if (dpi <= 140)
			return DPIClassification.DPI_120;
		
        if (dpi <= 200)
            return DPIClassification.DPI_160;
        
        if (dpi <= 280)
            return DPIClassification.DPI_240;
		
		if (dpi <= 400)
			return DPIClassification.DPI_320;
		
		if (dpi <= 560)
			return DPIClassification.DPI_480;
        
        return DPIClassification.DPI_640;
    }
}
}