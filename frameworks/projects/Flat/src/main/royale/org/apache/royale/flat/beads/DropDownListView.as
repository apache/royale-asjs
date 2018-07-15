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
package org.apache.royale.flat.beads
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFieldType;
	
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.CSSShape;
	import org.apache.royale.core.CSSSprite;
	import org.apache.royale.core.CSSTextField;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.Button;
	import org.apache.royale.html.beads.IDropDownListView;
	import org.apache.royale.utils.CSSUtils;
    import org.apache.royale.utils.UIUtils;
    
    /**
     *  The DropDownListView class is the default view for
     *  the org.apache.royale.flat.DropDownList class.
     *  It displays a simple text label with what appears to be a
     *  down arrow button on the right, but really, the entire
     *  view is the button that will display or dismiss the dropdown.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DropDownListView extends BeadViewBase implements IDropDownListView, IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DropDownListView()
		{
            upSprite = new CSSSprite();
            upSprite.className = 'dropdown-toggle-open-btn';
            downSprite = new CSSSprite();
            downSprite.className = 'dropdown-toggle-open-btn';
            overSprite = new CSSSprite();
            overSprite.className = 'dropdown-toggle-open-btn';
            overSprite.state = 'hover';
			upTextField = new CSSTextField();
			downTextField = new CSSTextField();
			overTextField = new CSSTextField();
            upSprite.addChild(upTextField);
            overSprite.addChild(overTextField);
            downSprite.addChild(downTextField);
			upTextField.selectable = false;
            upTextField.parentDrawsBackground = true;
            upTextField.parentHandlesPadding = true;
			upTextField.type = TextFieldType.DYNAMIC;
			downTextField.selectable = false;
            downTextField.parentDrawsBackground = true;
            downTextField.parentHandlesPadding = true;
			downTextField.type = TextFieldType.DYNAMIC;
			overTextField.selectable = false;
            overTextField.parentDrawsBackground = true;
            overTextField.parentHandlesPadding = true;
			overTextField.type = TextFieldType.DYNAMIC;
            // auto-size collapses if no text
			//upTextField.autoSize = "left";
			//downTextField.autoSize = "left";
			//overTextField.autoSize = "left";

            upArrows = new CSSShape();
            upArrows.className = 'dropdown-caret';
            overArrows = new CSSShape();
            overArrows.className = 'dropdown-caret';
            downArrows = new CSSShape();
            downArrows.className = 'dropdown-caret';
            upSprite.addChild(upArrows);
			overSprite.addChild(overArrows);
			downSprite.addChild(downArrows);

		}

        
		private var selectionModel:ISelectionModel;
		
		private var shape:Shape;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            var b:Button = Button(value);
            selectionModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
            selectionModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
            selectionModel.addEventListener("dataProviderChanged", selectionChangeHandler);
			shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 10, 10);
			shape.graphics.endFill();
			b.upState = upSprite;
			b.downState = downSprite;
			b.overState = overSprite;
			b.hitTestState = shape;
			if (selectionModel.selectedIndex !== -1)
				selectionChangeHandler(null);
            else
                text = "^W_";
            upTextField.height = upTextField.textHeight + 4;
            downTextField.height = downTextField.textHeight + 4;
            overTextField.height = overTextField.textHeight + 4;
            if (selectionModel.selectedIndex == -1)
                text = "";
            
            IEventDispatcher(value).addEventListener("heightChanged", changeHandler);
            IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			changeHandler(null);
		}
		
		private function selectionChangeHandler(event:Event):void
		{
            if (selectionModel.selectedItem == null)
                text = "";
            else if (selectionModel.labelField != null)
                text = selectionModel.selectedItem[selectionModel.labelField].toString();
            else
    			text = selectionModel.selectedItem.toString();
		}
		
        private function changeHandler(event:Event):void
        {
            var ww:Number = IUIBase(_strand).width;
            var hh:Number = IUIBase(_strand).height;
            var padding:Object = ValuesManager.valuesImpl.getValue(_strand, "padding");
            var paddingLeft:Object = ValuesManager.valuesImpl.getValue(_strand,"padding-left");
            var paddingRight:Object = ValuesManager.valuesImpl.getValue(_strand,"padding-right");
            var paddingTop:Object = ValuesManager.valuesImpl.getValue(_strand,"padding-top");
            var paddingBottom:Object = ValuesManager.valuesImpl.getValue(_strand,"padding-bottom");
            var pl:Number = CSSUtils.getLeftValue(paddingLeft, padding, ww);
            var pr:Number = CSSUtils.getRightValue(paddingRight, padding, ww);
            var pt:Number = CSSUtils.getLeftValue(paddingTop, padding, hh);
            var pb:Number = CSSUtils.getRightValue(paddingBottom, padding, hh);
            
            upArrows.draw(0, 0);
            overArrows.draw(0, 0);
            downArrows.draw(0, 0);
            if (ILayoutChild(_strand).isHeightSizedToContent() && text != "")
            {
                hh = upTextField.textHeight + pt + pb;
                ILayoutChild(_strand).setHeight(hh, true);
            }
            upSprite.draw(ww, hh);
            overSprite.draw(ww, hh);
            downSprite.draw(ww, hh);
            
            upArrows.x = ww - upArrows.width - pr;            
            overArrows.x = ww - overArrows.width - pr;            
            downArrows.x = ww - downArrows.width - pr;
            upArrows.y = (hh - upArrows.height) / 2;            
            overArrows.y = (hh - overArrows.height) / 2;            
            downArrows.y = (hh - downArrows.height) / 2;
            
			upTextField.width = upTextField.textWidth + 4;
			downTextField.width = downTextField.textWidth + 4;
			overTextField.width = overTextField.textWidth + 4;
			upTextField.height = upTextField.textHeight + 5;
			downTextField.height = downTextField.textHeight + 5;
			overTextField.height = overTextField.textHeight + 5;
            upTextField.y = (hh - upTextField.height) / 2;
            downTextField.y = (hh - downTextField.height) / 2;
            overTextField.y = (hh - overTextField.height) / 2;
            upTextField.x = pl;
            downTextField.x = pl;
            overTextField.x = pl;
			shape.graphics.clear();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, ww, hh);
			shape.graphics.endFill();
        }
        
		private var upTextField:CSSTextField;
		private var downTextField:CSSTextField;
		private var overTextField:CSSTextField;
        private var upSprite:CSSSprite;
        private var downSprite:CSSSprite;
        private var overSprite:CSSSprite;
        private var upArrows:CSSShape;
        private var downArrows:CSSShape;
        private var overArrows:CSSShape;
		
        /**
         *  The text that is displayed in the view.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get text():String
		{
			return upTextField.text;
		}
        
        /**
         *  @private
         */
		public function set text(value:String):void
		{
			upTextField.text = value;
			downTextField.text = value;
			overTextField.text = value;
            changeHandler(null);
		}
		
        private var _popUp:IStrand;
        
        /**
         *  The dropdown/popup that displays the set of choices.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get popUp():IStrand
        {
            if (!_popUp)
            {
                var popUpClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iPopUp") as Class;
                _popUp = new popUpClass() as IStrand;
            }
            return _popUp;
        }
        
        private var _popUpVisible:Boolean;
        
        /**
         *  A flag that indicates whether the dropdown/popup is
         *  visible.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get popUpVisible():Boolean
        {
            return _popUpVisible;
        }
        
        /**
         *  @private
         */
        public function set popUpVisible(value:Boolean):void
        {
            var host:IPopUpHost;
            if (value != _popUpVisible)
            {
                _popUpVisible = value;
                if (value)
                {
                    host = UIUtils.findPopUpHost(_strand as IUIBase);
                    IPopUpHost(host).popUpParent.addElement(popUp as IChild);
                }
                else
                {
                    host = UIUtils.findPopUpHost(_strand as IUIBase);
                    IPopUpHost(host).popUpParent.removeElement(popUp as IChild);
                }
            }
        }
        
	}
}
