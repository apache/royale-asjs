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
package
{
 	
 	internal class TLFClasses
	{
		
		// import org.apache.flex.textLayout.accessibility.TextAccImpl; TextAccImpl;
		
		import org.apache.flex.textLayout.TextLayoutVersion; TextLayoutVersion;

		import org.apache.flex.textLayout.compose.BaseCompose; BaseCompose;
		import org.apache.flex.textLayout.compose.ComposeState; ComposeState;
		import org.apache.flex.textLayout.compose.FactoryComposer; FactoryComposer;
		import org.apache.flex.textLayout.compose.FlowComposerBase; FlowComposerBase;
		import org.apache.flex.textLayout.compose.FloatCompositionData; FloatCompositionData;
		import org.apache.flex.textLayout.compose.FlowDamageType; FlowDamageType;
		import org.apache.flex.textLayout.compose.IFlowComposer; IFlowComposer;
		import org.apache.flex.textLayout.compose.ISWFContext; ISWFContext;
		import org.apache.flex.textLayout.compose.IVerticalJustificationLine; IVerticalJustificationLine;
		import org.apache.flex.textLayout.compose.Parcel; Parcel;
		import org.apache.flex.textLayout.compose.ParcelList; ParcelList;
		import org.apache.flex.textLayout.compose.SimpleCompose; SimpleCompose;
		import org.apache.flex.textLayout.compose.Slug; Slug;
		import org.apache.flex.textLayout.compose.TextFlowLine; TextFlowLine;
		import org.apache.flex.textLayout.compose.TextFlowLineLocation; TextFlowLineLocation;
		import org.apache.flex.textLayout.compose.TextLineRecycler; TextLineRecycler;
		import org.apache.flex.textLayout.compose.StandardFlowComposer; StandardFlowComposer;
		import org.apache.flex.textLayout.compose.VerticalJustifier; VerticalJustifier;
		
		import org.apache.flex.textLayout.container.ColumnState; ColumnState;		
		import org.apache.flex.textLayout.container.ContainerController; ContainerController;
		import org.apache.flex.textLayout.container.ISandboxSupport; ISandboxSupport;
		import org.apache.flex.textLayout.container.ScrollPolicy; ScrollPolicy;
				
		import org.apache.flex.textLayout.debug.assert;assert;
		import org.apache.flex.textLayout.debug.Debugging; Debugging;
		
		import org.apache.flex.textLayout.edit.EditingMode; EditingMode;
		import org.apache.flex.textLayout.edit.IInteractionEventHandler; IInteractionEventHandler;
		import org.apache.flex.textLayout.edit.ISelectionManager; ISelectionManager;
		import org.apache.flex.textLayout.edit.SelectionFormat; SelectionFormat;
		import org.apache.flex.textLayout.edit.SelectionState; SelectionState;
		import org.apache.flex.textLayout.edit.SelectionType; SelectionType;
		import org.apache.flex.textLayout.edit.EditManager; EditManager;
		
		import org.apache.flex.textLayout.elements.SubParagraphGroupElementBase; SubParagraphGroupElementBase;
		import org.apache.flex.textLayout.elements.BreakElement; BreakElement;
		import org.apache.flex.textLayout.elements.Configuration; Configuration;
		import org.apache.flex.textLayout.elements.ContainerFormattedElement; ContainerFormattedElement;
		import org.apache.flex.textLayout.elements.DivElement; DivElement;
		import org.apache.flex.textLayout.elements.FlowElement; FlowElement;
		import org.apache.flex.textLayout.elements.FlowGroupElement; FlowGroupElement;
		import org.apache.flex.textLayout.elements.FlowLeafElement; FlowLeafElement;
		import org.apache.flex.textLayout.elements.GlobalSettings; GlobalSettings;
		import org.apache.flex.textLayout.elements.IConfiguration; IConfiguration;
		import org.apache.flex.textLayout.elements.IExplicitFormatResolver; IExplicitFormatResolver;
		import org.apache.flex.textLayout.elements.IFormatResolver; IFormatResolver;
		import org.apache.flex.textLayout.elements.InlineGraphicElement; InlineGraphicElement;
		import org.apache.flex.textLayout.elements.InlineGraphicElementStatus; InlineGraphicElementStatus;
		import org.apache.flex.textLayout.elements.ListElement; ListElement;
		import org.apache.flex.textLayout.elements.ListItemElement; ListItemElement;
		import org.apache.flex.textLayout.elements.LinkElement; LinkElement;
		import org.apache.flex.textLayout.elements.LinkState; LinkState;
		import org.apache.flex.textLayout.elements.OverflowPolicy; OverflowPolicy;
		import org.apache.flex.textLayout.elements.ParagraphElement; ParagraphElement;
		import org.apache.flex.textLayout.elements.ParagraphFormattedElement; ParagraphFormattedElement;
		import org.apache.flex.textLayout.elements.SpanElement; SpanElement;
		import org.apache.flex.textLayout.elements.SpecialCharacterElement; SpecialCharacterElement;
		import org.apache.flex.textLayout.elements.SubParagraphGroupElement; SubParagraphGroupElement;
		import org.apache.flex.textLayout.elements.TabElement; TabElement;
		import org.apache.flex.textLayout.elements.TableElement; TableElement;
		import org.apache.flex.textLayout.elements.TableBodyElement; TableBodyElement;
		import org.apache.flex.textLayout.elements.TableColElement; TableColElement;
		import org.apache.flex.textLayout.elements.TableColGroupElement; TableColGroupElement;
		import org.apache.flex.textLayout.elements.TableCellElement; TableCellElement;
		import org.apache.flex.textLayout.elements.TableRowElement; TableRowElement;
		import org.apache.flex.textLayout.elements.TCYElement; TCYElement;
		import org.apache.flex.textLayout.elements.TextFlow; TextFlow;
		import org.apache.flex.textLayout.elements.TextRange; TextRange;

		
		import org.apache.flex.textLayout.events.CompositionCompleteEvent; CompositionCompleteEvent;
		import org.apache.flex.textLayout.events.DamageEvent; DamageEvent;
		import org.apache.flex.textLayout.events.FlowElementMouseEvent; FlowElementMouseEvent;
		import org.apache.flex.textLayout.events.FlowElementMouseEventManager; FlowElementMouseEventManager;
		import org.apache.flex.textLayout.events.FlowElementEventDispatcher; FlowElementEventDispatcher;
		import org.apache.flex.textLayout.events.ModelChange; ModelChange;
		import org.apache.flex.textLayout.events.ScrollEvent; ScrollEvent;
		import org.apache.flex.textLayout.events.ScrollEventDirection; ScrollEventDirection;
		import org.apache.flex.textLayout.events.StatusChangeEvent; StatusChangeEvent;
		import org.apache.flex.textLayout.events.TextLayoutEvent; TextLayoutEvent;
		
		import org.apache.flex.textLayout.factory.TextLineFactoryBase; TextLineFactoryBase;
		import org.apache.flex.textLayout.factory.StringTextLineFactory; StringTextLineFactory;
		import org.apache.flex.textLayout.factory.TextFlowTextLineFactory; TextFlowTextLineFactory;
		import org.apache.flex.textLayout.factory.TruncationOptions; TruncationOptions;		

		import org.apache.flex.textLayout.formats.BaselineOffset; BaselineOffset;
		import org.apache.flex.textLayout.formats.BaselineShift; BaselineShift;
		import org.apache.flex.textLayout.formats.BlockProgression; BlockProgression;
		import org.apache.flex.textLayout.formats.BreakStyle; BreakStyle;

		import org.apache.flex.textLayout.formats.Category; Category;
		import org.apache.flex.textLayout.formats.ClearFloats; ClearFloats;
		import org.apache.flex.textLayout.formats.Direction; Direction;
		import org.apache.flex.textLayout.formats.Float; Float;
		import org.apache.flex.textLayout.formats.FormatValue; FormatValue;
		import org.apache.flex.textLayout.formats.IMEStatus; IMEStatus;
		import org.apache.flex.textLayout.formats.IListMarkerFormat; IListMarkerFormat;
		import org.apache.flex.textLayout.formats.ITabStopFormat; ITabStopFormat;
		import org.apache.flex.textLayout.formats.ITextLayoutFormat; ITextLayoutFormat;
		import org.apache.flex.textLayout.formats.JustificationRule; JustificationRule;
		import org.apache.flex.textLayout.formats.LeadingModel; LeadingModel;
		import org.apache.flex.textLayout.formats.LineBreak; LineBreak;
		import org.apache.flex.textLayout.formats.ListMarkerFormat; ListMarkerFormat;
		import org.apache.flex.textLayout.formats.Suffix; Suffix;
		import org.apache.flex.textLayout.formats.TabStopFormat; TabStopFormat;
		import org.apache.flex.textLayout.formats.TextAlign; TextAlign;
		import org.apache.flex.textLayout.formats.TextDecoration; TextDecoration;
		import org.apache.flex.textLayout.formats.TextJustify; TextJustify;
		import org.apache.flex.textLayout.formats.TextLayoutFormat; TextLayoutFormat;		
		import org.apache.flex.textLayout.formats.VerticalAlign; VerticalAlign;
		import org.apache.flex.textLayout.formats.WhiteSpaceCollapse; WhiteSpaceCollapse;

		import org.apache.flex.textLayout.property.ArrayProperty; ArrayProperty;
		import org.apache.flex.textLayout.property.Property; Property;
		
		// new property classes
		import org.apache.flex.textLayout.property.PropertyHandler; PropertyHandler;
		import org.apache.flex.textLayout.property.BooleanPropertyHandler; BooleanPropertyHandler;
		import org.apache.flex.textLayout.property.EnumPropertyHandler; EnumPropertyHandler;
		import org.apache.flex.textLayout.property.FormatPropertyHandler; FormatPropertyHandler;
		import org.apache.flex.textLayout.property.StringPropertyHandler; StringPropertyHandler;
		import org.apache.flex.textLayout.property.IntPropertyHandler; IntPropertyHandler;
		import org.apache.flex.textLayout.property.UintPropertyHandler; UintPropertyHandler;
		import org.apache.flex.textLayout.property.NumberPropertyHandler; NumberPropertyHandler;
		import org.apache.flex.textLayout.property.UndefinedPropertyHandler; UndefinedPropertyHandler;
		import org.apache.flex.textLayout.property.PercentPropertyHandler; PercentPropertyHandler;
		import org.apache.flex.textLayout.property.CounterContentHandler; CounterContentHandler;
		import org.apache.flex.textLayout.property.CounterPropHandler; CounterPropHandler;
		
		import org.apache.flex.textLayout.utils.CharacterUtil; CharacterUtil;
		import org.apache.flex.textLayout.utils.GeometryUtil; GeometryUtil;
		import org.apache.flex.textLayout.utils.HitTestArea; HitTestArea;
		import org.apache.flex.textLayout.utils.Twips; Twips;
		import org.apache.flex.textLayout.factory.ITLFFactory; ITLFFactory;
		
		// CONFIG::release public function exportAssert():void
		// {
		// 	assert();
		// }
	}
}

