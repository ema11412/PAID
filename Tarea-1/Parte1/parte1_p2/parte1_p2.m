clc; clear; close all; %Limiar la linea de comandos
pkg load image; %Cargar el paquete de imagenes
pkg load video; %Cargar paquete de video 

function Y = mediana(A)
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
  Y=A;
  [m,n,i]=size(A); %Los parametros de largo y ancho de la imagen
  for x= 1:m
    for y=1:n
       if (y == 1 && x == 1) %Esquina superior izquierda
         Y(x,y,1)= median(A(1:4,1:4,1)'(:)); % aplica la tanspuesta, esto para convertir la matriz en vector
         Y(x,y,2)= median(A(1:4,1:4,2)'(:)); % ya que esto es lo que recibe la funcion median 
         Y(x,y,3)= median(A(1:4,1:4,3)'(:)); % Se hace tres veces debido a que son 3 canales
       elseif(y == 1 && x == m) %Esquina superior derecha
         Y(x,y,1)= median(A(m-4:m,1:4,1)'(:));
         Y(x,y,2)= median(A(m-4:m,1:4,2)'(:));% Se hace tres veces debido a que son 3 canales
         Y(x,y,3)= median(A(m-4:m,1:4,3)'(:));
       elseif(y == n && x == 1) %Esquina inferior izquierda
         Y(x,y,1)= median(A(1:4,n-4:n,1)'(:));
         Y(x,y,2)= median(A(1:4,n-4:n,2)'(:));% Se hace tres veces debido a que son 3 canales
         Y(x,y,3)= median(A(1:4,n-4:n,3)'(:));
       elseif(y == n && x == m) %Esquina inferior derecha
         Y(x,y,1)= median(A(m-4:m,n-4:n,1)'(:));
         Y(x,y,2)= median(A(m-4:m,n-4:n,2)'(:));% Se hace tres veces debido a que son 3 canales
         Y(x,y,3)= median(A(m-4:m,n-4:n,3)'(:));
       elseif(y == 1) %Borde superior
         Y(x,y,1)= median(A(x-1:x+1,y:y+1,1)'(:));
         Y(x,y,2)= median(A(x-1:x+1,y:y+1,2)'(:));% Se hace tres veces debido a que son 3 canales
         Y(x,y,3)= median(A(x-1:x+1,y:y+1,3)'(:));
       elseif(x == 1) %Borde izquierdo
         Y(x,y,1)= median(A(x:x+1,y-1:y+1,1)'(:));
         Y(x,y,2)= median(A(x:x+1,y-1:y+1,2)'(:));% Se hace tres veces debido a que son 3 canales
         Y(x,y,3)= median(A(x:x+1,y-1:y+1,3)'(:));
       elseif(y == n) %Borde inferior
         Y(x,y,1)= median(A(x-1:x+1,y-1:y,1)'(:));
         Y(x,y,2)= median(A(x-1:x+1,y-1:y,2)'(:));% Se hace tres veces debido a que son 3 canales
         Y(x,y,3)= median(A(x-1:x+1,y-1:y,3)'(:));
       elseif(x == m) %Borde derecho
         Y(x,y,1)= median(A(x-1:x,y-1:y+1,1)'(:));
         Y(x,y,2)= median(A(x-1:x,y-1:y+1,2)'(:));% Se hace tres veces debido a que son 3 canales
         Y(x,y,3)= median(A(x-1:x,y-1:y+1,3)'(:));
       else %Los demas casos
         Y(x,y,1)= median(A(x-1:x+1,y-1:y+1,1)'(:));
         Y(x,y,2)= median(A(x-1:x+1,y-1:y+1,2)'(:));% Se hace tres veces debido a que son 3 canales
         Y(x,y,3)= median(A(x-1:x+1,y-1:y+1,3)'(:));
     endif
    endfor
  endfor
 endfunction

v  = VideoReader('video_con_ruido.mp4'); %Cargar video

fr = v.NumberOfFrames; % cantidad de frames
nf = v.Height; % dimensiones
nc = v.Width;
m = round(nf); % redimensión de video.
n = round(nc);

Y = uint8(zeros(m, n, 3, fr)); %Convertir a formato 8bits
fr
% Leer el video y guardar los frames en la matriz Y.
for i = 1 : fr
    i
    Z1 = readFrame(v);
    Y(:, :, :, i) = imresize(Z1(:, :, :), [m n]); % Leer un frame
    Y(:, :, :, i) = mediana(Y(:, :, :, i)); %Aplicar el filtro de la mediana
end

% Crear un video a partir de un conjunto de imágenes en Y
video = VideoWriter('video_sin_ruido.mp4'); %Escribir el video 

for i = 1 : fr
    writeVideo(video, Y(:,:,:, i)); %Escribir el video
end

close(video)

