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

package mx.controls.treeClasses
{


import mx.controls.Image;
import mx.controls.Tree;

import org.apache.royale.core.ISelectionModel;

/**
 *  The TreeIconItemRenderer class defines an item renderer for a Tree control that supports the Tree.iconFunction.
 *  By default, the item renderer draws the text associated with each item in the tree, 
 *  an optional icon, and an optional disclosure icon.
 *
 *  <p>You can override the default item renderer by creating a custom item renderer.</p>
 *
 *  @see mx.controls.Tree
 *  @see mx.core.IDataRenderer
 *  @see mx.controls.listClasses.IDropInListItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TreeIconItemRenderer extends TreeItemRenderer
{

    private static var _DEFAULT_LEAF:String = 'Assets/flex_assets/Tree_defaultLeafIcon.svg';
    public static function get DEFAULT_LEAF():String{
        return _DEFAULT_LEAF;
    }
    public static function set DEFAULT_LEAF(value:String):void{
        _DEFAULT_LEAF = value;
    }

    private static var _DEFAULT_FOLDER_OPEN:String = 'Assets/flex_assets/Tree_folderOpenIcon.svg';
    public static function get DEFAULT_FOLDER_OPEN():String{
        return _DEFAULT_FOLDER_OPEN;
    }
    public static function set DEFAULT_FOLDER_OPEN(value:String):void{
        _DEFAULT_FOLDER_OPEN = value;
    }


    private static var _DEFAULT_FOLDER_CLOSED:String = 'Assets/flex_assets/Tree_folderClosedIcon.svg';
    public static function get DEFAULT_FOLDER_CLOSED():String{
        return _DEFAULT_FOLDER_CLOSED;
    }
    public static function set DEFAULT_FOLDER_CLOSED(value:String):void{
        _DEFAULT_FOLDER_CLOSED = value;
    }
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
    public function TreeIconItemRenderer()
    {
        super();
    }

    /**
     * override to specify a fixed icon width, otherwise the icon width defaults to the renderer height
     * @return
     */
    public function getIconWidth():uint{
        return 0;
    }
    /**
     * override to specify a fixed icon height, otherwise the icon height defaults to the renderer height
     * @return
     */
    public function getIconHeight():uint{
        return 0;
    }

    override protected function createChildren():void
    {
        super.createChildren();
        if (!icon)
        {
            var img:mx.controls.Image = new mx.controls.Image();
            img.setStyle("verticalAlign", "middle" );
            this.icon = img;
            var fixedDimension:uint  = getIconWidth();
            if (fixedDimension) img.width = fixedDimension;
            fixedDimension = getIconHeight();
            if (fixedDimension) img.height = fixedDimension;
            addChild(img);
        }
    }
   
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    protected var updateSizeInBase:Boolean=true;

    /**
     *
     * @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    override public function set data(value:Object):void
    {
        super.data = value;
        var tree:Tree = listData.owner as Tree;
        if (tree) {
            if (tree.iconFunction) {
                var iconSource:Object = tree.iconFunction(value);
            } else {
                /*if (tree.iconField) {
                    //@todo...
                 }*/
                var model:ISelectionModel = tree.model as ISelectionModel;
                var hcv:HierarchicalCollectionView = model.dataProvider as HierarchicalCollectionView
                if (hcv){
                    if (hcv.isBranch(value)) {
                        iconSource = hcv.isOpen(value) ? DEFAULT_FOLDER_OPEN : DEFAULT_FOLDER_CLOSED;
                    } else {
                        iconSource = DEFAULT_LEAF;
                    }
                }
            }
            if (iconSource) {
                icon.visible=true;
            } else {
                icon.visible=false;
            }
            mx.controls.Image(icon).source = iconSource;
            if(updateSizeInBase && width && height) adjustSize();
        } else {
            icon.visible=false;
        }

    }


    


    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth,unscaledHeight)
        icon.x = disclosureIcon.width + hGap;
        var iconW:uint = getIconWidth();
        var iconH:uint = getIconHeight();
        if (!iconH) iconH = unscaledHeight;
        if (!iconW) iconW = iconH;

        icon.width = iconW;
        icon.height = iconH;
        icon.y = Math.max(0,(unscaledHeight-iconH)*.5);
        if (icon.visible) {
            label.x = icon.x + icon.width + hGap;
        } else {
            label.x = icon.x + hGap;
        }
        label.width = unscaledWidth - label.x;

    }


    
}

}
