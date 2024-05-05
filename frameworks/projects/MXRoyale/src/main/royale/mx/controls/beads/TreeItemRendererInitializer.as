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

	import mx.controls.listClasses.BaseListData;

	//import org.apache.royale.collections.ITreeData;
    import mx.controls.treeClasses.TreeListData;
    import mx.controls.listClasses.ListBase;

	import org.apache.royale.core.IBeadController;
import org.apache.royale.core.IIndexedItemRenderer;

	import mx.controls.treeClasses.ITreeData

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


		override protected function getDefaultController():IBeadController{
			return new TreeItemRendererMouseController();
		}

		/**
		 *
		 *  @royaleignorecoercion org.apache.royale.collections.ITreeData
		 *
		 */
		override protected function makeListData(data:Object, uid:String,
												 rowNum:int):BaseListData
		{
			var treeData:ITreeData = dataProviderModel.dataProvider as ITreeData;
			var depth:int = treeData.getDepth(data);
			var isOpen:Boolean = treeData.isOpen(data);
			var hasChildren:Boolean = treeData.isBranch(data);// treeData.hasChildren(data);

			// Set the listData with the depth of this item
			var treeListData:TreeListData = new TreeListData("", uid, _strand as ListBase);
			treeListData.depth = depth;
			treeListData.isOpen = isOpen;
			treeListData.hasChildren = hasChildren;
			treeListData.item = data;
			
			return treeListData;

		}


		override protected function adjustItemRendererForMX(ir:IIndexedItemRenderer):void{
			//JS: do nothing, we want to keep isAbsolute = true for this component, so avoid the setting for 'relative' in the super
		}
        
	}
}
