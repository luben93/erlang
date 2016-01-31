defmodule Temp do
	def f2c(f) do
		5 * (f-32)/9
	end

	def c2f(c) do
		((9*c)/5) + 32
	end

	def convert({scale,temp}) do
		case {scale,temp} do
		   {:c,c} -> c2f(c);    
		   {:f,f} -> f2c(f);    
		end
	end

end