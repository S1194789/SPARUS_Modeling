clear all;
clc;

% Define the contants
rho = 1000;
lh = 0.1;
lcy = 1.1;
lt = 0.22;
lco = 0.18;
ltotal = 1.6;
R = 0.12;
rf = 0.2;

%% drag matrices:
% 1. The Hull
%  the projection of the hull body along the x axis is a circle with radius R
Sx = pi*R^2 ;
%  Using the turbulant drag coefficient
%  the hull is approximated to ellipsoid in 3D:
CD11 = 0.1; 
% CD22 = 0.1;
CD22 = 0.3;
Dy = 0.24;
% Define the drag coefficients for each direction
K11 = 0.5 * rho * Sx * CD11;
K22 = 0.5 * rho * CD22 * Dy * ltotal;
K33 = K22;
K44 = 0;
K66 = (1/64) * rho * ltotal^4 * CD22 * Dy ;
K55 = K66;

% Construct the drag matrix
DragMatrix_Hull = diag([K11, K22, K33, K44, K55, K66]);

% Display the matrix
disp('Drag Matrix Hull:');
disp(DragMatrix_Hull);

% Drag matrix for Antenna
l_antenna = 0.26;
d_antenna_y = 0.06;
d_antenna_x = 0.04;

CD11_antenna = 1.1+0.02*(l_antenna/d_antenna_x+d_antenna_x/l_antenna);
CD22_antenna = 1.3;

K11_antenna = 0.5 * rho * l_antenna*d_antenna_x * CD11_antenna;
K22_antenna = 0.5 * rho * CD22_antenna * d_antenna_y * l_antenna;
K33_antenna = 0;
K44_antenna = 0;
K66_antenna = 0;
K55_antenna = 0;
% Construct the drag matrix
DragMatrix_Antenna = diag([K11_antenna, K22_antenna, K33_antenna, K44_antenna, K55_antenna, K66_antenna]);

% Display the matrix
disp('Drag Matrix Antenna:');
disp(DragMatrix_Antenna);

% Drag matrix for Thrusters 

K11_thruster = 0.19;
K22_thruster = 0;
K33_thruster = 11.44;
K44_thruster = 0;
K66_thruster = 0;
K55_thruster = 0;
% Construct the drag matrix
DragMatrix_thruster = diag([K11_thruster, K22_thruster, K33_thruster, K44_thruster, K55_thruster, K66_thruster]);

% Display the matrix
disp('Drag Matrix thruster:');
disp(DragMatrix_thruster);

%% Added Mass 

% 1. Added Mass for Hull

% M11 
a = ltotal/2;
b = R;
e = sqrt(1-(b^2/a^2));
a0 = 2*(1-e^2)/e^3*((1/2)*log((1+e)/(1-e))-e);
k1 = a0/(2-a0);
m11 = k1*4/3*pi*b^2*a*rho;

% M22, M33 

%Hemisphere
a1 = integral(@(x) rho * 1 * pi * (lh^2 - (x - ltotal/2 + lh).^2), ltotal/2 - lh, ltotal/2);

%Cylinder ( Ca = 0.9 because b/2a is around 5)
a2 = integral(@(x) pi * 1* rho * R*R ,-(ltotal/2 - lt - lco), ltotal/2 - lh,'ArrayValued', true);

% Fin
a3 = integral(@(x) pi * rho * rf^2 .* (1 - (R ./ rf).^2 + (R ./ rf).^4),  -(ltotal/2 - lco), -(ltotal/2 - lt - lco),'ArrayValued', true);

%Cone
a4 = integral(@(x) 1* pi * rho * ((R/lco) .* (x + ltotal/2 - lco) + R).^2, -ltotal/2, -(ltotal/2 - lco));

m22 = a1 + a2 + a3+a4;
m33 = m22;

% M44
m44 = 0;

% M55, M66 

i1 =integral(@(x) x .* rho .* pi .* (lh^2 - (x - ltotal/2 + lh).^2), ltotal/2 - lh, ltotal/2);
i2 = integral(@(x) x .* pi .* rho .* R.^2, -(ltotal/2 - lt - lco), ltotal/2 - lh);
i3 = integral(@(x) x .* pi .* rho .* rf.^2 .* (1 - (R ./ rf).^2 + (R ./ rf).^4), -(ltotal/2 - lco), -(ltotal/2 - lt - lco));
i4 = integral(@(x) x .* pi .* rho .* ((R/lco) .* (x + ltotal/2 - lco) + R).^2, -ltotal/2, -(ltotal/2 - lco));

