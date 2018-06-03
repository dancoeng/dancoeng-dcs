%%mr2
clear
nit = 200;
h = 1;
for t = 1:nit
    %onda quadrada de per�odo 100 segundo
    u1 = sin(2*pi*(1/100)*t*h);
    if u1 >= 0
       w(t) = 1;
    else
       w(t) = -1;
    end
    % sinal aleat�rio de amplitude entre -1 e 1
    if rand > 0.5
       u(t)= 1;
    else
       u(t)= -1;
    end
    e = u*0.2; %  ruido de amplitude entre -0.2 e 0.2
    Ao=0.9048; Bo = 0.04758; gama = 0.79;  am = 0.6159; bm = 2.193;
    if t<3
        ym(t)=0;  g(t)=0; f(t)=0; ymf(t)=0;  erropm(t)=0; ucon(t)=0; w(t)=0;
    else
        ym(t) = am*ym(t-1) + bm*w(t-1);%modelo
        ymf(t) = Ao*ymf(t-1) + Bo*ucon(t-1); %planta  real em malha fechada
        erropm(t) = ymf(t) - ym(t);% sinal de erro entre a panta e o modelo
        g(t) = g(t-1)*(1-am) + am*g(t-2) - gama*w(t-2)*erropm(t-1);
        f(t) = f(t-1)*(1-am) + am*f(t-2) + gama*ymf(t-2)*erropm(t-1);
        ucon(t) = -f(t)*ymf(t) + g(t)*w(t); %A��O DE CONTROLE
    end
end
gms=tf(1,[2 1]); gmz=c2d(gms,h,'zoh'); ymodelo = lsim(gmz,w,t);
plot(t,ymodelo,t,ymf);title('resposta do modelo e em malha fechada'),xlabel('amostragem');grid;