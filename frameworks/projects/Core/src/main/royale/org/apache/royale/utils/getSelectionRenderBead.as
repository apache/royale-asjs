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
package org.apache.royale.utils
{
  import org.apache.royale.core.IItemRenderer;
  import org.apache.royale.core.ISelectableItemRenderer;

  /**
   * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
   */
  public function getSelectionRenderBead(renderer:IItemRenderer):ISelectableItemRenderer
  {
    COMPILE::JS
    {
      var selectionBead:ISelectableItemRenderer = renderer["_selectionBead_"];
      if(!selectionBead)
      {
        selectionBead = renderer.getBeadByType(ISelectableItemRenderer) as ISelectableItemRenderer;
        if(selectionBead)
          renderer["_selectionBead_"] = selectionBead;
      }
      return selectionBead;
    }

    COMPILE::SWF
    {
      return renderer.getBeadByType(ISelectableItemRenderer) as ISelectableItemRenderer;
    }
  }
}