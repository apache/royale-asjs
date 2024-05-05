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

package mx.controls.menuClasses
{
	import mx.controls.Label;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.RoyaleUtil;
	
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IListDataItemRenderer;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.html.supportClasses.CascadingMenuItemRenderer;
	import mx.supportClasses.IFoldable;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IPopUpHostParent;
	import mx.controls.Menu;
	import org.apache.royale.html.beads.DisableBead;
	import org.apache.royale.html.beads.DisabledAlphaBead;
	import org.apache.royale.html.util.getLabelFromData;
	import org.apache.royale.events.Event;

	import org.apache.royale.svg.Rect;

	/**
	 *  The ListItemRenderer is the default renderer for mx.controls.List
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */

	public class CascadingMenuIconItemRenderer extends UIComponent
			implements IDataRenderer,IDropInListItemRenderer,IListDataItemRenderer,IListItemRenderer,IFoldable
	{
		public function CascadingMenuIconItemRenderer()
		{
			super();
			typeNames = "CascadingMenuItemRenderer"; //keep the styling the same as the text-only renderer
		}

		/*
		*  @private
		*/
		/*private var _enabled:Boolean;
		private var _disableBead:DisableBead;
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if (_disableBead == null) {
				_disableBead = new DisableBead();
				addBead(_disableBead);
				addBead(new DisabledAlphaBead());
			}
			_disableBead.disabled = !_enabled;
			COMPILE::JS
			{
			    element.style.cursor = value ? "pointer" : "auto";
			}
		}*/

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


		public function getSubmenuIcon():String{
			return "▶";
		}

		private var _data:Object;

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

			_data  =value;

			var isSeparator:Boolean = getType() == "separator";


			if (isSeparator) {
				if (label) {
					removeChild(label);
					label = null;
				}
				if (icon) {
					configureIcon(null);
				}
				if (separator == null) {
					separator = new Rect();
					separator.fill = new SolidColor(0x000000);
					addElement(separator);
				}
			}
			else {
				if (separator) {
					removeElement(separator);
					separator = null;
				}
				var menu:Menu = listData ? listData.owner as Menu : null;
				if (menu) {
					if (menu.iconFunction){
						configureIcon(menu.iconFunction(value))
					} else {
						configureIcon(null)
					}
				}

				if (label == null) {
					label = new Label();
					addChild(label);
				}

				label.text = getLabel();

				if (getHasMenu()) {
					if (submenuIndicator == null) {
						submenuIndicator = new Label();
						submenuIndicator.text = getSubmenuIcon();
						addChild(submenuIndicator);
					}
					/*COMPILE::SWF {
						this.width = this.width + 2 + submenuIndicator.width;
					}*/
				}
			}

			if (parent && parent is Menu && (parent as Menu).dataDescriptor)
			{
				var desc:IMenuDataDescriptor = (parent as Menu).dataDescriptor;
				//make sure that "separators" are not 'enabled' as well:
				var configureEnabled:Boolean = (getType() != 'separator') && desc.isEnabled(value)
				enabled = configureEnabled;
			}
			dispatchEvent(new FlexEvent("dataChange"));
			if (parent) adjustSize();
		}

		private var _dataField:String;

		/**
		 *  The name of the field within the data the itemRenderer should use.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get dataField():String
		{
			return _dataField;
		}
		public function set dataField(value:String):void
		{
			_dataField = value;
		}
		
		protected function getHasMenu():Boolean
		{
			if (!(data is XML))
			{
				return data.hasOwnProperty("children");
			}
			return (data as XML).children().length() > 0;
		}


		
		protected function getLabel():String
		{
			if (_listData ) {
				return _listData.label;
			}
			if (!(data is XML))
			{
				return getLabelFromData(this,data);
			}
			var xml:XML = data as XML;
			if (labelField)
			{
				return xml.attribute(labelField).toString();
			}
			if (dataField)
			{
				return xml.attribute(dataField).toString();
			}
			return xml.attribute("label").toString();
		}
		
		protected function getType():String
		{
			if (!(data is XML))
			{
				return data.hasOwnProperty("type") ? data["type"] : null;
			}
			var type:String = (data as XML).attribute("type").toString();
			return type ? type : null;
		}

		private var _canFold:Boolean;
		public function get canFold():Boolean
		{
			return _canFold;
		}
		
		public function get canUnfold():Boolean
		{
			return getHasMenu();
		}

		public function isFoldInitiator(check:Object):Boolean
		{
			return true;//tbd
		}


		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();

			// very common for item renderers to be resized by their containers,
			addEventListener("widthChanged", sizeChangeHandler);
			addEventListener("heightChanged", sizeChangeHandler);
			addEventListener("sizeChanged", sizeChangeHandler);
			addEventListener("dataChange", sizeChangeHandler);
			/*     // each MXML file can also have styles in fx:Style block
                 ValuesManager.valuesImpl.init(this);*/

			dispatchEvent(new Event("initBindings"));
			dispatchEvent(new Event("initComplete"));
			/*if (data && width && height) {
				adjustSize();
			}*/

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

		//----------------------------------
		//  label
		//----------------------------------

		/**
		 *  The internal UITextField that displays the text in this renderer.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var label:Label;

		/**
		 * A place to show the sub-menu indicator
		 */
		private var submenuIndicator:Label;
	//	private var showingIndicator:Boolean = false;

		/**
		 * The separator if that's what this itemRenderer instance is supposed to show
		 */
		private var separator:Rect;


		//----------------------------------
		//  disclosureIcon
		//----------------------------------




		/*override protected function createChildren():void
		{
			super.createChildren();
			if (numChildren == 0)
			{
				label = new Label();
				addChild(label);
/!*				disclosureIcon = new Label();
				disclosureIcon.x = 0;
				disclosureIcon.truncateToFit = false;
				disclosureIcon.textAlign = 'right';
				addChild(disclosureIcon);*!/
			}
		}*/

		protected function createIcon():IFlexDisplayObject{
			var img:mx.controls.Image = new mx.controls.Image();
			img.width = getIconWidth() || height - 2;
			img.height = getIconHeight() || height -2 ;
		//	img.x = img.y = 2;
		//	img.setStyle("verticalAlign", "middle" );
			this.icon = img;
			addChild(img);
			return img;
		}

		//porting notes, only create icon if needed
		protected function configureIcon(source:Object):void{
			if (!source) {
				if (icon) removeChild(icon as IUIComponent);
				icon = null;
			} else {
				if (!icon) {
					icon = createIcon();
				}
				if (icon is mx.controls.Image) {
					mx.controls.Image(icon).source = source;
				}
			}
		}

		private var _listData:Object;

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

		/**
		 * @private
		 */
		private function sizeChangeHandler(event:Event):void
		{
			if (initialized)
				RoyaleUtil.commitDeferred(adjustSize)
		}

		/**
		 *  This function is called whenever the itemRenderer changes size. Sub-classes should override
		 *  this method an handle the size change.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function adjustSize():void
		{
			updateDisplayList(width, height);
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var cy:Number = unscaledHeight/2;
			var rightOffset:uint = 0;
			if (icon) {
				/*icon.y = 0;
				icon.x = ;*/
				icon.x = 2;
				icon.y = cy - icon.height/2;
				label.x = icon.x + icon.width + 2;
			} else {
				var iw:Number = getIconWidth();
				if (iw) iw += 4;
				if (label) label.x = iw;
			}
			if (label) {
				label.y = cy - label.height/2;
			}

			if (submenuIndicator) {
				rightOffset = submenuIndicator.width;
				submenuIndicator.x = unscaledWidth - rightOffset;
				submenuIndicator.y = cy - submenuIndicator.height/2;
			}

			if (separator) {
				this.setHeight(3,true);
				separator.x = 0;
				separator.y = 1;
				separator.width = unscaledWidth;
				separator.height = 1;
				separator.draw();
			}

			if (label){
				var lw:uint = unscaledWidth - label.x - rightOffset
				//if (label.width > lw) {
					label.setWidth(lw);
				//}
				//label.width = unscaledWidth - label.x - rightOffset;
			}
		}


		override public function get measuredWidth():Number{
			var w:Number = 0;
			if (icon) {
				w =  icon.width + 4;
			} else {
				w = getIconWidth();
				if (w) w += 4;
			}
			if (label) {
				w += label.measuredWidth + 4;
			}
			if (submenuIndicator) {
				w += submenuIndicator.measuredWidth;
			}
			if (separator) {
				w = 100;
			}
			return w;
		}



	}

}
