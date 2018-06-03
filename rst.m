%%Planta
%%num=3.2;
%den=[0.377 1];
%gps=tf(num,den);
%h1=0.0377;
%gpz=c2d(gps,h1,'zoh');
%%Malha
%num2=1;
%den2=[0.2 1];
%gms=tf(num2,den2);
%h2=0.02;
%gmz=c2d(gms,h2,'zoh');
%%----------------------------%%
  clear;
  gps = tf(3.2,[0.377 1]);   % planta contínua
  h = 0.0377; gpz = c2d(gps,h,'zoh'); gpz2 = zpk(gpz);  % equivalente ZOH da planta
% parâmetros da planta para o projeto RST
% Polinomio A (Denominador da funçao de transferencia Pulsada da Planta)
   A = gpz.den{:}; a1 = A(1); a2 = A(2);
   Kp = gpz2.k;
% modelo contínuo desejado

  tau = 0.2; km = 1; gms = tf(km,[tau 1]);
  gmz = c2d(gms,h,'zoh'); gmz2 = zpk(gmz);  % equivalente ZOH do modelo desejado
% ajuste no mdelo ZOH para exemplo Astrom
% Polinomio Am (Denominador da funçao de transferencia Pulsada do Modelo)
  Am = gmz.den{:}; po = Am(1); p1 = Am(2);
% parâmetros do modelo para o projeto RST
  Km = gmz2.k;
% parâmetros do controlador RST
  ro = 1/a1;     so = (p1-a2*ro+ro*a1)/Kp;     s1 = (a2*ro)/Kp;
% polinômios do controlador RST
  Tz = [Km/Kp 0];Rz = ro*[1 -1]; Sz = [so s1];
% Teste via simulação
   B = gpz.num{:}; B = B(2);  % Numerador da função de transferência da planta
% Função de transferência de malha fechada
  AR = conv(A,Rz);     BS = conv(B,Sz);     BT = conv(B,Tz);
  ARmaisBS = AR + [0 BS];
  Gmfz = tf(BT,ARmaisBS,h); Gmfz2 = zpk(Gmfz);
  figure(1); step(Gmfz);grid on; title('resposta de malha fechada')
  TA = conv(A,Tz);
  Gmfzu = tf(TA,ARmaisBS,h);
  erro= Gmfz-gmz;
  figure(2); step(gpz,'r',erro,'g',Gmfz,'b'); grid on; title('resposta do modelo')
figure(3); step(gmz,'g');grid on;