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
package org.apache.royale.externsjs.inspiretree.vos
{
   
   //import org.apache.royale.externsjs.inspiretree.DragAndDropConfig;

    public class ConfigDOM
    {
        public function ConfigDOM(){}

        /**
         * An Element, selector, or jQuery object.
         */
        public var target:HTMLElement;
         /**
         * DragAndDropConfig {
         *      enabled - Enable drag and drop support. Default: false
         *      validateOn - Use dragstart or dragover to determine when "target" nodes are validated. Default: dragstart.
         *      validate - (TreeNode dragNode, TreeNode targetNode) - Custom target node validation.
         * }
         */
        public var dragAndDrop:Boolean;        
        /**
         * Automatically triggers "Load More" links on scroll. Used with deferrals.
         */
        public var autoLoadMore:Boolean;
        /**
         * Only render nodes as the user clicks to display more.
         */
        public var deferredRendering:Boolean;
        /**
         * Height (in pixels) of your nodes. Used with deferrals, if pagination.limit not provided.
         */
        public var nodeHeight:Number;
        /**
         * Show checkbox inputs.
         */
        public var showCheckboxes:Boolean;
       
        public var dragTargets:Array;
        /**
         * Define a tab index for the tree container (used for key nav).
         */
        public var tabindex:Number;
    }

}