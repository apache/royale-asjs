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

package mx.controls.listClasses
{

//import flash.display.DisplayObject;
import mx.display.Graphics;
//import flash.display.Shape;
//import flash.display.Sprite;
import org.apache.royale.events.Event;
import mx.events.KeyboardEvent;
import org.apache.royale.geom.Point;
import mx.core.Keyboard;
//import flash.utils.Dictionary;
import org.apache.royale.utils.ObjectMap;
//import flash.utils.setInterval;

import mx.collections.CursorBookmark;
//import mx.collections.ItemResponder;
//import mx.collections.ItemWrapper;
//import mx.collections.ModifiedCollectionView;
import mx.collections.errors.ItemPendingError;
//import mx.controls.scrollClasses.ScrollBar;
import mx.core.ClassFactory;
import mx.core.EdgeMetrics;
//import mx.core.FlexShape;
//import mx.core.FlexSprite;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.ScrollEvent;
//import mx.events.ScrollEventDetail;
//import mx.events.ScrollEventDirection;
//import mx.skins.halo.ListDropIndicator;

use namespace mx_internal;

/**
 *  The TileBase class is the base class for controls
 *  that display data items in a sequence of rows and columns.
 *  TileBase-derived classes ignore the <code>variableRowHeight</code>
 *  and <code>wordWrap</code> properties inherited from their parent class.
 *  All items in a TileList are the same width and height.
 *
 *  <p>This class is not used directly in applications.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TileBase extends ListBase
{
    //include "../../core/Version.as";

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
    public function TileBase()
    {
        super();

        itemRenderer = new ClassFactory(TileListItemRenderer);

        // Set default sizes.
        //setRowHeight(50);
        //setColumnWidth(50);
    }
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  direction
    //----------------------------------

    /**
     *  @private
     *  Storage for direction property.
     */
    private var _direction:String = TileBaseDirection.HORIZONTAL;

    [Bindable("directionChanged")]
    [Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="horizontal")]

    /**
     *  The direction in which this control lays out its children.
     *  Possible values are <code>TileBaseDirection.HORIZONTAL</code>
     *  and <code>TileBaseDirection.VERTICAL</code>.
     *  The default value is <code>TileBaseDirection.HORIZONTAL</code>.
     *
     *  <p>If the value is <code>TileBaseDirection.HORIZONTAL</code>, the tiles are
     *  laid out along the first row until the number of visible columns or maxColumns
     *  is reached and then a new row is started.  If more rows are created
     *  than can be displayed at once, the control will display a vertical scrollbar.
     *  The opposite is true if the value is <code>TileBaseDirection.VERTICAL</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get direction():String
    {
        return _direction;
    }

    /**
     *  @private
     */
    public function set direction(value:String):void
    {
        _direction = value;

      /*  itemsSizeChanged = true;
        offscreenExtraRowsOrColumnsChanged = true;

        if (listContent)
        {           
            if (direction == TileBaseDirection.HORIZONTAL)
            {
                listContent.leftOffset = listContent.rightOffset = 0;
                offscreenExtraColumnsLeft = offscreenExtraColumnsRight = 0;
            }
            else
            {
                listContent.topOffset = listContent.bottomOffset = 0;
                offscreenExtraRowsTop = offscreenExtraRowsBottom = 0;
            }
        }
        invalidateProperties();

        invalidateSize();
        invalidateDisplayList();  */

        dispatchEvent(new Event("directionChanged")); 
    }
	

}

}
