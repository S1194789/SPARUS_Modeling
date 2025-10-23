function [AccG] = RovModel(Thrust,PosE,VitB)

global Para

% global Ff_store;
% if isempty(Ff_store)
%     Ff_store = [];
% end


%% Attitudes in earth frame
% z=PosE(3,1);
phi     = PosE(4,1)	;
theta   = PosE(5,1)	;

%% Gravity Force

Fg = 1* [-Para.P * sin(theta) ;
        Para.P * cos(theta)*sin(phi) ;
        Para.P * cos(theta)*cos(phi) ;
        0 ;
        0 ;
        0 ];
    
% Expressed in b and computed in G
    
%% Force d'Archimède

Fa_F = [Para.B * sin(theta) ;
        -Para.B * cos(theta)*sin(phi) ;
        -Para.B * cos(theta)*cos(phi) ;
        ];
%  Expressed in b


Fa_M = S_(Para.rb-Para.rg) * Fa_F ; % Computed in G

Fa = [ Fa_F ; Fa_M ] ;
%  Expressed in b and computed in G

%% Force de Coriolis


u = VitB(1,1) ;
v = VitB(2,1) ;
w = VitB(3,1) ;
p = VitB(4,1)   ;   %Body fixed velocity roll (rad*s^(-1))
q = VitB(5,1)   ;   %Body fixed velocity pitch (rad*s^(-1))
r = VitB(6,1)   ;   %Body fixed velocity yaw (rad*s^(-1))
V_ = [u;v;w] ;
W_ = [p;q;r]     ;  %General vector



% General coriolis matrix :
M11 = Para.Mg(1:3, 1:3);  % Top-left 
M12 = Para.Mg(1:3, 4:6);  % Top-right 
M21 = Para.Mg(4:6, 1:3);  % Bottom-left 
M22 = Para.Mg(4:6, 4:6);  % Bottom-right 

Mv1 =  M12 * W_;
Mv2 = M21 * V_ + M22 * W_;
S_Mv1 = S_(Mv1);
S_Mv2 = S_(Mv2);

C_all = [ zeros(3, 3), -S_Mv1;
          -S_Mv1',     -S_Mv2 ];

%coriolis Force :
Fc = C_all * VitB   ;
% disp(C_all)
% disp(Fc)

%% Friction forces
% Hull body
% Compute the speed at Buoyancy center
% from speed measured at the DVL position
Vit_0=H_(Para.S0.r)*VitB;

Fb_0 =  Para.S0.Kq * abs(Vit_0).*Vit_0 ;
% Move the force to center of gravity
Ff_0 = H_(Para.S0.r)'*Fb_0;

% Antenna
Vit_1=H_(Para.S1.r)*VitB;
Fb_1 =  Para.S1.Kq * abs(Vit_1).*Vit_1 ;
% Move the force to center of gravity
Ff_1 = H_(Para.S1.r)'*Fb_1;

% Thruster right

Vit_2 = H_(Para.S2.r)*VitB;
Fb_2 = Para.S2.Kq * abs(Vit_2).*Vit_2 ;
Ff_2 = H_(Para.S2.r)'*Fb_2;

% Thruster left
Vit_3 = H_(Para.S3.r)*VitB;
Fb_3 = Para.S2.Kq * abs(Vit_3).*Vit_3 ;
Ff_3 = H_(Para.S3.r)'*Fb_3;


%% Propulsions Forces
Fp = Para.Eb * Thrust ;

% Ff_store = [Ff_store; Ff_0, Ff_1, Ff_2, Ff_3, ];

%% Accelearion computation :
AccG = Para.Mg\ (Ff_0+Ff_1 +Ff_2+Ff_3+Fa + Fg+ Fp- Fc) ; % Mg\ = Mg^-1 computed at the gravity center of the Sparus


