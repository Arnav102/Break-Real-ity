const = {
	tolerance : real("1e-18"),
	maxsignificantdigits : int64(17),
	explimit : real("1.7e308"),
	realexpmax : real("308"),
	realexpmin : real("-324"),
	int64min : int64(-9223372036854775808),
	epsilon : real("4.94e-324"),
	positiveinf : infinity,
	negativeinf : -infinity
}

// Welcome to Break Real-ity, a some-what break_infinity port in gml
// Inspired by Break_Infinity.cs
// Break_infinity.js by Patashu

function Decimal() constructor 
{
	mantissa = real("0")
	exponent = int64("0")

	zero = Decimal(0, 0, false)
	one = Decimal(1, 0, false)
	NaN = Decimal(NaN, const.int64min, false)
	
	/// @param {real} _mantissa
	/// @param {int64} _exponent
	/// @param {bool} normal
	Decimal = function(_mantissa, _exponent, normal = true)
	{
		if !normal 
		{
			mantissa = _mantissa
			exponent = _exponent
		}
		else
		{
			mantissa = _mantissa
			exponent = _exponent
			normalize(mantissa, exponent)
		}
	}

	static parse = function(_value)
	{
		if is_array(_value) 
		{
		mantissa = real(string(_value[0]))
		exponent = int64(string(_value[1]))
		} 
		else if is_string(_value) 
		{
			if string_pos("e", _value) != 0 
			{
				var parts = string_split(_value, "e")
				var _mantissa = real(string(parts[0]))
				var _exponent = int64(string(parts[1]))
				return normalize(_mantissa, _exponent);
			}
		}
	}
	
	/// @param {real} _mantissa
	/// @param {int64} _exponent
	static normalize = function(_mantissa, _exponent)
	{
		if _mantissa >= 1 && _mantissa < 10 || !is_finite(_mantissa)
			return Decimal(_mantissa, _exponent, false)
		if is_zero(_mantissa)
			return zero
			
		var tempExponent = floor(log10(abs(_mantissa)));
		
		if tempExponent == const.realexpmin
		{
			_mantissa = _mantissa * 10 / real("1e-323");
		}
		else
		{
			_mantissa = _mantissa / powersof10.look(tempExponent)
		}
		return Decimal(_mantissa, _exponent + tempExponent)
	}
	
	with (mantissa)
		usedmantissa = mantissa
	with (exponent)
		usedexponent = exponent
	
	/// @returns {real}
	static toReal = function()
	{
		if is_nan(self)
		{
			return NaN;
		}
		
		if usedexponent > const.realexpmax
		{
			return usedmantissa > 0 ? infinity : -infinity
		}
		
		if usedexponent < const.realexpmin
		{
			return 0.0
		}
		
		if usedexponent == const.realexpmax
		{
			return usedmantissa > 0 ? real("5e-324") : real("-5e-324")
		}
		
		var result = usedmantissa * powersof10.look(usedexponent)
		if !is_finite(result) || usedexponent < 0
		{
			return result
		}
		
		var resultrounded = round(result)
		if (abs(resultrounded- result) < real("1e-10"))
			return resultrounded
		return result
	}
	
	
	/// @param {real} _value
	/// @returns {Bool}
	is_finite = function(_value)
	{
		return !is_nan(_value) && !is_infinity(_value)
	}
	
	is_zero = function(_value)
	{
		return abs(_value) < const.epsilon
	}
	
	
	powers = []
	indexof0 = -const.realexpmin - 1
	
	powersof10 = function()
	{
		for (i = const.realexpmin; i < const.realexpmax; i++)
		{
			array_push(powers, real("1e" + string(i)))
		}
	}
	/// @param {real} _power
	powersof10.look = function(_power)
	{
		// safety reasons
		if (array_length(powers) == 0)
		{
			powersof10();
		}
		return powers[indexof0 + _power]
	}
}