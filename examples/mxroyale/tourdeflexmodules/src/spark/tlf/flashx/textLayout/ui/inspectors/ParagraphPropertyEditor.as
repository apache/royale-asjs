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
	
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.FormatValue;
	import flashx.textLayout.formats.TextJustify;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.tlf_internal;
	import flashx.textLayout.formats.LeadingModel;
	use namespace tlf_internal;
		
	public class ParagraphPropertyEditor extends DynamicTextPropertyEditor
	{
		[Embed(source="./assets/align_start_icon.png")]
		private var alignStartIcon:Class;
		
		[Embed(source="./assets/align_end_icon.png")]
		private var alignEndIcon:Class;
		
		[Embed(source="./assets/align_left_icon.png")]
		private var alignLeftIcon:Class;
		
		[Embed(source="./assets/align_center_icon.png")]
		private var alignCenterIcon:Class;
		
		[Embed(source="./assets/align_right_icon.png")]
		private var alignRightIcon:Class;
		
		[Embed(source="./assets/align_justify_icon.png")]
		private var alignJustifyIcon:Class;
		
		[Embed(source="./assets/align_last_left_icon.png")]
		private var alignLastLeftIcon:Class;
		
		[Embed(source="./assets/align_last_center_icon.png")]
		private var alignLastCenterIcon:Class;
		
		[Embed(source="./assets/align_last_right_icon.png")]
		private var alignLastRightIcon:Class;

		public function ParagraphPropertyEditor()
		{
			var recipe:XML =
				<recipe>
					<row>
						<editor type="multiIconButton" style="iconButtonGroup" label="$$$/stage/TextEditing/Label/Alignment=Alignment:">
							<property name={TextInspectorController.TEXT_ALIGN_UIPROP}/>
							<button icon="alignStartIcon" value="start"/>
							<button icon="alignEndIcon" value="end"/>
							<button icon="alignLeftIcon" value="left"/>
							<button icon="alignCenterIcon" value="center"/>
							<button icon="alignRightIcon" value="right"/>
							<button icon="alignJustifyIcon" value="justify"/>
						</editor>
					</row>
					<row>
						<editor type="multiIconButton" style="iconButtonGroup" label="$$$/stage/TextEditing/Label/LastLine=Last Line:">
							<property name={TextInspectorController.TEXT_ALIGN_LAST_UIPROP}/>
							<button icon="alignStartIcon" value="start"/>
							<button icon="alignEndIcon" value="end"/>
							<button icon="alignLastLeftIcon" value="left"/>
							<button icon="alignLastCenterIcon" value="center"/>
							<button icon="alignLastRightIcon" value="right"/>
							<button icon="alignJustifyIcon" value="justify"/>
						</editor>
					</row>
					<row>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/Indent=Text Indent:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.TEXT_INDENT_UIPROP}
								minValue={TextLayoutFormat.textIndentProperty.minValue}
								maxValue={TextLayoutFormat.textIndentProperty.maxValue}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/Left=Start Indent:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.START_INDENT_UIPROP} 
								minValue={TextLayoutFormat.paragraphStartIndentProperty.minValue}
								maxValue={TextLayoutFormat.paragraphStartIndentProperty.maxValue}/>
						</editor>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/Right=End:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.END_INDENT_UIPROP} 
								minValue={TextLayoutFormat.paragraphEndIndentProperty.minValue} 
								maxValue={TextLayoutFormat.paragraphEndIndentProperty.maxValue}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/Before=Space Before:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.SPACE_BEFORE_UIPROP} 
								minValue={TextLayoutFormat.paragraphSpaceBeforeProperty.minValue} 
								maxValue={TextLayoutFormat.paragraphSpaceBeforeProperty.maxValue}/>
						</editor>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/After=After:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.SPACE_AFTER_UIPROP} 
								minValue={TextLayoutFormat.paragraphSpaceAfterProperty.minValue} 
								maxValue={TextLayoutFormat.paragraphSpaceAfterProperty.maxValue}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/justRule=Just. Rule:">
							<property name={TextInspectorController.JUSTIFICATION_RULE_UIPROP}/>
							<choice display="Auto" value={FormatValue.AUTO}/>
							<choice display="Roman" value={flashx.textLayout.formats.JustificationRule.SPACE}/>
							<choice display="East Asian" value={flashx.textLayout.formats.JustificationRule.EAST_ASIAN}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/textJust=Text Justify:">
							<property name={TextInspectorController.TEXT_JUSTIFY_UIPROP}/>
							<choice display="Inter-word" value={flashx.textLayout.formats.TextJustify.INTER_WORD}/>
							<choice display="Distribute" value={flashx.textLayout.formats.TextJustify.DISTRIBUTE}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/justStyle=Just. Style:">
							<property name={TextInspectorController.JUSTIFICATION_STYLE_UIPROP}/>
							<choice display="Auto" value={FormatValue.AUTO}/>
							<choice display="Prioritize Least Adjustment" value={flash.text.engine.JustificationStyle.PRIORITIZE_LEAST_ADJUSTMENT}/>
							<choice display="Push in Kinsoku" value={flash.text.engine.JustificationStyle.PUSH_IN_KINSOKU}/>
							<choice display="Push out Only" value={flash.text.engine.JustificationStyle.PUSH_OUT_ONLY}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/direction=Direction:">
							<property name={TextInspectorController.DIRECTION_UIPROP}/>
							<choice display="Left to Right" value={flashx.textLayout.formats.Direction.LTR}/>
							<choice display="Right to Left" value={flashx.textLayout.formats.Direction.RTL}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/leadingModel=Leading Model:">
							<property name={TextInspectorController.LEADING_MODEL_UIPROP}/>
							<choice display="Roman; Up" value={flashx.textLayout.formats.LeadingModel.ROMAN_UP}/>
							<choice display="Ideographic Top; Up" value={flashx.textLayout.formats.LeadingModel.IDEOGRAPHIC_TOP_UP}/>
							<choice display="Ideographic Center; Up" value={flashx.textLayout.formats.LeadingModel.IDEOGRAPHIC_CENTER_UP}/>
							<choice display="Ideographic Top; Down" value={flashx.textLayout.formats.LeadingModel.IDEOGRAPHIC_TOP_DOWN}/>
							<choice display="Ideographic Center; Down" value={flashx.textLayout.formats.LeadingModel.IDEOGRAPHIC_CENTER_DOWN}/>
							<choice display="Ascent-Descent; Up" value={flashx.textLayout.formats.LeadingModel.ASCENT_DESCENT_UP}/>
							<choice display="Approximate TextField" value={flashx.textLayout.formats.LeadingModel.APPROXIMATE_TEXT_FIELD}/>
							<choice display="Auto" value={flashx.textLayout.formats.LeadingModel.AUTO}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/Lacale=Locale:">
							<property name={TextInspectorController.PARA_LOCALE_UIPROP}/>
							<choice display="Arabic" value="ar"/>,
							<choice display="Bengali" value="bn"/>,
							<choice display="Bulgarian" value="bg"/>,
							<choice display="Catalan" value="ca"/>,
							<choice display="Chinese, Simplified (China)" value="zh-CN"/>,
							<choice display="Chinese, Traditional (Taiwan)" value="zh-TW"/>,
							<choice display="Croatian" value="hr"/>,
							<choice display="Czech" value="cs"/>,
							<choice display="Danish" value="da"/>,
							<choice display="Dutch" value="nl"/>,
							<choice display="English" value="en"/>,
							<choice display="Estonian" value="et"/>,
							<choice display="Finnish" value="fi"/>,
							<choice display="French" value="fr"/>,
							<choice display="German" value="de"/>,
							<choice display="Greek" value="el"/>,
							<choice display="Gujarati" value="gu"/>,
							<choice display="Hindi" value="hi"/>,
							<choice display="Hebrew" value="he"/>,
							<choice display="Hungarian" value="hu"/>,
							<choice display="Italian" value="it"/>,
							<choice display="Japanese" value="ja"/>,
							<choice display="Korean" value="ko"/>,
							<choice display="Latvian" value="lv"/>,
							<choice display="Lithuanian" value="lt"/>,
							<choice display="Marathi" value="mr"/>,
							<choice display="Norwegian" value="no"/>,
							<choice display="Persian" value="fa"/>,
							<choice display="Polish" value="pl"/>,
							<choice display="Portuguese" value="pt"/>,
							<choice display="Punjabi" value="pa"/>,
							<choice display="Romanian" value="ro"/>,
							<choice display="Russian" value="ru"/>,
							<choice display="Slovak" value="sk"/>,
							<choice display="Slovenian" value="sl"/>,
							<choice display="Spanish" value="es"/>,
							<choice display="Swedish" value="sv"/>,
							<choice display="Tamil" value="ta"/>,
							<choice display="Telugu" value="te"/>,
							<choice display="Thai" value="th"/>,
							<choice display="Turkish" value="tr"/>,
							<choice display="Ukrainian" value="uk"/>,
							<choice display="Urdu" value="ur"/>,
							<choice display="Vietnamese" value="vi"/>
						</editor>
					</row>
				</recipe>;

			super(recipe);
			
 			SetIcon("alignStartIcon", alignStartIcon);
 			SetIcon("alignEndIcon", alignEndIcon);
 			SetIcon("alignLeftIcon", alignLeftIcon);
 			SetIcon("alignCenterIcon", alignCenterIcon);
 			SetIcon("alignRightIcon", alignRightIcon);
 			SetIcon("alignJustifyIcon", alignJustifyIcon);
 			SetIcon("alignLastLeftIcon", alignLastLeftIcon);
 			SetIcon("alignLastCenterIcon", alignLastCenterIcon);
 			SetIcon("alignLastRightIcon", alignLastRightIcon);
		}
	}
}