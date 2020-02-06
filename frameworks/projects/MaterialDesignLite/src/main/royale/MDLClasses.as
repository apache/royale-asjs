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
package
{

	/**
	*  @private
	*  This class is used to link additional classes into mdl.swc
	*  beyond those that are found by dependecy analysis starting
	*  from the classes specified in manifest.xml.
	*/
	internal class MDLClasses
	{
		import org.apache.royale.mdl.beads.TabsItemRendererFactoryForArrayData; TabsItemRendererFactoryForArrayData;
        import org.apache.royale.mdl.beads.TabsItemRendererInitializer; TabsItemRendererInitializer;
        import org.apache.royale.mdl.beads.TabsDataItemRendererFactoryForArrayListData; TabsDataItemRendererFactoryForArrayListData;
		import org.apache.royale.mdl.beads.models.TabArrayModel; TabArrayModel;
		import org.apache.royale.mdl.beads.models.TabArrayListModel; TabArrayListModel;
		import org.apache.royale.mdl.beads.models.ToastModel; ToastModel;
		import org.apache.royale.mdl.beads.models.SnackbarModel; SnackbarModel;
		import org.apache.royale.mdl.beads.models.SliderRangeModel; SliderRangeModel;
		import org.apache.royale.mdl.beads.models.DropDownListModel; DropDownListModel;
		import org.apache.royale.mdl.materialIcons.MaterialIconType; MaterialIconType;
		import org.apache.royale.mdl.beads.UpgradeElement; UpgradeElement;
		import org.apache.royale.mdl.beads.UpgradeChildren; UpgradeChildren;
		import org.apache.royale.mdl.beads.controllers.DropDownListController; DropDownListController;

		COMPILE::JS
		{
			import org.apache.royale.mdl.utils.getMdlContainerParent; getMdlContainerParent;
		}
		COMPILE::SWF
		{
			import org.apache.royale.mdl.beads.views.SliderThumbView; org.apache.royale.mdl.beads.views.SliderThumbView;
			import org.apache.royale.mdl.beads.views.SliderTrackView; org.apache.royale.mdl.beads.views.SliderTrackView;
		}
	}

}

