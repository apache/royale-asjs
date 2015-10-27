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
package {

/**
 *  @private
 *  This class is used to link additional classes into rpc.swc
 *  beyond those that are found by dependency analysis starting
 *  from the classes specified in manifest.xml.
 */
internal class CoreClasses
{	
    import org.apache.flex.core.BeadViewBase; BeadViewBase;
    import org.apache.flex.core.BrowserWindow; BrowserWindow;
	COMPILE::AS3
	{
		import org.apache.flex.core.CSSShape; CSSShape;
		import org.apache.flex.core.CSSSprite; CSSSprite;
		import org.apache.flex.core.CSSTextField; CSSTextField;
	    import org.apache.flex.core.StyleableCSSTextField; StyleableCSSTextField;
	}
    import org.apache.flex.core.ItemRendererClassFactory; ItemRendererClassFactory;  
	import org.apache.flex.core.FilledRectangle; FilledRectangle;
    import org.apache.flex.core.IAlertModel; IAlertModel;
    import org.apache.flex.core.IBead; IBead;
    import org.apache.flex.core.IBeadController; IBeadController;
    import org.apache.flex.core.IBeadLayout; IBeadLayout;
    import org.apache.flex.core.IBeadModel; IBeadModel;
    import org.apache.flex.core.IBeadView; IBeadView;
	COMPILE::AS3
	{
	    import org.apache.flex.core.IBorderModel; IBorderModel;
	}
    import org.apache.flex.core.IChild; IChild;
    import org.apache.flex.core.IChrome; IChrome;
    import org.apache.flex.core.IComboBoxModel; IComboBoxModel;
    import org.apache.flex.core.IContainer; IContainer;
	import org.apache.flex.core.IContainerView; IContainerView;
    import org.apache.flex.core.IContentView; IContentView;
	import org.apache.flex.core.IContentViewHost; IContentViewHost;
    import org.apache.flex.core.IDataProviderItemRendererMapper; IDataProviderItemRendererMapper;
    import org.apache.flex.core.IDocument; IDocument;
    import org.apache.flex.core.IFormatBead; IFormatBead;
	COMPILE::AS3
	{
	    import org.apache.flex.core.IImageModel; IImageModel;
	}
    import org.apache.flex.core.ILayoutChild; ILayoutChild;
	import org.apache.flex.core.ILayoutHost; ILayoutHost;
    import org.apache.flex.core.IListPresentationModel; IListPresentationModel;
    import org.apache.flex.core.IPanelModel; IPanelModel;
    import org.apache.flex.core.IParent; IParent;
    import org.apache.flex.core.IParentIUIBase; IParentIUIBase;
    import org.apache.flex.core.IPopUp; IPopUp;
    import org.apache.flex.core.IRangeModel; IRangeModel;
    import org.apache.flex.core.IRollOverModel; IRollOverModel;
	COMPILE::AS3
	{
	    import org.apache.flex.core.IScrollBarModel; IScrollBarModel;
	}
    import org.apache.flex.core.ISelectableItemRenderer; ISelectableItemRenderer;
    import org.apache.flex.core.ISelectionModel; ISelectionModel;
    import org.apache.flex.core.IStrand; IStrand;
    import org.apache.flex.core.IStrandWithModel; IStrandWithModel;
    import org.apache.flex.core.ITextModel; ITextModel;
    import org.apache.flex.core.ITitleBarModel; ITitleBarModel;
    import org.apache.flex.core.IToggleButtonModel; IToggleButtonModel;
    import org.apache.flex.core.IUIBase; IUIBase;
    import org.apache.flex.core.IValueToggleButtonModel; IValueToggleButtonModel;
	import org.apache.flex.core.IViewport; IViewport;
	import org.apache.flex.core.IViewportModel; IViewportModel;
	COMPILE::AS3
	{
		import org.apache.flex.core.IViewportScroller; IViewportScroller;
	}
	import org.apache.flex.core.ListBase; ListBase;
	import org.apache.flex.core.ListBaseStrandChildren; ListBaseStrandChildren;
    import org.apache.flex.core.SimpleStatesImpl; SimpleStatesImpl;
	COMPILE::AS3
	{
	    import org.apache.flex.core.SimpleApplication; SimpleApplication;
	}
    import org.apache.flex.core.DataBindingBase; DataBindingBase;
    import org.apache.flex.core.UIBase; UIBase;
	COMPILE::AS3
	{
	    import org.apache.flex.core.UIButtonBase; UIButtonBase;
	}
	import org.apache.flex.events.CustomEvent; CustomEvent;
	import org.apache.flex.events.Event; Event;
    import org.apache.flex.events.EventDispatcher; EventDispatcher;
    import org.apache.flex.events.IEventDispatcher; IEventDispatcher;
	import org.apache.flex.events.MouseEvent; MouseEvent;
	import org.apache.flex.events.ValueEvent; ValueEvent;
    import org.apache.flex.events.utils.MouseUtils; MouseUtils;
    import org.apache.flex.geom.Point; Point;
    import org.apache.flex.geom.Rectangle; Rectangle;
    import org.apache.flex.utils.BinaryData; BinaryData;
	COMPILE::AS3
	{
	    import org.apache.flex.utils.CSSBorderUtils; CSSBorderUtils;
	}
    import org.apache.flex.utils.CSSContainerUtils; CSSContainerUtils;
	COMPILE::AS3
	{
	    import org.apache.flex.utils.dbg.DOMPathUtil; DOMPathUtil;
	}
	import org.apache.flex.utils.EffectTimer; EffectTimer;
    import org.apache.flex.utils.MixinManager; MixinManager;
	COMPILE::AS3
	{
	    import org.apache.flex.utils.PNGEncoder; PNGEncoder;
    	import org.apache.flex.utils.SolidBorderUtil; SolidBorderUtil;
	    import org.apache.flex.utils.StringTrimmer; StringTrimmer;
}
	import org.apache.flex.utils.Timer; Timer;
	import org.apache.flex.utils.UIUtils; UIUtils;
    
	import org.apache.flex.core.ClassFactory; ClassFactory;
    import org.apache.flex.states.AddItems; AddItems;
    import org.apache.flex.states.SetEventHandler; SetEventHandler;
    import org.apache.flex.states.SetProperty; SetProperty;
    import org.apache.flex.states.State; State;
	
	import org.apache.flex.core.IDataGridLayout; IDataGridLayout;
    import org.apache.flex.core.IDataGridModel; IDataGridModel;
    import org.apache.flex.core.IDataGridPresentationModel; IDataGridPresentationModel;
    import org.apache.flex.core.IDateChooserModel; IDateChooserModel;
    import org.apache.flex.core.ParentDocumentBead; ParentDocumentBead;
    import org.apache.flex.utils.CSSUtils; CSSUtils;

}

}

