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
	
	import flash.text.engine.*;
	
	import flashx.textLayout.formats.TabStopFormat;
	import flashx.textLayout.tlf_internal;
	use namespace tlf_internal;
	
	public class TabPropertyEditor extends DynamicPropertyEditorBase
	{
		public function TabPropertyEditor()
		{
			var recipe:XML = 
				<recipe>
					<row>
						<editor type="checkbox" label="$$$/stage/TextEditing/Label/showRuler=Show Ruler" labelSide="right">
							<property name="rulervisible"/>
						</editor>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/tabPosition=Position:" decimals="1" enforcePrecision="no">
							<property name={TabStopFormat.positionProperty.name}
								minValue={TabStopFormat.positionProperty.minValue}
								maxValue={TabStopFormat.positionProperty.maxValue}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/tabType=Tab Type:">
							<property name={TabStopFormat.alignmentProperty.name}/>
							<choice display="Start" value={flash.text.engine.TabAlignment.START}/>
							<choice display="Center" value={flash.text.engine.TabAlignment.CENTER}/>
							<choice display="End" value={flash.text.engine.TabAlignment.END}/>
							<choice display="Align" value={flash.text.engine.TabAlignment.DECIMAL}/>
						</editor>
						<editor type="string" label="$$$/stage/TextEditing/Label/tabAlign=Align to:" width="50">
							<property name={TabStopFormat.decimalAlignmentTokenProperty.name}/>
						</editor>
					</row>
				</recipe>;

			super(recipe);
		}
		
	}
}