m26 = i1 + i2 + i3+i4;
m35 = -m26;

% M26, M35 

c1 = integral(@(x) x.^2 .* rho .* pi .* (lh^2 - (x - ltotal/2 + lh).^2), ltotal/2 - lh, ltotal/2);
c2 = integral(@(x) x.^2 .* pi .* rho .* R.^2, -(ltotal/2 - lt - lco), ltotal/2 - lh);
c3 = integral(@(x) x.^2 .* pi .* rho .* rf.^2 .* (1 - (R ./ rf).^2 + (R ./ rf).^4), -(ltotal/2 - lco), -(ltotal/2 - lt - lco));
c4 = integral(@(x) x.^2 .* pi .* rho .* ((R/lco) .* (x + ltotal/2 - lco) + R).^2,-ltotal/2, -(ltotal/2 - lco));
m55 = c1 + c2 + c3 +c4;
m66 = m55;


% Mhull 

m_hull = [ m11 0 0 0 0 0; 
           0 m22 0 0 0 m26;
           0 0 m33 0 m35 0;
           0 0 0 m44 0 0;
           0 0 m35 0 m55 0 ;
           0 m26 0 0 0 m66];
disp("Added_mass_hull =")
disp(m_hull)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2. AddedMass for Antenna

a_a = 0.04 /2; 
b_a = 0.06/2;
h_a = 0.26; 
Ca_1 = 2.23; % 0.04/0.26
Ca_2 = 1.98; % 0.06/0.26
Be_1 = 0.147;
Be_2 = 0.15;

m11 =  integral(@(z) pi * rho * Ca_1 .* a_a.^2, -h_a/2, h_a/2,'ArrayValued', true);
m22 = integral(@(z) pi * rho * Ca_2 .* b_a.^2, -h_a/2, h_a/2,'ArrayValued', true);
m33 = 0;
m15 = integral(@(z) z .* pi * rho * Ca_1 .* a_a.^2, -h_a/2, h_a/2);
m24 = -integral(@(z) z .* pi * rho * Ca_2 .* b_a.^2, -h_a/2, h_a/2);
m42 = -integral(@(z) z .* pi * rho * Ca_2 .* b_a.^2, -h_a/2, h_a/2);
m55 = integral(@(z) z.^2 .* pi * rho * Ca_1 .* a_a.^2, -h_a/2, h_a/2);
m44 = integral(@(z) z.^2 .* pi * rho * Ca_2 .* b_a.^2, -h_a/2, h_a/2);
m51 = integral(@(z) z .* pi * rho * Ca_1 .* a_a.^2, -h_a/2, h_a/2);
m66 = Be_2 * rho * pi * b_a.^4;

% Mantenna, m44, m55, and m66 are set as 0
m_antenna = [ m11 0 0 0 m51 0; 
           0 m22 0 m42 0  0;
           0 0 m33 0 0 0;
           0 m24 0 0 0 0;
           m15 0 0 0 0 0 ;
           0 0 0 0 0 0];
disp("Added_mass_antenna =")
disp(m_antenna)

% Total added mass
M = m_antenna + m_hull;
disp("Added_mass =")
disp(M)

%% Moving Mass Matrices
% Distances to gravity center
r_hull_CB_CG = [0, 0, -0.02];
r_antenna_CB_CG = [-0.4, 0, -0.15];

M_hull_CG = MoveMatrix(m_hull,r_hull_CB_CG);
M_antenna_CG = MoveMatrix(m_antenna,r_antenna_CB_CG);

% rigid body mass is given
M_rigid_body = [
    52    0    0    0  -0.1   0;
     0   52    0  0.1    0 -1.3;
     0    0   52    0  1.3   0;
     0  0.1    0  0.5    0   0;
  -0.1    0  1.3    0  9.4   0;
     0 -1.3    0    0    0  9.5
];
M_global = M_rigid_body + M_hull_CG + M_antenna_CG;
disp("global mass matrix");
disp(M_global);


%% Save the values
save('inputData.mat');


