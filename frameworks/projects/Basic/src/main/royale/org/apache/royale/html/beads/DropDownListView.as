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
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextFieldType;
	
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.CSSTextField;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.SolidBorderUtil;
	import org.apache.royale.utils.UIUtils;
    import org.apache.royale.html.beads.IDropDownListView;
    
    /**
     *  The DropDownListView class is the default view for
     *  the org.apache.royale.html.DropDownList class.
     *  It displays a simple text label with what appears to be a
     *  down arrow button on the right, but really, the entire
     *  view is the button that will display or dismiss the dropdown.
     *  
	 *  @viewbead
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
            upSprite = new Sprite();
            downSprite = new Sprite();
            overSprite = new Sprite();
			upTextField = new CSSTextField();
			downTextField = new CSSTextField();
			overTextField = new CSSTextField();
            upSprite.addChild(upTextField);
            overSprite.addChild(overTextField);
            downSprite.addChild(downTextField);
            upTextField.parentDrawsBackground = true;
            downTextField.parentDrawsBackground = true;
            overTextField.parentDrawsBackground = true;
			upTextField.selectable = false;
			upTextField.type = TextFieldType.DYNAMIC;
			downTextField.selectable = false;
			downTextField.type = TextFieldType.DYNAMIC;
			overTextField.selectable = false;
            overTextField.type = TextFieldType.DYNAMIC;
            // auto-size collapses if no text
			//upTextField.autoSize = "left";
			//downTextField.autoSize = "left";
			//overTextField.autoSize = "left";

            upArrows = new Shape();
            overArrows = new Shape();
            downArrows = new Shape();
            upSprite.addChild(upArrows);
			overSprite.addChild(overArrows);
			downSprite.addChild(downArrows);
            drawArrows(upArrows);
            drawArrows(overArrows);
            drawArrows(downArrows);

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
            selectionModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
            selectionModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
            selectionModel.addEventListener("dataProviderChanged", selectionChangeHandler);
			shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 10, 10);
			shape.graphics.endFill();
            upTextField.styleParent = _strand;
            downTextField.styleParent = _strand;
            overTextField.styleParent = _strand;
            var button:SimpleButton = value as SimpleButton;
			button.upState = upSprite;
            button.downState = downSprite;
            button.overState = overSprite;
            button.hitTestState = shape;
			if (selectionModel.selectedIndex !== -1)
				text = selectionModel.selectedItem.toString();
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
            
            upArrows.x = ww - upArrows.width - 6;            
            overArrows.x = ww - overArrows.width - 6;            
            downArrows.x = ww - downArrows.width - 6;
            upArrows.y = (hh - upArrows.height) / 2;            
            overArrows.y = (hh - overArrows.height) / 2;            
            downArrows.y = (hh - downArrows.height) / 2;

			upTextField.width = upArrows.x;
			downTextField.width = downArrows.x;
			overTextField.width = overArrows.x;
			upTextField.height = hh;
			downTextField.height = hh;
			overTextField.height = hh;
            
            drawBorder(upSprite, 0xf8f8f8, ww, hh);
            drawBorder(overSprite, 0xe8e8e8, ww, hh);
            drawBorder(downSprite, 0xd8d8d8, ww, hh);
            
			shape.graphics.clear();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, ww, hh);
			shape.graphics.endFill();
        }
        
		private var upTextField:CSSTextField;
		private var downTextField:CSSTextField;
		private var overTextField:CSSTextField;
        private var upSprite:Sprite;
        private var downSprite:Sprite;
        private var overSprite:Sprite;
        private var upArrows:Shape;
        private var downArrows:Shape;
        private var overArrows:Shape;
		
        private function drawBorder(sprite:Sprite, color:uint, ww:Number, hh:Number):void
        {
			sprite.graphics.clear();
            SolidBorderUtil.drawBorder(sprite.graphics, 0, 0,
                ww, hh,
                0x808080, color, 1, 1, 4);
        }
        
        private function drawArrows(shape:Shape):void
        {
            var g:Graphics = shape.graphics;
            g.beginFill(0);
            g.moveTo(8, 0);
            g.lineTo(12, 4);
            g.lineTo(4, 4);
            g.lineTo(8, 0);
            g.endFill();
            g.beginFill(0);
            g.moveTo(8, 10);
            g.lineTo(12, 6);
            g.lineTo(4, 6);
            g.lineTo(8, 10);
            g.endFill();
        }
            
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
