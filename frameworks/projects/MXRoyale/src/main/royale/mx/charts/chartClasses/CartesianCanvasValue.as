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

package mx.charts.chartClasses
{
    /**
     * Defines the position of objects on a data canvas. This class has a data coordinate and an
     * optional offset that are used by the CartesianDataCanvas class to calculate pixel 
     * coordinates.
     * 
     * @see mx.charts.chartClasses.CartesianDataCanvas
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public class CartesianCanvasValue
    {
//        include "../../core/Version.as";
        
        //-------------------------------------------------------
        //
        // Constructor
        //
        //-------------------------------------------------------
        /**
         * Constructor.
         * 
         * @param value The data coordinate of a point.
         * @param offset Offset of the data coordinate specified in <code>value</code>, in pixels.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function CartesianCanvasValue(value:*, offset:Number = 0):void
        {
            this.value = value;
            this.offset = offset;
        }
        
        //---------------------------------
        // offset
        //---------------------------------
        
        /**
         * @private
         * Storage for value
         */
        private var _offset:Number;
         
        /**
         *  @private
         */
        public function get offset():Number
        {
            return _offset;
        }
        
        /**
         * @private
         */
        public function set offset(data:Number):void
        {
            _offset = data;
        }
        
        //---------------------------------
        // value
        //---------------------------------
        
        /**
         * @private
         * Storage for value
         */
        private var _value:*;
         
        /**
         *  @private
         */
        public function get value():*
        {
            return _value;
        }
        
        /**
         * @private
         */
        public function set value(data:*):void
        {
            _value = data;
        }  
        
        //-------------------------------------------------
        //
        //  Methods
        //
        //-------------------------------------------------
        
        /**
         * @private
         */
        public function clone():CartesianCanvasValue
        {
            return new CartesianCanvasValue(value,offset);
        }
    }
}