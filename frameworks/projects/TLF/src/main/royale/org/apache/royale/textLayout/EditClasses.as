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
package org.apache.royale.textLayout
{
	internal class EditClasses
	{
		import org.apache.royale.textLayout.container.TextContainerManager; TextContainerManager;
		
		import org.apache.royale.textLayout.events.FlowOperationEvent; FlowOperationEvent;
		import org.apache.royale.textLayout.events.SelectionEvent; SelectionEvent;
 
		import org.apache.royale.textLayout.edit.EditManager; EditManager;
		import org.apache.royale.textLayout.edit.ElementRange; ElementRange;
		import org.apache.royale.textLayout.edit.IEditManager; IEditManager;
		import org.apache.royale.textLayout.edit.Mark; Mark;
		import org.apache.royale.textLayout.edit.SelectionManager; SelectionManager;
		import org.apache.royale.textLayout.edit.ModelEdit; ModelEdit;
		import org.apache.royale.textLayout.edit.IMemento; IMemento;
		import org.apache.royale.textLayout.edit.ElementMark; ElementMark;

		import org.apache.royale.textLayout.edit.TextScrap; TextScrap;

		import org.apache.royale.textLayout.operations.ApplyFormatOperation; ApplyFormatOperation;
		import org.apache.royale.textLayout.operations.ApplyFormatToElementOperation; ApplyFormatToElementOperation;
		import org.apache.royale.textLayout.operations.ApplyLinkOperation; ApplyLinkOperation;
		import org.apache.royale.textLayout.operations.ApplyTCYOperation; ApplyTCYOperation;
		import org.apache.royale.textLayout.operations.ApplyElementIDOperation; ApplyElementIDOperation;
		import org.apache.royale.textLayout.operations.ApplyElementStyleNameOperation; ApplyElementStyleNameOperation;
		import org.apache.royale.textLayout.operations.ApplyElementTypeNameOperation; ApplyElementTypeNameOperation;
		import org.apache.royale.textLayout.operations.CreateDivOperation; CreateDivOperation;
		import org.apache.royale.textLayout.operations.ClearFormatOperation; ClearFormatOperation;
		import org.apache.royale.textLayout.operations.ClearFormatOnElementOperation; ClearFormatOnElementOperation;
		import org.apache.royale.textLayout.operations.CreateListOperation; CreateListOperation;
		import org.apache.royale.textLayout.operations.CreateSubParagraphGroupOperation; CreateSubParagraphGroupOperation;
		import org.apache.royale.textLayout.operations.CompositeOperation; CompositeOperation;
		import org.apache.royale.textLayout.operations.CopyOperation; CopyOperation;
		import org.apache.royale.textLayout.operations.CutOperation; CutOperation;
		import org.apache.royale.textLayout.operations.DeleteTextOperation; DeleteTextOperation;
		import org.apache.royale.textLayout.operations.FlowOperation; FlowOperation;
		import org.apache.royale.textLayout.operations.InsertInlineGraphicOperation; InsertInlineGraphicOperation;
		import org.apache.royale.textLayout.operations.InsertTextOperation; InsertTextOperation;
		import org.apache.royale.textLayout.operations.PasteOperation; PasteOperation;
		import org.apache.royale.textLayout.operations.RedoOperation; RedoOperation;
		import org.apache.royale.textLayout.operations.ApplyElementUserStyleOperation; ApplyElementUserStyleOperation;
		import org.apache.royale.textLayout.operations.SplitParagraphOperation; SplitParagraphOperation;
		import org.apache.royale.textLayout.operations.SplitElementOperation; SplitElementOperation;
		import org.apache.royale.textLayout.operations.UndoOperation; UndoOperation;

		import org.apache.royale.textLayout.utils.NavigationUtil; NavigationUtil;
		

	}
}
