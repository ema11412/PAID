clc; clear; close all
pkg load image;
function [F,Fplot] = DFT_2D(A)
  #Función discreta de fourier
  #Esta función esta basada en el paper:
  #Complex and hypercomplex discrete Fourier transforms based on matrix exponential form of Euler’s formula
  #Busca utilizar la formula de Euler para calcula la transformada discreta de fourier
  #
  #Los parametros a recibir es la imagen A, la cual se le desea calcular la frecuencia
  #
  #Las salidas son F y Fplot, cada una de las entradas de F es una matriz 4x4
  #Fplot es la matriz una vez que se le aplique la norma 2 de octave, esto para poder graficar la respuesta
  [m n _] = size(A);
  F=zeros(m,n,4,4);
  Fplot=zeros(m,n);
  sqrtmn = 1/sqrt(m*n);
  [J1 J2] = parte2_p1();
  J=J1;
  #Valores en la Matriz F
  I_4 = eye(4);
  for u=1:m
    for v=1:n
      #Sumatorias
      for r=0:m-1
        E1 = Ematrix(r,u,m,I_4,J);
        for s=0:n-1
          AuxF = E1*Fmatrix(A(r+1,s+1,:))*Ematrix(s,v,n,I_4,J);
          AuxF=reshape(AuxF,1,1,4,4);
          F(u,v,:,:)=F(u,v,:,:)+AuxF;
        endfor
      endfor
      F(u,v,:,:)=F(u,v,:,:)*sqrtmn;
      Fplot(u,v)=norm(reshape(F(u,v,:,:),4,4),2);
    endfor
  endfor
endfunction

function F = Fmatrix(A)
  #Calculo de F, descrito en el paper
  #En este caso cada entrada es una parte diferente del canal de colores
  #La entrada es un pixel de la imagen en todos sus colores
  #La salida es una matriz de 4x4
  F = [0 -A(1) -A(2) -A(3);
       A(1) 0 -A(3) A(2);
       A(2) A(3) 0  -A(1);
       A(3) -A(2) A(1) 0];
endfunction

function E = Ematrix(p,q,r,I_4,J)
  #Calculo de E, las entradas (p,q,r) son parte de la exuación descrita ene el paper
  #I_4 es la matriz identidad de 4x4 y J es de manera que J^2=-I_4
  #La salida es una matriz que utiliza la formula de Euler
  E = I_4*cos(2*pi*((p*q)/r))+J*sin(2*pi*((p*q)/r));
  #I4cos(2pi(pq/r))-Jsin(2pi(pq/r))
endfunction

#Donde se comienza el programa
#Leer la imagen
A = imread('lena.jpg');
subplot(1,2,1)
imshow(A)
title('Imagen')
A = im2double(A);
#Aplicar la transformada
[F Fplot]=DFT_2D(A);
Fplot=fftshift(Fplot);
#Mostrar el resultado
subplot(1,2,2)
imshow(log(1+Fplot),[])
title('Frecuencia de la imagen')