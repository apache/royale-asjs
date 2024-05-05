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

package mx.controls.listClasses
{

import mx.controls.Image;
import mx.controls.Label;

import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.events.ListEvent;

import org.apache.royale.core.IBead;
import org.apache.royale.core.IBeadView;
import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
import org.apache.royale.core.IChild;
import org.apache.royale.core.IIndexedItemRenderer;
import org.apache.royale.core.ILabelFieldItemRenderer;
import org.apache.royale.core.IOwnerViewItemRenderer;
import org.apache.royale.core.IItemRendererOwnerView;
import org.apache.royale.core.IParent;
import org.apache.royale.core.ISelectableItemRenderer;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.core.layout.EdgeData;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.ItemClickedEvent;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.html.supportClasses.StringItemRenderer;
import org.apache.royale.html.util.getLabelFromData;

COMPILE::SWF
{
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import org.apache.royale.core.CSSTextField;
}

/**
 *  The ListItemRenderer is the default renderer for mx.controls.List
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */

public class ListIconItemRenderer extends ListItemRenderer
{
    public function ListIconItemRenderer()
    {
       /* addEventListener("click", clickHandler);
        COMPILE::SWF
        {
            textField = new CSSTextField();
            textField.type = TextFieldType.DYNAMIC;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.selectable = false;
            textField.parentDrawsBackground = true;
        }
        COMPILE::JS
        {
            typeNames = "ListItemRenderer";
            isAbsolute = false;
        }
        addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);*/
        super();
    }

    /**
     * override to specify a fixed icon width, otherwise the icon width defaults to the renderer height
     * @return
     */
    public function getIconWidth():uint{
        return 0;
    }
    /**
     * override to specify a fixed icon height, otherwise the icon height defaults to the renderer height
     * @return
     */
    public function getIconHeight():uint{
        return 0;
    }

    //----------------------------------
    //  icon
    //----------------------------------

    /**
     *  The internal IFlexDisplayObject that displays the icon in this renderer.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var icon:IFlexDisplayObject;

    protected var label:Label;

    protected var hGap:uint = 2;

    override protected function createChildren():void
    {
        super.createChildren();
        if (numChildren == 0)
        {
            label = new Label();
            addChild(label);
        }
        if (!icon)
        {
            var img:mx.controls.Image = new mx.controls.Image();
            img.setStyle("verticalAlign", "middle" );
            this.icon = img;
            var fixedDimension:uint  = getIconWidth();
            if (fixedDimension) img.width = fixedDimension;
            fixedDimension = getIconHeight();
            if (fixedDimension) img.height = fixedDimension;
            addChild(img);
        }
    }

    protected var updateSizeInBase:Boolean=true;

    override public function set data(value:Object):void
    {
        super.data = value;
        var listBase:ListBase = listData.owner as ListBase;
        if (listBase) {
            var iconSource:Object = null;
            if (listBase.iconFunction) {
                iconSource = listBase.iconFunction(value);
            } //else iconField ? @todo
            if (iconSource) {
                icon.visible=true;
            } else {
                icon.visible=false;
            }
            mx.controls.Image(icon).source = iconSource;
            if(updateSizeInBase && width && height) adjustSize();
        } else {
            icon.visible=false;
        }
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth,unscaledHeight)
        icon.x = hGap;
        var iconW:uint = getIconWidth();
        var iconH:uint = getIconHeight();
        if (!iconH) iconH = unscaledHeight;
        if (!iconW) iconW = iconH;

        icon.width = iconW;
        icon.height = iconH;
        icon.y = Math.max(0,(unscaledHeight-iconH)*.5);
        if (icon.visible) {
            label.x = icon.x + icon.width + hGap;
        } else {
            label.x = icon.x + hGap;
        }
        label.width = unscaledWidth - label.x;

    }



    COMPILE::JS
    override public function get text():String
    {
       return label.text;
    }
    COMPILE::JS
    override public function set text(value:String):void
    {
        label.text = value;
    }
}

}
