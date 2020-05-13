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

package spark.components.beads.controllers
{


import org.apache.royale.core.IBeadController;
import org.apache.royale.core.IStrand;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.MouseEvent;

import mx.core.ISelectableList;
import org.apache.royale.core.IParent;
import org.apache.royale.core.IChild;
import spark.components.supportClasses.ListBase;
import org.apache.royale.core.IViewport;

/**
 *  @private
 *  The controller for Spark TabBar.
 * 
 */
    public class TabBarController implements IBeadController
    {
        // NOTE:  this is a copy of Basic DropDownListController but the Basic one is SWF-only
        
        
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            var eventDispatcher:IEventDispatcher = (_strand.getBeadByType(IViewport) as IViewport).contentView as IEventDispatcher;
            eventDispatcher.addEventListener("itemsCreated", handleDataProviderChanged);
        }
        
        private function clickHandler(event:org.apache.royale.events.MouseEvent):void
        {
            var parent:IParent = (event.target as IChild).parent;
            var index:int = parent.getElementIndex(event.target as IChild);
            var list:IEventDispatcher = (_strand as ListBase).dataProvider as IEventDispatcher;
            if (list is ISelectableList)
            {
                (list as ISelectableList).selectedIndex = index;
            }
        }
        

        private function handleDataProviderChanged(event:Event):void
        {
            var parent:IParent = (_strand.getBeadByType(IViewport) as IViewport).contentView as IParent;
            for (var i:int = 0; i < parent.numElements; i++)
            {
                IEventDispatcher(parent.getElementAt(i)).addEventListener(org.apache.royale.events.MouseEvent.CLICK, clickHandler);
            }
        }
    }

}
