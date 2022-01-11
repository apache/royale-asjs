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
     *  This class is used to link additional classes into externsjs.swc
     *  beyond those that are found by dependecy analysis starting
     *  from the classes specified in manifest.xml.
     */
    internal class ExternsJSClasses
    {
        COMPILE::JS
		{
			import org.apache.royale.externsjs.inspiretree.InspireTree; InspireTree;
			import org.apache.royale.externsjs.inspiretree.InspireTreeDOM; InspireTreeDOM;
	        import org.apache.royale.externsjs.inspiretree.TreeNode; TreeNode;
			import org.apache.royale.externsjs.inspiretree.TreeNodes; TreeNodes;
			
			import org.apache.royale.externsjs.inspiretree.beads.InspireTreeCheckBoxModeBead; InspireTreeCheckBoxModeBead;
			import org.apache.royale.externsjs.inspiretree.beads.InspireTreeEventsBead; InspireTreeEventsBead;
			import org.apache.royale.externsjs.inspiretree.beads.InspireTreeIconBead; InspireTreeIconBead;
			import org.apache.royale.externsjs.inspiretree.beads.InspireTreePaginateBead; InspireTreePaginateBead;
			import org.apache.royale.externsjs.inspiretree.beads.InspireTreeReadOnlyCheckBead; InspireTreeReadOnlyCheckBead;
			import org.apache.royale.externsjs.inspiretree.beads.InspireTreeReadOnlyCheckBead_V0; InspireTreeReadOnlyCheckBead_V0;
			import org.apache.royale.externsjs.inspiretree.beads.InspireTreeRevertCheckBead; InspireTreeRevertCheckBead;
			
			import org.apache.royale.externsjs.inspiretree.beads.models.InspireTreeModel; InspireTreeModel;
			
			import org.apache.royale.externsjs.inspiretree.InspireTreeBasicControl; InspireTreeBasicControl;			
			import org.apache.royale.externsjs.inspiretree.vos.ItemTreeNode; ItemTreeNode;
			import org.apache.royale.externsjs.inspiretree.vos.ConfigDOM; ConfigDOM;
			import org.apache.royale.externsjs.inspiretree.vos.OptionsTree; OptionsTree;
		}		
    }
}
