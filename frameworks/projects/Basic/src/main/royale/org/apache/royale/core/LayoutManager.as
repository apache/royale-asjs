////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package org.apache.royale.core
{
    COMPILE::SWF
    {
        import flash.utils.setTimeout;
    }
    import org.apache.royale.utils.measureComponent;
    /**
     * The LayoutManager class is an all static class which allows queing
     * up measuring of components and layouts to prevent layout thrashing
     * @langversion 3.0
     * @playerversion Flash 10.2
     * @playerversion AIR 2.6
     * @productversion Royale 0.9.3
     */
    public class LayoutManager
    {
        static private var layoutPending:Boolean;
        static private var measurementPending:Boolean;
        static private var measurements:Array = [];
        /**
         * Add a component to be measured during the next cycle.
         * The queued layouts are automatically run after all components are measured.
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
        static public function addMeasurement(component:ILayoutChild):void
        {
            measurements.push(component);
            COMPILE::SWF
            {
                if(!measurementPending)
                {
                    measurementPending = true;
                    setTimeout(executeMeasurements, 0);
                }
            }

            COMPILE::JS
            {
                if(!measurementPending)
                {
                    measurementPending = true;
                    requestAnimationFrame(executeMeasurements);
                }
            }
        }
        static private var pendingLayouts:Array = [];
        /**
         * Add a function to be called during the next group of layouts.
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
        static public function addLayout(callback:Function):void
        {
            pendingLayouts.push(callback);
            if(!layoutPending && !measurementPending)
            {
                layoutPending = true;
                COMPILE::SWF
                {
                    setTimeout(executeLayouts, 0);
                }

                COMPILE::JS
                {
                    requestAnimationFrame(executeLayouts);
                }
            }
        }
        static private function executeMeasurements():void
        {
            
            measurementPending = false;
            while(measurements.length)
            {
                var component:ILayoutChild = measurements.shift();
                measureComponent(component);
            }
            executeLayouts();
        }
        static private function executeLayouts():void
        {
            while(pendingLayouts.length)
            {
                var callback:Function  = pendingLayouts.shift();
                callback();
            }
            layoutPending = false;
        }
    }
}