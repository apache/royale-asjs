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

package mx.modules
{
import mx.core.Container;
//import mx.core.LayoutContainer;

//[Frame(factoryClass="mx.core.FlexModuleFactory")]

//[Alternative(replacement="spark.modules.Module", since="4.5")]

/**
 *  The base class for MXML-based dynamically-loadable modules. You extend this
 *  class in MXML by using the <code>&lt;mx:Module&gt;</code> tag in an MXML file, as the
 *  following example shows:
 *  
 *  <pre>
 *  &lt;?xml version="1.0"?&gt;
 *  &lt;!-- This module loads an image. --&gt;
 *  &lt;mx:Module  width="100%" height="100%" xmlns:mx="http://www.adobe.com/2006/mxml"&gt;
 *  
 *    &lt;mx:Image source="trinity.gif"/&gt;
 *  
 *  &lt;/mx:Module&gt;
 *  </pre>
 *  
 *  <p>Extending the Module class in ActionScript is the same as using the <code>&lt;mx:Module&gt;</code> tag
 *  in an MXML file. You extend this class if your module interacts with the framework. 
 *  To see an example of an ActionScript class that extends the Module class, create an MXML 
 *  file with the root tag of <code>&lt;mx:Module&gt;</code>. When you compile this file, 
 *  set the value of the <code>keep-generated-actionscript</code> compiler option to <code>true</code>.
 *  The Flex compiler stores the generated ActionScript class in a directory called generated, which
 *  you can look at.</p>
 *  
 *  <p>If your module does not include any framework code, you can create a class that extends 
 *  the ModuleBase class. If you use the ModuleBase class, your module will typically be smaller than 
 *  if you create a module that is based on the Module class because it does not have any framework 
 *  class dependencies.</p>
 *  
 *  @see mx.modules.ModuleBase
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *    cornerRadius="0"
 *    fontWeight="normal"
 *    paddingLeft="0"
 *    verticalAlign="top|bottom|middle"
 *    verticalScrollPolicy="auto|on|off"
 */
public class Module extends Container implements IModule //extends LayoutContainer 
{
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function Module()
    {
        super();
    }
	
    /**
     * These APIs keep properties in ROYALE_CLASS_INFO from being minified.
     * When a module is being loaded, both the loading .js file and the loaded
     * .js file need to have an agreement on which plain object field names
     * can be minified.  If you run into other issues with plain object renaming
     * you can add your own getters.
     */
    private static function get interfaces():Boolean
    {
        return true;
    }
    private static function get qName():Boolean
    {
        return true;
    }
    
    
    //----------------------------------
    //  layout
    //----------------------------------

    /**
     *  @private
     *  Storage for layout property.
     */
    private var _layout:String = ""; //ContainerLayout.VERTICAL;

    [Bindable("layoutChanged")]
    [Inspectable(category="General", enumeration="vertical,horizontal,absolute", defaultValue="vertical")]

    /**
     *  Specifies the layout mechanism used for this application. 
     *  Applications can use <code>"vertical"</code>, <code>"horizontal"</code>, 
     *  or <code>"absolute"</code> positioning. 
     *  Vertical positioning lays out each child component vertically from
     *  the top of the application to the bottom in the specified order.
     *  Horizontal positioning lays out each child component horizontally
     *  from the left of the application to the right in the specified order.
     *  Absolute positioning does no automatic layout and requires you to
     *  explicitly define the location of each child component. 
     *
     *  @default "vertical"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get layout():String
    {
        return _layout;
    }

    /**
     *  @private
     */
    public function set layout(value:String):void
    {
        if (_layout != value)
        {
            _layout = value;
			/*
            if (layoutObject)
                // Set target to null for cleanup.
                layoutObject.target = null;

            if (_layout == ContainerLayout.ABSOLUTE)
                layoutObject = new canvasLayoutClass();
            else
            {
                layoutObject = new boxLayoutClass();

                if (_layout == ContainerLayout.VERTICAL)
                {
                    BoxLayout(layoutObject).direction =
                        BoxDirection.VERTICAL;
                }
                else
                {
                    BoxLayout(layoutObject).direction =
                        BoxDirection.HORIZONTAL;
                }
            }

            if (layoutObject)
                layoutObject.target = this;

            invalidateSize();
            invalidateDisplayList();

            dispatchEvent(new Event("layoutChanged"));*/
        }
    }
    
    COMPILE::JS
    public function _keepcode(obj:Object):Object
    {
        // Google Closure will remove code from a module that
        // it doesn't see anybody use in the module.  But if
        // there is stuff in the module the loading app uses
        // we need to add it here in a way that Closure will
        // think it is used.  Exported/public variables should
        // be ok, but non-exported stuff needs to be used.
        if (obj.cssData)
            return obj.cssData;
        
        return obj.ROYALE_CLASS_INFO;
    }

}

}
