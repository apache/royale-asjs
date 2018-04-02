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
COMPILE::JS
{
	import goog.DEBUG;
}
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
 *  @productversion Flex 3
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
 *  @productversion Flex 3
 */
public class Image extends UIComponent
                   implements IImage
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
     *  @productversion Flex 3
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


    [Bindable("sourceChanged")]
    [Inspectable(category="General", defaultValue="", format="File")]

    /**
     *  @private
     */
    public function set source(value:Object):void
    {
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
		(model as IImageModel).url = value;
	}
	
	public function get src():String
	{
		return (model as IImageModel).url;
	}

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	COMPILE::JS
	public function get imageElement():Element
	{
		return element;
	}
	
	COMPILE::JS
	public function applyImageData(binaryDataAsString:String):void
	{
		element.addEventListener("load", handleImageLoaded);
		(element as HTMLImageElement).src = binaryDataAsString;
	}
	
	COMPILE::JS
	public function get complete():Boolean
	{
		return (element as HTMLImageElement).complete;
	}
	
	COMPILE::JS
	private function handleImageLoaded(event:BrowserEvent):void
	{
		trace("The image src "+src+" is now loaded");
		
		trace("Image offset size is: "+(element as HTMLImageElement).naturalWidth+" x "+(element as HTMLImageElement).naturalHeight);
		// should we now set the image's measured sizes?
		measuredWidth = (element as HTMLImageElement).naturalWidth;
		measuredHeight = (element as HTMLImageElement).naturalHeight;
		setActualSize(measuredWidth, measuredHeight);
		
		dispatchEvent(new Event("complete"));
		
		var newEvent:Event = new Event("layoutNeeded",true);
		dispatchEvent(newEvent);
	}


    //--------------------------------------------------------------------------
    //
    //  Inherited methods: UIComponent
    //
    //--------------------------------------------------------------------------

	/**
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 */
	COMPILE::JS
	override protected function createElement():WrappedHTMLElement
	{
		addElementToWrapper(this,'img');
		typeNames = 'Image';
		return element;
	}


}

}
