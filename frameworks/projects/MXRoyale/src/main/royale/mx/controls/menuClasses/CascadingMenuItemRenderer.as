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
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.html.supportClasses.CascadingMenuItemRenderer;
	import mx.supportClasses.IFoldable;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IPopUpHostParent;
	import mx.controls.Menu;
	import org.apache.royale.html.beads.DisableBead;
	import org.apache.royale.html.beads.DisabledAlphaBead;

	/**
	 *  The ListItemRenderer is the default renderer for mx.controls.List
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */

	public class CascadingMenuItemRenderer extends org.apache.royale.html.supportClasses.CascadingMenuItemRenderer implements IFoldable
	{
		public function CascadingMenuItemRenderer()
		{
			super();
		}

		/*
		*  @private
		*/
		private var _enabled:Boolean;
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
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			if (parent && parent is Menu && (parent as Menu).dataDescriptor)
			{
				var desc:IMenuDataDescriptor = (parent as Menu).dataDescriptor;
				//make sure that "separators" are not 'enabled' as well:
				var configureEnabled:Boolean = (getType() != 'separator') && desc.isEnabled(value)
				enabled = configureEnabled;
			}
	/*        COMPILE::SWF
			{
				var edge:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(this);
				var h:Number = textField.textHeight + edge.top + edge.bottom;
				textField.autoSize = "none";
				textField.height = h;
			}
	*/    }
		
		override protected function getHasMenu():Boolean
		{
			if (!(data is XML))
			{
				return data.hasOwnProperty("children");
			}
			return (data as XML).children().length() > 0;
		}
		
		override protected function getLabel():String
		{
			if (!(data is XML))
			{
				return super.getLabel();
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
		
		override protected function getType():String
		{
			if (!(data is XML))
			{
				return super.getType();
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
		
		public function isFoldInitiator(check:Object):Boolean{
			return true; //tbd
		}
	}

}
