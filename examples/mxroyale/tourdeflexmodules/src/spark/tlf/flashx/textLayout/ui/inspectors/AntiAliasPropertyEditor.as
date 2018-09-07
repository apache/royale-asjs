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
	import flash.text.AntiAliasType;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.RenderingMode;

	public class AntiAliasPropertyEditor extends DynamicTextPropertyEditor
	{
		public function AntiAliasPropertyEditor()
		{
			var recipe:XML = 
				<recipe>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/Antialias=Antialias:">
							<property name={TextInspectorController.RENDERING_MODE_UIPROP}/>
							<choice display="Normal" value={flash.text.engine.RenderingMode.NORMAL}/>
							<choice display="CFF" value={flash.text.engine.RenderingMode.CFF}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/GridFit=Grid Fit:">
							<property name={TextInspectorController.CFF_HINTING_UIPROP}/>
							<choice display="None" value={flash.text.engine.CFFHinting.NONE}/>
							<choice display="Horizontal stem" value={flash.text.engine.CFFHinting.HORIZONTAL_STEM}/>
						</editor>
					</row>
				</recipe>;
			super(recipe);
		}
		
	}
}