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
package org.apache.flex.html.beads
{
	COMPILE::SWF {
		import flash.display.DisplayObject;
		import flash.display.DisplayObjectContainer;
		import flash.display.Sprite;
	}
	
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.ElementWrapper;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IComboBoxModel;
	import org.apache.flex.core.IPopUpHost;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ValuesManager;
    import org.apache.flex.core.IChild;
    import org.apache.flex.core.IParent;
    import org.apache.flex.core.IUIBase;
    import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Button;
	import org.apache.flex.html.TextInput;
    import org.apache.flex.utils.UIUtils;
	import org.apache.flex.core.IComboBoxModel;
	
	COMPILE::JS
	{
		import goog.events;
		import org.apache.flex.core.WrappedHTMLElement;            
	}
	
	/**
	 *  The ComboBoxView class creates the visual elements of the org.apache.flex.html.ComboBox 
	 *  component. The job of the view bead is to put together the parts of the ComboBox such as the TextInput
	 *  control and org.apache.flex.html.Button to trigger the pop-up.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	COMPILE::JS
	public class ComboBoxView extends BeadViewBase implements IBeadView, IComboBoxView
	{
		public function ComboBoxView()
		{
			
		}
		
		private var input: WrappedHTMLElement;
		private var button: WrappedHTMLElement;
		private var _popup:HTMLElement;
		
		public function get strand():IStrand
		{
			return _strand;
		}
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var element:WrappedHTMLElement = (_strand as UIBase).element;
			
			input = document.createElement('input') as WrappedHTMLElement;
			input.style.position = 'absolute';
			input.style.width = '80px';
			element.appendChild(input);
			
			button = document.createElement('div') as WrappedHTMLElement;
			button.style.position = 'absolute';
			button.style.top = '0px';
			button.style.right = '0px';
			button.style.background = '#bbb';
			button.style.width = '16px';
			button.style.height = '20px';
			button.style.margin = '0';
			button.style.border = 'solid #609 1px';
			element.appendChild(button);

			input.flexjs_wrapper = this;
		}
		
		/**
		 *  The TextInput component of the ComboBox.
		 * 
		 *  @copy org.apache.flex.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get textInputField():Object 
		{
			return input;
		}
		
		/**
		 *  The Button component of the ComboBox.
		 * 
		 *  @copy org.apache.flex.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get popupButton():Object
		{
			return button;
		}
		
		/**
		 *  The pop-up list component of the ComboBox.
		 * 
		 *  @copy org.apache.flex.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get popUp():Object
		{
			return _popup;
		}
		
		/**
		 *  Returns whether or not the pop-up is visible.
		 * 
		 *  @copy org.apache.flex.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get popUpVisible():Boolean
		{
			return _popup != null;
		}
		public function set popUpVisible(value:Boolean):void
		{
			if (value && _popup == null) {
				showPopup();
			}
			else {
				dismissPopup();
			}
		}
		
		/**
		 * @param event The event.
		 * @flexjsignorecoercion HTMLSelectElement
		 * @flexjsignorecoercion HTMLInputElement
		 */
		private function selectChanged(event:Event):void
		{
			var select:HTMLSelectElement;
			
			select = event.currentTarget as HTMLSelectElement;
			
			var model:IComboBoxModel = (_strand as UIBase).model as IComboBoxModel;
			model.selectedItem = select.options[select.selectedIndex].value;
			(input as HTMLInputElement).value = model.selectedItem.toString();
			
			_popup.parentNode.removeChild(_popup);
			_popup = null;
			
			dispatchEvent(event);
		}
		
		/**
		 */
		private function dismissPopup():void
		{
			// remove the popup if it already exists
			if (_popup) {
				_popup.parentNode.removeChild(_popup);
				_popup = null;
			}
		}
		
		/**
		 * @export
		 * @param {Object} event The event.
		 * @flexjsignorecoercion HTMLInputElement
		 * @flexjsignorecoercion HTMLElement
		 * @flexjsignorecoercion HTMLSelectElement
		 * @flexjsignorecoercion HTMLOptionElement
		 * @flexjsignorecoercion Array
		 */
		private function showPopup():void
		{
			var dp:Array;
			var i:int;
			var input:HTMLInputElement;
			var left:Number;
			var n:int;
			var opt:HTMLOptionElement;
			var pn:HTMLElement;
			var select:HTMLSelectElement;
			var si:int;
			var top:Number;
			var width:Number;
			
			if (_popup) {
				dismissPopup();
				
				return;
			}
			
			var element:WrappedHTMLElement = (_strand as UIBase).element;
			
			input = element.childNodes.item(0) as HTMLInputElement;
			
			pn = element;
			top = pn.offsetTop + input.offsetHeight;
			left = pn.offsetLeft;
			width = pn.offsetWidth;
			
			_popup = document.createElement('div') as HTMLElement;
			_popup.className = 'popup';
			_popup.id = 'test';
			_popup.style.position = 'absolute';
			_popup.style.top = top.toString() + 'px';
			_popup.style.left = left.toString() + 'px';
			_popup.style.width = width.toString() + 'px';
			_popup.style.margin = '0px auto';
			_popup.style.padding = '0px';
			_popup.style.zIndex = '10000';
			
			select = document.createElement('select') as HTMLSelectElement;
			select.style.width = width.toString() + 'px';
			goog.events.listen(select, 'change', selectChanged);
			
			var model:IComboBoxModel = (_strand as UIBase).model as IComboBoxModel;
			
			dp = model.dataProvider as Array;
			n = dp.length;
			for (i = 0; i < n; i++) {
				opt = document.createElement('option') as HTMLOptionElement;
				opt.text = dp[i];
				select.add(opt, null);
			}
			
			select.size = n;
			
			si = model.selectedIndex;
			if (si < 0) {
				select.value = null;
			} else {
				select.value = dp[si];
			}
						
			_popup.appendChild(select);
			document.body.appendChild(_popup);
		}
	}
	
	/**
	 *  The ComboBoxView class creates the visual elements of the org.apache.flex.html.ComboBox 
	 *  component. The job of the view bead is to put together the parts of the ComboBox such as the TextInput
	 *  control and org.apache.flex.html.Button to trigger the pop-up.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	COMPILE::SWF
	public class ComboBoxView extends BeadViewBase implements IBeadView, IComboBoxView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ComboBoxView()
		{
		}
		
		private var textInput:TextInput;
		private var button:Button;
		private var selectionModel:IComboBoxModel;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get strand():IStrand
		{
			return _strand;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
        
			selectionModel = value.getBeadByType(IComboBoxModel) as IComboBoxModel;
			selectionModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
            
			textInput = new TextInput();
			IParent(strand).addElement(textInput);
			textInput.width = 100;
			textInput.height = 18;
			
			upSprite = new Sprite();
			drawButton( upSprite, "up", 18, 18 );
			overSprite = new Sprite();
			drawButton( overSprite, "over", 18, 18 );
			downSprite = new Sprite();
			drawButton( downSprite, "down", 18, 18 );
			
			button = new Button();
            button.$button.upState = upSprite;
            button.$button.overState = overSprite;
            button.$button.downState = downSprite;
			UIBase(strand).$displayObjectContainer.addChild(button.$button);
			button.width = 18;
			button.height = 18;
			button.x = textInput.width;
			button.y = textInput.y;
			
			// listen for events on the text input and modify the list and selection
			textInput.addEventListener("change", textChangeHandler,false,0,true);
		}
		
		private var upSprite:Sprite;
		private var overSprite:Sprite;
		private var downSprite:Sprite;
		
		/**
		 * @private
		 */
		private function drawButton( sprite:Sprite, mode:String, width:Number, height:Number ) : void
		{
			sprite.graphics.clear();
			sprite.graphics.lineStyle(1,0xFFFFFF);
			sprite.graphics.drawRect(0, 0, width-1, height-1);
			sprite.graphics.lineStyle(-1);
			
			if( mode == "over" ) sprite.graphics.beginFill(0xCCCCCC);
			else if( mode == "down" ) sprite.graphics.beginFill(0x888888);
			sprite.graphics.drawRect(0, 0, width-1, height-1);
			sprite.graphics.endFill();
			
			sprite.graphics.beginFill(0x333333);
			sprite.graphics.moveTo(4,4);
			sprite.graphics.lineTo(width-4,4);
			sprite.graphics.lineTo(int(width/2),height-4);
			sprite.graphics.lineTo(4,4);
			sprite.graphics.endFill();
		}
		
		/**
		 *  The TextInput component of the ComboBox.
		 * 
		 *  @copy org.apache.flex.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get textInputField():Object 
		{
			return textInput;
		}
		
		/**
		 *  The Button component of the ComboBox.
		 * 
		 *  @copy org.apache.flex.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get popupButton():Object
		{
			return button;
		}
        
        private var _popUp:IStrand;
		
        /**
         *  The dropdown/popup that displays the set of choices.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get popUp():Object
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
         *  @productversion FlexJS 0.0
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
                    IPopUpHost(host).addElement(popUp as IChild);
                }
                else
                {
                    host = UIUtils.findPopUpHost(_strand as IUIBase);
                    IPopUpHost(host).removeElement(popUp as IChild);
                }
            }
        }
		
		/**
		 * @private
		 */
		private function selectionChangeHandler(event:Event):void
		{
			textInput.text = selectionModel.selectedItem.toString();
		}
		
		/**
		 * @private
		 */
		private function textChangeHandler(event:Event):void
		{	
			var newEvent:Event = new Event("change");
			IEventDispatcher(strand).dispatchEvent(newEvent);
		}
	}
}
