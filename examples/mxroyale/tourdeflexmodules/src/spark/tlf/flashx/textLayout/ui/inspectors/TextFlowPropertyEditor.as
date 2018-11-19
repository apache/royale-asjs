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
	import flashx.textLayout.formats.BlockProgression;
	import flashx.textLayout.formats.LineBreak;

	public class TextFlowPropertyEditor extends DynamicTextPropertyEditor
	{
		public function TextFlowPropertyEditor()
		{
			var recipe:XML =
				<recipe>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/LineProgression=Orientation:">
							<property name={TextInspectorController.BLOCK_PROGRESSION_UIPROP}/>
							<choice display="Horizontal" value={flashx.textLayout.formats.BlockProgression.TB}/>
							<choice display="Vertical" value={flashx.textLayout.formats.BlockProgression.RL}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/direction=Direction:">
							<property name={TextInspectorController.FLOW_DIRECTION_UIPROP}/>
							<choice display="Left to Right" value={flashx.textLayout.formats.Direction.LTR}/>
							<choice display="Right to Left" value={flashx.textLayout.formats.Direction.RTL}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/Linebreak=Line Breaks:">
							<property name={TextInspectorController.LINE_BREAK_UIPROP}/>
							<choice display="Auto Line Wrap" value={flashx.textLayout.formats.LineBreak.TO_FIT}/>
							<choice display="Hard Breaks Only" value={flashx.textLayout.formats.LineBreak.EXPLICIT}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/vertScroll=V. Scroll:">
							<property name={TextInspectorController.VERTICAL_SCROLL_UIPROP}/>
							<choice display="Off" value="off"/>
							<choice display="On" value="on"/>
							<choice display="Auto" value="auto"/>
						</editor>
						<editor type="combo" label="$$$/stage/TextEditing/Label/horzScroll=H. Scroll:">
							<property name={TextInspectorController.HORIZONTAL_SCROLL_UIPROP}/>
							<choice display="Off" value="off"/>
							<choice display="On" value="on"/>
							<choice display="Auto" value="auto"/>
						</editor>
					</row>
				</recipe>;
			super(recipe);
		}
		
	}
}