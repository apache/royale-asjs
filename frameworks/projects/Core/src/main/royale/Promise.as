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

	import org.apache.royale.promises.enums.PromiseState;
	import org.apache.royale.promises.interfaces.IThenable;
	import org.apache.royale.promises.vo.Handler;

	public class Promise implements IThenable
	{


		//--------------------------------------------------------------------------
		//
		//    Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Promise(resolver:Function) 
		{
			handlers_ = new Vector.<Handler>();
			
			state_ = PromiseState.PENDING;
			
			doResolve_(resolver, resolve_, reject_);
		}

		public static function all(promises:Array):Promise
		{
			//TODO implement all()
			return null;
		}

		public static function race(promises:Array):Promise
		{
			//TODO implement race()
			return null;
		}

		public static function reject(reason:*):Promise
		{
			//TODO implement reject()
			return null;
		}

		public static function resolve(value:*):Promise
		{
			//TODO implement resolve()
			return null;
		}

		//--------------------------------------------------------------------------
		//
		//    Variables
		//
		//--------------------------------------------------------------------------
		
		private var handlers_:Vector.<Handler>;
		
		private var state_:PromiseState;
		
		private var value_:*;
		
		
		
		//--------------------------------------------------------------------------
		//
		//    Methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//    doResolve_
		//----------------------------------
		
		private function doResolve_(fn:Function, onFulfilled:Function, 
									onRejected:Function):void
		{
			var done:Boolean = false;
			
			try
			{
				fn(function (value:*):void {
					if (done)
					{
						return;
					}
					
					done = true;
					
					onFulfilled(value);
				}, function (reason:*):void {
					if (done)
					{
						return;
					}
					
					done = true;
					
					onRejected(reason);
				});
			}
			catch (e:Error)
			{
				if (done)
				{
					return;
				}
				
				done = true;
				
				onRejected(e);
			}
		}
		
		//----------------------------------
		//    fulfill_
		//----------------------------------
		
		private function fulfill_(result:*):void
		{
			state_ = PromiseState.FULFILLED;
			
			value_ = result;
			
			processHandlers_();
		}
		
		//----------------------------------
		//    handle_
		//----------------------------------
		
		private function handle_(handler:Handler):void
		{
			if (state_ === PromiseState.PENDING)
			{
				handlers_.push(handler);
			}
			else
			{
				if (state_ === PromiseState.FULFILLED && 
					handler.onFulfilled != null)
				{
					handler.onFulfilled(value_);
				}
				
				if (state_ === PromiseState.REJECTED && 
					handler.onRejected != null)
				{
					handler.onRejected(value_);
				}
			}
		}
		
		//----------------------------------
		//    processHandlers_
		//----------------------------------
		
		private function processHandlers_():void
		{
			for (var i:int = 0, n:int = handlers_.length; i < n; i++)
			{
				handle_(handlers_.shift());
			}
		}
		
		//----------------------------------
		//    reject_
		//----------------------------------
		
		private function reject_(error:*):void
		{
			state_ = PromiseState.REJECTED;
			
			value_ = error;
			
			processHandlers_();
		}
		
		//----------------------------------
		//    resolve_
		//----------------------------------
		
		private function resolve_(result:*):void
		{
			try 
			{
				if (result && 
					(typeof(result) === 'object' || 
					typeof(result) === 'function') &&
					result.then is Function)
				{
					doResolve_(result.then, resolve_, reject_);
				}
				else 
				{
					fulfill_(result);
				}
			}
			catch (e:Error)
			{
				reject_(e);
			}
		}

		//----------------------------------
		//    then
		//----------------------------------
		public function then(onFulfilled:Function = null, 
							onRejected:Function = null):IThenable
		{
			return new Promise(function (resolve:Function, reject:Function):* {
				handle_(new Handler(function (result:*):* {
					if (typeof(onFulfilled) === 'function')
					{
						try
						{
							return resolve(onFulfilled(result));
						}
						catch (e:Error)
						{
							return reject(e);
						}
					}
					else
					{
						return resolve(result);
					}
				}, function (error:*):* {
					if (typeof(onRejected) === 'function')
					{
						try
						{
							return resolve(onRejected(error));
						}
						catch (e:Error)
						{
							return reject(e);
						}
					}
					else
					{
						return reject(error);
					}
				}))
			});
		}

		//----------------------------------
		//    catch
		//----------------------------------
		public function catch(onRejected:Function = null):IThenable
		{
			//TODO implement catch
			return null;
		}

	}
}
