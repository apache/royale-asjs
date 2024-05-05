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

//import mx.controls.HTML;
//import mx.core.Container;

import mx.core.IUIComponent;
import mx.core.IChildList;
import mx.events.TextEvent;

import org.apache.royale.core.IUIBase;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.events.Event;

COMPILE::SWF{

    import flash.utils.setTimeout;
}
    
COMPILE::JS{
    import org.apache.royale.core.WrappedHTMLElement;
}

/**
 *  The RoyaleUtil utility class is an all-static class
 *  with methods for emulation support
 *
 * @langversion 3.0
 * @playerversion Flash 10.2
 * @playerversion AIR 2.6
 * @productversion Royale 0.9.9
 *
 * @royalesuppressexport
 */
public class RoyaleUtil
{	

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    public static const DELAY:uint = 5;

    private static var timeOut:Number = -1;
    public static function commitDeferred(commitPropertiesFunc:Function, delay:uint=5):Boolean{
        if (deferreds.indexOf(commitPropertiesFunc) == -1) {
            deferreds.push(commitPropertiesFunc);
            if (timeOut == -1) {
                timeOut = setTimeout(onDeferral, delay);
            }
            return true;
        }
        return false;
    }

    /**
     * @royaleignorecoercion Function
     */
    private static function onDeferral():void{
        timeOut = -1;
        var local:Array = deferreds;
        deferreds = [];
        var l:uint = local.length;
        for (var i:uint = 0; i<l;i++) {
            var commitPropertiesFunc:Function = local[i];
            commitPropertiesFunc();
        }
    }

    private static var deferreds:Array = [];


    COMPILE::JS
    public static function childByName(parent:IChildList, name:String):IUIComponent{
        var i:uint = 0;
        var l:uint = parent.numChildren;
        for (;i<l;i++) {
            var child:IUIComponent = parent.getChildAt(i);
            if (child && child.name == name) return child;
        }
        return null;
    }
    
    /**
     * @royaleemitcoercion org.apache.royale.core.ILayoutChild
     */
    public static function measureAndAscendContentSizedLayouts(from:ILayoutChild/*Container*/):void{

        var parent:ILayoutChild/*Container*/ = from.parent as ILayoutChild/*Container*/;
        var layout:Boolean;
        if (from.isWidthSizedToContent()) {
            //@todo assert: from is IUIComponent
            (from as IUIComponent).measuredWidth = NaN;
            layout = true;
        }
        if (from.isHeightSizedToContent()) {
            //@todo assert: from is IUIComponent
            (from as IUIComponent).measuredHeight = NaN;
            layout = true;
        }
        if (layout) {
            from.dispatchEvent(new org.apache.royale.events.Event('layoutNeeded'));
            if (parent) {
                measureAndAscendContentSizedLayouts(parent);
            }
        }

    }

    /**
     *  @private
     *
     *  @royaleignorecoercion Element
     */
    COMPILE::JS
    public static function getNativeMatrixBetween(upper:IUIBase, lower:IUIBase):Object{
        var p:Element = upper.element as Element;
        var c:Element = lower.element as Element;
        var mm:Object = jsUnsafeNativeInline("new DOMMatrixReadOnly()");
        while(c != p) {
            var ts:String = getComputedStyle(c).transform;
            var cur:Object = jsUnsafeNativeInline("new DOMMatrixReadOnly(ts)");
            mm = mm.multiply(cur);
            c = c.parentNode as Element;
        }
        return mm;
    }

    COMPILE::JS
    public static function linkEventEnhancer(base:IUIComponent):void{
        base.element.addEventListener('click',onClickLinkCheck)
    }

    /**
     *
     * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
     */
    COMPILE::JS
    private static function onClickLinkCheck(event:PointerEvent):void{
        //note MouseEvent here is the browser MouseEvent, not a royale one
        var component:IUIComponent = WrappedHTMLElement(event.currentTarget).royale_wrapper as IUIComponent;
        var anchor:HTMLAnchorElement = resolveHTMLAnchor(event.target as Element);
        if (anchor && component && component.hasEventListener(TextEvent.LINK)) {
           // var anchor:HTMLAnchorElement = event.target as HTMLAnchorElement;
            var href:String = anchor.href;
            if (href && href.indexOf('event:') == 0) {
                //todo, check: should this bubble and/or be cancelable
                var te:TextEvent  = new TextEvent(TextEvent.LINK,false,false,href.substr(6));
                component.dispatchEvent(te);
                //todo, check: should this only be if the TextEvent has preventDefault?
                event.preventDefault();
            }
        }
    }

    /**
     *
     * @royaleignorecoercion HTMLAnchorElement
     */
    COMPILE::JS
    private static function resolveHTMLAnchor(tag:Element):HTMLAnchorElement{
        //stop at HTMLSpanElement or HTMLTextAreaElement (which doesn't work for html anyway, may need alternate implementation for emulation)
        if (!tag) return null;
        if (tag is HTMLAnchorElement) return tag as HTMLAnchorElement;
        if (tag is HTMLSpanElement) return null;
        if (tag is HTMLTextAreaElement) return null;
        return resolveHTMLAnchor(tag.parentElement);

    }
    

}

}
