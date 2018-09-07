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
	public class LinkPropertyEditor extends DynamicTextPropertyEditor
	{
		public function LinkPropertyEditor()
		{
			var recipe:XML =
				<recipe>
					<row>
						<editor type="string" label="$$$/stage/TextEditing/Label/linkURL=URL:" width="150">
							<property name={TextInspectorController.LINK_URL_UIPROP}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/linkTarget=Target:">
							<property name={TextInspectorController.LINK_TARGET_UIPROP}/>
							<choice display="_blank" value={"_blank"}/>
							<choice display="_self" value={"_self"}/>
							<choice display="_parent" value={"_parent"}/>
							<choice display="_top" value={"_top"}/>
						</editor>
						<editor type="checkbox" label="$$$/stage/TextEditing/Label/linkExtend=Extend:">
							<property name={TextInspectorController.LINK_EXTEND_UIPROP}/>
						</editor>
					</row>
				</recipe>;
			super(recipe);
		}
		
	}
}