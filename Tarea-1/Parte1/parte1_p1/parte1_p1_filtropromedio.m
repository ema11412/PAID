clc; clear; close all; %Limiar la linea de comandos
pkg load image; %Cargar el paquete de imagenes

function Y = filtroprom(A)
    %Esta función le aplica el filtro de la mediana a una imagen ya cargada "A"
    %
    %Sintaxis:  Y = mediana(A)
    % 
    %Parámetros Iniciales: 
    %             A = una imagen con ruido
    %    
    %Parámetros de Salida:                           
    %             Y = una imagen sin ruido            
    %
    %
  [m,n,i] = size(A);
  k=3;
  B=(1/k^2)*ones(k); %ones(k) crea un matriz de kxk de 1's
  A = double(A);
  for i=1:10
    A(:,:,1) = conv2(A(:,:,1),B,'same');
    A(:,:,2) = conv2(A(:,:,2),B,'same');
    A(:,:,3) = conv2(A(:,:,3),B,'same');
  endfor
  Y = A;
  size(Y)
  Y= uint8(Y);
 endfunction
 
A=imread('imagen1.jpg'); %cargar la imagen con ruido
subplot(1,2,1);
imshow(A);
title('Imagen Original');
Y=filtroprom(A); %Aplicarle el filtro de la mediana, el resutado queda en y

subplot(1,2,2);
imshow(Y); %Mostrar el resultado 'y', imagen sin ruido
title('Filtro promedio');