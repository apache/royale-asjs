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
package org.apache.royale.html.beads
{
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.core.DispatcherBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.UIBase;
    COMPILE::JS
    {
    import org.apache.royale.html.Group;
    }

	/**
	 *  The ContextMenu class used to display a menu inside a component after the user press the rigth click
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */    
    [Event(name="show")]
	[DefaultProperty("content")]
    public class ContextMenu extends DispatcherBead
    {
        private var menu:UIBase;

        public static const SHOW:String = "show";

        public function set content(value:Array):void
        {
            COMPILE::JS
            {
                menu = new Group();
                menu.className = "context-menu";
            }

            for each(var item:IChild in value)
            {
                COMPILE::JS
                {
                    item.element.className = "item";
                }
                menu.addElement(item);
            }
        }
        
        public override function set strand(value:IStrand):void
		{
            super.strand = value;

            (value as UIBase).addElement(menu);

            COMPILE::JS
            {
                (value as UIBase).element.addEventListener("contextmenu", function(event:MouseEvent):void
                {
                    event.preventDefault();

                    var normalized:Array = normalizePosition(event.clientX, event.clientY);

                    var contextMenus:NodeList = document.querySelectorAll('.context-menu');
                    contextMenus.forEach(function(element:Element):void
                    {
                        element.classList.remove("visible");
                    });

                    menu.element.style.left = normalized[0] + "px";
                    menu.element.style.top = normalized[1] + "px";
                    menu.element.classList.add("visible");

                    dispatchEvent(new Event(SHOW));
                });

                document.querySelector("body").addEventListener("click", function(event:MouseEvent):void
                {
                    menu.element.classList.remove("visible");
                });
            }
		}

        private function normalizePosition(mouseX:int, mouseY:int):Array
        {
            var normalizedX:int = mouseX;
            var normalizedY:int = mouseY;

            COMPILE::JS
            {
                var scope:Element = document.querySelector("body");

                var scopeOffsetX:Number = Math.max(scope.getBoundingClientRect().left, 0);
                var scopeOffsetY:Number = Math.max(scope.getBoundingClientRect().top, 0);

                if (mouseX - scopeOffsetX + menu.element.clientWidth > scope.clientWidth)
                    normalizedX = scopeOffsetX + scope.clientWidth - menu.element.clientWidth;

                if (mouseY - scopeOffsetY + menu.element.clientHeight > scope.clientHeight)
                    normalizedY = scopeOffsetY + scope.clientHeight - menu.element.clientHeight;
            }

            return [normalizedX, normalizedY];
        }
   }
}