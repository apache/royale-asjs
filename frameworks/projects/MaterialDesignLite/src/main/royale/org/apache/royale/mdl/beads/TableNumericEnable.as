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
package org.apache.royale.mdl.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.mdl.TableCell;
    import org.apache.royale.mdl.TableColumn;

    /**
     *  TableNumericEnable bead applies numeric formatting to header (TableColumn) or data cell (TableCell)
     *  It removes class "mdl-data-table__cell--non-numeric" from strand (content of column will be align to the right)
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    public class TableNumericEnable implements IBead
    {
        private var _strand:IStrand;
        private var host:UIBase;

        /**
         * @copy org.apache.royale.core.IBead#strand
         *
         * @royaleignorecoercion HTMLElement
         *
         * @param value
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            host = _strand as UIBase;

            COMPILE::JS
            {
                if (isTableHostValid())
                {
                    var element:HTMLElement = host.element as HTMLElement;
                    element.classList.remove("mdl-data-table__cell--non-numeric");
                }
                else
                {
                    throw new Error("Host component must be an MDL TableColumn or TableCell.");
                }
            }
        }

        private function isTableHostValid():Boolean
        {
            return host is TableCell || host is TableColumn;
        }
    }
}
