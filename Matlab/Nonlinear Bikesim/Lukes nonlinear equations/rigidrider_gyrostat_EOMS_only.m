function [t, dxdt] = nonlinearWhipple(t, x)
%global   g ICyy IDxx IDxz IDyy IDzz IExx IExz IEyy IEzz IFyy lf lfx lfz lr lrx lrz ls mf mr rf rft rr rrt Tfw Trw Ts;
%global   q0 q1 q2 q3 q4 q5 q6 q7 u1 u3 u5;

% Set the torques here
Ts = 0.01*sin(t);   % Steer torque
Trw = 0.0;   % Rear wheel torque
Tfw = 0.0;   % Front wheel torque


% Reserve space and initialize matrices
z = zeros(283,1);
dxdt = zeros(11); %% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<? 11x11?

% Evaluate constants
z(237) = g*mr;
z(238) = g*mf;

q0 = x(1);
q1 = x(2);
q2 = x(3);
q3 = x(4);
q4 = x(5);
q5 = x(6);
q6 = x(7);
q7 = x(8);
u1 = x(9);
u3 = x(10);
u5 = x(11);
z(5) = cos(q2);
z(6) = sin(q2);
z(7) = cos(q3);
z(8) = sin(q3);
z(3) = cos(q1);
z(16) = z(6)*z(8);
z(4) = sin(q1);
z(20) = z(3)*z(16) + z(4)*z(7);
z(23) = 1 - z(20)^2;
z(24) = z(23)^0.5;
z(26) = z(20)/z(24);
z(28) = rf*z(26);
z(25) = 1/z(24);
z(27) = -rft - rf*z(25);
z(41) = ls*z(5) - rr - lr*z(6) - lf*z(6)*z(7) - z(6)*z(8)*z(28) - z(3)*(rrt+z(27));
z(22) = z(3)*z(5);
z(14) = z(6)*z(7);
z(18) = z(4)*z(8) - z(3)*z(14);
z(34) = lr*z(22) + z(8)*(ls*z(20)+z(22)*z(28)) + z(7)*(lf*z(22)-ls*z(18));
z(46) = z(41)/z(34);
z(42) = -lf*z(7) - z(8)*z(28) - z(3)*z(6)*z(27);
z(47) = z(42)/z(34);
z(15) = z(5)*z(8);
z(43) = z(3)*z(15)*z(27);
z(48) = z(43)/z(34);
u0 = z(46)*u1 + z(47)*u3 + z(48)*u5;
q0p = u0;
q1p = u1;
z(33) = z(5)*(rr+rrt*z(3));
z(13) = z(5)*z(7);
z(21) = z(4)*z(5);
z(44) = z(13)*z(28) + z(21)*(rrt+z(27)) - lf*z(15);
z(35) = -lf*z(20) - lr*z(4) - z(18)*z(28) - rr*z(4)*z(6);
z(53) = z(44) - z(35)*z(46);
z(37) = z(6)*(rr+rrt*z(3));
z(29) = z(4)*z(6);
z(38) = lf*z(6)*z(8) - z(6)*z(7)*z(28) - z(29)*(rrt+z(27));
z(31) = z(7)*(ls*z(20)+z(22)*z(28)) - rr*z(4)*z(5) - z(8)*(lf*z(22)-ls*z(18));
z(50) = z(38) - z(31)*z(46);
z(36) = -lr - lf*z(7) - rr*z(6) - z(8)*z(28) - z(3)*z(6)*(rrt+z(27));
z(32) = ls*z(7)^2 + ls*z(8)^2 - rr*z(5) - z(3)*z(5)*(rrt+z(27));
z(49) = z(33)*z(36) - z(32)*z(37);
z(56) = (z(33)*z(53)-z(37)*z(50))/z(49);
z(19) = z(3)*z(7) - z(4)*z(16);
z(45) = z(27)*(z(6)*z(19)-z(15)*z(21));
z(54) = z(45) - z(35)*z(48);
z(40) = z(27)*(z(5)*z(19)+z(15)*z(29));
z(52) = z(40) - z(31)*z(48);
z(58) = (z(33)*z(54)-z(37)*z(52))/z(49);
z(55) = z(35)*z(47);
z(39) = lf*z(8) - z(7)*z(28) - z(5)*z(21)*z(27) - z(6)*z(27)*z(29);
z(51) = z(39) - z(31)*z(47);
z(57) = (z(33)*z(55)+z(37)*z(51))/z(49);
u2 = z(56)*u1 + z(58)*u5 - z(57)*u3;
q2p = u2;
q3p = u3;
z(59) = (z(32)*z(53)-z(36)*z(50))/z(49);
z(61) = (z(32)*z(54)-z(36)*z(52))/z(49);
z(60) = (z(32)*z(55)+z(36)*z(51))/z(49);
u4 = z(59)*u1 + z(61)*u5 - z(60)*u3;
q4p = u4;
q5p = u5;
z(1) = cos(q0);
q6p = -z(1)*(rr+rrt*z(3))*(q2p+q4p);
z(2) = sin(q0);
q7p = -z(2)*(rr+rrt*z(3))*(q2p+q4p);
z(30) = z(3)*z(6);
z(121) = z(30)*z(47);
z(129) = z(22)*z(47);
z(188) = IDxz*z(121) - IDzz*z(129);
z(136) = z(18)*z(47) - z(8)*z(57);
z(143) = 1 + z(22)*z(47);
z(200) = -IExz*z(136) - IEzz*z(143);
z(184) = IDxx*z(121) - IDxz*z(129);
z(196) = -IExx*z(136) - IExz*z(143);
z(140) = z(20)*z(47) - z(7)*z(57);
z(204) = IEyy*z(140);
z(208) = IFyy*z(140);
z(154) = z(47)*(lrx*z(22)+lrz*z(30));
z(218) = mr*z(154);
z(157) = lrx*(z(57)-z(4)*z(47)) + rrt*z(3)*z(6)*(z(57)+z(60)) + rr*z(6)*(z(57)+z(60)-z(4)*z(47));
z(221) = mr*z(157);
z(175) = lfx*z(7)*z(57) - lfx*z(20)*z(47) - z(3)*z(6)*z(27)*z(57) - z(28)*(z(8)*z(57)-z(18)*z(47));
z(235) = mf*z(175);
z(126) = z(4)*z(47) - z(57);
z(193) = IDyy*z(126);
z(110) = z(4)*z(47) - z(57) - z(60);
z(179) = ICyy*z(110);
z(150) = rrt*z(3)*z(5)*(z(57)+z(60)) + rr*z(5)*(z(57)+z(60)-z(4)*z(47)) - lrz*(z(57)-z(4)*z(47));
z(214) = mr*z(150);
z(17) = z(3)*z(8) + z(4)*z(14);
z(166) = lfz*z(20)*z(47) - lfz*z(7)*z(57) - z(6)*z(17)*z(27) - z(28)*(1+z(22)*z(47)) - z(13)*z(27)*(z(21)+z(3)*z(57));
z(226) = mf*z(166);
z(169) = lfx + lfx*z(22)*z(47) + lfz*z(8)*z(57) + z(15)*z(27)*(z(21)+z(3)*z(57)) - lfz*z(18)*z(47) - z(6)*z(19)*z(27);
z(229) = mf*z(169);
z(243) = z(188)*(z(6)+z(22)*z(46)) + z(200)*(z(6)+z(22)*z(46)) + z(184)*(z(5)-z(30)*z(46)) + z(196)*(z(13)+z(8)*z(56)+z(18)*z(46)) + z(204)*(z(15)-z(7)*z(56)-z(20)*z(46)) + z(208)*(z(15)-z(7)*z(56)-z(20)*z(46)) + z(218)*(lrz*z(5)-rr-lrx*z(6)-rrt*z(3)-lrx*z(22)*z(46)-lrz*z(30)*z(46)) + z(221)*(rrt*z(21)+lrx*(z(56)+z(4)*z(46))+rrt*z(3)*z(6)*(z(56)+z(59))+rr*z(6)*(z(56)+z(59)+z(4)*z(46))) + z(235)*(lfx*z(7)*z(56)+lfx*z(20)*z(46)-lfx*z(15)-z(21)*z(27)-z(3)*z(6)*z(27)*z(56)-z(28)*(z(13)+z(8)*z(56)+z(18)*z(46))) - z(193)*(z(56)+z(4)*z(46)) - z(179)*(z(56)+z(59)+z(4)*z(46)) - z(214)*(rrt*z(29)+lrz*(z(56)+z(4)*z(46))-rrt*z(3)*z(5)*(z(56)+z(59))-rr*z(5)*(z(56)+z(59)+z(4)*z(46))) - z(226)*(lfz*z(7)*z(56)+lfz*z(20)*z(46)+z(3)*z(13)*z(27)*z(56)-z(17)*z(27)-lfz*z(5)*z(8)-z(28)*(z(6)+z(22)*z(46))) - z(229)*(lfx*z(6)+lfx*z(22)*z(46)-z(19)*z(27)-lfz*z(5)*z(7)-lfz*z(8)*z(56)-lfz*z(18)*z(46)-z(3)*z(15)*z(27)*z(56));
z(122) = z(30)*z(48);
z(130) = z(22)*z(48);
z(189) = IDxz*z(122) - IDzz*z(130);
z(137) = z(8)*z(58) + z(18)*z(48);
z(201) = -IExz*z(137) - IEzz*z(130);
z(125) = z(58) + z(4)*z(48);
z(192) = IDyy*z(125);
z(109) = z(58) + z(61) + z(4)*z(48);
z(178) = ICyy*z(109);
z(141) = z(7)*z(58) + z(20)*z(48);
z(205) = IEyy*z(141);
z(145) = 1 + z(7)*z(58) + z(20)*z(48);
z(209) = IFyy*z(145);
z(151) = lrz*(z(58)+z(4)*z(48)) - rrt*z(3)*z(5)*(z(58)+z(61)) - rr*z(5)*(z(58)+z(61)+z(4)*z(48));
z(215) = mr*z(151);
z(171) = lfx*z(22)*z(48) - lfz*z(8)*z(58) - lfz*z(18)*z(48) - z(3)*z(15)*z(27)*z(58);
z(231) = mf*z(171);
z(185) = IDxx*z(122) - IDxz*z(130);
z(155) = z(48)*(lrx*z(22)+lrz*z(30));
z(219) = mr*z(155);
z(197) = -IExx*z(137) - IExz*z(130);
z(159) = -lrx*(z(58)+z(4)*z(48)) - rrt*z(3)*z(6)*(z(58)+z(61)) - rr*z(6)*(z(58)+z(61)+z(4)*z(48));
z(223) = mr*z(159);
z(174) = z(6)*z(27)*(z(19)+z(3)*z(58)) + z(28)*(z(8)*z(58)+z(18)*z(48)) - lfx*z(7)*z(58) - lfx*z(20)*z(48) - z(15)*z(21)*z(27);
z(234) = mf*z(174);
z(167) = lfz*z(7)*z(58) + lfz*z(20)*z(48) + z(15)*z(17)*z(27) + z(13)*z(27)*(z(19)+z(3)*z(58)) - z(22)*z(28)*z(48);
z(227) = mf*z(167);
z(248) = z(22)*z(47)*z(189) + z(201)*(1+z(22)*z(47)) + z(192)*(z(57)-z(4)*z(47)) + z(178)*(z(57)+z(60)-z(4)*z(47)) + z(205)*(z(7)*z(57)-z(20)*z(47)) + z(209)*(z(7)*z(57)-z(20)*z(47)) + z(215)*(lrz*(z(57)-z(4)*z(47))-rrt*z(3)*z(5)*(z(57)+z(60))-rr*z(5)*(z(57)+z(60)-z(4)*z(47))) + z(231)*(lfz*z(18)*z(47)+z(6)*z(19)*z(27)-lfx-lfx*z(22)*z(47)-lfz*z(8)*z(57)-z(15)*z(27)*(z(21)+z(3)*z(57))) - z(30)*z(47)*z(185) - z(47)*z(219)*(lrx*z(22)+lrz*z(30)) - z(197)*(z(8)*z(57)-z(18)*z(47)) - z(223)*(lrx*(z(57)-z(4)*z(47))+rrt*z(3)*z(6)*(z(57)+z(60))+rr*z(6)*(z(57)+z(60)-z(4)*z(47))) - z(234)*(lfx*z(7)*z(57)-lfx*z(20)*z(47)-z(3)*z(6)*z(27)*z(57)-z(28)*(z(8)*z(57)-z(18)*z(47))) - z(227)*(lfz*z(20)*z(47)-lfz*z(7)*z(57)-z(6)*z(17)*z(27)-z(28)*(1+z(22)*z(47))-z(13)*z(27)*(z(21)+z(3)*z(57)));
z(244) = z(189)*(z(6)+z(22)*z(46)) + z(201)*(z(6)+z(22)*z(46)) + z(185)*(z(5)-z(30)*z(46)) + z(197)*(z(13)+z(8)*z(56)+z(18)*z(46)) + z(205)*(z(15)-z(7)*z(56)-z(20)*z(46)) + z(209)*(z(15)-z(7)*z(56)-z(20)*z(46)) + z(219)*(lrz*z(5)-rr-lrx*z(6)-rrt*z(3)-lrx*z(22)*z(46)-lrz*z(30)*z(46)) + z(223)*(rrt*z(21)+lrx*(z(56)+z(4)*z(46))+rrt*z(3)*z(6)*(z(56)+z(59))+rr*z(6)*(z(56)+z(59)+z(4)*z(46))) + z(234)*(lfx*z(7)*z(56)+lfx*z(20)*z(46)-lfx*z(15)-z(21)*z(27)-z(3)*z(6)*z(27)*z(56)-z(28)*(z(13)+z(8)*z(56)+z(18)*z(46))) - z(192)*(z(56)+z(4)*z(46)) - z(178)*(z(56)+z(59)+z(4)*z(46)) - z(215)*(rrt*z(29)+lrz*(z(56)+z(4)*z(46))-rrt*z(3)*z(5)*(z(56)+z(59))-rr*z(5)*(z(56)+z(59)+z(4)*z(46))) - z(227)*(lfz*z(7)*z(56)+lfz*z(20)*z(46)+z(3)*z(13)*z(27)*z(56)-z(17)*z(27)-lfz*z(5)*z(8)-z(28)*(z(6)+z(22)*z(46))) - z(231)*(lfx*z(6)+lfx*z(22)*z(46)-z(19)*z(27)-lfz*z(5)*z(7)-lfz*z(8)*z(56)-lfz*z(18)*z(46)-z(3)*z(15)*z(27)*z(56));
z(247) = z(22)*z(47)*z(188) + z(200)*(1+z(22)*z(47)) + z(193)*(z(57)-z(4)*z(47)) + z(179)*(z(57)+z(60)-z(4)*z(47)) + z(204)*(z(7)*z(57)-z(20)*z(47)) + z(208)*(z(7)*z(57)-z(20)*z(47)) + z(214)*(lrz*(z(57)-z(4)*z(47))-rrt*z(3)*z(5)*(z(57)+z(60))-rr*z(5)*(z(57)+z(60)-z(4)*z(47))) + z(229)*(lfz*z(18)*z(47)+z(6)*z(19)*z(27)-lfx-lfx*z(22)*z(47)-lfz*z(8)*z(57)-z(15)*z(27)*(z(21)+z(3)*z(57))) - z(30)*z(47)*z(184) - z(47)*z(218)*(lrx*z(22)+lrz*z(30)) - z(196)*(z(8)*z(57)-z(18)*z(47)) - z(221)*(lrx*(z(57)-z(4)*z(47))+rrt*z(3)*z(6)*(z(57)+z(60))+rr*z(6)*(z(57)+z(60)-z(4)*z(47))) - z(235)*(lfx*z(7)*z(57)-lfx*z(20)*z(47)-z(3)*z(6)*z(27)*z(57)-z(28)*(z(8)*z(57)-z(18)*z(47))) - z(226)*(lfz*z(20)*z(47)-lfz*z(7)*z(57)-z(6)*z(17)*z(27)-z(28)*(1+z(22)*z(47))-z(13)*z(27)*(z(21)+z(3)*z(57)));
z(259) = z(243)*z(248) - z(244)*z(247);
z(241) = Tfw + Trw*z(61) + z(238)*z(18)*(lfz*z(7)*z(58)+z(15)*z(17)*z(27)+z(13)*z(27)*(z(19)+z(3)*z(58))) - z(238)*z(20)*z(58)*(lfz*z(8)+z(3)*z(15)*z(27)) - z(237)*z(22)*(lrx*z(58)+rrt*z(3)*z(6)*(z(58)+z(61))+rr*z(6)*(z(58)+z(61)+z(4)*z(48))) - z(237)*z(30)*(lrz*z(58)-rrt*z(3)*z(5)*(z(58)+z(61))-rr*z(5)*(z(58)+z(61)+z(4)*z(48))) - z(238)*z(22)*(lfx*z(7)*z(58)+z(15)*z(21)*z(27)-z(8)*z(28)*z(58)-z(6)*z(27)*(z(19)+z(3)*z(58)));
z(181) = ICyy*u1*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5));
z(212) = IFyy*(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(u5+z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5));
z(119) = z(3)*z(5)*q2p - z(4)*z(6)*u1;
z(66) = z(6)*z(7)*u3 + z(5)*z(8)*q2p;
z(67) = z(3)*z(7)*u1 + z(3)*z(66) - z(4)*z(8)*u3 - z(4)*z(16)*u1;
z(68) = z(20)*z(67)/z(23)^0.5;
z(71) = rf*z(68)/z(24)^2;
z(69) = (z(20)*z(68)+z(24)*z(67))/z(24)^2;
z(77) = lf*z(6)*z(8)*u3 + z(4)*(rrt+z(27))*u1 + z(3)*z(71) - z(6)*z(7)*z(28)*u3 - lr*z(5)*q2p - ls*z(6)*q2p - lf*z(5)*z(7)*q2p - z(5)*z(8)*z(28)*q2p - rf*z(6)*z(8)*z(69);
z(78) = -z(4)*z(5)*u1 - z(3)*z(6)*q2p;
z(74) = z(5)*z(7)*q2p - z(6)*z(8)*u3;
z(75) = z(3)*z(8)*u1 + z(4)*z(7)*u3 + z(4)*z(14)*u1 - z(3)*z(74);
z(79) = z(7)*(ls*z(20)+z(22)*z(28))*u3 + lr*z(78) + z(7)*(lf*z(78)-ls*z(75)) + z(8)*(ls*z(67)+z(28)*z(78)+rf*z(22)*z(69)) - z(8)*(lf*z(22)-ls*z(18))*u3;
z(80) = (z(34)*z(77)-z(41)*z(79))/z(34)^2;
z(101) = lf*z(8)*u3 + z(4)*z(6)*z(27)*u1 + z(3)*z(6)*z(71) - z(7)*z(28)*u3 - z(3)*z(5)*z(27)*q2p - rf*z(8)*z(69);
z(102) = (z(34)*z(101)-z(42)*z(79))/z(34)^2;
z(72) = z(5)*z(7)*u3 - z(6)*z(8)*q2p;
z(93) = z(3)*z(27)*z(72) - z(4)*z(15)*z(27)*u1 - z(3)*z(15)*z(71);
z(94) = (z(34)*z(93)-z(43)*z(79))/z(34)^2;
z(123) = -z(6)*u1*q2p - (z(46)*u1+z(47)*u3+z(48)*u5)*z(119) - z(30)*(u1*z(80)+u3*z(102)+u5*z(94));
z(131) = z(5)*u1*q2p + (z(46)*u1+z(47)*u3+z(48)*u5)*z(78) + z(22)*(u1*z(80)+u3*z(102)+u5*z(94));
z(190) = IDyy*(z(5)*u1-z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)) - IDxz*(z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)) - IDxx*(z(5)*u1-z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)) - IDxz*z(123) - IDzz*z(131);
z(65) = -z(5)*z(8)*u3 - z(6)*z(7)*q2p;
z(87) = lf*z(8)*u3 + z(4)*z(6)*(rrt+z(27))*u1 + z(3)*z(6)*z(71) - z(7)*z(28)*u3 - rr*z(5)*q2p - z(3)*z(5)*(rrt+z(27))*q2p - rf*z(8)*z(69);
z(64) = -rrt*z(4)*z(5)*u1 - z(6)*(rr+rrt*z(3))*q2p;
z(82) = z(5)*(rr+rrt*z(3))*q2p - rrt*z(4)*z(6)*u1;
z(88) = z(4)*z(5)*(rrt+z(27))*u1 + rr*z(6)*q2p + z(3)*z(6)*(rrt+z(27))*q2p + z(3)*z(5)*z(71);
z(89) = z(33)*z(87) + z(36)*z(64) - z(32)*z(82) - z(37)*z(88);
z(76) = -lr*z(3)*u1 - rr*z(3)*z(6)*u1 - rr*z(4)*z(5)*q2p - lf*z(67) - z(28)*z(75) - rf*z(18)*z(69);
z(103) = z(35)*z(102) + z(47)*z(76);
z(70) = z(3)*z(5)*u1 - z(4)*z(6)*q2p;
z(83) = z(3)*z(6)*u1 + z(4)*z(5)*q2p;
z(104) = lf*z(7)*u3 + z(8)*z(28)*u3 + z(6)*z(21)*z(27)*q2p + z(5)*z(21)*z(71) + z(6)*z(29)*z(71) - z(5)*z(27)*z(29)*q2p - rf*z(7)*z(69) - z(5)*z(27)*z(70) - z(6)*z(27)*z(83);
z(85) = rr*z(4)*z(6)*q2p + z(7)*(ls*z(67)+z(28)*z(78)+rf*z(22)*z(69)) - rr*z(3)*z(5)*u1 - z(8)*(ls*z(20)+z(22)*z(28))*u3 - z(7)*(lf*z(22)-ls*z(18))*u3 - z(8)*(lf*z(78)-ls*z(75));
z(105) = z(104) - z(31)*z(102) - z(47)*z(85);
z(106) = ((z(33)*z(55)+z(37)*z(51))*z(89)-z(49)*(z(33)*z(103)+z(37)*z(105)+z(51)*z(82)+z(55)*z(64)))/z(49)^2;
z(84) = lf*z(6)*z(7)*u3 + z(6)*z(8)*z(28)*u3 + lf*z(5)*z(8)*q2p + z(29)*z(71) - z(5)*z(7)*z(28)*q2p - (rrt+z(27))*z(83) - rf*z(6)*z(7)*z(69);
z(86) = z(84) - z(31)*z(80) - z(46)*z(85);
z(73) = z(28)*z(65) + rf*z(13)*z(69) + (rrt+z(27))*z(70) - lf*z(72) - z(21)*z(71);
z(81) = z(73) - z(35)*z(80) - z(46)*z(76);
z(90) = ((z(33)*z(53)-z(37)*z(50))*z(89)+z(49)*(z(37)*z(86)+z(50)*z(82)-z(33)*z(81)-z(53)*z(64)))/z(49)^2;
z(91) = -z(3)*z(8)*u3 - z(3)*z(16)*u1 - z(4)*z(7)*u1 - z(4)*z(66);
z(96) = -(z(5)*z(19)+z(15)*z(29))*z(71) - z(27)*(z(6)*z(19)*q2p-z(5)*z(91)-z(15)*z(83)-z(29)*z(72));
z(97) = z(96) - z(31)*z(94) - z(48)*z(85);
z(92) = z(27)*(z(5)*z(19)*q2p+z(6)*z(91)-z(15)*z(70)-z(21)*z(72)) - (z(6)*z(19)-z(15)*z(21))*z(71);
z(95) = z(92) - z(35)*z(94) - z(48)*z(76);
z(98) = ((z(33)*z(54)-z(37)*z(52))*z(89)+z(49)*(z(37)*z(97)+z(52)*z(82)-z(33)*z(95)-z(54)*z(64)))/z(49)^2;
z(138) = u1*z(65) + (z(46)*u1+z(47)*u3+z(48)*u5)*z(75) + z(18)*(u1*z(80)+u3*z(102)+u5*z(94)) + z(8)*(u3*z(106)-u1*z(90)-u5*z(98)) - z(7)*u3*(z(57)*u3-z(56)*u1-z(58)*u5);
z(202) = IExz*(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)) + IExx*(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))*(z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)) - IEyy*(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))*(z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)) - IExz*z(138) - IEzz*z(131);
z(127) = z(3)*u1*(z(46)*u1+z(47)*u3+z(48)*u5) + u3*z(106) + z(4)*(u1*z(80)+u3*z(102)+u5*z(94)) - u1*z(90) - u5*z(98);
z(194) = -(z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(IDxz*(z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))-IDzz*(z(5)*u1-z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))) - (z(5)*u1-z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))*(IDxx*(z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))-IDxz*(z(5)*u1-z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))) - IDyy*z(127);
z(142) = z(8)*u3*(z(57)*u3-z(56)*u1-z(58)*u5) + (z(46)*u1+z(47)*u3+z(48)*u5)*z(67) + z(20)*(u1*z(80)+u3*z(102)+u5*z(94)) + z(7)*(u3*z(106)-u1*z(90)-u5*z(98)) - u1*z(72);
z(206) = -(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(IExz*(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))-IEzz*(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))) - (z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))*(IExx*(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))-IExz*(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))) - IEyy*z(142);
z(198) = IEyy*(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)) - IEzz*(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)) - IExz*(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))*(z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)) - IExx*z(138) - IExz*z(131);
z(156) = lrx*z(5)*u1*q2p + lrz*z(6)*u1*q2p + lrx*(z(46)*u1+z(47)*u3+z(48)*u5)*z(78) + lrx*z(22)*(u1*z(80)+u3*z(102)+u5*z(94)) + lrz*(z(46)*u1+z(47)*u3+z(48)*u5)*z(119) + lrz*z(30)*(u1*z(80)+u3*z(102)+u5*z(94)) - rrt*z(4)*u1^2;
z(220) = mr*((z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(lrz*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5))-rrt*z(29)*u1-rrt*z(3)*z(5)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5)-rr*z(5)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)))-(z(5)*u1-z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))*(rrt*z(21)*u1-lrx*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5))-rrt*z(3)*z(6)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5)-rr*z(6)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)))-z(156));
z(172) = lfz*z(5)*z(8)*u1*u3 + lfz*z(7)*u3*(z(57)*u3-z(56)*u1-z(58)*u5) + lfx*z(5)*u1*q2p + lfz*z(6)*z(7)*u1*q2p + z(19)*(u1+z(6)*u3)*z(71) + lfx*(z(46)*u1+z(47)*u3+z(48)*u5)*z(78) + lfx*z(22)*(u1*z(80)+u3*z(102)+u5*z(94)) + z(27)*(z(21)*u3+z(3)*(z(57)*u3-z(56)*u1-z(58)*u5))*z(72) + z(15)*z(27)*(u3*z(70)-z(4)*u1*(z(57)*u3-z(56)*u1-z(58)*u5)-z(3)*(u3*z(106)-u1*z(90)-u5*z(98))) - z(5)*z(19)*z(27)*u3*q2p - z(27)*(u1+z(6)*u3)*z(91) - lfz*(z(46)*u1+z(47)*u3+z(48)*u5)*z(75) - lfz*z(18)*(u1*z(80)+u3*z(102)+u5*z(94)) - lfz*z(8)*(u3*z(106)-u1*z(90)-u5*z(98)) - z(15)*(z(21)*u3+z(3)*(z(57)*u3-z(56)*u1-z(58)*u5))*z(71);
z(232) = mf*((u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(lfz*z(5)*z(8)*u1+z(17)*z(27)*(u1+z(6)*u3-z(15)*u5)+lfz*z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)+z(28)*(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))-lfz*z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(13)*z(27)*(z(19)*u5-z(21)*u3-z(3)*(z(57)*u3-z(56)*u1-z(58)*u5)))-(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))*(lfx*z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-lfx*z(15)*u1-z(21)*z(27)*(u1-z(15)*u5)-lfx*z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)-z(6)*z(27)*(z(19)*u5-z(3)*(z(57)*u3-z(56)*u1-z(58)*u5))-z(28)*(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5)))-z(172));
z(211) = IFyy*(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))*(u5+z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5));
z(186) = IDzz*(z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)) + IDxz*(z(5)*u1-z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)) - IDyy*(z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)) - IDxx*z(123) - IDxz*z(131);
z(107) = ((z(32)*z(55)+z(36)*z(51))*z(89)-z(49)*(z(32)*z(103)+z(36)*z(105)+z(51)*z(87)+z(55)*z(88)))/z(49)^2;
z(99) = ((z(32)*z(53)-z(36)*z(50))*z(89)+z(49)*(z(36)*z(86)+z(50)*z(87)-z(32)*z(81)-z(53)*z(88)))/z(49)^2;
z(100) = ((z(32)*z(54)-z(36)*z(52))*z(89)+z(49)*(z(36)*z(97)+z(52)*z(87)-z(32)*z(95)-z(54)*z(88)))/z(49)^2;
z(111) = z(3)*u1*(z(46)*u1+z(47)*u3+z(48)*u5) + u3*z(106) + u3*z(107) + z(4)*(u1*z(80)+u3*z(102)+u5*z(94)) - u1*z(90) - u1*z(99) - u5*z(98) - u5*z(100);
z(180) = ICyy*z(111);
z(210) = IFyy*z(142);
z(160) = rrt*z(3)*z(5)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5)*q2p + rr*z(5)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5))*q2p + lrx*(u1*z(90)+u5*z(98)-z(3)*u1*(z(46)*u1+z(47)*u3+z(48)*u5)-u3*z(106)-z(4)*(u1*z(80)+u3*z(102)+u5*z(94))) + rr*z(6)*(u1*z(90)+u1*z(99)+u5*z(98)+u5*z(100)-z(3)*u1*(z(46)*u1+z(47)*u3+z(48)*u5)-u3*z(106)-u3*z(107)-z(4)*(u1*z(80)+u3*z(102)+u5*z(94))) - rrt*z(4)*z(6)*u1*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5) - rrt*u1*z(70) - rrt*z(3)*z(6)*(u3*z(106)+u3*z(107)-u1*z(90)-u1*z(99)-u5*z(98)-u5*z(100));
z(224) = mr*((z(5)*u1-z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))*(lrz*z(5)*u1-rr*u1-lrx*z(6)*u1-rrt*z(3)*u1-lrx*z(22)*(z(46)*u1+z(47)*u3+z(48)*u5)-lrz*z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))+(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5))*(lrz*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5))-rrt*z(29)*u1-rrt*z(3)*z(5)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5)-rr*z(5)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)))-z(160));
z(152) = rrt*u1*z(83) + rr*z(5)*(u1*z(90)+u1*z(99)+u5*z(98)+u5*z(100)-z(3)*u1*(z(46)*u1+z(47)*u3+z(48)*u5)-u3*z(106)-u3*z(107)-z(4)*(u1*z(80)+u3*z(102)+u5*z(94))) - rrt*z(4)*z(5)*u1*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5) - rrt*z(3)*z(6)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5)*q2p - rr*z(6)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5))*q2p - rrt*z(3)*z(5)*(u3*z(106)+u3*z(107)-u1*z(90)-u1*z(99)-u5*z(98)-u5*z(100)) - lrz*(u1*z(90)+u5*z(98)-z(3)*u1*(z(46)*u1+z(47)*u3+z(48)*u5)-u3*z(106)-z(4)*(u1*z(80)+u3*z(102)+u5*z(94)));
z(216) = mr*((z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(lrz*z(5)*u1-rr*u1-lrx*z(6)*u1-rrt*z(3)*u1-lrx*z(22)*(z(46)*u1+z(47)*u3+z(48)*u5)-lrz*z(30)*(z(46)*u1+z(47)*u3+z(48)*u5))+(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5))*(rrt*z(21)*u1-lrx*(z(57)*u3-z(56)*u1-z(58)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5))-rrt*z(3)*z(6)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5)-rr*z(6)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5)))+z(152));
z(164) = z(3)*z(7)*u3 + z(3)*z(14)*u1 + z(4)*z(74) - z(4)*z(8)*u1;
z(168) = lfz*z(8)*u3*(z(57)*u3-z(56)*u1-z(58)*u5) + lfz*z(6)*z(8)*u1*q2p + lfz*(z(46)*u1+z(47)*u3+z(48)*u5)*z(67) + lfz*z(20)*(u1*z(80)+u3*z(102)+u5*z(94)) + z(17)*(u1+z(6)*u3-z(15)*u5)*z(71) + lfz*z(7)*(u3*z(106)-u1*z(90)-u5*z(98)) + z(27)*(z(19)*u5-z(21)*u3-z(3)*(z(57)*u3-z(56)*u1-z(58)*u5))*z(65) - lfz*z(5)*z(7)*u1*u3 - z(17)*z(27)*(z(5)*u3*q2p-u5*z(72)) - z(27)*(u1+z(6)*u3-z(15)*u5)*z(164) - rf*(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*z(69) - z(13)*(z(19)*u5-z(21)*u3-z(3)*(z(57)*u3-z(56)*u1-z(58)*u5))*z(71) - z(28)*(z(5)*u1*q2p+(z(46)*u1+z(47)*u3+z(48)*u5)*z(78)+z(22)*(u1*z(80)+u3*z(102)+u5*z(94))) - z(13)*z(27)*(u3*z(70)-z(4)*u1*(z(57)*u3-z(56)*u1-z(58)*u5)-u5*z(91)-z(3)*(u3*z(106)-u1*z(90)-u5*z(98)));
z(228) = mf*((z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5))*(lfx*z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-lfx*z(15)*u1-z(21)*z(27)*(u1-z(15)*u5)-lfx*z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)-z(6)*z(27)*(z(19)*u5-z(3)*(z(57)*u3-z(56)*u1-z(58)*u5))-z(28)*(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5)))-(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))*(lfz*z(5)*z(7)*u1+z(19)*z(27)*(u1+z(6)*u3)+lfz*z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-lfx*u3-lfx*z(6)*u1-lfx*z(22)*(z(46)*u1+z(47)*u3+z(48)*u5)-lfz*z(8)*(z(57)*u3-z(56)*u1-z(58)*u5)-z(15)*z(27)*(z(21)*u3+z(3)*(z(57)*u3-z(56)*u1-z(58)*u5)))-z(168));
z(176) = z(5)*z(27)*(z(19)*u5-z(3)*(z(57)*u3-z(56)*u1-z(58)*u5))*q2p + lfx*u1*z(72) + z(27)*(u1-z(15)*u5)*z(70) + rf*(z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))*z(69) + z(6)*z(27)*(z(4)*u1*(z(57)*u3-z(56)*u1-z(58)*u5)+u5*z(91)+z(3)*(u3*z(106)-u1*z(90)-u5*z(98))) - lfx*z(8)*u3*(z(57)*u3-z(56)*u1-z(58)*u5) - z(21)*z(27)*u5*z(72) - z(21)*(u1-z(15)*u5)*z(71) - lfx*(z(46)*u1+z(47)*u3+z(48)*u5)*z(67) - lfx*z(20)*(u1*z(80)+u3*z(102)+u5*z(94)) - lfx*z(7)*(u3*z(106)-u1*z(90)-u5*z(98)) - z(6)*(z(19)*u5-z(3)*(z(57)*u3-z(56)*u1-z(58)*u5))*z(71) - z(28)*(z(7)*u3*(z(57)*u3-z(56)*u1-z(58)*u5)-u1*z(65)-(z(46)*u1+z(47)*u3+z(48)*u5)*z(75)-z(18)*(u1*z(80)+u3*z(102)+u5*z(94))-z(8)*(u3*z(106)-u1*z(90)-u5*z(98)));
z(236) = mf*((z(13)*u1+z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(8)*(z(57)*u3-z(56)*u1-z(58)*u5))*(lfz*z(5)*z(7)*u1+z(19)*z(27)*(u1+z(6)*u3)+lfz*z(18)*(z(46)*u1+z(47)*u3+z(48)*u5)-lfx*u3-lfx*z(6)*u1-lfx*z(22)*(z(46)*u1+z(47)*u3+z(48)*u5)-lfz*z(8)*(z(57)*u3-z(56)*u1-z(58)*u5)-z(15)*z(27)*(z(21)*u3+z(3)*(z(57)*u3-z(56)*u1-z(58)*u5)))-(z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(15)*u1-z(7)*(z(57)*u3-z(56)*u1-z(58)*u5))*(lfz*z(5)*z(8)*u1+z(17)*z(27)*(u1+z(6)*u3-z(15)*u5)+lfz*z(7)*(z(57)*u3-z(56)*u1-z(58)*u5)+z(28)*(u3+z(6)*u1+z(22)*(z(46)*u1+z(47)*u3+z(48)*u5))-lfz*z(20)*(z(46)*u1+z(47)*u3+z(48)*u5)-z(13)*z(27)*(z(19)*u5-z(21)*u3-z(3)*(z(57)*u3-z(56)*u1-z(58)*u5)))-z(176));
z(253) = z(3)*z(48)*z(181) + (z(8)*z(58)+z(18)*z(48))*z(212) + z(22)*z(48)*z(190) + z(22)*z(48)*z(202) + (z(58)+z(4)*z(48))*z(194) + (z(7)*z(58)+z(20)*z(48))*z(206) + (z(8)*z(58)+z(18)*z(48))*z(198) + z(48)*(lrx*z(22)+lrz*z(30))*z(220) + (lfx*z(22)*z(48)-lfz*z(8)*z(58)-lfz*z(18)*z(48)-z(3)*z(15)*z(27)*z(58))*z(232) - z(22)*z(48)*z(211) - z(30)*z(48)*z(186) - (z(58)+z(61)+z(4)*z(48))*z(180) - (1+z(7)*z(58)+z(20)*z(48))*z(210) - (lrx*(z(58)+z(4)*z(48))+rrt*z(3)*z(6)*(z(58)+z(61))+rr*z(6)*(z(58)+z(61)+z(4)*z(48)))*z(224) - (lrz*(z(58)+z(4)*z(48))-rrt*z(3)*z(5)*(z(58)+z(61))-rr*z(5)*(z(58)+z(61)+z(4)*z(48)))*z(216) - (z(22)*z(28)*z(48)-lfz*z(7)*z(58)-lfz*z(20)*z(48)-z(15)*z(17)*z(27)-z(13)*z(27)*(z(19)+z(3)*z(58)))*z(228) - (lfx*z(7)*z(58)+lfx*z(20)*z(48)+z(15)*z(21)*z(27)-z(6)*z(27)*(z(19)+z(3)*z(58))-z(28)*(z(8)*z(58)+z(18)*z(48)))*z(236);
z(256) = -z(241) - z(253);
z(252) = z(22)*z(48)*z(189) + z(22)*z(48)*z(201) + z(197)*(z(8)*z(58)+z(18)*z(48)) + z(223)*(lrx*(z(58)+z(4)*z(48))+rrt*z(3)*z(6)*(z(58)+z(61))+rr*z(6)*(z(58)+z(61)+z(4)*z(48))) + z(227)*(z(22)*z(28)*z(48)-lfz*z(7)*z(58)-lfz*z(20)*z(48)-z(15)*z(17)*z(27)-z(13)*z(27)*(z(19)+z(3)*z(58))) + z(234)*(lfx*z(7)*z(58)+lfx*z(20)*z(48)+z(15)*z(21)*z(27)-z(6)*z(27)*(z(19)+z(3)*z(58))-z(28)*(z(8)*z(58)+z(18)*z(48))) - z(30)*z(48)*z(185) - z(192)*(z(58)+z(4)*z(48)) - z(178)*(z(58)+z(61)+z(4)*z(48)) - z(205)*(z(7)*z(58)+z(20)*z(48)) - z(48)*z(219)*(lrx*z(22)+lrz*z(30)) - z(209)*(1+z(7)*z(58)+z(20)*z(48)) - z(231)*(lfx*z(22)*z(48)-lfz*z(8)*z(58)-lfz*z(18)*z(48)-z(3)*z(15)*z(27)*z(58)) - z(215)*(lrz*(z(58)+z(4)*z(48))-rrt*z(3)*z(5)*(z(58)+z(61))-rr*z(5)*(z(58)+z(61)+z(4)*z(48)));
z(251) = z(22)*z(48)*z(188) + z(22)*z(48)*z(200) + z(196)*(z(8)*z(58)+z(18)*z(48)) + z(221)*(lrx*(z(58)+z(4)*z(48))+rrt*z(3)*z(6)*(z(58)+z(61))+rr*z(6)*(z(58)+z(61)+z(4)*z(48))) + z(226)*(z(22)*z(28)*z(48)-lfz*z(7)*z(58)-lfz*z(20)*z(48)-z(15)*z(17)*z(27)-z(13)*z(27)*(z(19)+z(3)*z(58))) + z(235)*(lfx*z(7)*z(58)+lfx*z(20)*z(48)+z(15)*z(21)*z(27)-z(6)*z(27)*(z(19)+z(3)*z(58))-z(28)*(z(8)*z(58)+z(18)*z(48))) - z(30)*z(48)*z(184) - z(193)*(z(58)+z(4)*z(48)) - z(179)*(z(58)+z(61)+z(4)*z(48)) - z(204)*(z(7)*z(58)+z(20)*z(48)) - z(48)*z(218)*(lrx*z(22)+lrz*z(30)) - z(208)*(1+z(7)*z(58)+z(20)*z(48)) - z(229)*(lfx*z(22)*z(48)-lfz*z(8)*z(58)-lfz*z(18)*z(48)-z(3)*z(15)*z(27)*z(58)) - z(214)*(lrz*(z(58)+z(4)*z(48))-rrt*z(3)*z(5)*(z(58)+z(61))-rr*z(5)*(z(58)+z(61)+z(4)*z(48)));
z(261) = z(247)*z(252) - z(248)*z(251);
z(239) = Trw*z(59) + z(238)*z(20)*(lfx*z(6)-z(19)*z(27)-lfz*z(5)*z(7)-lfz*z(8)*z(56)-z(3)*z(15)*z(27)*z(56)) - z(237)*z(4)*(lrz*z(5)-rr-lrx*z(6)-rrt*z(3)) - z(238)*z(18)*(z(6)*z(28)+z(17)*z(27)+lfz*z(5)*z(8)-lfz*z(7)*z(56)-z(3)*z(13)*z(27)*z(56)) - z(237)*z(22)*(lrx*z(56)+rrt*z(21)+rrt*z(3)*z(6)*(z(56)+z(59))+rr*z(6)*(z(56)+z(59)+z(4)*z(46))) - z(237)*z(30)*(lrz*z(56)+rrt*z(29)-rrt*z(3)*z(5)*(z(56)+z(59))-rr*z(5)*(z(56)+z(59)+z(4)*z(46))) - z(238)*z(22)*(lfx*z(7)*z(56)-lfx*z(15)-z(21)*z(27)-z(3)*z(6)*z(27)*z(56)-z(28)*(z(13)+z(8)*z(56)));
z(182) = ICyy*z(3)*(z(46)*u1+z(47)*u3+z(48)*u5)*(z(57)*u3+z(60)*u3-z(56)*u1-z(58)*u5-z(59)*u1-z(61)*u5-z(4)*(z(46)*u1+z(47)*u3+z(48)*u5));
z(245) = z(3)*z(46)*z(181) + (z(13)+z(8)*z(56)+z(18)*z(46))*z(212) + (z(6)+z(22)*z(46))*z(190) + (z(6)+z(22)*z(46))*z(202) + (z(56)+z(4)*z(46))*z(194) + (z(5)-z(30)*z(46))*z(186) + (z(13)+z(8)*z(56)+z(18)*z(46))*z(198) + (z(15)-z(7)*z(56)-z(20)*z(46))*z(210) + (lfz*z(7)*z(56)+lfz*z(20)*z(46)+z(3)*z(13)*z(27)*z(56)-z(17)*z(27)-lfz*z(5)*z(8)-z(28)*(z(6)+z(22)*z(46)))*z(228) + (lfx*z(6)+lfx*z(22)*z(46)-z(19)*z(27)-lfz*z(5)*z(7)-lfz*z(8)*z(56)-lfz*z(18)*z(46)-z(3)*z(15)*z(27)*z(56))*z(232) - z(182) - (z(6)+z(22)*z(46))*z(211) - (z(56)+z(59)+z(4)*z(46))*z(180) - (z(15)-z(7)*z(56)-z(20)*z(46))*z(206) - (lrz*z(5)-rr-lrx*z(6)-rrt*z(3)-lrx*z(22)*z(46)-lrz*z(30)*z(46))*z(220) - (rrt*z(21)+lrx*(z(56)+z(4)*z(46))+rrt*z(3)*z(6)*(z(56)+z(59))+rr*z(6)*(z(56)+z(59)+z(4)*z(46)))*z(224) - (rrt*z(29)+lrz*(z(56)+z(4)*z(46))-rrt*z(3)*z(5)*(z(56)+z(59))-rr*z(5)*(z(56)+z(59)+z(4)*z(46)))*z(216) - (lfx*z(7)*z(56)+lfx*z(20)*z(46)-lfx*z(15)-z(21)*z(27)-z(3)*z(6)*z(27)*z(56)-z(28)*(z(13)+z(8)*z(56)+z(18)*z(46)))*z(236);
z(254) = -z(239) - z(245);
z(264) = z(243)*z(252) - z(244)*z(251);
z(240) = Ts + z(238)*z(22)*z(57)*(lfx*z(7)-z(8)*z(28)-z(3)*z(6)*z(27)) + z(237)*z(22)*(lrx*z(57)+rrt*z(3)*z(6)*(z(57)+z(60))+rr*z(6)*(z(57)+z(60)-z(4)*z(47))) + z(237)*z(30)*(lrz*z(57)-rrt*z(3)*z(5)*(z(57)+z(60))-rr*z(5)*(z(57)+z(60)-z(4)*z(47))) - Trw*z(60) - z(238)*z(18)*(z(28)+lfz*z(7)*z(57)+z(6)*z(17)*z(27)+z(13)*z(27)*(z(21)+z(3)*z(57))) - z(238)*z(20)*(z(6)*z(19)*z(27)-lfx-lfz*z(8)*z(57)-z(15)*z(27)*(z(21)+z(3)*z(57)));
z(249) = z(3)*z(47)*z(181) + z(22)*z(47)*z(190) + (1+z(22)*z(47))*z(202) + (z(7)*z(57)-z(20)*z(47))*z(210) + (z(57)+z(60)-z(4)*z(47))*z(180) + z(47)*(lrx*z(22)+lrz*z(30))*z(220) + (lfx*z(7)*z(57)-lfx*z(20)*z(47)-z(3)*z(6)*z(27)*z(57)-z(28)*(z(8)*z(57)-z(18)*z(47)))*z(236) + (lrx*(z(57)-z(4)*z(47))+rrt*z(3)*z(6)*(z(57)+z(60))+rr*z(6)*(z(57)+z(60)-z(4)*z(47)))*z(224) + (lrz*(z(57)-z(4)*z(47))-rrt*z(3)*z(5)*(z(57)+z(60))-rr*z(5)*(z(57)+z(60)-z(4)*z(47)))*z(216) + (lfz*z(20)*z(47)-lfz*z(7)*z(57)-z(6)*z(17)*z(27)-z(28)*(1+z(22)*z(47))-z(13)*z(27)*(z(21)+z(3)*z(57)))*z(228) - (1+z(22)*z(47))*z(211) - (z(8)*z(57)-z(18)*z(47))*z(212) - z(30)*z(47)*z(186) - (z(57)-z(4)*z(47))*z(194) - (z(7)*z(57)-z(20)*z(47))*z(206) - (z(8)*z(57)-z(18)*z(47))*z(198) - (lfz*z(18)*z(47)+z(6)*z(19)*z(27)-lfx-lfx*z(22)*z(47)-lfz*z(8)*z(57)-z(15)*z(27)*(z(21)+z(3)*z(57)))*z(232);
z(255) = -z(240) - z(249);
z(120) = z(5) - z(30)*z(46);
z(128) = z(6) + z(22)*z(46);
z(187) = -IDxz*z(120) - IDzz*z(128);
z(135) = z(13) + z(8)*z(56) + z(18)*z(46);
z(199) = -IExz*z(135) - IEzz*z(128);
z(195) = -IExx*z(135) - IExz*z(128);
z(158) = -rrt*z(21) - lrx*(z(56)+z(4)*z(46)) - rrt*z(3)*z(6)*(z(56)+z(59)) - rr*z(6)*(z(56)+z(59)+z(4)*z(46));
z(222) = mr*z(158);
z(165) = lfz*z(7)*z(56) + lfz*z(20)*z(46) + z(3)*z(13)*z(27)*z(56) - z(17)*z(27) - lfz*z(5)*z(8) - z(28)*(z(6)+z(22)*z(46));
z(225) = mf*z(165);
z(173) = lfx*z(15) + z(21)*z(27) + z(3)*z(6)*z(27)*z(56) + z(28)*(z(13)+z(8)*z(56)+z(18)*z(46)) - lfx*z(7)*z(56) - lfx*z(20)*z(46);
z(233) = mf*z(173);
z(183) = -IDxx*z(120) - IDxz*z(128);
z(124) = z(56) + z(4)*z(46);
z(191) = IDyy*z(124);
z(108) = z(56) + z(59) + z(4)*z(46);
z(177) = ICyy*z(108);
z(139) = z(7)*z(56) + z(20)*z(46) - z(15);
z(203) = IEyy*z(139);
z(153) = rr + lrx*z(6) + rrt*z(3) + lrx*z(22)*z(46) + lrz*z(30)*z(46) - lrz*z(5);
z(217) = mr*z(153);
z(207) = IFyy*z(139);
z(170) = lfx*z(6) + lfx*z(22)*z(46) - z(19)*z(27) - lfz*z(5)*z(7) - lfz*z(8)*z(56) - lfz*z(18)*z(46) - z(3)*z(15)*z(27)*z(56);
z(230) = mf*z(170);
z(149) = rrt*z(29) + lrz*(z(56)+z(4)*z(46)) - rrt*z(3)*z(5)*(z(56)+z(59)) - rr*z(5)*(z(56)+z(59)+z(4)*z(46));
z(213) = mr*z(149);
z(250) = z(22)*z(48)*z(187) + z(22)*z(48)*z(199) + z(195)*(z(8)*z(58)+z(18)*z(48)) + z(222)*(lrx*(z(58)+z(4)*z(48))+rrt*z(3)*z(6)*(z(58)+z(61))+rr*z(6)*(z(58)+z(61)+z(4)*z(48))) + z(225)*(z(22)*z(28)*z(48)-lfz*z(7)*z(58)-lfz*z(20)*z(48)-z(15)*z(17)*z(27)-z(13)*z(27)*(z(19)+z(3)*z(58))) + z(233)*(lfx*z(7)*z(58)+lfx*z(20)*z(48)+z(15)*z(21)*z(27)-z(6)*z(27)*(z(19)+z(3)*z(58))-z(28)*(z(8)*z(58)+z(18)*z(48))) - z(30)*z(48)*z(183) - z(191)*(z(58)+z(4)*z(48)) - z(177)*(z(58)+z(61)+z(4)*z(48)) - z(203)*(z(7)*z(58)+z(20)*z(48)) - z(48)*z(217)*(lrx*z(22)+lrz*z(30)) - z(207)*(1+z(7)*z(58)+z(20)*z(48)) - z(230)*(lfx*z(22)*z(48)-lfz*z(8)*z(58)-lfz*z(18)*z(48)-z(3)*z(15)*z(27)*z(58)) - z(213)*(lrz*(z(58)+z(4)*z(48))-rrt*z(3)*z(5)*(z(58)+z(61))-rr*z(5)*(z(58)+z(61)+z(4)*z(48)));
z(242) = z(187)*(z(6)+z(22)*z(46)) + z(199)*(z(6)+z(22)*z(46)) + z(183)*(z(5)-z(30)*z(46)) + z(195)*(z(13)+z(8)*z(56)+z(18)*z(46)) + z(203)*(z(15)-z(7)*z(56)-z(20)*z(46)) + z(207)*(z(15)-z(7)*z(56)-z(20)*z(46)) + z(217)*(lrz*z(5)-rr-lrx*z(6)-rrt*z(3)-lrx*z(22)*z(46)-lrz*z(30)*z(46)) + z(222)*(rrt*z(21)+lrx*(z(56)+z(4)*z(46))+rrt*z(3)*z(6)*(z(56)+z(59))+rr*z(6)*(z(56)+z(59)+z(4)*z(46))) + z(233)*(lfx*z(7)*z(56)+lfx*z(20)*z(46)-lfx*z(15)-z(21)*z(27)-z(3)*z(6)*z(27)*z(56)-z(28)*(z(13)+z(8)*z(56)+z(18)*z(46))) - z(191)*(z(56)+z(4)*z(46)) - z(177)*(z(56)+z(59)+z(4)*z(46)) - z(213)*(rrt*z(29)+lrz*(z(56)+z(4)*z(46))-rrt*z(3)*z(5)*(z(56)+z(59))-rr*z(5)*(z(56)+z(59)+z(4)*z(46))) - z(225)*(lfz*z(7)*z(56)+lfz*z(20)*z(46)+z(3)*z(13)*z(27)*z(56)-z(17)*z(27)-lfz*z(5)*z(8)-z(28)*(z(6)+z(22)*z(46))) - z(230)*(lfx*z(6)+lfx*z(22)*z(46)-z(19)*z(27)-lfz*z(5)*z(7)-lfz*z(8)*z(56)-lfz*z(18)*z(46)-z(3)*z(15)*z(27)*z(56));
z(246) = z(22)*z(47)*z(187) + z(199)*(1+z(22)*z(47)) + z(191)*(z(57)-z(4)*z(47)) + z(177)*(z(57)+z(60)-z(4)*z(47)) + z(203)*(z(7)*z(57)-z(20)*z(47)) + z(207)*(z(7)*z(57)-z(20)*z(47)) + z(213)*(lrz*(z(57)-z(4)*z(47))-rrt*z(3)*z(5)*(z(57)+z(60))-rr*z(5)*(z(57)+z(60)-z(4)*z(47))) + z(230)*(lfz*z(18)*z(47)+z(6)*z(19)*z(27)-lfx-lfx*z(22)*z(47)-lfz*z(8)*z(57)-z(15)*z(27)*(z(21)+z(3)*z(57))) - z(30)*z(47)*z(183) - z(47)*z(217)*(lrx*z(22)+lrz*z(30)) - z(195)*(z(8)*z(57)-z(18)*z(47)) - z(222)*(lrx*(z(57)-z(4)*z(47))+rrt*z(3)*z(6)*(z(57)+z(60))+rr*z(6)*(z(57)+z(60)-z(4)*z(47))) - z(233)*(lfx*z(7)*z(57)-lfx*z(20)*z(47)-z(3)*z(6)*z(27)*z(57)-z(28)*(z(8)*z(57)-z(18)*z(47))) - z(225)*(lfz*z(20)*z(47)-lfz*z(7)*z(57)-z(6)*z(17)*z(27)-z(28)*(1+z(22)*z(47))-z(13)*z(27)*(z(21)+z(3)*z(57)));
z(257) = z(242)*z(247) - z(243)*z(246);
z(258) = z(242)*z(248) - z(244)*z(246);
z(260) = z(250)*z(259) + z(252)*z(257) - z(251)*z(258);
z(267) = (z(259)*z(256)+z(261)*z(254)-z(264)*z(255))/z(260);
u1p = z(267);
z(262) = z(246)*z(252) - z(248)*z(250);
z(265) = z(242)*z(252) - z(244)*z(250);
z(268) = (z(258)*z(256)+z(262)*z(254)-z(265)*z(255))/z(260);
u3p = -z(268);
z(263) = z(246)*z(251) - z(247)*z(250);
z(266) = z(242)*z(251) - z(243)*z(250);
z(269) = (z(257)*z(256)+z(263)*z(254)-z(266)*z(255))/z(260);
u5p = z(269);

% Update derivative array prior to integration step
dxdt(1) = q0p;
dxdt(2) = q1p;
dxdt(3) = q2p;
dxdt(4) = q3p;
dxdt(5) = q4p;
dxdt(6) = q5p;
dxdt(7) = q6p;
dxdt(8) = q7p;
dxdt(9) = u1p;
dxdt(10) = u3p;
dxdt(11) = u5p;
