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
package org.apache.royale.svg.elements
{
  COMPILE::JS
  {
    import org.apache.royale.html.util.addSvgElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
  }
  COMPILE::SWF
  public class Line{
    public function Line(){}
  }
  
  COMPILE::JS
  public class Line extends SVGBase
  {
    public function Line()
    {
      super();
    }
    override protected function createElement():WrappedHTMLElement{
      return addSvgElementToWrapper(this, 'line');
    }

    public function get x1():*{
      return element.getAttribute("x1");
    }
    public function set x1(value:*):void{
      element.setAttribute("x1",value);
    }
    public function get x2():*{
      return element.getAttribute("x2");
    }
    public function set x2(value:*):void{
      element.setAttribute("x2",value);
    }
    public function get y1():*{
      return element.getAttribute("y1");
    }
    public function set y1(value:*):void{
      element.setAttribute("y1",value);
    }
    public function get y2():*{
      return element.getAttribute("y2");
    }
    public function set y2(value:*):void{
      element.setAttribute("y2",value);
    }
  }
}