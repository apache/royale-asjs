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

package mx.core
{

import org.apache.royale.events.Event;
//import flash.display.DisplayObject;
//import flash.events.ErrorEvent;
//import flash.events.Event;
//import flash.external.ExternalInterface;
//import flash.net.URLRequest;
//import flash.net.navigateToURL;
//import flash.system.Capabilities;
//import flash.utils.describeType;
//import flash.utils.setInterval;
//import mx.containers.BoxDirection;
//import mx.containers.utilityClasses.BoxLayout;
//import mx.containers.utilityClasses.CanvasLayout;
//import mx.containers.utilityClasses.ConstraintColumn;
//import mx.containers.utilityClasses.ConstraintRow;
//import mx.containers.utilityClasses.IConstraintLayout;
//import mx.containers.utilityClasses.Layout;
//import mx.effects.EffectManager;
//import mx.events.FlexEvent;
//import mx.managers.ISystemManager;
//import mx.managers.LayoutManager;
//import mx.managers.SystemManager;
//import mx.styles.CSSStyleDeclaration;
//import mx.styles.IStyleClient;

//use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

//include "../styles/metadata/AlignStyles.as";
//include "../styles/metadata/GapStyles.as";

/**
 *  Number of pixels between the bottom border
 *  and its content area.  
 *
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the top border
 *  and its content area. 
 *
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------
/*
[Exclude(name="direction", kind="property")]
[Exclude(name="icon", kind="property")]
[Exclude(name="label", kind="property")]
[Exclude(name="tabIndex", kind="property")]
[Exclude(name="toolTip", kind="property")]
[Exclude(name="x", kind="property")]
[Exclude(name="y", kind="property")]
*/
//--------------------------------------
//  Other metadata
//--------------------------------------

/**
 *  Flex defines a default, or Application, container that lets you start
 *  adding content to your module or Application without explicitly defining
 *  another container.
 *  Flex creates this container from the <code>&lt;mx:Application&gt;</code>
 *  tag, the first tag in an MXML application file, or from the
 *  <code>&lt;mx:Module&gt;</code> tag, the first tag in an MXML module file.
 *  While you might find it convenient to use the Application or Module container
 *  as the only  container in your application, in most cases you explicitly
 *  define at least one more container before you add any controls
 *  to your application or module.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Application&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Application
 *    <strong>Properties</strong>
 *    layout="vertical|horizontal|absolute"
 *    xmlns:<i>No default</i>="<i>No default</i>"
 * 
 *    <strong>Styles</strong> 
 *    horizontalAlign="center|left|right"
 *    horizontalGap="8"
 *    paddingBottom="0"
 *    paddingTop="0"
 *    verticalAlign="top|bottom|middle"
 *    verticalGap="6"
 *  
 *  /&gt;
 *  </pre>
 *
 *  @see flash.events.EventDispatcher
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LayoutContainer extends Container
// implements IConstraintLayout
{
   // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private    
     */
   // mx_internal static var useProgressiveLayout:Boolean = false;

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
    public function LayoutContainer()
    {
        super();

       // layoutObject.target = this;
        
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  The mx.containers.utilityClasses.Layout subclass that is doing the layout
     */
   // protected var layoutObject:Layout = new BoxLayout();

    /**
     *  The mx.containers.utilityClasses.Layout subclass that is doing the layout
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
   // protected var canvasLayoutClass:Class = CanvasLayout;

    /**
     *  The mx.containers.utilityClasses.Layout subclass that is doing the layout
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
   // protected var boxLayoutClass:Class = BoxLayout;

    /**
     *  @private
     */
   // private var resizeHandlerAdded:Boolean = false;

    /**
     *  @private
     *  Placeholder for Preloader object reference.
     */
   // private var preloadObj:Object;

    /**
     *  @private
     *  Used in progressive layout.
     */
    private var creationQueue:Array = [];

    /**
     *  @private
     *  Used in progressive layout.
     */
    private var processingCreationQueue:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  constraintColumns
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the constraintColumns property.
     */
   // private var _constraintColumns:Array = [];

   // [ArrayElementType("mx.containers.utilityClasses.ConstraintColumn")]
   // [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintColumn")]
     
    /**
     *  @private
     *  Storage for the constraintRows property.
     */
   // private var _constraintRows:Array = [];
 
   // [ArrayElementType("mx.containers.utilityClasses.ConstraintRow")]
   // [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintRow")]
       
     
    //----------------------------------
    //  layout
    //----------------------------------

    /**
     *  @private
     *  Storage for layout property.
     */
   // private var _layout:String = ContainerLayout.VERTICAL;

   // [Bindable("layoutChanged")]
   // [Inspectable(category="General", enumeration="vertical,horizontal,absolute", defaultValue="vertical")]

     
}

}
