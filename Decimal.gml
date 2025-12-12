const = {
	tolerance : real("1e-18"),
	maxsignificantdigits : int64(17),
	explimit : real("1.7e308"),
	realexpmax : real("308"),
	realexpmin : real("-324")
}

// Welcome to Break Real-ity, a some-what break_infinity port in gml
// Inspired by Break_Infinity.cs
// Break_infinity.js by Patashu

function Decimal() constructor 
{
	mantissa = real("0")
	exponent = int64("0")

	zero = Decimal(0, 0, false)
	doubleepsilon = real("4.94e-324")
	
	/// @param {real} _mantissa
	/// @param {int64} _exponent
	/// @param {bool} normal
	Decimal = function(_mantissa, _exponent, normal)
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
	}
	
	/// @param {real} _value
	is_finite = function(_value)
	{
		return !is_nan(_value) && !is_infinity(_value)
	}
	
	is_zero = function(_value)
	{
		return abs(_value) < doubleepsilon
	}
}