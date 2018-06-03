clear,clc
%planta a ser controlada
gs=tf(2.7657,[0.4846 1]);h=1;gpz=c2d(gs,h,'zoh');figure(1);step(gpz),title('planta em malha aberta');
%modelo a ser seguido
pause(1)
gms=tf(5.71,[2.0636 1]);gmz=c2d(gms,h,'zoh');step(gmz),%title('modelo a ser seguido');
gpz
gmz