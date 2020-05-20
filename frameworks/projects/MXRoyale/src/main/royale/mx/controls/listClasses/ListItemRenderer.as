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

public class ListItemRenderer extends UIComponent implements IListItemRenderer, IIndexedItemRenderer, ILabelFieldItemRenderer, IOwnerViewItemRenderer
{
    public function ListItemRenderer()
    {
        addEventListener("click", clickHandler);    
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
        addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
    }

    private function doubleClickHandler(event:MouseEvent):void
    {
        var newEvent:ListEvent = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK);
        newEvent.rowIndex = index;
		newEvent.columnIndex = 0;
		getComponentDispatcher().dispatchEvent(newEvent);        
    }

    COMPILE::SWF
    public var textField:CSSTextField;

    /**
     * @private
     */
    COMPILE::SWF
    override public function addedToParent():void
    {
        super.addedToParent();
        $sprite_addChild(textField);
        adjustSize();
    }

    /**
     * @private
     */
    COMPILE::SWF
    public function adjustSize():void
    {
        var cy:Number = height/2;

        textField.x = 0;
        textField.y = cy - textField.height/2;
        textField.width = width;
    }
    
    private var _rowIndex:int;

    /**
     *  The index of the row the itemRenderer represents.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get rowIndex():int
    {
        return _rowIndex;
    }
    public function set rowIndex(value:int):void
    {
        _rowIndex = value;
    }

    /**
     * @royaleignorecoercion mx.core.UIComponent
     * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
     */
    private function clickHandler(event:MouseEvent):void
    {
        var le:ListEvent = new ListEvent("itemClick");
        le.rowIndex = rowIndex;
        le.columnIndex = 0;
        le.itemRenderer = this;
        getComponentDispatcher().dispatchEvent(le);
    }

    private var _itemRendererOwnerView:IItemRendererOwnerView;
    
    /**
     * The parent container for the itemRenderer instance.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get itemRendererOwnerView():IItemRendererOwnerView
    {
        return _itemRendererOwnerView;
    }
    public function set itemRendererOwnerView(value:IItemRendererOwnerView):void
    {
        _itemRendererOwnerView = value;
        if (!getBeadByType(ISelectableItemRenderer))
        {
            // load ISelectableItemRenderer impl from the
            // owner, not the item renderer so that item
            // renderers aren't strongly coupled to a
            // particular selection visual and the list
            // can dictate the selection visual
            var c:Class = ValuesManager.valuesImpl.getValue(value.host, "iSelectableItemRenderer");
            if (c)
                addBead(new c() as IBead);                    
        }
    }
			
    private var _labelField:String = "label";
    
    /**
     * The name of the field within the data to use as a label. Some itemRenderers use this field to
        * identify the value they should show while other itemRenderers ignore this if they are showing
        * complex information.
        */
    public function get labelField():String
    {
        return _labelField;
    }
    public function set labelField(value:String):void
    {
        _labelField = value;
    }	

    protected function getComponentDispatcher():IEventDispatcher
    {
        var irp:Object = itemRendererOwnerView;
        var p:IParent = parent;
        while (p)
        {
            if (p is IStrand)
            {
                var b:IBead = (p as IStrand).getBeadByType(IBeadView);
                if (b == irp) return p as IEventDispatcher;
            }
            p = (p as IChild).parent;
        }
        return null;
    }
    
		/**
		 *  The text currently displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get text():String
		{
            COMPILE::SWF
            {
                return textField.text;
            }
            COMPILE::JS
            {
                return this.element.textContent;
            }
		}

		public function set text(value:String):void
		{
            COMPILE::SWF
            {
                textField.text = value;
                var edge:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(this);
                var h:Number = textField.textHeight + edge.top + edge.bottom;
                textField.autoSize = "none";
                textField.height = h;    
            }
            COMPILE::JS
            {
                this.element.textContent = value;
            }
		}

        protected function dataToString(value:Object):String
        {
            if (value is XML)
            {
                var xml:XML = value as XML;
                return xml[labelField];
            }
            return getLabelFromData(this,value);
        }
        
    private var _data:Object;
    private var _listData:Object;
    private var _index:int;
		
    [Bindable("__NoChangeEvent__")]
    /**
     *  The data being represented by this itemRenderer. This can be something simple like a String or
     *  a Number or something very complex.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get data():Object
    {
        return _data;
    }

    public function set data(value:Object):void
    {
        _data = value;
        text = dataToString(value);
    }

    [Bindable("__NoChangeEvent__")]
    /**
     *  The extra data being represented by this itemRenderer. This can be something simple like a String or
     *  a Number or something very complex.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get listData():Object
    {
        return _listData;
    }
    
    public function set listData(value:Object):void
    {
        _listData = value;
    }
    
    public function get nestLevel():int
    {
    	throw new Error("Method not implemented.");
    }

    public function set nestLevel(value:int):void
    {
    	throw new Error("Method not implemented.");
    }

    public function get processedDescriptors():Boolean
    {
    	throw new Error("Method not implemented.");
    }

    public function set processedDescriptors(value:Boolean):void
    {
    	throw new Error("Method not implemented.");
    }

    public function get updateCompletePendingFlag():Boolean
    {
    	throw new Error("Method not implemented.");
    }

    public function set updateCompletePendingFlag(value:Boolean):void
    {
    	throw new Error("Method not implemented.");
    }
}

}
