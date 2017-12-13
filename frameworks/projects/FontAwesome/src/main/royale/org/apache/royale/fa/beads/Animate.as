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
package org.apache.royale.fa.beads {
import org.apache.royale.core.IBead;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.UIBase;

public class Animate implements IBead {
    /**
     *  constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function Animate() {
    }

    private var _strand:IStrand;
    private var _hostElement:Object;
    private var _spin:Boolean = true;
    private var _pulse:Boolean = false;

    /**
     *  Rotate the icon
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get spin():Boolean
    {
        return _spin;
    }

    public function set spin(value:Boolean):void
    {
        _spin = value;
        if(this._hostElement) {
            _hostElement.classList.toggle('fa-spin', _spin);
        }
    }
    /**
     *  Pulse the icon, i.e. rotate with 8 steps
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get pulse():Boolean
    {
        return _pulse;
    }

    public function set pulse(value:Boolean):void
    {
        _pulse = value;
        if(this._hostElement) {
            _hostElement.classList.toggle('fa-pulse',_pulse);
        }
    }

    /**
     * @royaleignorecoercion HTMLElement
     *
     * @param value
     */
    public function set strand(value:IStrand):void
    {
        _strand = value;

        COMPILE::JS
        {
            var host:UIBase = value as UIBase;
            _hostElement = host.element;
            _hostElement.classList.toggle('fa-spin',_spin);
            _hostElement.classList.toggle('fa-pulse',_pulse);
        }
    }

}
}
