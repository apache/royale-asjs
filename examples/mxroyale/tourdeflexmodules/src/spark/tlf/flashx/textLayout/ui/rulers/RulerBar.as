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

package flashx.textLayout.ui.rulers
{
	import bxf.ui.inspectors.DynamicPropertyEditorBase;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.TabAlignment;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.ElementRange;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.ContainerFormattedElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.events.SelectionEvent;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.ITabStopFormat;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.formats.TabStopFormat;
	import flashx.textLayout.formats.BlockProgression;
	import flashx.textLayout.tlf_internal;
	import flashx.textLayout.ui.inspectors.TabPropertyEditor;
	import flashx.textLayout.ui.inspectors.TextInspectorController;
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	use namespace tlf_internal;
	
	public class RulerBar extends Canvas
	{
		public static const RULER_HORIZONTAL:String = "horizontal";
		public static const RULER_VERTICAL:String = "vertical";
		
		public function RulerBar()
		{
			super();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			mDefaultTabStop = new TabStopFormat(TabStopFormat.defaultFormat);
			addEventListener(MouseEvent.MOUSE_DOWN, onRulerMouseDown);
			selectMarker(null);
			TextInspectorController.Instance().AddRuler(this);
			curParagraphFormat = null;
		}
		
		override public function initialize():void
		{
			super.initialize();
			adjustForActive();
		}
		
		public function creationComplete():void
		{
			if (mSyncToPanel)
			{
				mSyncToPanel.addEventListener(ResizeEvent.RESIZE, onSyncPanelResize);
			}
			SyncRulerToPanel();
			mIndentMarker = addParagraphPropertyMarker(TextLayoutFormat.textIndentProperty.name);
			mLeftMarginMarker = addParagraphPropertyMarker(TextLayoutFormat.paragraphStartIndentProperty.name);
			mRightMarginMarker = addParagraphPropertyMarker(TextLayoutFormat.paragraphEndIndentProperty.name);
		}
		
 		public function set activeFlow(inFlow:TextFlow):void
		{
			if (inFlow && !inFlow.interactionManager is EditManager)
				throw new Error("Can't set the active flow to a flow without an EditManager.");
			if (mActiveFlow)
			{
				mActiveFlow.removeEventListener(SelectionEvent.SELECTION_CHANGE, onTextSelectionChanged);
				mEditManager = null;
			}
			mActiveFlow = inFlow;
			mLastSelActiveIdx = -1;
			mLastSelAnchorIdx = -1;
			mTabSet = null;
			RemoveTabMarkers();
			selectMarker(null);
			
			if (mActiveFlow)
			{
				mEditManager = mActiveFlow.interactionManager as EditManager;
				mActiveFlow.addEventListener(SelectionEvent.SELECTION_CHANGE, onTextSelectionChanged);
			}
			else
				onTextSelectionChanged(null);
		}
		
		public function get activeFlow():TextFlow
		{
			return mActiveFlow;
		}
		
		public function set active(inActive:Boolean):void
		{
			mActive = inActive;
			selectMarker(null);
			adjustForActive();
		}
		
		public function get active():Boolean
		{
			return mActive;
		}

		private function set rightRuler(inActive:Boolean):void
		{
			mRightRuler = inActive;
			adjustForActive();
		}
		
		private function get rightRuler():Boolean
		{
			return mRightRuler;
		}
		
		private function adjustForActive():void
		{
			if (parent)
			{
				if (mActive && mRightRuler)
				{
					parent.visible = true;
					if (parent is Canvas)
						(parent as Canvas).includeInLayout = true;
				}
				else
				{
					parent.visible = false;
					if (parent is Canvas)
						(parent as Canvas).includeInLayout = false;
				}
			}
		}
		
		public function set orientation(inOrientation:String):void
		{
			if (inOrientation != mOrientation && (inOrientation == RULER_HORIZONTAL || inOrientation == RULER_VERTICAL))
			{
				mOrientation = inOrientation;
			}
		}
		
		public function set syncToPanel(inPanel:UIComponent):void
		{
			mSyncToPanel = inPanel;
		}
		
		public function set tabPropertyEditor(inEditor:TabPropertyEditor):void
		{
			mPropertyEditor = inEditor;
			mPropertyEditor.addEventListener(DynamicPropertyEditorBase.MODELCHANGED_EVENT, onFormatValueChanged, false, 0, true);
			mPropertyEditor.addEventListener(DynamicPropertyEditorBase.MODELEDITED_EVENT, onFormatValueChanged, false, 0, true);
			selectMarker(mSelectedMarker);
		}
		
 		private function onSyncPanelResize(evt:ResizeEvent):void
 		{
 			RedrawRuler();
 		}
 		
 		public function RedrawRuler():void
 		{
 			SyncRulerToPanel();
 			if (curParagraphFormat != null) {
 				ShowTabs(curParagraphFormat);
 			} 			
 		}

  		private function SyncRulerToPanel():void
 		{
 			if (mActiveFlow && mActiveFlow.flowComposer && rightRuler)
 			{
 				var selStart:int = Math.min(mActiveFlow.interactionManager.activePosition, mActiveFlow.interactionManager.anchorPosition);
 				var line:TextFlowLine = selStart != -1 ? mActiveFlow.flowComposer.findLineAtPosition(selStart) : null;
 				if (line)
 				{
 					var controller:ContainerController;
 					var containerDO:DisplayObject;
 					if (line.controller)
 					{
 						controller = line.controller;
 						containerDO = controller.container as DisplayObject;
 					}
 					else
 					{
 						// get the last container
 						controller = mActiveFlow.flowComposer.getControllerAt(mActiveFlow.flowComposer.numControllers-1);
 						containerDO = controller.container as DisplayObject;
 					}
 					var localOrigin:Point = parent.globalToLocal(containerDO.parent.localToGlobal(new Point(containerDO.x, containerDO.y)));
	 				var columnBounds:Rectangle;
	 				var columnIndex:int = line.columnIndex;
	 				if (columnIndex == -1)
	 					columnBounds = controller.columnState.getColumnAt(controller.columnState.columnCount - 1);
	 				else
	 				{
	 					// columnIndex is an index into all the columns in the flow, so to get the actual
	 					// column bounds 
	 					var idx:int = 0;
	 					var ch:ContainerController = mActiveFlow.flowComposer.getControllerAt(idx);
	 					while (ch && ch != controller)
	 					{
	 						columnIndex -= ch.columnState.columnCount;
	 						idx++;
 							ch = idx == mActiveFlow.flowComposer.numControllers ? null : mActiveFlow.flowComposer.getControllerAt(idx);
	 					}
	 					// Pin the column number to the actual range of column indices. I have found this
	 					// is needed when the insertion point is inside a table (because the line's container
	 					// is not in the flow's list of containers) or when the insertion point is in regular
	 					// text after a table (the column number doesn't make sense, and I think it's a bug, which
	 					// I have written to Robin about.
	 					columnIndex = Math.max(0, Math.min(line.columnIndex, controller.columnState.columnCount - 1));
	 					columnBounds = controller.columnState.getColumnAt(columnIndex);
	 				}
	 				
		 			if (columnBounds)
		 			{
			 			if (mOrientation == RULER_HORIZONTAL)
			 			{
			 				x = localOrigin.x + columnBounds.x;
			 				y = 0;
			 				height = parent.height;
				 			width = columnBounds.width;
			 			}
			 			else
			 			{
			 				x = parent.width;
			 				y = localOrigin.y + columnBounds.y;
			 				rotation = 90;
			   				height = parent.width;
							width = columnBounds.height;
						}
		 			}
	 			}
 			}
 		}

		private function onTextSelectionChanged(e:SelectionEvent):void
		{
			curParagraphFormat = null;
			if (mEditManager && (mEditManager.activePosition != mLastSelActiveIdx || mEditManager.anchorPosition != mLastSelAnchorIdx))
			{
				mLastSelActiveIdx = mActiveFlow.interactionManager.activePosition;
				mLastSelAnchorIdx = mActiveFlow.interactionManager.anchorPosition;
				selectMarker(null);
			}
			if (e)
			{
				var selState:SelectionState = e.selectionState;
				var selectedElementRange:ElementRange =  selState ? ElementRange.createElementRange(selState.textFlow, selState.absoluteStart, selState.absoluteEnd) : null;
				if (selectedElementRange)
				{
		 			var rootElement:ContainerFormattedElement = selectedElementRange.firstLeaf.getAncestorWithContainer();
		 			if ((rootElement.computedFormat.blockProgression == BlockProgression.RL) == (mOrientation == RULER_VERTICAL))
		 			{
		 				// should be active
		 				if (rightRuler != true)
		 				{
		 					mTabSet = null;
		 				}
		 				if (!rightRuler)
		 					rightRuler = true;
		 			}
		 			else
		 			{
		 				// should be inactive
		 				if (rightRuler != false)
		 				{
		 					mTabSet = null;
		 				}
		 				if (rightRuler)
		 					rightRuler = false;
		 			}
					
	  				curParagraphFormat = new TextLayoutFormat(selectedElementRange.firstParagraph.computedFormat);
	  				setRightToLeft(curParagraphFormat.direction == flashx.textLayout.formats.Direction.RTL);					
					ShowTabs(curParagraphFormat);
				}
				else
					ShowTabs(null);
			}
			else
				ShowTabs(null);
		}
		
		
		private function RemoveTabMarkers():void
		{
			var markers:Array = getChildren();
			for each (var marker:UIComponent in markers)
				if (marker is TabMarker)
					this.removeChild(marker);
		}
		
		
		private function ShowTabs(inFormat:ITextLayoutFormat):void
		{
			SyncRulerToPanel();
			var tabs:Array = inFormat ? ((inFormat.tabStops && (inFormat.tabStops.length > 0)) ? inFormat.tabStops as Array : null) : null;
			if (isNewTabSet(tabs))
			{
				mTabSet = tabs;
				if (mUpdateFromSelection)
				{
					RemoveTabMarkers();
					var oldSel:RulerMarker = mSelectedMarker;
					selectMarker(null);
					if (mTabSet)
						for each(var tab:TabStopFormat in mTabSet)
						{
							var tabMarker:TabMarker = addTabMarker(tab);
							if (oldSel && oldSel.pos == tabMarker.pos)
								selectMarker(tabMarker);
						}
				}
			}
			if (inFormat)
			{
				if(mIndentMarker)
				{
					mIndentMarker.rightToLeftPar = mRightToLeft;
					mIndentMarker.pos = Number(inFormat.textIndent);
					mIndentMarker.relativeToPosition = inFormat.paragraphStartIndent;
				}
				
				if(mLeftMarginMarker)
				{
					mLeftMarginMarker.rightToLeftPar = mRightToLeft;
					mLeftMarginMarker.pos = rightToLeft ? Number(inFormat.paragraphEndIndent): Number(inFormat.paragraphStartIndent);
				}
				
				if(mRightMarginMarker)
				{
					mRightMarginMarker.rightToLeftPar = mRightToLeft;
					mRightMarginMarker.pos = rightToLeft ? Number(inFormat.paragraphStartIndent): Number(inFormat.paragraphEndIndent);
				}
			}
		}
		
		
		private function addTabMarker(tabAttrs:ITabStopFormat):TabMarker
		{
			var tabMarker:TabMarker = new TabMarker(this, tabAttrs);
			tabMarker.addEventListener(MouseEvent.MOUSE_DOWN, onMarkerMouseDown);
			addChild(tabMarker);
			return tabMarker;
		}
		
		
		private function addParagraphPropertyMarker(inProperty:String):ParagraphPropertyMarker
		{
			var propMarker:ParagraphPropertyMarker = new ParagraphPropertyMarker(this, inProperty);
			propMarker.addEventListener(MouseEvent.MOUSE_DOWN, onMarkerMouseDown);
			addChild(propMarker);
			return propMarker;
		}
		
		
		private function isNewTabSet(inTabs:Array):Boolean
		{
			if (inTabs == mTabSet)
				return false;
			if ((inTabs == null) != (mTabSet == null))
				return true;
			if (inTabs)
			{
				if (inTabs.length == mTabSet.length)
				{
					var n:int = inTabs.length;
					for (var i:int = 0; i < n; ++i)
					{
						if (inTabs[i] != mTabSet[i])
							return true;
					}
					return false;
				}
				else
					return true;
			}
			return false;
		}


		override protected function updateDisplayList(w:Number, h:Number):void
		{
		    super.updateDisplayList(w, h);
		    
			graphics.clear();
			var m:Matrix = new Matrix();
			m.createGradientBox(height, height, Math.PI / 2);
			graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xe0e0e0], [1, 1], [0, 255], m);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			graphics.lineStyle(1, 0x404040, 1.0, true);
			for (var x:int = 0; x < w; x += 10)
			{
				var rulerX:Number = rightToLeft ? w - x - 1 : x;
				if (x % 100 == 0)
					graphics.moveTo(rulerX, 12);
				else if (x % 50 == 0)
					graphics.moveTo(rulerX, 9);
				else
					graphics.moveTo(rulerX, 5);
				graphics.lineTo(rulerX, 0);
			}
		}
		
		private function onMarkerMouseDown(e:MouseEvent):void
		{
			if (mEditManager)
			{
				var cookie:Object;
				if (e.target is TabMarker)
				{
					var tabMarker:TabMarker = e.target as TabMarker;
					selectMarker(tabMarker);
					e.stopPropagation();
					cookie = new Object();
					cookie["marker"] = tabMarker;
					cookie["offset"] = e.localX;
					cookie["onRuler"] = true;
					mUpdateFromSelection = false;
					new RulerDragTracker(this.parentApplication as UIComponent, this, cookie).BeginTracking(e, false);
				}
				else if (e.target is ParagraphPropertyMarker)
				{
					var propMarker:ParagraphPropertyMarker = e.target as ParagraphPropertyMarker;
					selectMarker(null);
					e.stopPropagation();
					cookie = new Object();
					cookie["marker"] = propMarker;
					cookie["offset"] = e.localX;
					new RulerDragTracker(this.parentApplication as UIComponent, this, cookie).BeginTracking(e, false);
				}
			}
		}
		
		private function onRulerMouseDown(e:MouseEvent):void
		{
			if (e.target is RulerBar && mEditManager)
			{
				var tabMarker:TabMarker = addTabMarker(mDefaultTabStop);
				tabMarker.markerLeft = e.localX + tabMarker.hOffset;
				selectMarker(tabMarker);
				mUpdateFromSelection = false;
				setFormatFromRuler();
				e.stopPropagation();
				var cookie:Object = new Object();
				cookie["marker"] = tabMarker;
				cookie["offset"] = -tabMarker.hOffset;
				cookie["onRuler"] = true;
				new RulerDragTracker(this.parentApplication as UIComponent, this, cookie, 0).BeginTracking(e, false);
			}
		}
		
		public function TrackDrag(inCurPos:Point, inCookie:Object, inCommit:Boolean):void
		{
			if (inCookie)
			{
				if (inCookie["marker"] is TabMarker)
				{
					var tabMarker:TabMarker = inCookie["marker"] as TabMarker;
					var wasOnRuler:Boolean = inCookie["onRuler"];
					if (inCookie["onRuler"] && inCurPos.y > height + 16)
					{
						inCookie["onRuler"] = false;
						removeChild(tabMarker);
						selectMarker(null);
					}
					else if (!inCookie["onRuler"] && inCurPos.y <= height + 16)
					{
						inCookie["onRuler"] = true;
						addChild(tabMarker);
						selectMarker(tabMarker);
					}
					
					tabMarker.markerLeft = inCurPos.x - inCookie["offset"];
					if (wasOnRuler || inCookie["onRuler"])
						setFormatFromRuler();
				}
				else if (inCookie["marker"] is ParagraphPropertyMarker)
				{
					var propMarker:ParagraphPropertyMarker = inCookie["marker"] as ParagraphPropertyMarker;
					propMarker.markerLeft = inCurPos.x - inCookie["offset"];
					var pa:TextLayoutFormat = new TextLayoutFormat();
					pa[propMarker.property] = propMarker.pos;
					mEditManager.applyParagraphFormat(pa);
				}
			}
			if (inCommit)
				mUpdateFromSelection = true;
		}
		
		public function DragCancelled():void
		{
			mUpdateFromSelection = true;
		}

		private function selectMarker(inMarker:RulerMarker):void
		{
			if (mSelectedMarker)
				mSelectedMarker.setStyle("selected", false);
			mSelectedMarker = inMarker;
			if (mSelectedMarker)
				mSelectedMarker.setStyle("selected", true);
			updatePropertyEditor();
		}
		
		private function updatePropertyEditor():void
		{
			if (mRightRuler && mPropertyEditor && mTabPanelActive)
			{
				mPropertyEditor.reset();
				mPropertyEditor.properties["rulervisible"] = TextInspectorController.Instance().rulerVisible;
				if (TextInspectorController.Instance().rulerVisible)
				{
					var tab:ITabStopFormat = mSelectedMarker as ITabStopFormat;
					if (!tab)
						tab = mDefaultTabStop as ITabStopFormat;
					if (tab)
					{
						mPropertyEditor.properties["alignment"] = tab.alignment;
						if (tab != mDefaultTabStop)
							mPropertyEditor.properties["position"] = tab.position;
						if (tab.alignment == flash.text.engine.TabAlignment.DECIMAL)
							mPropertyEditor.properties["decimalAlignmentToken"] = tab.decimalAlignmentToken;
					}
				}
				mPropertyEditor.rebuildUI();
			}
		}
		
		private function onFormatValueChanged(e:PropertyChangeEvent):void
		{
			if (mRightRuler)
			{
				var property:String = e.property as String;
				if (property == "rulervisible")
					TextInspectorController.Instance().rulerVisible = (e.newValue == "true" ? true : false);
				else
				{
					if (e.type == DynamicPropertyEditorBase.MODELEDITED_EVENT)
						mUpdateFromSelection = false;
					var tab:Object = mSelectedMarker;
					if (!tab)
						tab = mDefaultTabStop;
					var newValue:Object = e.newValue;
					if (property == "position")
						newValue = Number(newValue);
					tab[property] = newValue;
					if (property == "alignment" && newValue == flash.text.engine.TabAlignment.DECIMAL && tab["decimalAlignmentToken"] == null)
						tab["decimalAlignmentToken"] = "";
					if (mSelectedMarker)
						setFormatFromRuler();
					if (e.type == DynamicPropertyEditorBase.MODELCHANGED_EVENT)
						mUpdateFromSelection = true;
					updatePropertyEditor();
				}
			}
		}

		private function setFormatFromRuler():void
		{
			var newTabs:Array = [];
			if (mSelectedMarker && mSelectedMarker.parent)
				newTabs.push(new TabStopFormat(mSelectedMarker as ITabStopFormat));
			var markers:Array = getChildren();
			for each (var marker:UIComponent in markers)
				if (marker is TabMarker)
				{
					var tab:TabMarker = marker as TabMarker;
					if (isUniquePosition(newTabs, tab.pos))
						newTabs.push(new TabStopFormat(tab));
					
				}
			newTabs.sortOn("position", Array.NUMERIC);
			var pa:TextLayoutFormat = new TextLayoutFormat();
			pa.tabStops = newTabs;
			mEditManager.applyParagraphFormat(pa);
			updatePropertyEditor();
		}
		
		private static function isUniquePosition(inTabFormat:Array, inNewPosition:Number):Boolean
		{
			for each (var tab:TabStopFormat in inTabFormat)
				if (tab.position == inNewPosition)
					return false;
			return true;
		}

		public function set tabPanelActive(inActive:Boolean):void
		{
			if (mTabPanelActive != inActive)
			{
				mTabPanelActive = inActive;
				if (mTabPanelActive)
					updatePropertyEditor();
			}
		}
		
		public function get tabPanelActive():Boolean
		{
			return mTabPanelActive;
		}
		
		public function get rightToLeft():Boolean
		{
			return mRightToLeft;
		}
		
		private function setRightToLeft(inRTL:Boolean):void
		{
			if (inRTL != mRightToLeft)
			{
				mTabSet = null;
				mRightToLeft = inRTL;
				invalidateDisplayList();
			}
		}
		
		private var mActive:Boolean = true;
		private var mActiveFlow:TextFlow = null;
		private var mEditManager:EditManager = null;
		private var mTabSet:Array = null;
		private var mSelectedMarker:RulerMarker = null;
		private var mUpdateFromSelection:Boolean = true;
		private var mDefaultTabStop:TabStopFormat;
		private var mPropertyEditor:TabPropertyEditor = null;
		private var mOrientation:String = RULER_HORIZONTAL;
		private var mSyncToPanel:UIComponent = null;
		private var mRightRuler:Boolean = true;
		private var mLastSelAnchorIdx:int = -1;
		private var mLastSelActiveIdx:int = -1;
		private var mIndentMarker:ParagraphPropertyMarker = null;
		private var mLeftMarginMarker:ParagraphPropertyMarker = null;
		private var mRightMarginMarker:ParagraphPropertyMarker = null;
		private var mTabPanelActive:Boolean = false;
		private var mRightToLeft:Boolean = false;
		private var curParagraphFormat:TextLayoutFormat = null;
		
	}
}