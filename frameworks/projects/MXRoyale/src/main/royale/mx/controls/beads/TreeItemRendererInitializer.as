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
package mx.controls.beads
{	
    
	import org.apache.royale.collections.ITreeData;
    import org.apache.royale.core.Bead;
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IIndexedItemRenderer;
    import org.apache.royale.core.IIndexedItemRendererInitializer;
    import org.apache.royale.core.IItemRenderer;
    import org.apache.royale.core.IListDataItemRenderer;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.SimpleCSSStyles;
    import org.apache.royale.core.UIBase;
    import mx.controls.treeClasses.TreeListData;
    
	/**
	 *  The TreeItemRendererInitializer class initializes item renderers
     *  in tree classes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TreeItemRendererInitializer extends ListItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function TreeItemRendererInitializer()
		{
		}
				
		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 */
		override public function initializeIndexedItemRenderer(ir:IIndexedItemRenderer, data:Object, index:int):void
		{
            if (!dataProviderModel)
                return;
            
            super.initializeItemRenderer(ir, data, index);
            
            var treeData:ITreeData = dataProviderModel.dataProvider as ITreeData;
            var depth:int = treeData.getDepth(data);
            var isOpen:Boolean = treeData.isOpen(data);
            var hasChildren:Boolean = treeData.hasChildren(data);
            
            // Set the listData with the depth of this item
            var treeListData:TreeListData = new TreeListData();
            treeListData.depth = depth;
            treeListData.isOpen = isOpen;
            treeListData.hasChildren = hasChildren;
            treeListData.owner = _strand;
            
            (ir as IListDataItemRenderer).listData = treeListData;
            
        }
        
	}
}
