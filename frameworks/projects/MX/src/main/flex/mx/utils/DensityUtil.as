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

package mx.utils
{
import mx.core.DPIClassification;
import mx.core.RuntimeDPIProvider;
import mx.core.Singleton;

[ExcludeClass]

/**
 *  The <code>DensityUtil</code> class is an all-static class with methods for working with
 *  density within Flex.
 * 
 *  Flex uses this class to calculate the scaling factor when automatic density
 *  scaling is enabled for the <code>Application</code>.
 *
 *  @see mx.core.DPIClassification
 *  @see spark.components.Application#applicationDPI 
 */
public class DensityUtil
{
    /**
     *  Cached runtimeDPI value, which is computed from the runtimeDPIProvider class.
     */
    private static var runtimeDPI:Number;
    
    /**
     *  Returns the current runtimeDPI value which is calculated by 
     *  an instance of the runtimeDPIProvider class.
     *  If a runtimeDPIProvider class is not provided to the Application,
     *  Flex uses the default class, RuntimeDPIProvider.
     *
     *  @see #getDPIScale 
     *  @see mx.core.RuntimeDPIProvider
     */
    public static function getRuntimeDPI():Number
    {
        if (!isNaN(runtimeDPI))
            return runtimeDPI;
        
        var runtimeDPIProviderClass:Class = Singleton.getClass("mx.core::RuntimeDPIProvider");
        
        // Default to RuntimeDPIProvider
        if (!runtimeDPIProviderClass)
            runtimeDPIProviderClass = RuntimeDPIProvider;
        
        var instance:RuntimeDPIProvider = RuntimeDPIProvider(new runtimeDPIProviderClass());
        runtimeDPI = instance.runtimeDPI;
        
        return runtimeDPI;
    }
    
    /**
     *  Calculates a scale factor to be used when element authored for 
     *  <code>sourceDPI</code> is rendered at <code>targetDPI</code>.
     *  
     *  @param sourceDPI The <code>DPIClassification</code> dpi value for which
     *  a resource is optimized.
     * 
     *  @param targetDPI The <code>DPIClassification</code> dpi value at
     *  which a resource is rendered.
     * 
     *  @return The scale factor to be applied to the resource at render time.
     *
     *  @see #getRuntimeDPI
     *  @see mx.core.DPIClassification
     */
    public static function getDPIScale(sourceDPI:Number, targetDPI:Number):Number
    {
        // Unknown dpi returns NaN
        if ((sourceDPI != DPIClassification.DPI_120 && sourceDPI != DPIClassification.DPI_160 && sourceDPI != DPIClassification.DPI_240 && sourceDPI != DPIClassification.DPI_320 && sourceDPI != DPIClassification.DPI_480 && sourceDPI != DPIClassification.DPI_640) ||
            (targetDPI != DPIClassification.DPI_120 && targetDPI != DPIClassification.DPI_160 && targetDPI != DPIClassification.DPI_240 && targetDPI != DPIClassification.DPI_320 && targetDPI != DPIClassification.DPI_480 && targetDPI != DPIClassification.DPI_640))
        {
            return NaN;
        }

        return targetDPI / sourceDPI;
    }
}
}