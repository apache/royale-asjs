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

package spark.primitives
{

/* import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.Capabilities;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

import mx.core.FlexGlobals;
import mx.core.IInvalidating;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.graphics.BitmapFillMode;
import mx.graphics.BitmapScaleMode;
import mx.graphics.BitmapSmoothingQuality;
import mx.utils.DensityUtil;
import mx.utils.LoaderUtil;

import spark.core.ContentRequest;
import spark.core.DisplayObjectSharingMode;
import spark.core.IContentLoader;
import spark.layouts.HorizontalAlign;
import spark.layouts.VerticalAlign;
import spark.primitives.supportClasses.GraphicElement;
import spark.utils.MultiDPIBitmapSource;

use namespace mx_internal; */
import mx.core.mx_internal;
import org.apache.royale.events.EventDispatcher;
use namespace mx_internal;
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when content loading is complete. This
 *  event is only dispatched for url and ByteArray based
 *  sources (those sources requiring a Loader).
 *
 *  <p>Note that for content loaded via Loader, both
 *  <code>ready</code> and <code>complete</code> events
 *  are dispatched.</p>  For other source types such as
 *  embeds, only <code>ready</code> is dispatched.
 *
 *  @eventType flash.events.Event.COMPLETE
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.4
 */
//[Event(name="complete", type="flash.events.Event")]

/**
 *  Dispatched when a network request is made over HTTP
 *  and Flash Player or AIR can detect the HTTP status code.
 *
 *  @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.4
 */
//[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]

/**
 *  Dispatched when an input/output error occurs.
 *  @see flash.events.IOErrorEvent
 *
 *  @eventType flash.events.IOErrorEvent.IO_ERROR
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.4
 */
//[Event(name="ioError", type="flash.events.IOErrorEvent")]

/**
 *  Dispatched when content is loading.
 *
 *  <p><strong>Note:</strong>
 *  The <code>progress</code> event is not guaranteed to be dispatched.
 *  The <code>complete</code> event may be received, without any
 *  <code>progress</code> events being dispatched.
 *  This can happen when the loaded content is a local file.</p>
 *
 *  @eventType flash.events.ProgressEvent.PROGRESS
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.4
 */
//[Event(name="progress", type="flash.events.ProgressEvent")]

/**
 *  Dispatched when content loading is complete.  Unlike the
 *  <code>complete</code> event, this event is dispatched for
 *  all source types.
 *
 *  <p>Note that for content loaded via Loader, both
 *  <code>ready</code> and <code>complete</code> events
 *  are dispatched.</p>  For other source types such as
 *  embeds, only <code>ready</code> is dispatched.
 *
 *  @eventType mx.events.FlexEvent.READY
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.4
 */
//[Event(name="ready", type="mx.events.FlexEvent")]

/**
 *  Dispatched when a security error occurs.
 *  @see flash.events.SecurityErrorEvent
 *
 *  @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.4
 */
//[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
//
/**
 *  A BitmapImage element defines a rectangular region in its parent element's
 *  coordinate space, filled with bitmap data drawn from a source file or
 *  source URL.
 *
 *  @includeExample examples/BitmapImageExample.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.4
 */
public class BitmapImage extends EventDispatcher
{ //extends GraphicElement
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function BitmapImage()
    {
        super();

        // Typically, this should not be mirrored.
       // layoutDirection = "ltr";
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	
public function set left(value:Number):void
{
	// stub - this should be removed once BitmapImage extends the right class;
}
	
public function set right(value:Number):void
{
	// stub - this should be removed once BitmapImage extends the right class;
}
	
public function set top(value:Number):void
{
	// stub - this should be removed once BitmapImage extends the right class;
}
	
public function set bottom(value:Number):void
{
	// stub - this should be removed once BitmapImage extends the right class;
}
	
public function set minWidth(value:Number):void
{
	// stub - this should be removed once BitmapImage extends the right class;
}
	
public function set minHeight(value:Number):void
{
	// stub - this should be removed once BitmapImage extends the right class;
}

/* 
    private var _scaleGridBottom:Number;
    private var _scaleGridLeft:Number;
    private var _scaleGridRight:Number;
    private var _scaleGridTop:Number;
    private var bitmapDataCreated:Boolean;
    private static var matrix:Matrix = new Matrix();
    private var cachedSourceGrid:Array;
    private var cachedDestGrid:Array;
    private var imageWidth:Number = NaN;
    private var imageHeight:Number = NaN;
    private var loadedContent:DisplayObject;
    private var loadingContent:Object;
    private var previousUnscaledWidth:Number;
    private var previousUnscaledHeight:Number;
    private var sourceInvalid:Boolean;
    private var loadFailed:Boolean;
	private var dpiScale:Number = 1;
	private var _cachedImageDecodePolicy:Boolean;
	private var _haveCachedImageDecodePolicy:Boolean; */
	
	
	/**
	 *  Specifies that the image being loaded will be decoded when needed.
	 * 
	 *  @see flash.system.ImageDecodingPolicy
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 0.9.4
	 */
	//public static const ON_DEMAND:String = "onDemand";

	/**
	 *  Specifies that the image being loaded will be decoded on load.
	 * 
	 *  @see flash.system.ImageDecodingPolicy
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 0.9.4
	 */
	//public static const ON_LOAD:String = "onLoad";

    //----------------------------------
    //  bitmapData
    //----------------------------------

   // private var _bitmapData:BitmapData;

    /**
     *  Returns a copy of the BitmapData object representing
     *  the currently loaded image content (unscaled).  This property
     *  is <code>null</code> for untrusted cross domain content.
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.4
     */
    /* public function get bitmapData():BitmapData
    {
		//We return a copy because when the source of the data changes we destroy the bitmap
		//If a developer is holding a reference to the actual bitmap they will have an invalid reference
        return _bitmapData ? _bitmapData.clone() : _bitmapData;
    } */

    //----------------------------------
    //  bytesLoaded
    //----------------------------------

   // private var _bytesLoaded:Number = NaN;

    /**
     *  The number of bytes of the image already loaded.
     *  Only relevant for images loaded by request URL.
     *
     *  @default NaN
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.4
     */
    /* public function get bytesLoaded():Number
    {
        return _bytesLoaded;
    } */

    //----------------------------------
    //  bytesTotal
    //----------------------------------

    //private var _bytesTotal:Number = NaN;

    /**
     *  The total image data in bytes loaded or pending load.
     *  Only relevant for images loaded by request URL.
     *
     *  @default NaN
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.4
     */
   /*  public function get bytesTotal():Number
    {
        return _bytesTotal;
    } */

    //----------------------------------
    //  clearOnLoad
    //----------------------------------

    //private var _clearOnLoad:Boolean = true;

    /**
     *  Denotes whether or not to clear previous
     *  image content prior to loading new content.
     *
     *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.4
     */
   /*  public function get clearOnLoad():Boolean
    {
        return _clearOnLoad;
    } */

    /**
     *  @private
     */
    /* public function set clearOnLoad(value:Boolean):void
    {
        _clearOnLoad = value;
    } */

    //----------------------------------
    //  contentLoaderGrouping
    //----------------------------------

    //private var _contentLoaderGrouping:String;

    /**
     *  Optional content grouping identifier to pass to the an
     *  associated IContentLoader instance's load() method.
     *  This property is only considered when a valid contentLoader
     *  is assigned.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get contentLoaderGrouping():String
    {
        return _contentLoaderGrouping;
    } */

    /**
     *  @private
     */
   /*  public function set contentLoaderGrouping(value:String):void
    {
        if (value != _contentLoaderGrouping)
        {
            _contentLoaderGrouping = value;
            invalidateProperties();
        }
    } */

    //----------------------------------
    //  contentLoader
    //----------------------------------

    /* private var _contentLoader:IContentLoader;
    private var contentLoaderInvalid:Boolean;
	*/
    /**
     *  Optional custom image loader (e.g. image cache or queue) to
     *  associate with content loader client.
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get contentLoader():IContentLoader
    {
        return _contentLoader;
    } */

    /**
     *  @private
     */
   /*  public function set contentLoader(value:IContentLoader):void
    {
        if (value != _contentLoader)
        {
            _contentLoader = value;
            contentLoaderInvalid = true;
            invalidateProperties();
        }
    } */

    //----------------------------------
    //  fillMode
    //----------------------------------

    /**
     *  @private
     */
  /*   protected var _fillMode:String = BitmapFillMode.SCALE;

    [Inspectable(category="General", enumeration="clip,repeat,scale", defaultValue="scale")] */

    /**
     *  Determines how the bitmap fills in the dimensions. If you set the value
     *  of this property in a tag, use the string (such as "repeat"). If you set the value of
     *  this property in ActionScript, use the constant (such as <code>mx.graphics.BitmapFillMode.CLIP</code>).
     *
     *  <p>When set to <code>BitmapFillMode.CLIP</code> ("clip"), the bitmap
     *  ends at the edge of the region.</p>
     *
     *  <p>When set to <code>BitmapFillMode.REPEAT</code> ("repeat"), the bitmap
     *  repeats to fill the region.</p>
     *
     *  <p>When set to <code>BitmapFillMode.SCALE</code> ("scale"), the bitmap
     *  stretches to fill the region.</p>
     *
     *  @default <code>BitmapFillMode.SCALE</code>
     *
     *  @see mx.graphics.BitmapFillMode
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get fillMode():String
    {
        return _fillMode;
    } */

    /**
     *  @private
     */
    /* public function set fillMode(value:String):void
    {
        if (value != _fillMode)
        {
            _fillMode = value;
            invalidateDisplayList();
        }
    } */

    //----------------------------------
    //  horizontalAlign
    //----------------------------------

    /**
     *  @private
     */
    /* private var _horizontalAlign:String = HorizontalAlign.CENTER;

    [Inspectable(category="General", enumeration="left,right,center", defaultValue="center")] */

    /**
     *  The horizontal alignment of the content when it does not have
     *  a one-to-one aspect ratio and <code>scaleMode</code> is set to
     *  <code>mx.graphics.BitmapScaleMode.LETTERBOX</code>.
     *
     *  <p>Can be one of <code>HorizontalAlign.LEFT</code> ("left"),
     *  <code>HorizontalAlign.RIGHT</code> ("right"), or
     *  <code>HorizontalAlign.CENTER</code> ("center").</p>
     *
     *  <p>This property is only applicable when <code>fillMode</code> is set to
     *  to <code>mx.graphics.BitmapFillMode.SCALE</code> ("scale").</p>
     *
     *  @default <code>HorizontalAlign.CENTER</code>
     *
     *  @see mx.graphics.BitmapFillMode
     *  @see mx.graphics.BitmapScaleMode
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get horizontalAlign():String
    {
        return _horizontalAlign;
    } */

    /**
     *  @private
     */
    /* public function set horizontalAlign(value:String):void
    {
        if (value == _horizontalAlign)
            return;

        _horizontalAlign = value;
        invalidateDisplayList();
    } */

    /**
     *  @private
     */
    /* private function getHorizontalAlignValue():Number
    {
        if (_horizontalAlign == HorizontalAlign.LEFT)
            return 0;
        else if (_horizontalAlign == HorizontalAlign.RIGHT)
            return 1;
        else
            return 0.5;
    }
	 */
	/**
	 *  The image decoding policy, set to ON_DEMAND or ON_LOAD.
	 *  The default is ON_DEMAND.
	 * 
	 *  ImageDecodingPolicy also defined ON_DEMAND and ON_LOAD but these
	 *  are only available under AIR 2.6 and above.
	 * 
	 *  Setting to asynchronously decode and load the bitmap images for
	 *  large image may improve your application’s perceived performance.
	 * 
	 *  @langversion 3.0
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	//public var imageDecodingPolicy:String = ON_DEMAND;

    //----------------------------------
    //  preliminaryHeight
    //----------------------------------

    /**
     *  @private
     */
    //private var _preliminaryHeight:Number = NaN;

    /**
     *  Provides an estimate to use for height when the "measured" bounds
     *  of the image is requested by layout, but the image data has
     *  yet to complete loading. When NaN the measured height is 0 until
     *  the image has finished loading.
     *
     *  @default NaN
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get preliminaryHeight():Number
    {
        return _preliminaryHeight;
    } */

    /**
     *  @private
     */
    /* public function set preliminaryHeight(value:Number):void
    {
        if (value != _preliminaryHeight)
        {
            _preliminaryHeight = value;
            invalidateSize();
        }
    } */

    //----------------------------------
    //  preliminaryWidth
    //----------------------------------

    /**
     *  @private
     */
   // private var _preliminaryWidth:Number = NaN;

    /**
     *  Provides an estimate to use for width when the "measured" bounds
     *  of the image is requested by layout, but the image data has
     *  yet to complete loading. When NaN the measured width is 0 until
     *  the image has finished loading.
     *
     *  @default NaN
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get preliminaryWidth():Number
    {
        return _preliminaryWidth;
    } */

    /**
     *  @private
     */
    /* public function set preliminaryWidth(value:Number):void
    {
        if (value != _preliminaryWidth)
        {
            _preliminaryWidth = value;
            invalidateSize();
        }
    } */

    //----------------------------------
    //  scaleMode
    //----------------------------------

    /**
     *  @private
     */
    /* private var _scaleMode:String = BitmapScaleMode.STRETCH;

    [Inspectable(category="General", enumeration="stretch,letterbox,zoom", defaultValue="stretch")] */

    /**
     *  Determines how the image is scaled when <code>fillMode</code> is set to
     *  <code>mx.graphics.BitmapFillMode.SCALE</code>.
     *
     *  <p>When set to <code>mx.graphics.BitmapScaleMode.STRETCH</code> ("stretch"),
     *  the image is stretched to fit.</p>
     *
     *  <p>When set to <code>BitmapScaleMode.LETTERBOX</code> ("letterbox"),
     *  the image is scaled with respect to the original unscaled image's
     *  aspect ratio.</p>
     *
     *  <p>When set to <code>BitmapScaleMode.ZOOM</code> ("zoom"),
     *  the image is scaled to fit with respect to the original unscaled image's
     *  aspect ratio. This results in cropping on one axis.</p>
     *
     *  @default <code>BitmapScaleMode.STRETCH</code>
     *
     *  @see mx.graphics.BitmapFillMode
     *  @see mx.graphics.BitmapScaleMode
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.4
     */
    /* public function get scaleMode():String
    {
        return _scaleMode;
    } */

    /**
     *  @private
     */
    /* public function set scaleMode(value:String):void
    {
        if (value == _scaleMode)
            return;

        _scaleMode = value;
        invalidateDisplayList();
    } */

    //----------------------------------
    //  smooth
    //----------------------------------

   /*  private var _smooth:Boolean = false;

    [Inspectable(category="General", enumeration="true,false", defaultValue="false")] */

    /**
     *  @copy flash.display.GraphicsBitmapFill#smooth
     *
     *  @default false
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function set smooth(value:Boolean):void
    {
        if (value != _smooth)
        {
            _smooth = value;
            invalidateDisplayList();
        }
    } */

    /**
     *  @private
     */
   /*  public function get smooth():Boolean
    {
        return _smooth;
    } */

    //----------------------------------
    //  smoothingQuality
    //----------------------------------

  /*   private var _smoothingQuality:String = BitmapSmoothingQuality.DEFAULT;

    [Inspectable(category="General", enumeration="default,high", defaultValue="default")] */

    /**
     *  Determines how the image is down-scaled.  When set to
     *  <code>BitmapSmoothingQuality.HIGH</code>, the image is resampled (if data
     *  is from a trusted source) to achieve a higher quality result.
     *  If set to <code>BitmapSmoothingQuality.DEFAULT</code>, the default stage
     *  quality for scaled bitmap fills is used.
     *
     *  @default <code>BitmapSmoothingQuality.DEFAULT</code>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function set smoothingQuality(value:String):void
    {
        if (value != _smoothingQuality)
        {
            _smoothingQuality = value;
            invalidateDisplayList();
        }
    } */

    /**
     *  @private
     */
    /* public function get smoothingQuality():String
    {
        return _smoothingQuality;
    }
	*/
    //----------------------------------
    //  source
    //----------------------------------

    private var _source:Object;

    [Bindable("sourceChanged")]
    [Inspectable(category="General")]

    /**
     *  The source used for the bitmap fill. The fill can render from various
     *  graphical sources, including the following:
     *  <ul>
     *   <li>A Bitmap or BitmapData instance.</li>
     *   <li>A class representing a subclass of DisplayObject. The BitmapFill
     *       instantiates the class and creates a bitmap rendering of it.</li>
     *   <li>An instance of a DisplayObject. The BitmapFill copies it into a
     *       Bitmap for filling.</li>
     *   <li>The name of an external image file. </li>
     *  </ul>
     *
     *  <p>If you use an image file for the source, it can be of type PNG, GIF,
     *  or JPG.</p>
     *
     *  <p>To specify an embedded image source, you can use the &#64;Embed directive,
     *  as the following example shows:
     *  <pre>
     *  source="&#64;Embed('&lt;i&gt;image_location&lt;/i&gt;')"
     *  </pre>
     *  </p>
     *
     *  <p>The image location can be specified via a URL, URLRequest, or file
     *  reference. If it is a file reference, its location is relative to the
     *  location of the file that is being compiled.</p>
     *
     *  <p>The BitmapImage class is designed to work with embedded images or
     *  images that are loaded at run time.</p>
     *
     *  <p>If the source is a Bitmap or BitmapData instance or is an external
     *  image file, it is the responsibility of the caller to dispose of the
     *  source once it is no longer needed. If ImageLoader created the BitmapData
     *  instance, then it will dispose of the BitmapData once the source has
     *  changed.</p>
     *
     *  @see flash.display.Bitmap
     *  @see flash.display.BitmapData
     *  @see mx.graphics.BitmapFill
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get source():Object
    {
        return _source;
    }

    /**
     *  @private
     */
    public function set source(value:Object):void
    {
        if (value != _source)
        {
            // Remove listeners from any previous load instance and clear
            // our reference to any existing load-event dispatcher. This ensures
            // for example that we do not receive further load related events
            // our previous content before we can consider the new source.
            /* clearLoadingContent();

            // Remove any event listeners from previous source.
            removeAddedToStageHandler(_source); */

            _source = value;
            /* sourceInvalid = true;
            loadFailed = false;
            invalidateProperties();
            dispatchEvent(new Event("sourceChanged")); */
        }
    }

    //----------------------------------
    //  sourceHeight
    //----------------------------------

    /**
     *  Provides the unscaled height of the original image data.
     *
     *  @default NaN
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get sourceHeight():Number
    {
        return imageHeight;
    } */

    //----------------------------------
    //  sourceWidth
    //----------------------------------

    /**
     *  Provides the unscaled width of the original image data.
     *
     *  @default NaN
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get sourceWidth():Number
    {
        return imageWidth;
    } */

    //----------------------------------
    //  trustedSource
    //----------------------------------

   // private var _trustedSource:Boolean = true;

    /**
     *  A read-only flag denoting whether the currently loaded
     *  content is considered loaded form a source whose security
     *  policy allows for cross domain image access.
     *  When <code>false</code>, advanced bitmap operations such as high quality scaling,
     *  and tiling are not permitted.  This flag is set once an
     *  image has been fully loaded.
     *
     *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get trustedSource():Boolean
    {
        return _trustedSource;
    } */

    //----------------------------------
    //  verticalAlign
    //----------------------------------

    /**
     *  @private
     */
   /*  private var _verticalAlign:String = VerticalAlign.MIDDLE;

    [Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")] */

    /**
     *  The vertical alignment of the content when it does not have
     *  a one-to-one aspect ratio and scaleMode is set to
     *  <code>mx.graphics.BitmapScaleMode.LETTERBOX</code>.
     *
     *  <p>Can be one of <code>VerticalAlign.TOP</code> ("top"),
     *  <code>VerticalAlign.BOTTOM</code> ("bottom"), or
     *  <code>VerticalAlign.MIDDLE</code> ("middle").</p>
     *
     *  <p>This property is only applicable when scaleMode is set to
     *  to <code>BitmapFillMode.SCALE</code> ("scale").</p>
     *
     *  @default <code>VerticalAlign.MIDDLE</code>
     *
     *  @see mx.graphics.BitmapFillMode
     *  @see mx.graphics.BitmapScaleMode
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get verticalAlign():String
    {
        return _verticalAlign;
    } */

    /**
     *  @private
     */
    /* public function set verticalAlign(value:String):void
    {
        if (value == _verticalAlign)
            return;

        _verticalAlign = value;
        invalidateDisplayList();
    } */

    /**
     *  @private
     */
    /* private function getVerticalAlignValue():Number
    {
        if (_verticalAlign == VerticalAlign.TOP)
            return 0;
        else if (_verticalAlign == VerticalAlign.BOTTOM)
            return 1;
        else
            return 0.5;
    } */

    //--------------------------------------------------------------------------
    //
    //  GraphicElement Overrides
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function commitProperties():void
    {
        validateSource();
        super.commitProperties();
    } */

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function measure():void
    {
        var app:Object = FlexGlobals.topLevelApplication;
        if ("applicationDPI" in app && "runtimeDPI" in app && source is MultiDPIBitmapSource)
            dpiScale = app.runtimeDPI / app.applicationDPI;

        if (loadedContent)
        {
            // Return size of our loaded image content.
            measuredWidth = imageWidth;
            measuredHeight = imageHeight;
            if (dpiScale != 1) // density scaling may be in effect
            {
                measuredWidth /= dpiScale;
                measuredHeight /= dpiScale;
            }
        }
        else if (_bitmapData)
        {
            // Return size of our bitmap data.
            measuredWidth = _bitmapData.width;
            measuredHeight = _bitmapData.height;
            if (dpiScale != 1) // density scaling may be in effect
            {
                measuredWidth /= dpiScale;
                measuredHeight /= dpiScale;
            }
        }
        else
        {
            // If we are loading new content we keep the old measured width/height to avoid
            // sizing to 0,0 for a frame unnecessarily. Otherwise we fall back to 0 unless
            // a preliminaryWidth/Height is set.
            var usePreviousSize:Boolean = !(_source == null || _source == "" || loadFailed);
            var previousWidth:Number = usePreviousSize ? measuredWidth : 0;
            var previousHeight:Number = usePreviousSize ? measuredHeight : 0;

            measuredWidth = !isNaN(_preliminaryWidth) && (previousWidth == 0) ?
                _preliminaryWidth : previousWidth;
            measuredHeight = !isNaN(_preliminaryHeight) && (previousHeight == 0) ?
                _preliminaryHeight : previousHeight;

            return;
        }

        // Consider aspectRatio
        if (maintainAspectRatio && measuredWidth > 0 && measuredHeight > 0)
        {
            if(!isNaN(explicitWidth) && isNaN(explicitHeight) &&
                isNaN(percentHeight))
            {
                measuredHeight = explicitWidth/measuredWidth * measuredHeight;
            }
            else if (!isNaN(explicitHeight) && isNaN(explicitWidth) &&
                isNaN(percentWidth))
            {
                measuredWidth = explicitHeight/measuredHeight * measuredWidth;
            }
            else if (!isNaN(percentWidth) && isNaN(explicitHeight) &&
                isNaN(percentHeight) && width > 0)
            {
                measuredHeight = width/measuredWidth * measuredHeight;
            }
            else if (!isNaN(percentHeight) && isNaN(explicitWidth) &&
                isNaN(percentWidth) && height > 0)
            {
                measuredWidth = height/measuredHeight * measuredWidth;
            }
        }
    } */

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        var adjustedHeight:Number = unscaledHeight;
        var adjustedWidth:Number = unscaledWidth;
        var isZoom:Boolean = (_fillMode == BitmapFillMode.SCALE) && 
                             (_scaleMode == BitmapScaleMode.ZOOM);

        // Consider aspectRatio
        var aspectRatio:Number = unscaledWidth/unscaledHeight;
        var imageAspectRatio:Number = imageWidth/imageHeight;
        if (maintainAspectRatio)
        {
            if (!isNaN(imageAspectRatio))
            {
                if (imageAspectRatio > aspectRatio)
                    adjustedHeight = unscaledWidth / imageAspectRatio;
                else
                    adjustedWidth = unscaledHeight * imageAspectRatio;
                
                if ((!isNaN(percentWidth) && isNaN(percentHeight) && isNaN(explicitHeight)) ||
                    (!isNaN(percentHeight) && isNaN(percentWidth) && isNaN(explicitWidth)))
                {
                    if (Math.abs(aspectRatio - imageAspectRatio) > 0.001)
                    {
                        invalidateSize();
                        return;
                    }
                }
            }
        }

        if (!_bitmapData || !drawnDisplayObject || !(drawnDisplayObject is Sprite))
        {
            if (loadedContent)
            {
                // We are hosting a display object so let's scale, align, and clip
                // as necessary.

                if (_fillMode == BitmapFillMode.SCALE)
                {
                    loadedContent.width = adjustedWidth;
                    loadedContent.height = adjustedHeight;
                }

                loadedContent.y = loadedContent.x = 0;

                // Align our loaded content as necessary if our width
                // and/or height is larger than our content height.
                if (maintainAspectRatio || _fillMode == BitmapFillMode.CLIP || isZoom)
                {
                    var contentWidth:Number = (_fillMode == BitmapFillMode.CLIP || isZoom) ?
                        imageWidth : adjustedWidth;
                    var contentHeight:Number = (_fillMode == BitmapFillMode.CLIP || isZoom) ?
                        imageHeight : adjustedHeight;

                    if (unscaledHeight > contentHeight)
                        loadedContent.y = Math.floor((unscaledHeight - contentHeight)
                            * getVerticalAlignValue());

                    if (unscaledWidth > contentWidth)
                        loadedContent.x = Math.floor((unscaledWidth - contentWidth)
                            * getHorizontalAlignValue());
                }

                // Setup clip rect if appropriate.
                loadedContent.scrollRect = (_fillMode == BitmapFillMode.CLIP || isZoom) ?
                    new Rectangle(0, 0, unscaledWidth, unscaledHeight) : null;

            }
            return;
        }

        // The base GraphicElement class has cleared the graphics for us.
        var g:Graphics = Sprite(drawnDisplayObject).graphics;

        g.lineStyle();
        var repeatBitmap:Boolean = false;
        var fillScaleX:Number = 1/dpiScale;
        var fillScaleY:Number = 1/dpiScale;
        var roundedDrawX:Number = Math.round(drawX);
        var roundedDrawY:Number = Math.round(drawY);
        var fillWidth:Number = adjustedWidth;
        var fillHeight:Number = adjustedHeight;
        
        if (_bitmapData)
        {
            switch(_fillMode)
            {
                case BitmapFillMode.REPEAT:
                {
                    repeatBitmap = true;
                    break;
                }
                case BitmapFillMode.SCALE:
                {
                    if (isZoom)
                    {
                        var widthRatio:Number = adjustedWidth / _bitmapData.width;
                        var heightRatio:Number = adjustedHeight / _bitmapData.height;
                        
                        if (widthRatio < heightRatio)
                            fillScaleX = fillScaleY = (adjustedHeight / _bitmapData.height);
                        else
                            fillScaleX = fillScaleY = (adjustedWidth / _bitmapData.width);
                    }
                    else
                    {
                        fillScaleX = adjustedWidth / _bitmapData.width;
                        fillScaleY = adjustedHeight / _bitmapData.height;
                    }
                    break;
                }
                case BitmapFillMode.CLIP:
                {
                    fillWidth = Math.min(adjustedWidth, _bitmapData.width);
                    fillHeight = Math.min(adjustedHeight, _bitmapData.height);
                    break;
                }
            }
        }

        // If no scaleGrid is defined or if fillMode != SCALE, just draw
        // the entire rect
        if (_fillMode != BitmapFillMode.SCALE ||
            isNaN(_scaleGridTop) ||
            isNaN(_scaleGridBottom) ||
            isNaN(_scaleGridLeft) ||
            isNaN(_scaleGridRight))
        {
            var sampledScale:Boolean = _smooth &&
                (_smoothingQuality == BitmapSmoothingQuality.HIGH) &&
                (_fillMode == BitmapFillMode.SCALE);
            var sampleWidth:Number = fillWidth;
            var sampleHeight:Number = fillHeight;
            
            if (isZoom)
            {
                sampleWidth = _bitmapData.width * fillScaleX;
                sampleHeight = _bitmapData.height * fillScaleY;
            }

            var b:BitmapData = sampledScale ? resample(_bitmapData, sampleWidth, sampleHeight) : _bitmapData;

            if (sampledScale && (_fillMode == BitmapFillMode.SCALE))
            {
                if (isZoom)
                {
                    fillScaleX = fillScaleY = 1;
                }
                else if (_fillMode == BitmapFillMode.SCALE)
                {
                    fillScaleX = adjustedWidth / b.width;
                    fillScaleY = adjustedHeight / b.height;
                }
            }
            
            var cHeight:Number = b.height * fillScaleX;
            var cWidth:Number = b.width * fillScaleY;

            // Align our bitmap content as necessary if our width
            // and/or height is larger than our content height.
            if (maintainAspectRatio || _fillMode == BitmapFillMode.CLIP || isZoom)
            {
                if (unscaledHeight > cHeight)
                    roundedDrawY = roundedDrawY + Math.floor((unscaledHeight - cHeight)
                        * getVerticalAlignValue());

                if (unscaledWidth > cWidth)
                    roundedDrawX = roundedDrawX + Math.floor((unscaledWidth - cWidth)
                        * getHorizontalAlignValue());
            }
            
            var translateX:Number = roundedDrawX;
            var translateY:Number = roundedDrawY;
            
            if (isZoom)
            {
                if (cWidth > unscaledWidth)
                    translateX = translateX + ((unscaledWidth - cWidth) * getHorizontalAlignValue());
                else if (cHeight > unscaledHeight)
                    translateY = translateY + ((unscaledHeight - cHeight) * getVerticalAlignValue());
            }

            matrix.identity();
            if (!(sampledScale && (maintainAspectRatio || isZoom))) 
                matrix.scale(fillScaleX, fillScaleY);
            matrix.translate(translateX, translateY);
            g.beginBitmapFill(b, matrix, repeatBitmap, _smooth);
            g.drawRect(roundedDrawX, roundedDrawY, fillWidth, fillHeight);
            g.endFill();
        }
        else
        {
            // If we have scaleGrid, we draw 9 sections, each with a different scale factor based
            // on the grid region.

            if (cachedSourceGrid == null)
            {
                // Generate the 16 points of the source (unscaled) grid
                cachedSourceGrid = [];
                cachedSourceGrid.push([new Point(0, 0), new Point(_scaleGridLeft, 0),
                    new Point(_scaleGridRight, 0), new Point(_bitmapData.width, 0)]);
                cachedSourceGrid.push([new Point(0, _scaleGridTop), new Point(_scaleGridLeft, _scaleGridTop),
                    new Point(_scaleGridRight, _scaleGridTop), new Point(_bitmapData.width, _scaleGridTop)]);
                cachedSourceGrid.push([new Point(0, _scaleGridBottom), new Point(_scaleGridLeft, _scaleGridBottom),
                    new Point(_scaleGridRight, _scaleGridBottom), new Point(_bitmapData.width, _scaleGridBottom)]);
                cachedSourceGrid.push([new Point(0, _bitmapData.height), new Point(_scaleGridLeft, _bitmapData.height),
                    new Point(_scaleGridRight, _bitmapData.height), new Point(_bitmapData.width, _bitmapData.height)]);
            }

            if (cachedDestGrid == null ||
                previousUnscaledWidth != unscaledWidth ||
                previousUnscaledHeight != unscaledHeight)
            {
                // Generate teh 16 points of the destination (scaled) grid
                var destScaleGridBottom:Number = unscaledHeight - (_bitmapData.height - _scaleGridBottom);
                var destScaleGridRight:Number = unscaledWidth - (_bitmapData.width - _scaleGridRight);
                cachedDestGrid = [];
                cachedDestGrid.push([new Point(0, 0), new Point(_scaleGridLeft, 0),
                    new Point(destScaleGridRight, 0), new Point(unscaledWidth, 0)]);
                cachedDestGrid.push([new Point(0, _scaleGridTop), new Point(_scaleGridLeft, _scaleGridTop),
                    new Point(destScaleGridRight, _scaleGridTop), new Point(unscaledWidth, _scaleGridTop)]);
                cachedDestGrid.push([new Point(0, destScaleGridBottom), new Point(_scaleGridLeft, destScaleGridBottom),
                    new Point(destScaleGridRight, destScaleGridBottom), new Point(unscaledWidth, destScaleGridBottom)]);
                cachedDestGrid.push([new Point(0, unscaledHeight), new Point(_scaleGridLeft, unscaledHeight),
                    new Point(destScaleGridRight, unscaledHeight), new Point(unscaledWidth, unscaledHeight)]);
            }

            var sourceSection:Rectangle = new Rectangle();
            var destSection:Rectangle = new Rectangle();

            // Iterate over the columns and rows. We draw each of the nine sections at a calculated
            // scale and translation.
            for (var rowIndex:int=0; rowIndex < 3; rowIndex++)
            {
                for (var colIndex:int = 0; colIndex < 3; colIndex++)
                {
                    // Create the source and destination rectangles for the current section
                    sourceSection.topLeft = cachedSourceGrid[rowIndex][colIndex];
                    sourceSection.bottomRight = cachedSourceGrid[rowIndex+1][colIndex+1];

                    destSection.topLeft = cachedDestGrid[rowIndex][colIndex];
                    destSection.bottomRight = cachedDestGrid[rowIndex+1][colIndex+1];

                    matrix.identity();
                    // Scale the bitmap by the ratio between the source and destination dimensions
                    matrix.scale(destSection.width / sourceSection.width, destSection.height / sourceSection.height);
                    // Translate based on the difference between the source and destination coordinates,
                    // making sure to account for the new scale.
                    matrix.translate(destSection.x - sourceSection.x * matrix.a, destSection.y - sourceSection.y * matrix.d);
                    matrix.translate(roundedDrawX, roundedDrawY);

                    // Draw the bitmap for the current section
                    g.beginBitmapFill(_bitmapData, matrix);
                    g.drawRect(destSection.x + roundedDrawX, destSection.y + roundedDrawY, destSection.width, destSection.height);
                    g.endFill();
                }
            }
        }

        previousUnscaledWidth = unscaledWidth;
        previousUnscaledHeight = unscaledHeight;
    } */

    /**
     *  @private
     */
    /* override protected function get needsDisplayObject():Boolean
    {
        // If we are hosting untrusted content the hosted loader becomes
        // our display object.
        return !trustedSource || super.needsDisplayObject;
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Utility function that sets the underlying bitmapData property.
     */
    /* protected function setBitmapData(bitmapData:BitmapData,
                                     internallyCreated:Boolean = false):void
    {
        // Clear previous bitmapData
        clearBitmapData();

        // Reset imageWidth/Height, as we aren't
        // loading external content so no reason to
        // cache our existing image width and height.
        imageWidth = imageHeight = NaN;

        // Clear any currently loading content.
        clearLoadingContent();

        if (bitmapData)
        {
            bitmapDataCreated = internallyCreated;

            _bitmapData = bitmapData;

            imageWidth = bitmapData.width;
            imageHeight = bitmapData.height;

            // Flush the cached scale grid points
            cachedSourceGrid = null;
            cachedDestGrid = null;

            // Dispatch ready event
            dispatchEvent(new FlexEvent(FlexEvent.READY));
        }

        if (!explicitHeight || !explicitWidth)
            invalidateSize();
        invalidateDisplayList();
    } */

    /**
     *  @private
     *  Utility method which analyzes our source and either acquires the
     *  associated bitmap data immediately or queues up a remote request
     *  as necessary.
     */
    /* mx_internal function applySource():void
    {
        var value:Object = _source;
        var bitmapData:BitmapData;
        var tmpSprite:DisplayObject;

        if (value is MultiDPIBitmapSource)
            value = (value as MultiDPIBitmapSource).getMultiSource();

        // Clear the previous scaleGrid properties
        _scaleGridLeft = NaN;
        _scaleGridRight = NaN;
        _scaleGridTop = NaN;
        _scaleGridBottom = NaN;
        var currentBitmapCreated:Boolean = false;

        // Reset byte counts and _trustedSource
        _bytesLoaded = NaN;
        _bytesTotal = NaN;
        _trustedSource = true;

        // We'll need to reconsider display object sharing.
        invalidateDisplayObjectSharing();
        invalidateDisplayList();

        // Remove any previously hosted content prior to loading
        // new content (if applicable).
        if (_clearOnLoad)
            removePreviousContent();

        if (value is Class)
        {
            var cls:Class = Class(value);
            value = new cls();
            currentBitmapCreated = true;
        }
        else if (value is String || value is URLRequest)
        {
            loadExternal(value);
        }
        else if (value is ByteArray)
        {
            loadFromBytes(value as ByteArray);
        }

        if (value is BitmapData)
        {
            bitmapData = value as BitmapData;
        }
        else if (value is Bitmap)
        {
            bitmapData = value.bitmapData;
        }
        else if (value is DisplayObject)
        {
            tmpSprite = value as DisplayObject;

            if ((tmpSprite.width == 0 || tmpSprite.height == 0) && !tmpSprite.stage )
            {
                // If our source DisplayObject has yet to be assigned a stage,
                // and doesn't have valid bounds, it is not ready to be captured,
                // so we defer bitmap capture until it is added to the display list.
                tmpSprite.addEventListener(Event.ADDED_TO_STAGE, source_addedToStageHandler);
                return;
            }
        }
        else if (value == null)
        {
            // This will set source to null
        }
        else
        {
            // We're loading external content or we
            // we have an unsupported source value.
            return;
        }

        if (!bitmapData && tmpSprite)
        {
            // We must ensure any IInvalidating sources
            // are properly validated before capturing.
            if (tmpSprite is IInvalidating)
                IInvalidating(tmpSprite).validateNow();

            // Return immediately if our input source has 0 bounds else
            // our BitmapData constructor will RTE.
            if (tmpSprite.width == 0 || tmpSprite.height == 0)
                return;

            bitmapData = new BitmapData(tmpSprite.width, tmpSprite.height, true, 0);
            bitmapData.draw(tmpSprite, new Matrix(), tmpSprite.transform.colorTransform);
            currentBitmapCreated = true;

            if (tmpSprite.scale9Grid)
            {
                _scaleGridLeft = tmpSprite.scale9Grid.left;
                _scaleGridRight = tmpSprite.scale9Grid.right;
                _scaleGridTop = tmpSprite.scale9Grid.top;
                _scaleGridBottom = tmpSprite.scale9Grid.bottom;
            }
        }

        // Remove any previously hosted content prior to assigning
        // new bitmap data (if we haven't already previously).
        if (!_clearOnLoad)
            removePreviousContent();

        setBitmapData(bitmapData, currentBitmapCreated);
    } */
	
	
	/**
	 * @private
	 * Returns true if current Flash Player/Air supports image decoding policy.
	 */
	/* protected function hasImageDecodingPolicy(loaderContext:LoaderContext):Boolean {
		// true for one it's true for all
		if (!_haveCachedImageDecodePolicy) {
			_cachedImageDecodePolicy =  ("imageDecodingPolicy" in loaderContext);
			_haveCachedImageDecodePolicy = true;
		}
		
		return _cachedImageDecodePolicy;
	} */

    /**
     *  @private
     */
    /* mx_internal function loadExternal(source:Object):void
    {
        // Ensure we handle unicode characters properly.
        if (source is String)
        {
           var url:String = source as String;
           source = LoaderUtil.OSToPlayerURI(url, LoaderUtil.isLocal(url));
        }

        if (contentLoader)
        {
            // We defer our load request to the configured content loader.
            var contentRequest:ContentRequest = contentLoader.load(source, contentLoaderGrouping);

            if (contentRequest.complete)
            {
                // No need to attach listeners as we've received a fully complete
                // request result.
                contentComplete(contentRequest.content);
            }
            else
            {
                // Attach load-event listeners to our ContentRequest instance.
                loadingContent = contentRequest;
                attachLoadingListeners();
            }
        }
        else
        {
            var loader:Loader = new Loader();
            var loaderContext:LoaderContext = new LoaderContext();

			if (hasImageDecodingPolicy(loaderContext))
				loaderContext["imageDecodingPolicy"] = imageDecodingPolicy;
				
            // Attach load-event listeners to our LoaderInfo instance.
            loadingContent = loader.contentLoaderInfo;
            attachLoadingListeners();

            try
            {
                loaderContext.checkPolicyFile = true;
                var urlRequest:URLRequest = source is URLRequest ?
                    source as URLRequest : new URLRequest(source as String);
                loader.load(urlRequest, loaderContext);
            }
            catch (error:SecurityError)
            {
                handleSecurityError(error);
            }
        }
    } */

    /**
     *  @private
     */
    /* mx_internal function loadFromBytes(source:ByteArray):void
    {
        var loader:Loader = new Loader();
        var loaderContext:LoaderContext = new LoaderContext();
		
		if (hasImageDecodingPolicy(loaderContext))
			loaderContext["imageDecodingPolicy"] = imageDecodingPolicy;
		
        loadingContent = loader.contentLoaderInfo;
        attachLoadingListeners();

        try
        {
            loader.loadBytes(source as ByteArray, loaderContext);
        }
        catch (error:SecurityError)
        {
            handleSecurityError(error);
        }
    } */

    /**
     * @private
     * Utility function used for higher quality image scaling. Essentially we
     * simply step down our bitmap size by half resulting in a much higher result
     * though taking potentially multiple passes to accomplish.
     */
    /* protected static function resample(bitmapData:BitmapData, newWidth:uint,
                                       newHeight:uint):BitmapData
    {
        var finalScale:Number = Math.max(newWidth/bitmapData.width,
            newHeight/bitmapData.height);

        var finalData:BitmapData = bitmapData;

        if (finalScale > 1)
        {
            finalData = new BitmapData(bitmapData.width * finalScale,
                bitmapData.height * finalScale, true, 0);

            finalData.draw(bitmapData, new Matrix(finalScale, 0, 0,
                finalScale), null, null, null, true);

            return finalData;
        }

        var drop:Number = .5;
        var initialScale:Number = finalScale;

        while (initialScale/drop < 1)
            initialScale /= drop;

        var w:Number = Math.floor(bitmapData.width * initialScale);
        var h:Number = Math.floor(bitmapData.height * initialScale);
        var bd:BitmapData = new BitmapData(w, h, bitmapData.transparent, 0);

        bd.draw(finalData, new Matrix(initialScale, 0, 0, initialScale),
            null, null, null, true);
        finalData = bd;

        for (var scale:Number = initialScale * drop;
            Math.round(scale * 1000) >= Math.round(finalScale * 1000);
            scale *= drop)
        {
            w = Math.floor(bitmapData.width * scale);
            h = Math.floor(bitmapData.height * scale);
            bd = new BitmapData(w, h, bitmapData.transparent, 0);

            bd.draw(finalData, new Matrix(drop, 0, 0, drop), null, null, null, true);
            finalData.dispose();
            finalData = bd;
        }

        return finalData;
    } */

    /**
     * @private
     * Invoked upon completion of a load request.
     */
    /* protected function contentComplete(content:Object):void
    {
        if (content is LoaderInfo)
        {
            // Clear any previous bitmap data or loader instance.
            setBitmapData(null);
            removePreviousContent();

            var loaderInfo:LoaderInfo = content as LoaderInfo;

            if (loaderInfo.childAllowsParent)
            {
                // For trusted content we adopt the loaded BitmapData.
                var image:Bitmap = Bitmap(loaderInfo.content);
                setBitmapData(image.bitmapData);
            }
            else
            {
                // For untrusted content we must host the acquired Loader
                // instance directly as our DisplayObject.
                displayObjectSharingMode = DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT;
                invalidateDisplayObjectSharing();

                // Create a content holder to use as our display object.
                var contentHolder:Sprite = new Sprite();
                setDisplayObject(contentHolder);
                loadedContent = loaderInfo.loader;
                contentHolder.addChild(loadedContent);

                // Retain our source image width and height.
                imageWidth = loaderInfo.width;
                imageHeight = loaderInfo.height ;

                // Update
                if (!explicitHeight || !explicitWidth)
                    invalidateSize();
                invalidateDisplayList();

                // Denote that we are hosting an untrusted image and as such some
                // features requiring access to the bitmap data will no longer
                // function.
                _trustedSource = false;

                // Dispatch ready event
                dispatchEvent(new FlexEvent(FlexEvent.READY));
            }
        }
        else
        {
            if (content is BitmapData)
                setBitmapData(content as BitmapData);
        }
    } */

    /**
     * @private
     * Returns true if are to consider aspect ratio while scaling.
     */
    /* private function get maintainAspectRatio():Boolean
    {
        return (_scaleMode == BitmapScaleMode.LETTERBOX && _fillMode == BitmapFillMode.SCALE);
    } */

    /**
     * @private
     * Removes any previously loaded content prior to loading new.
     */
    /* private function removePreviousContent():void
    {
        if (loadedContent && loadedContent.parent)
        {
            displayObjectSharingMode = DisplayObjectSharingMode.USES_SHARED_OBJECT;
            invalidateDisplayObjectSharing();
            loadedContent.parent.removeChild(loadedContent);
            loadedContent = null;
            setDisplayObject(null);
            imageWidth = imageHeight = NaN;
        }
        else if (drawnDisplayObject)
        {
            Sprite(drawnDisplayObject).graphics.clear();
            clearBitmapData();
        }
    } */

    /**
     *  @private
     */
    /* private function clearLoadingContent():void
    {
        if (loadingContent is LoaderInfo && LoaderInfo(loadingContent).loader)
        {
            try
            {
                LoaderInfo(loadingContent).loader.close();
            }
            catch (e:Error)
            {
                // Ignore
            }
        }

        removeLoadingListeners();
        loadingContent = null;
    } */

    /**
     *  @private
     */
    /* private function clearBitmapData():void
    {
        if (_bitmapData)
        {
            // Dispose the bitmap if we created it
            if (bitmapDataCreated)
                _bitmapData.dispose();
            _bitmapData = null;
        }
    } */

    /**
     *  @private
     */
    /* private function attachLoadingListeners():void
    {
        if (loadingContent)
        {
            loadingContent.addEventListener(Event.COMPLETE,
                loader_completeHandler, false, 0, true);
            loadingContent.addEventListener(IOErrorEvent.IO_ERROR,
                loader_ioErrorHandler, false, 0, true);
            loadingContent.addEventListener(ProgressEvent.PROGRESS,
                loader_progressHandler, false, 0, true);
            loadingContent.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                loader_securityErrorHandler, false, 0, true);
            loadingContent.addEventListener(HTTPStatusEvent.HTTP_STATUS,
                dispatchEvent, false, 0, true);
        }
    } */

    /**
     *  @private
     */
    /* private function removeLoadingListeners():void
    {
        if (loadingContent)
        {
            loadingContent.removeEventListener(Event.COMPLETE,
                loader_completeHandler);
            loadingContent.removeEventListener(IOErrorEvent.IO_ERROR,
                loader_ioErrorHandler);
            loadingContent.removeEventListener(ProgressEvent.PROGRESS,
                loader_progressHandler);
            loadingContent.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
                loader_securityErrorHandler);
            loadingContent.removeEventListener(HTTPStatusEvent.HTTP_STATUS,
                dispatchEvent);
        }
    } */


    /**
     *  @private
     *  Utility method which is invoked to initiate loading of our
     *  source.
     */
    /* mx_internal function validateSource():void
    {
        if (sourceInvalid || contentLoaderInvalid)
        {
            applySource();
            sourceInvalid = false;
            contentLoaderInvalid = false;
        }
    } */

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
   /*  mx_internal function loader_completeHandler(event:Event):void
    {
        try
        {
            var loaderInfo:LoaderInfo = (event.target is ContentRequest) ?
                event.target.content as LoaderInfo : event.target as LoaderInfo;

            if (loaderInfo.bytesLoaded)
            {
                _bytesLoaded = _bytesTotal;
                contentComplete(loaderInfo);
            }
        }
        catch (error:SecurityError)
        {
            handleSecurityError(error);
        }

        dispatchEvent(event);

        // Remove any event listeners from load-event dispatcher.
        clearLoadingContent();
    } */

    /**
     *  @private
     */
    /* private function loader_ioErrorHandler(error:IOErrorEvent):void
    {
        // forward the event, only in the case of a listener, else
        // an RTE will occur.
        if (hasEventListener(error.type))
            dispatchEvent(error);

        // clear any current image and remove any event listeners from
        // load-event  dispatcher.
        setBitmapData(null);
        loadFailed = true;
    } */

    /**
     *  @private
     */
    /* private function loader_securityErrorHandler(error:SecurityErrorEvent):void
    {
        dispatchEvent(error);

        // clear any current image and remove any event listeners from
        // load-event  dispatcher.
        setBitmapData(null);
        loadFailed = true;
    } */

    /**
     *  @private
     */
    /* private function loader_progressHandler(progressEvent:ProgressEvent):void
    {
        _bytesLoaded = progressEvent.bytesLoaded;
        _bytesTotal = progressEvent.bytesTotal;

        // forward the event
        dispatchEvent(progressEvent);
    } */

    /**
     *  @private
     */
    /* private function handleSecurityError(error:SecurityError):void
    {
        dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,
            false, false, error.message));

        // clear any current image and remove any event listeners from
        // load-event  dispatcher.
        setBitmapData(null);
        loadFailed = true;
    } */

    /**
     *  @private
     *  Used for deferral of bitmap capture when an assigned source
     *  has yet to be added to the stage.
     */
    /* private function source_addedToStageHandler(event:Event):void
    {
        removeAddedToStageHandler(event.target);
        applySource();
    } */

    /**
     *  @private
     */
    /* private function removeAddedToStageHandler(target:Object):void
    {
        if (target && target is DisplayObject)
            target.removeEventListener(Event.ADDED_TO_STAGE, source_addedToStageHandler);
    } */
	//----------------------------------
    //  height copied from GraphicElement
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the height property.
     */
    /* mx_internal */ private var _height:Number = 0;

    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    [PercentProxy("percentHeight")]

    /**
     *  The height of the graphic element.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     *  @royalesuppresspublicvarwarning
	 */
    public function get height():Number
    {
        return _height;
    }

    /**
     *  @private
     */
    
    public function set height(value:Number):void
    {
       // explicitHeight = value;

        if (_height == value)
            return;

        var oldValue:Number = _height;
        _height = value;
       // dispatchPropertyChangeEvent("height", oldValue, value);

        // Invalidate the display list, since we're changing the actual height
        // and we're not going to correctly detect whether the layout sets
        // new actual height different from our previous value.
       // invalidateDisplayList();
    }
	//----------------------------------
    //  width copied from GraphicElement
    //----------------------------------

    /**
     *  @private
     *  Storage for the width property.
     */
     /* mx_internal */ private  var _width:Number = 0;

    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    [PercentProxy("percentWidth")]

    /**
     *  The width of the graphic element.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     *  @royalesuppresspublicvarwarning
	*/
    public function get width():Number
    {
        return _width;
    }

    /**
     *  @private
     */
    public function set width(value:Number):void
    {
       // explicitWidth = value;

        if (_width == value)
            return;

        var oldValue:Number = _width;
        _width = value;

        // The width is needed for the mirroring transform.
      /*   if (layoutFeatures)
        {
            layoutFeatures.layoutWidth = value;
            invalidateTransform();
        }        

        dispatchPropertyChangeEvent("width", oldValue, value);

        // Invalidate the display list, since we're changing the actual width
        // and we're not going to correctly detect whether the layout sets
        // new actual width different from our previous value.
        invalidateDisplayList(); */
    }
}
}
