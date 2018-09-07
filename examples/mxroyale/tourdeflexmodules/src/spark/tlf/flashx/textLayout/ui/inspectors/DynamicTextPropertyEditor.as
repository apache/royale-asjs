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

package flashx.textLayout.ui.inspectors
{
	import bxf.ui.inspectors.DynamicPropertyEditorBase;

	import mx.events.PropertyChangeEvent;

	public class DynamicTextPropertyEditor extends DynamicPropertyEditorBase
	{
		public function DynamicTextPropertyEditor(inRecipe:XML)
		{
			super(inRecipe);
			TextInspectorController.Instance().addEventListener(SelectionUpdateEvent.SELECTION_UPDATE, onSelectionUpdate);
			addEventListener(DynamicPropertyEditorBase.MODELCHANGED_EVENT, onFormatValueChanged, false, 0, true);
			addEventListener(DynamicPropertyEditorBase.MODELEDITED_EVENT, onFormatValueChanged, false, 0, true);
		}
		
		public function set active(inActive:Boolean):void
		{
			if (mActive != inActive)
			{
				mActive = inActive;
				if (mActive)
					TextInspectorController.Instance().forceBroadcastFormats();
			}
		}
		
		public function get active():Boolean
		{
			return mActive;
		}
		
		private function onSelectionUpdate(e:SelectionUpdateEvent):void
		{
			if (mActive)
			{
				reset();
				for (var id:String in e.format)
				{
					if (e.format[id].length == 1)
						properties[id] = e.format[id][0];
					else
						properties[id] = e.format[id];
				}
				rebuildUI();
			}
		}

		private function onFormatValueChanged(e:PropertyChangeEvent):void
		{
			TextInspectorController.Instance().SetTextProperty(e.property as String, e.newValue);
		}
		
		private var mActive:Boolean = false;
	}
}