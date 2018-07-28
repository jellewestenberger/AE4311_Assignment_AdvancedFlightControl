


function rho = fcn(h)
R=287.05;
l=-0.0065;
h0=0;
T0=288.15;
rho_0=1.225;
h_trop=11000;
h_strat=20000;
g=9.80665;
if h<=h_trop
   T=T0+(h-h0)*l;
   rho=rho_0*(1+l*(h/T0))^(-(g/(R*l))-1);
end

if h>h_trop && h<h_strat
   rho_t=rho_0*(1+l*(h_trop/T0))^(-(g/(R*l))-1);
   T_trop=T0+(h_trop-h0)*l;
   rho=rho_t*(exp(-(g/(R*T_trop))*(h-h_trop)));
end

end