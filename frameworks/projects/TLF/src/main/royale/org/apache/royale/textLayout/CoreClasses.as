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
 	
 	internal class CoreClasses
	{
		
		// import org.apache.royale.textLayout.accessibility.TextAccImpl; TextAccImpl;
		
		import org.apache.royale.textLayout.TextLayoutVersion; TextLayoutVersion;

		import org.apache.royale.textLayout.compose.BaseCompose; BaseCompose;
		import org.apache.royale.textLayout.compose.ComposeState; ComposeState;
		import org.apache.royale.textLayout.compose.FlowComposerBase; FlowComposerBase;
		import org.apache.royale.textLayout.compose.FloatCompositionData; FloatCompositionData;
		import org.apache.royale.textLayout.compose.FlowDamageType; FlowDamageType;
		import org.apache.royale.textLayout.compose.IFlowComposer; IFlowComposer;
		import org.apache.royale.textLayout.compose.ISWFContext; ISWFContext;
		import org.apache.royale.textLayout.compose.IVerticalJustificationLine; IVerticalJustificationLine;
		import org.apache.royale.textLayout.compose.Parcel; Parcel;
		import org.apache.royale.textLayout.compose.ParcelList; ParcelList;
		import org.apache.royale.textLayout.compose.SimpleCompose; SimpleCompose;
		import org.apache.royale.textLayout.compose.Slug; Slug;
		import org.apache.royale.textLayout.compose.TextFlowLine; TextFlowLine;
		import org.apache.royale.textLayout.compose.TextFlowLineLocation; TextFlowLineLocation;
		import org.apache.royale.textLayout.compose.TextLineRecycler; TextLineRecycler;
		import org.apache.royale.textLayout.compose.StandardFlowComposer; StandardFlowComposer;
		import org.apache.royale.textLayout.compose.VerticalJustifier; VerticalJustifier;
		
		import org.apache.royale.textLayout.container.ColumnState; ColumnState;		
		import org.apache.royale.textLayout.container.ContainerController; ContainerController;
		import org.apache.royale.textLayout.container.ISandboxSupport; ISandboxSupport;
		import org.apache.royale.textLayout.container.ScrollPolicy; ScrollPolicy;
				
		import org.apache.royale.textLayout.debug.assert;assert;
		import org.apache.royale.textLayout.debug.Debugging; Debugging;
		
		import org.apache.royale.textLayout.edit.EditingMode; EditingMode;
		import org.apache.royale.textLayout.edit.IInteractionEventHandler; IInteractionEventHandler;
		import org.apache.royale.textLayout.edit.ISelectionManager; ISelectionManager;
		import org.apache.royale.textLayout.edit.SelectionFormat; SelectionFormat;
		import org.apache.royale.textLayout.edit.SelectionState; SelectionState;
		import org.apache.royale.textLayout.edit.SelectionType; SelectionType;
		
		import org.apache.royale.textLayout.elements.SubParagraphGroupElementBase; SubParagraphGroupElementBase;
		import org.apache.royale.textLayout.elements.BreakElement; BreakElement;
		import org.apache.royale.textLayout.elements.Configuration; Configuration;
		import org.apache.royale.textLayout.elements.ContainerFormattedElement; ContainerFormattedElement;
		import org.apache.royale.textLayout.elements.DivElement; DivElement;
		import org.apache.royale.textLayout.elements.FlowElement; FlowElement;
		import org.apache.royale.textLayout.elements.FlowGroupElement; FlowGroupElement;
		import org.apache.royale.textLayout.elements.FlowLeafElement; FlowLeafElement;
		import org.apache.royale.textLayout.elements.GlobalSettings; GlobalSettings;
		import org.apache.royale.textLayout.elements.IConfiguration; IConfiguration;
		import org.apache.royale.textLayout.elements.IExplicitFormatResolver; IExplicitFormatResolver;
		import org.apache.royale.textLayout.elements.IFormatResolver; IFormatResolver;
		import org.apache.royale.textLayout.elements.InlineGraphicElement; InlineGraphicElement;
		import org.apache.royale.textLayout.elements.InlineGraphicElementStatus; InlineGraphicElementStatus;
		import org.apache.royale.textLayout.elements.ListElement; ListElement;
		import org.apache.royale.textLayout.elements.ListItemElement; ListItemElement;
		import org.apache.royale.textLayout.elements.LinkElement; LinkElement;
		import org.apache.royale.textLayout.elements.LinkState; LinkState;
		import org.apache.royale.textLayout.elements.OverflowPolicy; OverflowPolicy;
		import org.apache.royale.textLayout.elements.ParagraphElement; ParagraphElement;
		import org.apache.royale.textLayout.elements.ParagraphFormattedElement; ParagraphFormattedElement;
		import org.apache.royale.textLayout.elements.SpanElement; SpanElement;
		import org.apache.royale.textLayout.elements.SpecialCharacterElement; SpecialCharacterElement;
		import org.apache.royale.textLayout.elements.SubParagraphGroupElement; SubParagraphGroupElement;
		import org.apache.royale.textLayout.elements.TabElement; TabElement;
		import org.apache.royale.textLayout.elements.TableElement; TableElement;
		import org.apache.royale.textLayout.elements.TableBodyElement; TableBodyElement;
		import org.apache.royale.textLayout.elements.TableColElement; TableColElement;
		import org.apache.royale.textLayout.elements.TableColGroupElement; TableColGroupElement;
		import org.apache.royale.textLayout.elements.TableCellElement; TableCellElement;
		import org.apache.royale.textLayout.elements.TableRowElement; TableRowElement;
		import org.apache.royale.textLayout.elements.TCYElement; TCYElement;
		import org.apache.royale.textLayout.elements.TextFlow; TextFlow;
		import org.apache.royale.textLayout.elements.TextRange; TextRange;

		
		import org.apache.royale.textLayout.events.CompositionCompleteEvent; CompositionCompleteEvent;
		import org.apache.royale.textLayout.events.DamageEvent; DamageEvent;
		import org.apache.royale.textLayout.events.FlowElementMouseEvent; FlowElementMouseEvent;
		import org.apache.royale.textLayout.events.FlowElementMouseEventManager; FlowElementMouseEventManager;
		import org.apache.royale.textLayout.events.FlowElementEventDispatcher; FlowElementEventDispatcher;
		import org.apache.royale.textLayout.events.ModelChange; ModelChange;
		import org.apache.royale.textLayout.events.ScrollEvent; ScrollEvent;
		import org.apache.royale.textLayout.events.ScrollEventDirection; ScrollEventDirection;
		import org.apache.royale.textLayout.events.StatusChangeEvent; StatusChangeEvent;
		import org.apache.royale.textLayout.events.TextLayoutEvent; TextLayoutEvent;
		
		import org.apache.royale.textLayout.compose.FactoryComposer; FactoryComposer;
		import org.apache.royale.textLayout.factory.TextLineFactoryBase; TextLineFactoryBase;
		import org.apache.royale.textLayout.factory.StringTextLineFactory; StringTextLineFactory;
		import org.apache.royale.textLayout.factory.TextFlowTextLineFactory; TextFlowTextLineFactory;
		import org.apache.royale.textLayout.factory.TruncationOptions; TruncationOptions;		

		import org.apache.royale.textLayout.formats.BaselineOffset; BaselineOffset;
		import org.apache.royale.textLayout.formats.BaselineShift; BaselineShift;
		import org.apache.royale.textLayout.formats.BlockProgression; BlockProgression;
		import org.apache.royale.textLayout.formats.BreakStyle; BreakStyle;

		import org.apache.royale.textLayout.formats.Category; Category;
		import org.apache.royale.textLayout.formats.ClearFloats; ClearFloats;
		import org.apache.royale.textLayout.formats.Direction; Direction;
		import org.apache.royale.textLayout.formats.Float; Float;
		import org.apache.royale.textLayout.formats.FormatValue; FormatValue;
		import org.apache.royale.textLayout.formats.IMEStatus; IMEStatus;
		import org.apache.royale.textLayout.formats.IListMarkerFormat; IListMarkerFormat;
		import org.apache.royale.textLayout.formats.ITabStopFormat; ITabStopFormat;
		import org.apache.royale.textLayout.formats.ITextLayoutFormat; ITextLayoutFormat;
		import org.apache.royale.textLayout.formats.JustificationRule; JustificationRule;
		import org.apache.royale.textLayout.formats.LeadingModel; LeadingModel;
		import org.apache.royale.textLayout.formats.LineBreak; LineBreak;
		import org.apache.royale.textLayout.formats.ListMarkerFormat; ListMarkerFormat;
		import org.apache.royale.textLayout.formats.Suffix; Suffix;
		import org.apache.royale.textLayout.formats.TabStopFormat; TabStopFormat;
		import org.apache.royale.textLayout.formats.TextAlign; TextAlign;
		import org.apache.royale.textLayout.formats.TextDecoration; TextDecoration;
		import org.apache.royale.textLayout.formats.TextJustify; TextJustify;
		import org.apache.royale.textLayout.formats.TextLayoutFormat; TextLayoutFormat;		
		import org.apache.royale.textLayout.formats.VerticalAlign; VerticalAlign;
		import org.apache.royale.textLayout.formats.WhiteSpaceCollapse; WhiteSpaceCollapse;

		import org.apache.royale.textLayout.property.ArrayProperty; ArrayProperty;
		import org.apache.royale.textLayout.property.Property; Property;
		
		// new property classes
		import org.apache.royale.textLayout.property.PropertyHandler; PropertyHandler;
		import org.apache.royale.textLayout.property.BooleanPropertyHandler; BooleanPropertyHandler;
		import org.apache.royale.textLayout.property.EnumPropertyHandler; EnumPropertyHandler;
		import org.apache.royale.textLayout.property.FormatPropertyHandler; FormatPropertyHandler;
		import org.apache.royale.textLayout.property.StringPropertyHandler; StringPropertyHandler;
		import org.apache.royale.textLayout.property.IntPropertyHandler; IntPropertyHandler;
		import org.apache.royale.textLayout.property.UintPropertyHandler; UintPropertyHandler;
		import org.apache.royale.textLayout.property.NumberPropertyHandler; NumberPropertyHandler;
		import org.apache.royale.textLayout.property.UndefinedPropertyHandler; UndefinedPropertyHandler;
		import org.apache.royale.textLayout.property.PercentPropertyHandler; PercentPropertyHandler;
		import org.apache.royale.textLayout.property.CounterContentHandler; CounterContentHandler;
		import org.apache.royale.textLayout.property.CounterPropHandler; CounterPropHandler;
		
		import org.apache.royale.textLayout.utils.CharacterUtil; CharacterUtil;
		import org.apache.royale.textLayout.utils.GeometryUtil; GeometryUtil;
		import org.apache.royale.textLayout.utils.HitTestArea; HitTestArea;
		import org.apache.royale.textLayout.utils.Twips; Twips;
				
		// CONFIG::release public function exportAssert():void
		// {
		// 	assert();
		// }
	}
}

