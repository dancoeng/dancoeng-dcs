clear all
nit = 2000;
h = 1; fe = 0.97;%input('fator de esquecimento?');
%onda quadrada de período 100 segundo
for i = 1:nit
    u1 = sin(2*pi*(1/100)*i*h);
    if u1 >= 0
       w(i) = 1;
    else
       w(i) = -1;
    end
end
% sinal aleatório de amplitude entre -1 e 1
for i = 1:nit
    if rand > 0.5
       u(i)= 1;
    else
       u(i)= -1;
    end
end
e = u*0.2; %  ruido de amplitude entre -0.2 e 0.2
%************************************************************
p = 1000*eye(2); teta = [0;0]; % inicializa matriz de covariância e teta NOVO
for t = 1:1  %inicializa: vetor Y, vetor erro e coeficientes ais e bis
y(t)=0; erro(t) = 0; a1(t) = teta(1);  bo(t) = teta(2);   
end
kg = []; Bo = 0.04758;
%*************************************************************
for t = 1:2
    ym(t)=0;  g(t)=0; f(t)=0; ymf(t)=0;  erropm(t)=0; ucon(t)=0; w(t)=0;
end
Bo = 0.04758; gama = 0.8;  am = 0.6065; bm = 0.3935;
%*************************************************************
for t = 2:nit
    y(t) = 0.9048*y(t-1) + Bo*w(t-1) + e(t);
    fi = [-y(t-1);u(t-1)];%passo 2
    erro(t) = y(t) - teta'*fi; %passo 3
    k = p*fi/(fe + fi'*p*fi);% passo 4
       kg = [kg k]; %apenas para tracar o gráficco de k
    teta = teta + k*erro(t);% passo 5
    p = (1/fe)*(p - k*fi'*p);%passo 6
    a1(t) = teta(1);  bo(t) = teta(2); 
%*************************************************************
if t>=3
   ym(t) = am*ym(t-1) + bm*w(t-1);%modelo
   %ymf(t) = 0.9048*ymf(t-1) + Bo*ucon(t-1); %planta  real em malha fechada
    ymf(t) = a1(t)*ymf(t-1) + bo(t)*ucon(t-1); %planta  real em malha fechada
   erropm(t) = ymf(t) - ym(t);% sinal de erro entre a panta e o modelo
   g(t) = g(t-1)*(1-am) + am*g(t-2) - gama*w(t-2)*erropm(t-1);
   f(t) = f(t-1)*(1-am) + am*f(t-2) + gama*ymf(t-2)*erropm(t-1);
   ucon(t) = -f(t)*ymf(t) + g(t)*w(t); %AÇÃO DE CONTROLE
end
end
t = 1:nit;gms=tf(1,[2 1]); gmz=c2d(gms,h,'zoh'); ymodelo = lsim(gmz,w,t);
figure(1);plot(t,ymodelo,t,ymf);title('resposta do modelo e em malha fechada'), xlabel('amostragem');grid;
%************************************************************
t = 1:nit;
figure(2);subplot(221),plot(kg(1,:));
subplot(222),plot(kg(2,:));
subplot(223),plot(t,a1(t)),title('a1'),xlabel('amostragem');grid;
subplot(224),plot(t,bo(t)),title('bo'),xlabel('amostragem');grid;
