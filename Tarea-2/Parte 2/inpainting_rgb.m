clear;clc; close all

pkg load image

% Carga imagen original
I1 = imread('selfie2.jpg');

subplot(1,2,1)
imshow(I1)
title('Imagen Original','FontSize',16)


% Creación de marca
I2 = imread('mask2.jpg');
I2(I2 < 50) = 0; I2(I2 >= 50) = 255;


% valores del kernel
a = 0.073235;
b = 0.176765;

kernel = [a b a; 
          b 0 b; 
          a b a];

% Encuentra los puntos en donde se debe realizar la convolución.
where_conv = find(I2);

R = I1(:, :, 1);
G = I1(:, :, 2);
B = I1(:, :, 3);

last_diff = inf;

it = 0;

% se realiza el procedimiento 10 veces.
while(true)
    % se convoluciona toda la imagen
    conv_red = conv2(R, kernel, "same");
    conv_green = conv2(G, kernel, "same");
    conv_blue = conv2(B, kernel, "same");
    
    % Calcula la sumatoria de los pixeles en la imagen reconstruida actual.
    current_sum = sum(R(where_conv));
    % Calcula la sumatoria de los pixeles en la convolución
    conv_sum = sum(conv_red(where_conv));
    % diferencia entre las sumatorias
    diff = abs(current_sum - conv_sum);
    
    % con la diferencia se sabe si ya se llegó a un valor de convergencia.
    if(floor(last_diff) == floor(diff))
      break;
    else
      % si no ha convergido se sigue convolucionando la imagen.
      last_diff = diff;
      % solo se toman los puntos que abarca la máscara en los tres canales.
      R(where_conv) = conv_red(where_conv);
      G(where_conv) = conv_green(where_conv);
      B(where_conv) = conv_blue(where_conv);
      % actualiza número de iteraciones.
      it++;
    endif
endwhile

% se construye una imagen RGB con el resultado.
I4 = cat(3, R, G, B);

subplot(1,2,2)
imshow(I4)
title(["Imagen Restaurada con " num2str(it) " iteraciones"],'FontSize',16)



