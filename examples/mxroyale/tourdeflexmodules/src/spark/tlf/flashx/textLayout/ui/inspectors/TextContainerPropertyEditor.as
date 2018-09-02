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
	import flash.text.engine.*;

	import flashx.textLayout.formats.FormatValue;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.tlf_internal;
	use namespace tlf_internal;
	
	public class TextContainerPropertyEditor extends DynamicTextPropertyEditor
	{
		[Embed(source="./assets/cont_align_top_icon.png")]
		private var contAlignTopIcon:Class;

		[Embed(source="./assets/cont_align_middle_icon.png")]
		private var contAlignMiddleIcon:Class;

		[Embed(source="./assets/cont_align_bottom_icon.png")]
		private var contAlignBottomIcon:Class;

		[Embed(source="./assets/cont_align_justify_icon.png")]
		private var contAlignJustifyIcon:Class;

		public function TextContainerPropertyEditor()
		{
			var recipe:XML =
				<recipe>
					<row>
						<editor type="multiIconButton" style="iconButtonGroup" label="$$$/stage/TextEditing/Label/Container/Alignment=Alignment:">
							<property name={TextInspectorController.VERTICAL_ALIGN_UIPROP}/>
							<button icon="contAlignTopIcon" value="top"/>
							<button icon="contAlignMiddleIcon" value="middle"/>
							<button icon="contAlignBottomIcon" value="bottom"/>
							<button icon="contAlignJustifyIcon" value="justify"/>
						</editor>
					</row>
					<row>
						<editor type="hotnumberunit" label="$$$/stage/TextEditing/Label/NumColumns=Columns:">
							<property name={TextInspectorController.COLUMN_COUNT_UIPROP}/>
							<defaultunit>count</defaultunit>
							<numericunit displayname="count"
								min={TextLayoutFormat.columnCountProperty.minValue} 
								max={TextLayoutFormat.columnCountProperty.maxValue} 
								default="1"/>
							<enumval displayname="Auto" value={flashx.textLayout.formats.FormatValue.AUTO}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumberunit" label="$$$/stage/TextEditing/Label/ColumnWidth=Column Width:">
							<property name={TextInspectorController.COLUMN_WIDTH_UIPROP}/>
							<defaultunit>pix</defaultunit>
							<numericunit displayname="pix" 
								min={TextLayoutFormat.columnWidthProperty.minValue} 
								max={TextLayoutFormat.columnWidthProperty.maxValue} 
								default="200"/>
							<enumval displayname="Auto" value={flashx.textLayout.formats.FormatValue.AUTO}/>
						</editor>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/ColumnGap=Gap:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.COLUMN_GAP_UIPROP} 
								minValue={TextLayoutFormat.columnGapProperty.minValue}
								maxValue={TextLayoutFormat.columnGapProperty.maxValue}/>
						</editor>
					</row>
					<row label="$$$/stage/TextEditing/Label/ContainerGeometry=Geometry:"/>
					<row>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/PaddingLeft=Left:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.PADDING_LEFT_UIPROP} 
								minValue={TextLayoutFormat.paddingLeftProperty.minValue} 
								maxValue={TextLayoutFormat.paddingLeftProperty.maxValue}/>
						</editor>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/PaddingTop=Top:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.PADDING_TOP_UIPROP} 
								minValue={TextLayoutFormat.paddingTopProperty.minValue} 
								maxValue={TextLayoutFormat.paddingTopProperty.maxValue}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/PaddingRight=Right:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.PADDING_RIGHT_UIPROP} 
								minValue={TextLayoutFormat.paddingRightProperty.minValue} 
								maxValue={TextLayoutFormat.paddingRightProperty.maxValue}/>
						</editor>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/PaddingBottom=Bottom:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.PADDING_BOTTOM_UIPROP} 
								minValue={TextLayoutFormat.paddingBottomProperty.minValue} 
								maxValue={TextLayoutFormat.paddingBottomProperty.maxValue}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumberunit" label="$$$/stage/TextEditing/Label/FirstBaseline=First Line Offset:">
							<property name={TextInspectorController.FIRST_BASELINE_UIPROP}/>
							<defaultunit>pix</defaultunit>
							<numericunit displayname="pix" 
								min={TextLayoutFormat.firstBaselineOffsetProperty.minValue}
								max={TextLayoutFormat.firstBaselineOffsetProperty.maxValue} 
								default="1"/>
							<enumval displayname="Auto" value={flashx.textLayout.formats.BaselineOffset.AUTO}/>
							<enumval displayname="Ascent" value={flashx.textLayout.formats.BaselineOffset.ASCENT}/>
							<enumval displayname="Line Height" value={flashx.textLayout.formats.BaselineOffset.LINE_HEIGHT}/>
						</editor>
					</row>
			<!--		<row label="$$$/stage/TextEditing/Label/Border=Border:">
						<editor type="combo" label="$$$/stage/TextEditing/Label/BorderStyle=Style:">
							<property name={TextInspectorController.BORDER_STYLE_UIPROP}/>
							<choice display="None" value={text.BorderStyle.NONE}/>
							<choice display="Solid" value={text.BorderStyle.SOLID}/>
							<choice display="Innie" value={text.BorderStyle.INSET}/>
							<choice display="Outie" value={text.BorderStyle.OUTSET}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/BorderThickness=Thickness:" decimals="0" enforcePrecision="yes">
							<property name={TextInspectorController.BORDER_THICKNESS_UIPROP} 
								minValue={TextLayoutFormat.borderThicknessProperty.minValue}
								maxValue={TextLayoutFormat.borderThicknessProperty.maxValue}/>
						</editor>
						<editor type="color" label="$$$/stage/TextEditing/Label/BorderColor=Color:">
							<property name={TextInspectorController.BORDER_COLOR_UIPROP}/>
						</editor>
					</row> -->
				</recipe>;

			super(recipe);

 			SetIcon("contAlignTopIcon", contAlignTopIcon);
 			SetIcon("contAlignMiddleIcon", contAlignMiddleIcon);
 			SetIcon("contAlignBottomIcon", contAlignBottomIcon);
 			SetIcon("contAlignJustifyIcon", contAlignJustifyIcon);
		}
		
	}
}