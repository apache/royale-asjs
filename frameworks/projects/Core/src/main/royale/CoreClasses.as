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
    import org.apache.royale.core.BeadViewBase; BeadViewBase;
    import org.apache.royale.core.ImageViewBase; ImageViewBase;
    import org.apache.royale.core.BrowserWindow; BrowserWindow;
	COMPILE::SWF
	{
		// import Promise; Promise;
		import org.apache.royale.core.ApplicationFactory; ApplicationFactory;
		import org.apache.royale.core.CSSShape; CSSShape;
		import org.apache.royale.core.CSSSprite; CSSSprite;
		import org.apache.royale.core.CSSTextField; CSSTextField;
	    import org.apache.royale.core.StyleableCSSTextField; StyleableCSSTextField;
		import org.apache.royale.core.WrappedMovieClip; WrappedMovieClip;
		import org.apache.royale.core.WrappedShape; WrappedShape;
		import org.apache.royale.core.WrappedSimpleButton; WrappedSimpleButton;
		import org.apache.royale.core.WrappedSprite; WrappedSprite;
		import org.apache.royale.core.WrappedTextField; WrappedTextField;
		import org.apache.royale.core.ByteArrayAsset; ByteArrayAsset;
	}
	import org.apache.royale.core.IBinaryImageLoader; IBinaryImageLoader;
    import org.apache.royale.core.ItemRendererClassFactory; ItemRendererClassFactory;
    import org.apache.royale.core.IAlertModel; IAlertModel;
    import org.apache.royale.core.IBead; IBead;
    import org.apache.royale.core.IBeadController; IBeadController;
	import org.apache.royale.core.IBeadLayout; IBeadLayout;
	import org.apache.royale.core.IBeadTransform; IBeadTransform;
    import org.apache.royale.core.IBeadModel; IBeadModel;
	import org.apache.royale.core.IBeadView; IBeadView;
	import org.apache.royale.core.IBinding; IBinding;
	import org.apache.royale.core.IImageView; IImageView;
    import org.apache.royale.core.IBinaryImage; IBinaryImage;
	COMPILE::SWF
	{
	    import org.apache.royale.core.IBorderModel; IBorderModel;
	}
	
    import org.apache.royale.core.IChild; IChild;
    import org.apache.royale.core.IChrome; IChrome;
    import org.apache.royale.core.IComboBoxModel; IComboBoxModel;
    import org.apache.royale.core.IContainer; IContainer;
	import org.apache.royale.core.IContainerView; IContainerView;
    import org.apache.royale.core.IContentView; IContentView;
	import org.apache.royale.core.IContentViewHost; IContentViewHost;
    import org.apache.royale.core.IDataProviderItemRendererMapper; IDataProviderItemRendererMapper;
	import org.apache.royale.core.IDataProviderNotifier; IDataProviderNotifier;
    import org.apache.royale.core.IBinaryImageModel; IBinaryImageModel;
    import org.apache.royale.core.IDocument; IDocument;
	import org.apache.royale.core.IDragInitiator; IDragInitiator;
    import org.apache.royale.core.IFormatBead; IFormatBead;
    import org.apache.royale.core.IImage; IImage;
    import org.apache.royale.core.IImageModel; IImageModel;
    import org.apache.royale.core.IItemRendererProvider; IItemRendererProvider;
    import org.apache.royale.core.ILayoutChild; ILayoutChild;
	import org.apache.royale.core.ILayoutHost; ILayoutHost;
	import org.apache.royale.core.ILayoutView; ILayoutView;
	import org.apache.royale.core.ILayoutParent; ILayoutParent;
    import org.apache.royale.core.IListPresentationModel; IListPresentationModel;
	import org.apache.royale.core.IMeasurementBead; IMeasurementBead;
    import org.apache.royale.core.IModule; IModule;
    import org.apache.royale.core.IPanelModel; IPanelModel;
    import org.apache.royale.core.IParent; IParent;
    import org.apache.royale.core.IParentIUIBase; IParentIUIBase;
    import org.apache.royale.core.IPopUp; IPopUp;
    import org.apache.royale.core.IRangeModel; IRangeModel;
    import org.apache.royale.core.ISWFApplication; ISWFApplication;
	import org.apache.royale.core.ITransformModel; ITransformModel;
	import org.apache.royale.core.ITransformHost; ITransformHost;
    import org.apache.royale.core.IRollOverModel; IRollOverModel;
	COMPILE::SWF
	{
	    import org.apache.royale.core.IScrollBarModel; IScrollBarModel;
	}
    import org.apache.royale.core.ISelectableItemRenderer; ISelectableItemRenderer;
    import org.apache.royale.core.ISelectionModel; ISelectionModel;
    import org.apache.royale.core.IStrand; IStrand;
	import org.apache.royale.core.IStrandPrivate; IStrandPrivate;
    import org.apache.royale.core.IStrandWithModel; IStrandWithModel;
    import org.apache.royale.core.ITextModel; ITextModel;
    import org.apache.royale.core.ITitleBarModel; ITitleBarModel;
    import org.apache.royale.core.IToggleButtonModel; IToggleButtonModel;
    import org.apache.royale.core.IUIBase; IUIBase;
    import org.apache.royale.core.IValueToggleButtonModel; IValueToggleButtonModel;
	import org.apache.royale.core.IViewport; IViewport;
	import org.apache.royale.core.IViewportModel; IViewportModel;
	COMPILE::SWF
	{
		import org.apache.royale.core.IViewportScroller; IViewportScroller;
	}
    import org.apache.royale.core.SimpleStatesImpl; SimpleStatesImpl;
	

	import org.apache.royale.core.StyleChangeNotifier; StyleChangeNotifier;
	import org.apache.royale.events.CustomEvent; CustomEvent;
    import org.apache.royale.events.Event; Event;
	import org.apache.royale.events.CollectionEvent; CollectionEvent;
    import org.apache.royale.events.ProgressEvent; ProgressEvent;
	import org.apache.royale.events.StyleChangeEvent; StyleChangeEvent;
    import org.apache.royale.events.EventDispatcher; EventDispatcher;
    import org.apache.royale.events.IEventDispatcher; IEventDispatcher;
	import org.apache.royale.events.MouseEvent; MouseEvent;
	import org.apache.royale.events.KeyboardEvent; KeyboardEvent;
	import org.apache.royale.events.utils.KeyboardEventConverter; KeyboardEventConverter;
	import org.apache.royale.events.utils.MouseEventConverter; MouseEventConverter;
	COMPILE::SWF
	{
	    import org.apache.royale.core.StageProxy; StageProxy;
	}
	import org.apache.royale.events.utils.KeyConverter; KeyConverter;
	import org.apache.royale.events.DetailEvent; DetailEvent;
	import org.apache.royale.events.ValueEvent; ValueEvent;
    import org.apache.royale.events.utils.MouseUtils; MouseUtils;
	import org.apache.royale.events.utils.EditingKeys; EditingKeys;
	import org.apache.royale.events.utils.ModifierKeys; ModifierKeys;
	import org.apache.royale.events.utils.NavigationKeys; NavigationKeys;
	import org.apache.royale.events.utils.SpecialKeys; SpecialKeys;
	import org.apache.royale.events.utils.WhitespaceKeys; WhitespaceKeys;
	import org.apache.royale.events.utils.UIKeys; UIKeys;
	import org.apache.royale.geom.Matrix; Matrix;
    import org.apache.royale.geom.Point; Point;
    import org.apache.royale.geom.Rectangle; Rectangle;
    import org.apache.royale.utils.AnimationUtil; AnimationUtil;
    import org.apache.royale.utils.BinaryData; BinaryData;
	import org.apache.royale.utils.BrowserInfo; BrowserInfo;
	COMPILE::SWF
	{
	    import org.apache.royale.utils.CSSBorderUtils; CSSBorderUtils;
	}
	import org.apache.royale.utils.ColorUtil; ColorUtil;
    import org.apache.royale.utils.CSSContainerUtils; CSSContainerUtils;
    import org.apache.royale.utils.DisplayUtils; DisplayUtils;
	COMPILE::SWF
	{
	    import org.apache.royale.utils.dbg.DOMPathUtil; DOMPathUtil;
	}
	import org.apache.royale.utils.EffectTimer; EffectTimer;
    import org.apache.royale.utils.MixinManager; MixinManager;
	COMPILE::SWF
	{
	    import org.apache.royale.utils.PNGEncoder; PNGEncoder;
    	import org.apache.royale.utils.SolidBorderUtil; SolidBorderUtil;
		import org.apache.royale.utils.HTMLLoader; HTMLLoader;
	}
	import org.apache.royale.utils.BrowserUtils; BrowserUtils;
	import org.apache.royale.utils.callLater; callLater;
	import org.apache.royale.utils.getParentOrSelfByType; getParentOrSelfByType;
    import org.apache.royale.utils.CompressionUtils; CompressionUtils;
	import org.apache.royale.utils.Endian; Endian;
	import org.apache.royale.utils.JXON; JXON;
	import org.apache.royale.utils.MD5; MD5;
	import org.apache.royale.utils.OSUtils; OSUtils;
	import org.apache.royale.utils.PointUtils; PointUtils;
    import org.apache.royale.utils.StringPadder; StringPadder;
	import org.apache.royale.utils.StringTrimmer; StringTrimmer;
	import org.apache.royale.utils.StringUtil; StringUtil;
	import org.apache.royale.utils.ObjectMap; ObjectMap;
	import org.apache.royale.utils.ObjectUtil; ObjectUtil;
	import org.apache.royale.utils.PointUtils; PointUtils;
	import org.apache.royale.utils.Timer; Timer;
	import org.apache.royale.utils.UIDUtil; UIDUtil;
	import org.apache.royale.utils.UIUtils; UIUtils;
	import org.apache.royale.utils.URLUtils; URLUtils;
	import org.apache.royale.utils.undo.UndoManager; UndoManager;
	COMPILE::JS
	{
        import org.apache.royale.events.utils.EventUtils; EventUtils;
	}

	import org.apache.royale.core.ClassFactory; ClassFactory;
    import org.apache.royale.states.AddItems; AddItems;
    import org.apache.royale.states.SetEventHandler; SetEventHandler;
    import org.apache.royale.states.SetProperty; SetProperty;
    import org.apache.royale.states.State; State;

    import org.apache.royale.core.IDataGridModel; IDataGridModel;
    import org.apache.royale.core.IDataGridPresentationModel; IDataGridPresentationModel;
    import org.apache.royale.core.IDateChooserModel; IDateChooserModel;
	import org.apache.royale.core.ParentDocumentBead; ParentDocumentBead;
	import org.apache.royale.core.TransformBeadBase; TransformBeadBase;
	import org.apache.royale.core.TransformModel; TransformModel;
	import org.apache.royale.core.TransformCompoundModel; TransformCompoundModel;
	import org.apache.royale.core.TransformRotateModel; TransformRotateModel;
	import org.apache.royale.core.TransformMoveXModel; TransformMoveXModel;
	import org.apache.royale.core.TransformMoveYModel; TransformMoveYModel;
	import org.apache.royale.core.TransformScaleModel; TransformScaleModel;
    import org.apache.royale.utils.CSSUtils; CSSUtils;

    import org.apache.royale.utils.Proxy; Proxy;
    import org.apache.royale.core.UIHTMLElementWrapper; UIHTMLElementWrapper;
	
	COMPILE::JS
	{
	    import org.apache.royale.core.IRoyaleElement; IRoyaleElement;
	}
	//Package Level Functions
	import org.apache.royale.debugging.assert; assert;
	import org.apache.royale.debugging.assertType; assertType;
	import org.apache.royale.debugging.check; check;
	// import org.apache.royale.debugging.conditionalBreak; conditionalBreak;
	import org.apache.royale.debugging.notNull; notNull;
	import org.apache.royale.debugging.throwError; throwError;

	import org.apache.royale.utils.loadBeadFromValuesManager; loadBeadFromValuesManager;
}

}

