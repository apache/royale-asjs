package org.apache.royale.utils.number
{
	/**
	 * Pins the specified value between a specified maximum and minimum bounds.
	 * If the value is outside the bounds, the minimum or maximum is returned.
	 */
	public function pinValue(value:Number, minimum:Number, maximum:Number):Number
		{
			return Math.min(Math.max(value, minimum), maximum);						
		}
}