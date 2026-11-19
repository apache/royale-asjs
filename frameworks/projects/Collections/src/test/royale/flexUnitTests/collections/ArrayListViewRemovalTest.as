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
package flexUnitTests.collections
{
    import org.apache.royale.test.asserts.*;

    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.collections.ArrayListView;
    import org.apache.royale.collections.Sort;
    import org.apache.royale.events.CollectionEvent;

    /**
     * ITEM_REMOVED from an ArrayListView must carry the removed item's index in the view, so a
     * list bound to it removes the right item renderer. (It used to report 0, or -offset, for
     * every removal: removing anything but the first item took the wrong renderer away.)
     *
     * @royalesuppresspublicvarwarning
     */
    public class ArrayListViewRemovalTest
    {
        private var removedIndices:Array;
        private var removedItems:Array;

        [Before]
        public function setUp():void
        {
            this.removedIndices = [];
            this.removedItems = [];
        }

        private function listen(view:ArrayListView):ArrayListView
        {
            view.addEventListener(CollectionEvent.ITEM_REMOVED, this.itemRemovedHandler);
            return view;
        }

        private function itemRemovedHandler(event:CollectionEvent):void
        {
            this.removedIndices.push(event.index);
            this.removedItems.push(event.item);
        }

        [Test]
        public function testRemoveWithoutFilterOrSort():void
        {
            var list:ArrayList = new ArrayList(['a', 'b', 'c', 'd']);
            var view:ArrayListView = this.listen(new ArrayListView(list));

            view.removeItem('c');

            assertEquals(1, this.removedIndices.length, 'one removal');
            assertEquals(2, this.removedIndices[0], 'the index in the view');
            assertEquals('c', this.removedItems[0], 'the removed item');
            assertEquals(3, view.length, 'view length');
        }

        [Test]
        public function testRemoveFromUnderlyingList():void
        {
            var list:ArrayList = new ArrayList(['a', 'b', 'c', 'd']);
            this.listen(new ArrayListView(list));

            list.removeItemAt(3);
            list.removeItemAt(1);

            assertEquals(3, this.removedIndices[0], 'first removal');
            assertEquals(1, this.removedIndices[1], 'second removal');
        }

        [Test]
        public function testRemoveWithFilter():void
        {
            var list:ArrayList = new ArrayList([1, 2, 3, 4, 5, 6]);
            var view:ArrayListView = new ArrayListView(list);
            view.filterFunction = function (item:Object):Boolean
            {
                return int(item) % 2 == 0; // the view: 2, 4, 6
            };
            view.refresh();
            this.listen(view);

            view.removeItem(4);

            assertEquals(1, this.removedIndices.length, 'one removal');
            assertEquals(1, this.removedIndices[0], 'the index in the filtered view');
            assertEquals(2, view.length, 'view length');
            assertEquals(6, view.getItemAt(1), 'the next item moved up');
        }

        [Test]
        public function testRemoveFilteredOutItemDispatchesNothing():void
        {
            var list:ArrayList = new ArrayList([1, 2, 3, 4]);
            var view:ArrayListView = new ArrayListView(list);
            view.filterFunction = function (item:Object):Boolean
            {
                return int(item) % 2 == 0;
            };
            view.refresh();
            this.listen(view);

            list.removeItem(3);

            assertEquals(0, this.removedIndices.length, 'not in the view, so no removal');
            assertEquals(2, view.length, 'view length');
        }

        [Test]
        public function testRemoveWithSort():void
        {
            var list:ArrayList = new ArrayList(['d', 'a', 'c', 'b']);
            var view:ArrayListView = new ArrayListView(list);
            view.sort = new Sort();
            view.refresh(); // the view: a, b, c, d
            this.listen(view);

            view.removeItem('c');

            assertEquals(1, this.removedIndices.length, 'one removal');
            assertEquals(2, this.removedIndices[0], 'the index in the sorted view');
            assertEquals('d', view.getItemAt(2), 'the next item moved up');
        }

        [Test]
        public function testRemoveItemAtWithFilter():void
        {
            var list:ArrayList = new ArrayList([1, 2, 3, 4, 5, 6]);
            var view:ArrayListView = new ArrayListView(list);
            view.filterFunction = function (item:Object):Boolean
            {
                return int(item) > 2; // the view: 3, 4, 5, 6
            };
            view.refresh();
            this.listen(view);

            view.removeItemAt(2); // 5

            assertEquals(2, this.removedIndices[0], 'the index in the filtered view');
            assertEquals(5, this.removedItems[0], 'the removed item');
        }
    }
}
