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
package org.apache.flex.mdl.beads
{
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.core.UIBase;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.Event;

    /**
     * UpgradeElement bead will automatically register in the case where you are creating DOM
     * elements dynamically.
     * Bead register new elements using the upgradeElement function from MDL library
     *
     * @langversion 3.0
     * @playerversion Flash 10.2
     * @playerversion AIR 2.6
     * @productversion FlexJS 0.8
     */
    public class UpgradeElement implements IBead
    {
        /**
         * @param element
         * @param className
         */
        public function UpgradeElement(element:Object = null, className:String = null)
        {
            _element = element;
            _className = className;
        }

        private var _strand:IStrand;
        private var _element:Object;
        private var _className:String;

        /**
         * The element we wish to upgrade
         *
         * @param value element for upgrade
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.8
         */
        public function set element(value:Object):void
        {
            _element = value;
        }

        /**
         * Optional name of the class we want to upgrade
         * the element to.
         * 
         * @param value class name
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.8
         */
        public function set className(value:String):void
        {
            _className = value;
        }

        /**
         *  @copy org.apache.flex.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         *  @flexjsignorecoercion HTMLInputElement
         *  @flexjsignorecoercion org.apache.flex.core.UIBase;
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            IEventDispatcher(value).addEventListener("beadsAdded", beadsAddedHandler);
        }

        private function beadsAddedHandler(event:Event):void
        {
            IEventDispatcher(_strand).removeEventListener("beadsAdded", beadsAddedHandler);
            COMPILE::JS
            {
                upgradeElement();
            }
        }

        COMPILE::JS
        private function upgradeElement():void
        {
            var componentHandler:Object = window["componentHandler"];
            var host:UIBase = _strand as UIBase;

            if (componentHandler && host && (host.element || _element))
            {
                var upgradeElement:Object = _element ? _element : host.element;
                componentHandler.upgradeElement(upgradeElement, _className);
            }
        }
    }
}
