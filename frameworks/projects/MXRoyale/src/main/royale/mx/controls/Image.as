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

package mx.controls
{
import org.apache.royale.core.IImage;
import org.apache.royale.core.IImageModel;
COMPILE::JS {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.events.BrowserEvent;
	import org.apache.royale.html.util.addElementToWrapper;
}
import mx.core.UIComponent;
/*
import flash.display.DisplayObject;
import flash.events.Event;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.IDataRenderer;
import mx.core.mx_internal;
*/
import mx.events.FlexEvent;
import org.apache.royale.events.Event;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.IDataRenderer;
/*

use namespace mx_internal;
*/

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When you use a component as an item renderer,
 *  the <code>data</code> property contains the data to display.
 *  You can listen for this event and update the component
 *  when the <code>data</code> property changes.</p>
 *
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(source="progress", destination="source")]

[DefaultTriggerEvent("complete")]

[Alternative(replacement="spark.components.Image", since="4.5")]

/**
 *  The Image control lets you import JPEG, PNG, GIF, and SWF files
 *  at runtime. You can also embed any of these files and SVG files at compile time
 *  by using <code>&#64;Embed(source='filename')</code>.
 *
 *  <p><strong>Note: </strong>Flex also includes the SWFLoader control for loading Flex applications.
 *  You typically use the Image control for loading static graphic files and SWF files,
 *  and use the SWFLoader control for loading Flex applications. The Image control
 *  is also designed to be used in custom item renderers and item editors. </p>
 *
 *  <p><strong>Note: </strong>Flex also includes the BitmapImage class. This class is
 *  used for embedding images into skins and FXG components. </p>
 *
 *  <p>Embedded images load immediately, because they are already part of the
 *  Flex SWF file. However, they add to the size of your application and slow down
 *  the application initialization process. Embedded images also require you to
 *  recompile your applications whenever your image files change.</p>
 *
 *  <p>The alternative to embedding a resource is to load the resource at runtime.
 *  You can load a resource from the local file system in which the SWF file runs,
 *  or you can access a remote resource, typically though an HTTP request over a network.
 *  These images are independent of your Flex application, so you can change them without
 *  causing a recompile operation as long as the names of the modified images remain the same.
 *  The referenced images add no additional overhead to an application's initial loading time.
 *  However, you might experience a delay when you use the images and load them
 *  into Flash Player or AIR. </p>
 *
 *  <p>A SWF file can access one type of external resource only, either local or over a network;
 *  it cannot access both types. You determine the type of access allowed by the SWF file
 *  using the <code>use-network</code> flag when you compile your application.
 *  When the <code>use-network</code> flag is set to <code>false</code>, you can access
 *  resources in the local file system, but not over the network.
 *  The default value is <code>true</code>, which allows you to access resources
 *  over the network, but not in the local file system. </p>
 *
 *  <p>When you load images at runtime, you should be aware of the security restrictions
 *  of Flash Player or AIR.
 *  For example, in Flash Player you can load an image from any domain by using a URL,
 *  but the default security settings won't allow your code to access the bitmap data
 *  of the image unless it came from the same domain as the application.
 *  To access bitmap data from images on other servers, you must use a crossdomain.xml file. </p>
 *
 *  <p>The PNG and GIF formats also support the use of an alpha channel
 *  for creating transparent images.</p>
 *
 *  <p>When you use the Image control as a drop-in item renderer in a List control,
 *  either set an explicit row height of the List control, by
 *  using the <code>rowHeight</code> property,
 *  or set the <code>variableRowHeight</code> property of the List control
 *  to <code>true</code> to size the row correctly.</p>
 *
 *  <p>If you find memory problems related to Images objects, try explicitly
 *  setting the <code>source</code> property to null when you are done using
 *  the Image object in your application.</p>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Image&gt;</code> tag inherits the tag attributes of its superclass,
 *  and adds the following tag attribute:</p>
 *
 *  <pre>
 *  &lt;mx:Image
 *    <strong>Events</strong>
 *    dataChange="No default"
 *  /&gt
 *  </pre>
 *
 *  @see mx.controls.SWFLoader
 *
 *  @includeExample examples/SimpleImage.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
public class Image extends UIComponent
		implements IImage,IListItemRenderer,IDropInListItemRenderer,IDataRenderer
{

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.4
	 */
	public function Image()
	{
		super();

		// images are generally not interactive
		//tabChildren = false;
		//tabEnabled = true;
		//tabFocusEnabled = true;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	/**
	 *  @private
	 */
	private var isContentLoaded:Boolean = false;


	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------

	override public function addedToParent():void
	{
		super.addedToParent();
		trace("Image.addedToParent called: "+getExplicitOrMeasuredWidth()+" x "+getExplicitOrMeasuredHeight());
	}

	//----------------------------------
	//  source
	//----------------------------------
	private var sourceSet:Boolean;

	[Bindable("sourceChanged")]
	[Inspectable(category="General", defaultValue="", format="File")]

	/**
	 *  @private
	 */
	public function set source(value:Object):void
	{
		sourceSet = true;
		(model as IImageModel).url = value as String;
	}
	public function get source():Object
	{
		return (model as IImageModel).url;
	}

	//----------------------------------
	//  src
	//----------------------------------

	public function set src(value:String):void
	{
		source = value;
	}

	public function get src():String
	{
		return source as String;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	COMPILE::JS
	private var _imgElement:HTMLImageElement

	COMPILE::JS
	public function get imageElement():HTMLImageElement
	{
		return _imgElement;
	}


	//----------------------------------
	//  data
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the data property.
	 */
	private var _data:Object;

	[Bindable("dataChange")]
	[Inspectable(environment="none")]

	/**
	 *  The <code>data</code> property lets you pass a value to the component
	 *  when you use it in an item renderer or item editor.
	 *  You typically use data binding to bind a field of the <code>data</code>
	 *  property to a property of this component.
	 *
	 *  <p>When you use the control as a drop-in item renderer, Flex
	 *  will use the <code>listData.label</code> property, if it exists,
	 *  as the value of the <code>source</code> property of this control, or
	 *  use the <code>data</code> property as the <code>source</code> property.</p>
	 *
	 *  @default null
	 *  @see mx.core.IDataRenderer
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get data():Object
	{
		return _data;
	}

	/**
	 *  @private
	 */
	public function set data(value:Object):void
	{
		_data = value;

		if (!sourceSet)
		{
			source = listData ? listData.label : data;
			sourceSet = false;
		}

		dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	}

	//----------------------------------
	//  listData
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the listData property.
	 */
	private var _listData:BaseListData;

	[Bindable("dataChange")]
	[Inspectable(environment="none")]

	/**
	 *  When a component is used as a drop-in item renderer or drop-in
	 *  item editor, Flex initializes the <code>listData</code> property
	 *  of the component with the appropriate data from the List control.
	 *  The component can then use the <code>listData</code> property
	 *  to initialize the other properties of the drop-in
	 *  item renderer
	 *
	 *  <p>You do not set this property in MXML or ActionScript;
	 *  Flex sets it when the component is used as a drop-in item renderer
	 *  or drop-in item editor.</p>
	 *
	 *  @default null
	 *  @see mx.controls.listClasses.IDropInListItemRenderer
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get listData():BaseListData
	{
		return _listData;
	}

	/**
	 *  @private
	 */
	public function set listData(value:BaseListData):void
	{
		_listData = value;
	}


	//----------------------------------
	//  contentWidth
	//----------------------------------

	/**
	 *  Width of the scaled content loaded by the control, in pixels.
	 *  Note that this is not the width of the control itself, but of the
	 *  loaded content. Use the <code>width</code> property of the control
	 *  to obtain its width.
	 *
	 *  <p>The value of this property is not final when the <code>complete</code> event is triggered.
	 *  You can get the value after the <code>updateComplete</code> event is triggered.</p>
	 *
	 *  @default NaN
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get contentWidth():Number
	{
		COMPILE::JS{
			return _imgElement.complete ? _imgElement.naturalWidth : NaN;
		}
		COMPILE::SWF{
			return NaN;
		}
	}

	//----------------------------------
	//  contentHeight
	//----------------------------------

	/**
	 *  Height of the scaled content loaded by the control, in pixels.
	 *  Note that this is not the height of the control itself, but of the
	 *  loaded content. Use the <code>height</code> property of the control
	 *  to obtain its height.
	 *
	 *  <p>The value of this property is not final when the <code>complete</code> event is triggered.
	 *  You can get the value after the <code>updateComplete</code> event is triggered.</p>
	 *
	 *  @default NaN
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get contentHeight():Number
	{
		COMPILE::JS{
			return _imgElement.complete ? _imgElement.naturalHeight : NaN;
		}
		COMPILE::SWF{
			return NaN;
		}
	}


	//----------------------------------
	//  maintainAspectRatio
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the maintainAspectRatio property.
	 */
	/*private var _maintainAspectRatio:Boolean = true;

	[Bindable("maintainAspectRatioChanged")]
	[Inspectable(defaultValue="true")]

	/!**
	 *  A flag that indicates whether to maintain the aspect ratio
	 *  of the loaded content.
	 *  If <code>true</code>, specifies to display the image with the same ratio of
	 *  height to width as the original image.
	 *
	 *  @default true
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 *!/
	public function get maintainAspectRatio():Boolean
	{
		return _maintainAspectRatio;
	}

	/!**
	 *  @private
	 *!/
	public function set maintainAspectRatio(value:Boolean):void
	{
		_maintainAspectRatio = value;

		dispatchEvent(new Event("maintainAspectRatioChanged"));
	}*/

	COMPILE::JS
	public function applyImageData(binaryDataAsString:String):void
	{
		//@todo check that there is no overhead here with adding the same listener multiple times.
		if (_imgElement.src != binaryDataAsString) {
			isContentLoaded = false;
			_imgElement.addEventListener("load", handleImageLoaded);
			_imgElement.src = binaryDataAsString;
		}
	}

	COMPILE::JS
	public function get complete():Boolean
	{
		return _imgElement.complete;
	}

	COMPILE::JS
	private function handleImageLoaded(event:BrowserEvent):void
	{
		trace("The image src "+src+" is now loaded");
		isContentLoaded = true;
		trace("Image offset size is: "+_imgElement.naturalWidth+" x "+_imgElement.naturalHeight);
		// should we now set the image's measured sizes?
		measuredWidth = _imgElement.naturalWidth;
		measuredHeight = _imgElement.naturalHeight;
		var w:Number = getExplicitOrMeasuredWidth();
		var h:Number = getExplicitOrMeasuredHeight();
		//@todo check this. For Item Renderer use
		// setActualSize(w, h);
		updateDisplayList(w, h);
		dispatchEvent(new Event("complete"));

		var newEvent:Event = new Event("layoutNeeded",true);
		dispatchEvent(newEvent);
	}

	//----------------------------------
	//  scaleContent copied from SWFLoader
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the scaleContent property.
	 */
	private var _scaleContent:Boolean = true;

	[Bindable("scaleContentChanged")]
	[Inspectable(category="General", defaultValue="true")]

	/**
	 *  A flag that indicates whether to scale the content to fit the
	 *  size of the control or resize the control to the content's size.
	 *  If <code>true</code>, the content scales to fit the SWFLoader control.
	 *  If <code>false</code>, the SWFLoader scales to fit the content.
	 *
	 *  @default true
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.4
	 */
	public function get scaleContent():Boolean
	{
		return _scaleContent;
	}

	/**
	 *  @private
	 */
	public function set scaleContent(value:Boolean):void
	{
		if (_scaleContent != value)
		{
			_scaleContent = value;

			//  scaleContentChanged = true;
			// invalidateDisplayList();
			if (isContentLoaded) updateDisplayList(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
			dispatchEvent(new Event("scaleContentChanged"));
		}

		// dispatchEvent(new Event("scaleContentChanged"));
	}
	//--------------------------------------------------------------------------
	//
	//  Inherited methods: UIComponent
	//
	//--------------------------------------------------------------------------

	/**
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 * @royaleignorecoercion HTMLImageElement
	 */
	COMPILE::JS
	override protected function createElement():WrappedHTMLElement
	{
		addElementToWrapper(this,'div');
		typeNames = 'Image';
		_imgElement = document.createElement('img') as HTMLImageElement;
		/*WrappedHTMLElement(_imgElement).royale_wrapper = this;*/
		element.appendChild(_imgElement);
		_imgElement.style.position = 'absolute';
		return element;
	}

	//----------------------------------------
	//
	//  Properties OF SWFLoader to Image
	//
	//---------------------------------------

	//----------------------------------
	//  verticalAlign
	//----------------------------------


	private var _vertAlign:String = 'top';
	public function get verticalAlign():String
	{
		return _vertAlign;
	}
	public function set verticalAlign(value:String):void
	{
		if (value!=_vertAlign && '|top|bottom|middle|'.indexOf('|'+value+'|')!=-1) {
			_vertAlign = value;
			if (isContentLoaded) updateDisplayList(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
		}
	}

	//----------------------------------
	//  horizontalAlign
	//----------------------------------
	private var _horizAlign:String = 'left';
	public function get horizontalAlign():String
	{
		return _horizAlign;
	}
	public function set horizontalAlign(value:String):void
	{
		if (value!=_horizAlign && '|left|right|center|'.indexOf('|'+value+'|')!=-1) {
			_horizAlign = value;
			if (isContentLoaded) updateDisplayList(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
		}
	}

	override protected function measure():void
	{
		super.measure();
		if (isContentLoaded) {
			measuredWidth = contentWidth;
			measuredHeight = contentHeight;
		}
	}


	override public function get measuredWidth():Number
	{
		return contentWidth;
	}

	override public function get measuredHeight():Number
	{
		return contentHeight;
	}

	override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		/*if (makeContentVisible && contentHolder)
		{
			contentHolder.visible = true;
			makeContentVisible = false;
		}*/
		/*if (contentChanged)
		{
			contentChanged = false;

			if (_autoLoad)
				load(_source);
		}*/

		if (isContentLoaded)
		{
			// We will either scale the content to the size of the SWFLoader,
			// or we will scale the loader to the size of the content.
			if (_scaleContent/* && !brokenImage*/)
				doScaleContent(unscaledWidth, unscaledHeight);
			else
				doScaleContainer(unscaledWidth,unscaledHeight);

			//scaleContentChanged = false;

			/*if (smoothBitmapContentChanged) {
				doSmoothBitmapContent();
				smoothBitmapContentChanged = false;
			}*/

			var newEvent:Event = new Event("layoutNeeded",true);
			dispatchEvent(newEvent);
		}

		/*if (brokenImage && !brokenImageBorder)
		{
			var skinClass:Class = getStyle("brokenImageBorderSkin");
			if (skinClass)
			{
				brokenImageBorder = IFlexDisplayObject(new skinClass());
				if (brokenImageBorder is ISimpleStyleClient)
					ISimpleStyleClient(brokenImageBorder).styleName = this;
				addChild(DisplayObject(brokenImageBorder));
			}
		}
		else if (!brokenImage && brokenImageBorder)
		{
			removeChild(DisplayObject(brokenImageBorder));
			brokenImageBorder = null;
		}

		if (brokenImageBorder)
			brokenImageBorder.setActualSize(unscaledWidth, unscaledHeight);*/

		//sizeShield();
	}


	/**
	 *  @private
	 *  If scaleContent = true then two situations arise:
	 *  1) the Image has explicitWidth/Height set so we
	 *  simply scale or resize the content to those dimensions; or
	 *  2) the Image doesn't have explicitWidth/Height.
	 *  In this case we should have had our measure() method called
	 *  which would set the measuredWidth/Height to that of the content,
	 *  and when we pass through this code we should just end up at scale = 1.0.
	 */
	private function doScaleContent(unscaledWidth:Number,
									unscaledHeight:Number):void
	{
		if (!isContentLoaded)
			return;


		if (maintainAspectRatio)
		{
			// Make sure any previous scaling is undone.
			//   unScaleContent();

			// Scale the image to the size of the enclosing , preserving aspect ratio.
			var interiorWidth:Number = unscaledWidth;
			var interiorHeight:Number = unscaledHeight;
			var contentWidth:Number = this.contentWidth;
			var contentHeight:Number = this.contentHeight;

			var x:Number = 0;
			var y:Number = 0;

			var newXScale:Number = contentWidth == 0 ?
					1 :
					interiorWidth / contentWidth;
			var newYScale:Number = contentHeight == 0 ?
					1 :
					interiorHeight / contentHeight;

			var scale:Number;

			/*  if (maintainAspectRatio)
              {*/
			if (newXScale > newYScale)
			{
				x = Math.floor((interiorWidth - contentWidth * newYScale) *
						(_horizAlign == 'left' ? 0 : (_horizAlign == 'right' ? 1 : 0.5)));
				scale = newYScale;
			}
			else
			{
				y = Math.floor((interiorHeight - contentHeight * newXScale) *
						(_vertAlign == 'top' ? 0 : (_vertAlign == 'bottom' ? 1 : 0.5)));
				scale = newXScale;
			}

			// Scale by the same amount in both directions.
			/*  contentHolder.scaleX = scale;
              contentHolder.scaleY = scale;*/

			setContentSize(contentWidth * scale, contentHeight * scale);
			/* }
             else
             {
                 /!*contentHolder.scaleX = newXScale;
                 contentHolder.scaleY = newYScale;*!/
                 setContentSize(contentWidth * newXScale, contentHeight * newYScale);
             }*/

			/*contentHolder.x = x;
            contentHolder.y = y;*/
			setContentPosition(x, y);
		}
		else
		{
			/* contentHolder.x = 0;
             contentHolder.y = 0;*/
			setContentPosition(0, 0);
			setContentSize(unscaledWidth, unscaledHeight);
			/*var w:Number = unscaledWidth;
            var h:Number = unscaledHeight;

            if (contentHolder is Loader)
            {
                var holder:Loader = Loader(contentHolder);
                try
                {
                    // don't resize contentHolder until after it is layed out
                    if (getContentSize().x > 0)
                    {
                        var sizeSet:Boolean = false;

                        if (holder.contentLoaderInfo.contentType == "application/x-shockwave-flash")
                        {
                            if (childAllowsParent)
                            {
                                if (holder.content is IFlexDisplayObject)
                                {
                                    IFlexDisplayObject(holder.content).setActualSize(w, h);
                                    sizeSet = true;
                                }
                            }

                            if (!sizeSet && swfBridge)
                            {
                                swfBridge.dispatchEvent(new SWFBridgeRequest(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST,
                                        false, false, null,
                                        { width: w, height: h}));
                                sizeSet = true;
                            }
                        }

                        if (!sizeSet)
                        {
                            // Bug 142705 - we can't just set width and height here. If the SWF content
                            // does not fill the stage, the width/height of the content holder is NOT
                            // the same as the loaderInfo width/height. If we just set width/height
                            // here is can scale the content in unpredictable ways.
                            var lInfo:LoaderInfo = holder.contentLoaderInfo;

                            if (lInfo)
                            {
                                contentHolder.scaleX = w / lInfo.width;
                                contentHolder.scaleY = h / lInfo.height;
                            }
                            else
                            {
                                contentHolder.width = w;
                                contentHolder.height = h;
                            }
                        }
                    }
                    else if (childAllowsParent &&
                            !(holder.content is IFlexDisplayObject))
                    {
                        contentHolder.width = w;
                        contentHolder.height = h;
                    }
                }
                catch(error:Error)
                {
                    contentHolder.width = w;
                    contentHolder.height = h;
                }

                if (!parentAllowsChild)
                    contentHolder.scrollRect = new Rectangle(0, 0,
                            w / contentHolder.scaleX,
                            h / contentHolder.scaleY);
            }
            else
            {
                contentHolder.width = w;
                contentHolder.height = h;
            }*/
		}

	}


	private function setContentSize(w:Number, h:Number):void{
		COMPILE::JS{
			var styles:CSSStyleDeclaration = _imgElement.style;
			styles.width = w + 'px';
			styles.height = h + 'px';
		}
	}

	private function setContentPosition(x:Number, y:Number):void{
		COMPILE::JS{
			var styles:CSSStyleDeclaration = _imgElement.style;
			styles.left = x + 'px';
			styles.top = y + 'px';
		}
	}

	/**
	 *  @private
	 *  If scaleContent = false then two situations arise:
	 *  1) the Image has been given explicitWidth/Height so we don't change
	 *  the size of the Image and simply place the content at 0,0
	 *  and don't scale it and clip it if needed; or
	 *  2) the Image does not have explicitWidth/Height in which case
	 *  our measure() method should have been called and we should have
	 *  been given the right size.
	 *  However if some other constraint applies we simply clip as in
	 *  situation #1, which is why there is only one code path in here.
	 */
	private function doScaleContainer(unscaledWidth:Number,
									  unscaledHeight:Number):void
	{
		if (!isContentLoaded)
			return;

		//   unScaleContent();

		var w:Number = unscaledWidth;
		var h:Number = unscaledHeight;

		if ((contentWidth > w) ||
				(contentHeight > h) /*||
                !parentAllowsChild*/)
		{
			//    contentHolder.scrollRect = new Rectangle(0, 0, w, h);

			COMPILE::JS{
				element.style.overflow = 'hidden';
			}
		}
		else
		{
			//contentHolder.scrollRect = null;
			COMPILE::JS{
				element.style.overflow = 'auto';
			}
		}

		/*   contentHolder.x = (w - contentHolderWidth) * getHorizontalAlignValue();
           contentHolder.y = (h - contentHolderHeight) * getVerticalAlignValue();*/

		COMPILE::JS{
			var styles:CSSStyleDeclaration = _imgElement.style;
			styles.top = (h - contentHeight) * (_vertAlign == 'top' ? 0 : (_vertAlign == 'bottom' ? 1 : 0.5)) + 'px';
			styles.left =  (w - contentWidth) * (_horizAlign == 'left' ? 0 : (_horizAlign == 'right' ? 1 : 0.5)) + 'px';
		}

	}

	private var _maintainAspectRatio:Boolean = true;

	//overriding for now because the stub in UIComponent does nothing....
	override public function get maintainAspectRatio():Boolean
	{
		return _maintainAspectRatio;
	}
	override public function set maintainAspectRatio(value:Boolean):void
	{
		if (_maintainAspectRatio != value) {
			_maintainAspectRatio = value;
			if (isContentLoaded) {
				updateDisplayList(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
			}
		}

	}

}

}
