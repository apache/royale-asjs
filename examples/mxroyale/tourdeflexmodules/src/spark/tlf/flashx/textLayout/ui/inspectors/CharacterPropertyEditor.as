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
	
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.tlf_internal;
	use namespace tlf_internal;	

	public class CharacterPropertyEditor extends DynamicTextPropertyEditor
	{
		[Embed(source="./assets/bold_icon.png")]
		private var boldIcon:Class;

		[Embed(source="./assets/italic_icon.png")]
		private var italicIcon:Class;
		
		[Embed(source="./assets/underline_icon.png")]
		private var underlineIcon:Class;

		[Embed(source="./assets/strikethrough_icon.png")]
		private var strikethroughIcon:Class;

		[Embed(source="./assets/superscript_icon.png")]
		private var superscriptIcon:Class;

		[Embed(source="./assets/subscript_icon.png")]
		private var subscriptIcon:Class;

		[Embed(source="./assets/tcy_icon.png")]
		private var tcyIcon:Class;

		public function CharacterPropertyEditor()
		{
			var recipe:XML = 
				<recipe>
					<row>
						<editor type="fontPicker" label="$$$/stage/TextEditing/Label/Font=Font:">
							<property name={TextInspectorController.FONT_FAMILY_UIPROP}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/FontLookup=Lookup:">
							<property name={TextInspectorController.FONT_LOOKUP_UIPROP}/>
							<choice display="Device" value={flash.text.engine.FontLookup.DEVICE}/>
							<choice display="Embedded CFF" value={flash.text.engine.FontLookup.EMBEDDED_CFF}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/Size=Size:" decimals="1" enforcePrecision="no">
							<property name={TextInspectorController.FONT_SIZE_UIPROP}
								minValue={TextLayoutFormat.fontSizeProperty.minValue}
								maxValue={TextLayoutFormat.fontSizeProperty.maxValue}/>
						</editor>
						<editor type="hotnumberunit" label="$$$/stage/TextEditing/Label/Leading=Leading:">
							<property name={TextInspectorController.LINE_HEIGHT_UIPROP}/>
							<defaultunit>pix</defaultunit>
							<numericunit displayname="%"
								min={TextLayoutFormat.lineHeightProperty.minPercentValue}
								max={TextLayoutFormat.lineHeightProperty.maxPercentValue}
								default="120"/>
							<numericunit displayname="pix"
								min={TextLayoutFormat.lineHeightProperty.minNumberValue}
								max={TextLayoutFormat.lineHeightProperty.maxNumberValue}
								default="14"
								decimals="1"/>
						</editor>
					</row>
					<row style="toggleButtonRow">
						<editor type="toggleButton" style="toggleIconButton" iconClass="boldIcon" width="17" commit="yes">
							<property name={TextInspectorController.FONT_WEIGHT_UIPROP} falseValue="normal" trueValue="bold"/>
						</editor>
						<editor type="toggleButton" style="toggleIconButton" iconClass="italicIcon" width="17" commit="yes">
							<property name={TextInspectorController.FONT_STYLE_UIPROP} falseValue="normal" trueValue="italic"/>
						</editor>
						<editor type="toggleButton" style="toggleIconButton" iconClass="underlineIcon" width="17" commit="yes">
							<property name={TextInspectorController.TEXT_DECORATION_UIPROP} falseValue="none" trueValue="underline"/>
						</editor>
						<editor type="toggleButton" style="toggleIconButton" iconClass="strikethroughIcon" width="17" commit="yes">
							<property name={TextInspectorController.LINE_THROUGH_UIPROP}/>
						</editor>
						<editor type="toggleButton" style="toggleIconButton" iconClass="superscriptIcon" width="17" commit="yes">
							<property name={TextInspectorController.BASELINE_SHIFT_SUPER_UIPROP}  falseValue="0" trueValue={flashx.textLayout.formats.BaselineShift.SUPERSCRIPT}/>
						</editor>
						<editor type="toggleButton" style="toggleIconButton" iconClass="subscriptIcon" width="17" commit="yes">
							<property name={TextInspectorController.BASELINE_SHIFT_SUB_UIPROP}  falseValue="0" trueValue={flashx.textLayout.formats.BaselineShift.SUBSCRIPT}/>
						</editor>
						<editor type="toggleButton" style="toggleIconButton" iconClass="tcyIcon" width="17" commit="yes">
							<property name={TextInspectorController.TCY_UIPROP}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/Kerning=Kerning:">
							<property name={TextInspectorController.KERNING_UIPROP}/>
							<choice display="On" value={flash.text.engine.Kerning.ON}/>
							<choice display="Off" value={flash.text.engine.Kerning.OFF}/>
							<choice display="Auto" value={flash.text.engine.Kerning.AUTO}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumberunit" label="$$$/stage/TextEditing/Label/Tracking=Track R:">
							<property name={TextInspectorController.TRACKING_RIGHT_UIPROP}/>
							<defaultunit>pix</defaultunit>
							<numericunit displayname="%" 
								min={TextLayoutFormat.trackingRightProperty.minPercentValue} 
								max={TextLayoutFormat.trackingRightProperty.maxPercentValue} 
								default="0"/>
							<numericunit displayname="pix" 
								min={TextLayoutFormat.trackingRightProperty.minNumberValue}
								max={TextLayoutFormat.trackingRightProperty.maxNumberValue}
								default="0" 
								decimals="1"/>
						</editor>
					</row>
					<row>
						<editor type="hotnumberunit" label="$$$/stage/TextEditing/Label/Tracking=Track L:">
							<property name={TextInspectorController.TRACKING_LEFT_UIPROP}/>
							<defaultunit>pix</defaultunit>
							<numericunit displayname="%" 
								min={TextLayoutFormat.trackingLeftProperty.minPercentValue} 
								max={TextLayoutFormat.trackingLeftProperty.maxPercentValue} 
								default="0"/>
							<numericunit displayname="pix" 
								min={TextLayoutFormat.trackingLeftProperty.minNumberValue}
								max={TextLayoutFormat.trackingLeftProperty.maxNumberValue}
								default="0" 
								decimals="1"/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/Case=Case:">
							<property name={TextInspectorController.TYPOGRAPHIC_CASE_UIPROP}/>
							<choice display="Default" value={flashx.textLayout.formats.TLFTypographicCase.DEFAULT}/>
							<choice display="Caps to Small Caps" value={flashx.textLayout.formats.TLFTypographicCase.CAPS_TO_SMALL_CAPS}/>
							<choice display="Upper" value={flashx.textLayout.formats.TLFTypographicCase.UPPERCASE}/>
							<choice display="Lower" value={flashx.textLayout.formats.TLFTypographicCase.LOWERCASE}/>
							<choice display="Lowercase to Small Caps" value={flashx.textLayout.formats.TLFTypographicCase.LOWERCASE_TO_SMALL_CAPS}/>
						</editor>
					</row>
					<row>
						<editor type="color" label="$$$/stage/TextEditing/Label/Color=Color:">
							<property name={TextInspectorController.COLOR_UIPROP}/>
						</editor>
						<editor type="color" label="$$$/stage/TextEditing/Label/BackgroundColor=Background color:">
							<property name={TextInspectorController.BGCOLOR_UIPROP}/>
						</editor>
					</row>
				</recipe>;
			
			super(recipe);
			SetIcon("boldIcon", boldIcon);
			SetIcon("italicIcon", italicIcon);
			SetIcon("underlineIcon", underlineIcon);
			SetIcon("strikethroughIcon", strikethroughIcon);
			SetIcon("superscriptIcon", superscriptIcon);
			SetIcon("subscriptIcon", subscriptIcon);
			SetIcon("tcyIcon", tcyIcon);
		}
		
	}
}