clear;clc; close all

pkg load image

% Carga imagen original
I1 = imread('paisaje.jpg');

% Creación de marca
I2 = imread('marca.jpg');
I2(I2 < 50) = 0; I2(I2 >= 50) = 255;


%Imagen a Restaurar: I3
I3 = I1 + I2;
subplot(1,2,1)
imshow(I3)
title('Imagen por Restaurar','FontSize',16)

% valores del kernel
a = 0.073235;
b = 0.176765;

kernel = [a b a; 
          b 0 b; 
          a b a];

% Encuentra los puntos en donde se debe realizar la convolución (busca que indices son != 0).
where_conv = find(I2);

last_diff = inf;
it = 0;

% se realiza el procedimiento 10 veces.
while(true)
    % se convoluciona toda la imagen
    conv_img = conv2(I3, kernel, "same");
    
    % Calcula la sumatoria de los pixeles en la imagen reconstruida actual.
    current_sum = sum(I3(where_conv));
    % Calcula la sumatoria de los pixeles en la convolución
    conv_sum = sum(conv_img(where_conv));
    % diferencia entre las sumatorias
    diff = abs(current_sum - conv_sum);
    
    % con la diferencia se sabe si ya se llegó a un valor de convergencia.
    if(last_diff == diff)
      break;
    else
      % si no ha convergido se sigue convolucionando la imagen.
      last_diff = diff;
      % solo se toman los puntos que abarca la máscara.
      I3(where_conv) = conv_img(where_conv);
      % actualiza número de iteraciones.
      it++;
    endif
endwhile

subplot(1,2,2)
imshow(I3)
title(["Imagen Restaurada con " num2str(it) " iteraciones"],'FontSize',16)

