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
package org.apache.flex.textLayout
{
	internal class EditClasses
	{
		import org.apache.flex.textLayout.container.TextContainerManager; TextContainerManager;
		
		import org.apache.flex.textLayout.events.FlowOperationEvent; FlowOperationEvent;
		import org.apache.flex.textLayout.events.SelectionEvent; SelectionEvent;
 
		import org.apache.flex.textLayout.edit.EditManager; EditManager;
		import org.apache.flex.textLayout.edit.ElementRange; ElementRange;
		import org.apache.flex.textLayout.edit.IEditManager; IEditManager;
		import org.apache.flex.textLayout.edit.Mark; Mark;
		import org.apache.flex.textLayout.edit.SelectionManager; SelectionManager;
		import org.apache.flex.textLayout.edit.ModelEdit; ModelEdit;
		import org.apache.flex.textLayout.edit.IMemento; IMemento;
		import org.apache.flex.textLayout.edit.ElementMark; ElementMark;

		import org.apache.flex.textLayout.edit.TextScrap; TextScrap;

		import org.apache.flex.textLayout.operations.ApplyFormatOperation; ApplyFormatOperation;
		import org.apache.flex.textLayout.operations.ApplyFormatToElementOperation; ApplyFormatToElementOperation;
		import org.apache.flex.textLayout.operations.ApplyLinkOperation; ApplyLinkOperation;
		import org.apache.flex.textLayout.operations.ApplyTCYOperation; ApplyTCYOperation;
		import org.apache.flex.textLayout.operations.ApplyElementIDOperation; ApplyElementIDOperation;
		import org.apache.flex.textLayout.operations.ApplyElementStyleNameOperation; ApplyElementStyleNameOperation;
		import org.apache.flex.textLayout.operations.ApplyElementTypeNameOperation; ApplyElementTypeNameOperation;
		import org.apache.flex.textLayout.operations.CreateDivOperation; CreateDivOperation;
		import org.apache.flex.textLayout.operations.ClearFormatOperation; ClearFormatOperation;
		import org.apache.flex.textLayout.operations.ClearFormatOnElementOperation; ClearFormatOnElementOperation;
		import org.apache.flex.textLayout.operations.CreateListOperation; CreateListOperation;
		import org.apache.flex.textLayout.operations.CreateSubParagraphGroupOperation; CreateSubParagraphGroupOperation;
		import org.apache.flex.textLayout.operations.CompositeOperation; CompositeOperation;
		import org.apache.flex.textLayout.operations.CopyOperation; CopyOperation;
		import org.apache.flex.textLayout.operations.CutOperation; CutOperation;
		import org.apache.flex.textLayout.operations.DeleteTextOperation; DeleteTextOperation;
		import org.apache.flex.textLayout.operations.FlowOperation; FlowOperation;
		import org.apache.flex.textLayout.operations.InsertInlineGraphicOperation; InsertInlineGraphicOperation;
		import org.apache.flex.textLayout.operations.InsertTextOperation; InsertTextOperation;
		import org.apache.flex.textLayout.operations.PasteOperation; PasteOperation;
		import org.apache.flex.textLayout.operations.RedoOperation; RedoOperation;
		import org.apache.flex.textLayout.operations.ApplyElementUserStyleOperation; ApplyElementUserStyleOperation;
		import org.apache.flex.textLayout.operations.SplitParagraphOperation; SplitParagraphOperation;
		import org.apache.flex.textLayout.operations.SplitElementOperation; SplitElementOperation;
		import org.apache.flex.textLayout.operations.UndoOperation; UndoOperation;

		import org.apache.flex.textLayout.utils.NavigationUtil; NavigationUtil;
		

	}
}
