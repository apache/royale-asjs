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
    COMPILE::SWF
    {
        import flash.display.BitmapData;
        import flash.display.DisplayObject;
        import flash.display.Bitmap;
    }

    /**
     *  The UIElement class Takes an IRenderedObject and creates a new UIBase
     *  which has the *appearance* of the original object.
     *  It *does not* have any of the orginal object's functionality.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    
    public class Lookalike extends UIBase
    {

        /**
         *
         * @royaleignorecoercion Element
         * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion Node
         */
        COMPILE::JS
        private function deepCloneWithStyles(node:Element):Element{
            var localNode:Node = node as Node;
            if (localNode.nodeType != 1) {
                //some stuff here for IE11:
                return localNode.nodeType == 3 ? document.createTextNode(localNode.nodeValue) as Element: localNode.cloneNode(true) as Element;
            }
            var clone:HTMLElement = localNode.cloneNode(false) as HTMLElement;
            var style:CSSStyleDeclaration = getComputedStyle(node, null);
            var cssText:String;
            if (style.cssText) {
                cssText = style.cssText;
            } else {
                //IE11 needs this fallback
                cssText = '';
                for (var i:uint = 0; i < style.length; i++) {
                    var styleName:String = style[i];
                    var propval:String = style.getPropertyValue(styleName);
                    cssText += (styleName + ":" + propval + "; ");
                }
            }

            clone.style.cssText = cssText;
            var child:Node = localNode.firstChild;
            while(child){
                clone.appendChild(deepCloneWithStyles(child as Element));
                child = child.nextSibling;
            }

            return clone;
        }

        /**
         *  Constructor.
         *  
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function Lookalike(original:IRenderedObject)
        {
            COMPILE::SWF
            {
                var dObj:DisplayObject = original.$displayObject;
    			var bd:BitmapData = new BitmapData(dObj.width,dObj.height);
	    		bd.draw(dObj);
                addChild(new Bitmap(bd));
            }
            COMPILE::JS
            {
                element = deepCloneWithStyles(original.element) as WrappedHTMLElement;
            }
            super();
            this.typeNames = 'LookALike';
        }
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            return element;
        }
    }
}
