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
package org.apache.royale.core
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;

	/**
	 *  The ConstraintSize class is used to set minimun and maximun sizes on the component
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class ConstraintSize implements IBead
	{
	    public function ConstraintSize()
	    {
	    }

        protected var host:UIBase;

        public function set strand(value:IStrand):void
        {
            host = value as UIBase;
            updateMinWidth();
            updateMinHeight();
        }
	    
        protected var _minWidth:Number;
        /**
         *  the minimun width for this component
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get minWidth():Number
        {
            return _minWidth;
        }
        public function set minWidth(value:Number):void
        {
            if (_minWidth !== value)
            {
                _minWidth = value;
                if(host)
                    updateMinWidth();
            }   
        }
        private function updateMinWidth():void
        {
            COMPILE::JS
            {
            if(_minWidth)
                host.positioner.style.minWidth = _minWidth.toString() + 'px';        
            }
        }
        
        protected var _minHeight:Number;
        /**
         *  the minimun height for this component
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get minHeight():Number
        {
            return _minHeight;
        }
        public function set minHeight(value:Number):void
        {
            if (_minHeight !== value)
            {
                _minHeight = value;
                if(host)
                    updateMinHeight();
            }   
        }
        private function updateMinHeight():void
        {
            COMPILE::JS
            {
            if(_minHeight)
                host.positioner.style.minHeight = _minHeight.toString() + 'px';        
            }
        }
        
        protected var _maxWidth:Number;
        /**
         *  the maximun width for this component
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get maxWidth():Number
        {
            return _maxWidth;
        }
        public function set maxWidth(value:Number):void
        {
            if (_maxWidth !== value)
            {
                _maxWidth = value;
                if(host)
                    updateMaxWidth();
            }   
        }
        private function updateMaxWidth():void
        {
            COMPILE::JS
            {
            if(_maxWidth)
                host.positioner.style.maxWidth = _maxWidth.toString() + 'px';        
            }
        }
        
        protected var _maxHeight:Number;
        /**
         *  the maximun height for this component
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get maxHeight():Number
        {
            return _maxHeight;
        }
        public function set maxHeight(value:Number):void
        {
            if (_maxHeight !== value)
            {
                _maxHeight = value;
                if(host)
                    updateMaxHeight();
            }   
        }
        private function updateMaxHeight():void
        {
            COMPILE::JS
            {
            if(_maxHeight)
                host.positioner.style.maxHeight = _maxHeight.toString() + 'px';        
            }
        }
	}
}
