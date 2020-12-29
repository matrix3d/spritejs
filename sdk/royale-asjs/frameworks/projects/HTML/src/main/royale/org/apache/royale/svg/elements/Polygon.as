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
  public class Polygon{
    public function Polygon(){}
  }
  
  COMPILE::JS
  public class Polygon extends SVGBase
  {
    public function Polygon()
    {
      super();
    }
    override protected function createElement():WrappedHTMLElement{
      return addSvgElementToWrapper(this, 'polygon');
    }
    public function get points():String{
    	return element.getAttribute("points");
    }
    public function set points(value:String):void{
    	element.setAttribute("points",value);
    }
  }
}