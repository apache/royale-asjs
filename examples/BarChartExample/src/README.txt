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

This example demonstrates how to construct a BarChart and a PieChart. The BarChart
is composed of two series while the PieChart has one (and only one) series.

At this time, PieChart supports only one series, but BarChart can support several. 

PieChart uses SVG on the HTML/JavaScript side to draw the wedges. This is still
a "to do" item for BarChart, but it should be done. Further charts can follow
the same pattern.

PieChart uses a special ChartDataGroup (since all charts, so far, are based on
List) that provides an SVG element on the JavaScript side. BarChart can make use
of the same construct and have BoxItemRenderer create an SVG <rect> element.
