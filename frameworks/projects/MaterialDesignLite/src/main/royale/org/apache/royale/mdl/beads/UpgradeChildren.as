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
package org.apache.royale.mdl.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;


    /**
     * UpgradeChildren bead will automatically register all the children for component
     * in the case where you are creating DOM
     * elements dynamically.
     * Bead register new elements using the upgradeElement function from MDL library
     *
     * @langversion 3.0
     * @playerversion Flash 10.2
     * @playerversion AIR 2.6
     * @productversion Royale 0.8
     */
    public class UpgradeChildren implements IBead
    {
        /**
         * @param classNames
         */
        public function UpgradeChildren(classNames:Array = null)
        {
            _classNames = classNames;
        }

        private var _host:UIBase;
        private var _strand:IStrand;
        private var _classNames:Array;

        /**
         * Class lists of children which need to be updated
         * 
         * @param value class names
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
         */
        public function set classNames(value:Array):void
        {
            _classNames = value;
        }

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.UIBase
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            _host = value as UIBase;

            COMPILE::JS
            {
                if (_host)
                {
                    _host.element.addEventListener("mdl-componentupgraded", onElementMdlComponentUpgraded, false);
                }
            }
        }

        COMPILE::JS
        private function onElementMdlComponentUpgraded(event:Event):void
        {
            if (!event.currentTarget) return;
            if (_host)
            {
                _host.element.removeEventListener("mdl-componentupgraded", onElementMdlComponentUpgraded, false);
            }
            
            upgradeChildren();
        }
        /**
		 *  @royaleignorecoercion HTMLElement
         */
        COMPILE::JS
        private function upgradeChildren():void
        {
            if (!_host && !_classNames) return;
            
            var elementChildren:Object = (_host.element as HTMLElement).children;
            if (!elementChildren) return;

            for each (var className:String in _classNames)
            {
                for (var i:int = 0; i < elementChildren.length; i++)
                {
                    var child:Element = elementChildren[i];
                    var isUpgraded:Object = child.getAttribute("data-upgraded");

                    if (child.classList.contains(className) && isUpgraded == null)
                    {
                        var componentHandler:Object = window["componentHandler"];
                        componentHandler["upgradeElement"](child);
                        break;
                    }
                }
            }
        }
    }
}
