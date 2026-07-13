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
package flexUnitTests
{
    import org.apache.royale.core.UIBase;
    import org.apache.royale.geom.Point;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.test.asserts.*;
    import org.apache.royale.utils.DisplayUtils;
    import org.apache.royale.utils.PointUtils;

    public class PointUtilsTest
    {
        private var target:UIBase;

        COMPILE::JS
        private var fixture:HTMLElement;

        COMPILE::JS
        private var originalScrollX:Number;

        COMPILE::JS
        private var originalScrollY:Number;

        [Before]
        public function setUp():void
        {
            COMPILE::JS
            {
                originalScrollX = window.pageXOffset;
                originalScrollY = window.pageYOffset;
                window.scrollTo(0, 0);

                fixture = document.createElement("div") as HTMLElement;
                fixture.style.position = "absolute";
                fixture.style.left = "600px";
                fixture.style.top = "600px";
                fixture.style.width = "3000px";
                fixture.style.height = "3000px";
                document.body.appendChild(fixture);

                target = new UIBase();
                target.element.style.position = "absolute";
                target.element.style.left = "25px";
                target.element.style.top = "40px";
                target.element.style.width = "100px";
                target.element.style.height = "80px";
                fixture.appendChild(target.element);
            }
        }

        [After]
        public function tearDown():void
        {
            COMPILE::JS
            {
                window.scrollTo(originalScrollX, originalScrollY);
                document.body.removeChild(fixture);
                fixture = null;
                target = null;
            }
        }

        [Test]
        public function testLocalToViewportAfterDocumentScroll():void
        {
            COMPILE::JS
            {
                window.scrollTo(200, 300);
                var rect:Object = target.element.getBoundingClientRect();
                var result:Point = PointUtils.localToViewport(new Point(10, 15), target);

                assertNear(rect.left + 10, result.x, "Incorrect viewport x");
                assertNear(rect.top + 15, result.y, "Incorrect viewport y");
            }
        }

        [Test]
        public function testViewportToLocalAfterDocumentScroll():void
        {
            COMPILE::JS
            {
                window.scrollTo(200, 300);
                var rect:Object = target.element.getBoundingClientRect();
                var result:Point = PointUtils.viewportToLocal(new Point(rect.left + 10, rect.top + 15), target);

                assertNear(10, result.x, "Incorrect local x");
                assertNear(15, result.y, "Incorrect local y");
            }
        }

        [Test]
        public function testViewportConversionsAccountForBorderAndElementScroll():void
        {
            COMPILE::JS
            {
                target.element.style.border = "5px solid transparent";
                target.element.style.overflow = "scroll";
                var content:HTMLElement = document.createElement("div") as HTMLElement;
                content.style.width = "300px";
                content.style.height = "300px";
                target.element.appendChild(content);
                target.element.scrollLeft = 20;
                target.element.scrollTop = 30;

                var localPoint:Point = new Point(75, 90);
                var viewportPoint:Point = PointUtils.localToViewport(localPoint, target);
                var result:Point = PointUtils.viewportToLocal(viewportPoint, target);

                assertNear(localPoint.x, result.x, "Incorrect round-trip x");
                assertNear(localPoint.y, result.y, "Incorrect round-trip y");
                var rect:Object = target.element.getBoundingClientRect();
                assertNear(rect.left + 5 - 20 + localPoint.x, viewportPoint.x, "Border or horizontal scroll was not applied");
                assertNear(rect.top + 5 - 30 + localPoint.y, viewportPoint.y, "Border or vertical scroll was not applied");
            }
        }

        [Test]
        public function testViewportConversionsAcceptHTMLElement():void
        {
            COMPILE::JS
            {
                var localPoint:Point = new Point(10, 15);
                var viewportPoint:Point = PointUtils.localToViewport(localPoint, target.element);
                var result:Point = PointUtils.viewportToLocal(viewportPoint, target.element);

                assertPointEquals(localPoint, result, "HTMLElement round trip");
            }
        }

        [Test]
        public function testViewportConversionsAcceptElementProperty():void
        {
            COMPILE::JS
            {
                var wrapper:Object = {element: target.element};
                var localPoint:Point = new Point(10, 15);
                var viewportPoint:Point = PointUtils.localToViewport(localPoint, wrapper);
                var result:Point = PointUtils.viewportToLocal(viewportPoint, wrapper);

                assertPointEquals(localPoint, result, "Element property round trip");
            }
        }

        [Test]
        public function testViewportConversionsBetweenElements():void
        {
            COMPILE::JS
            {
                var destination:UIBase = new UIBase();
                destination.element.style.position = "absolute";
                destination.element.style.left = "250px";
                destination.element.style.top = "300px";
                destination.element.style.width = "100px";
                destination.element.style.height = "80px";
                fixture.appendChild(destination.element);

                window.scrollTo(200, 300);
                var sourcePoint:Point = new Point(10, 15);
                var viewportPoint:Point = PointUtils.localToViewport(sourcePoint, target);
                var destinationPoint:Point = PointUtils.viewportToLocal(viewportPoint, destination);
                var sourceRect:Object = target.element.getBoundingClientRect();
                var destinationRect:Object = destination.element.getBoundingClientRect();

                assertNear(sourceRect.left + sourcePoint.x - destinationRect.left, destinationPoint.x, "Incorrect destination x");
                assertNear(sourceRect.top + sourcePoint.y - destinationRect.top, destinationPoint.y, "Incorrect destination y");
            }
        }

        [Test]
        public function testViewportConversionsDoNotMutateInput():void
        {
            COMPILE::JS
            {
                var localPoint:Point = new Point(10, 15);
                var viewportPoint:Point = PointUtils.localToViewport(localPoint, target);

                assertPointEquals(new Point(10, 15), localPoint, "localToViewport input");
                assertFalse(localPoint === viewportPoint);

                var viewportCopy:Point = new Point(viewportPoint.x, viewportPoint.y);
                var result:Point = PointUtils.viewportToLocal(viewportPoint, target);

                assertPointEquals(viewportCopy, viewportPoint, "viewportToLocal input");
                assertFalse(viewportPoint === result);
            }
        }

        [Test]
        public function testViewportToLocalAcceptsDisplayUtilsBounds():void
        {
            COMPILE::JS
            {
                window.scrollTo(200, 300);
                var bounds:Rectangle = DisplayUtils.getScreenBoundingRect(target);
                var result:Point = PointUtils.viewportToLocal(bounds.topLeft, target);

                assertPointEquals(new Point(), result, "DisplayUtils viewport bounds");
            }
        }

        [Test]
        public function testLegacyConversionsRetainDocumentCoordinates():void
        {
            COMPILE::JS
            {
                window.scrollTo(200, 300);
                var localPoint:Point = new Point(10, 15);
                var documentPoint:Point = PointUtils.localToGlobal(localPoint, target);
                var rect:Object = target.element.getBoundingClientRect();

                assertNear(rect.left + window.pageXOffset + localPoint.x, documentPoint.x, "Incorrect legacy document x");
                assertNear(rect.top + window.pageYOffset + localPoint.y, documentPoint.y, "Incorrect legacy document y");
                assertPointEquals(localPoint, PointUtils.globalToLocal(documentPoint, target), "Legacy round trip");
            }
        }

        COMPILE::JS
        private function assertPointEquals(expected:Point, actual:Point, message:String):void
        {
            assertNear(expected.x, actual.x, message + " x");
            assertNear(expected.y, actual.y, message + " y");
        }

        COMPILE::JS
        private function assertNear(expected:Number, actual:Number, message:String):void
        {
            assertTrue(Math.abs(expected - actual) < 0.01, message + ": expected " + expected + " but was " + actual);
        }
    }
}