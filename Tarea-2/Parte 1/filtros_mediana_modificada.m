clc; clear; close all; %Limpiar la linea de comandos
pkg load image; %Cargar el paquete de imagenes
pkg load video; %Cargar paquete de video

function Y = DP_FMFA(I)
    %Esta funcion le aplica el filtro de la mediana utilizando el metodo Fast Median Filter Approximation
    % a un frame/imagen "I". Este es mas rapido que el filtro de la mediana utilizado en la primera tarea.
    %
    %Sintaxis:  Y = FMFA(I)
    % 
    %Parametros Iniciales: 
    %             I = un frame/imagen con ruido
    %    
    %Parametros de Salida:                           
    %             Y = un frame/imagen con ruido reducido            
    %
    %
  Y=border_corner(I);
  [r,c,k]=size(I); %Los parametros de largo y ancho del frame
  c1 = [0;0;0];
  c2 = [0;0;0];
  c3 = [0,0,0];
##  tic
  for x=2:r-1
    c1=median(I(x-1:x+1,1,:));
    c2=median(I(x-1:x+1,2,:));
    for y = 2:c-1
        c3=median(I(x-1:x+1,y+1,:));
        Y(x,y,:) = median([c1 c2 c3]);
        c1=c2;
        c2=c3;
    endfor
  endfor
##  toc
endfunction

function Y =  IAMFA_I(I)
    %Otro metodo para limpiar frames/imagenes que mejora los resultados comparado al metodo DP.
    %Es más lento que DP pero, sigue siendo más rápido que el filtro de la mediana.
    %
    %Sintaxis:  Y =  IAMFA-I(I)
    % 
    %Parametros Iniciales: 
    %             I = un frame/imagen con ruido
    %    
    %Parametros de Salida:                           
    %             Y = un frame/imagen con ruido reducido            
    %
    %
  [r,c,k]=size(I); %Los parametros de largo y ancho del frame
  Y=border_corner(I);
  c1 = [0;0;0];
  c2 = [0;0;0];
  c3 = [0,0,0];
##  tic
  for x=2:r-1
    c1=MVDM(I(x-1:x+1,1,:));
    c2=MVDM(I(x-1:x+1,2,:));
    for y=2:c-1
      c3=MVDM(I(x-1:x+1,y+1,:));
      Y(x,y,:)=MVDM([c1; c2; c3]);
      c1 = c2;
      c2 = c3;
    endfor
  endfor
##  toc
endfunction

function R = MVDM(P)
    %Esta funcion calcula el valor mediano a devolver, es una mejora a la decision que normamente se realiza
    %Las sigals significan en ingles Mid Value DecisionMedian
    % Decision de mediana del valor medio
    %Sintaxis:  R = MVDM(V)
    % 
    %Parametros Iniciales: 
    %             P = los valores a tomar en cuenta para el mediano
    %    
    %Parametros de Salida:                           
    %             R = los nuevos valores del pixel
    %
    %
    P = sort(P,1);%Ordenar P de menor a mayor de todos los colores, es similar a Quicksort
    R = zeros(1,1,3);
    for i = 1:3
      if P(2,1,i)==255  %P1 si P2 = 255
         R(1,1,i)=P(1,1,i);
      elseif P(2,1,i)==0%P3 si P2 = 0
         R(1,1,i)=P(3,1,i);
      else              %P2 si 0 < P2 < 255
         R(1,1,i)=P(2,1,i);
      endif
    endfor
endfunction

function Y = border_corner(I)
    %El metodo para calcular las esquinas y los bordes de la imagen
    %Este se hace por medio del filtro de la mediana
    %
    %Sintaxis:  Y =  border_corner(I)
    % 
    %Parametros Iniciales: 
    %             I = un frame/imagen con ruido
    %    
    %Parametros de Salida:                           
    %             Y = un frame/imagen con ruido reducido en los bordes y las esquinas            
    %
    %
    [r,c,k]=size(I); %Los parametros de largo y ancho del frame
    Y=zeros(r,c,k); %Crear una matriz de 0's
    Y(1,1,:)=[median(I(1:2,1:2,1)(:)),median(I(1:2,1:2,2)(:)),median(I(1:2,1:2,3)(:))]; % esquina superior derecha
    Y(r,1,:)=[median(I(r-1:r,1:2,1)(:)),median(I(r-1:r,1:2,2)(:)),median(I(r-1:r,1:2,3)(:))];% esquina superior izquierda
    Y(1,c,:)=[median(I(1:2,c-1:c,1)(:)),median(I(1:2,c-1:c,2)(:)),median(I(1:2,c-1:c,3)(:))]; % esquina inferior derecha
    Y(r,c,:)=[median(I(r-1:r,c-1:c,1)(:)),median(I(r-1:r,c-1:c,2)(:)),median(I(r-1:r,c-1:c,3)(:))];% esquina inferior izquierda
    for x = 2:r-1
      Y(x,1,:)=[median(I(x-1:x+1,1:2,1)(:)),median(I(x-1:x+1,1:2,2)(:)),median(I(x-1:x+1,1:2,3)(:))];
      Y(x,c,:)=[median(I(x-1:x+1,c-1:c,1)(:)),median(I(x-1:x+1,c-1:c,2)(:)),median(I(x-1:x+1,c-1:c,3)(:))];
    endfor
    for y = 2:c-1
      Y(1,y,:)=[median(I(1:2,y-1:y+1,1)(:)),median(I(1:2,y-1:y+1,2)(:)),median(I(1:2,y-1:y+1,3)(:))];
      Y(r,y,:)=[median(I(r-1:r,y-1:y+1,1)(:)),median(I(r-1:r,y-1:y+1,2)(:)),median(I(r-1:r,y-1:y+1,3)(:))];
    endfor
    Y = uint8(Y);
endfunction





############################################################Primer Algoritmo
v  = VideoReader('../Parte 1/videos/video_con_ruido.mp4'); %Cargar video
fr = v.NumberOfFrames; % cantidad de frames
m = v.Height; % dimensiones
n = v.Width;
Y1 = uint8(zeros(m, n, 3, fr)); %Convertir a formato 8bits
%Aplicar el filtro DP
for i = 1 : fr
  Vr = readFrame(v);
  Y1(:,:,:,i)= DP_FMFA(Vr(:,:,:));
end
%Creacion del video sin ruido 1
video = VideoWriter('../Parte 1/videos/video_sin_ruido_alg1.mp4'); %Escribir el video 
for i = 1 : fr
    writeVideo(video, Y1(:,:,:, i)); %Escribir el video
end
close(video)

##############################################################Segundo Algoritmo
v  = VideoReader('../Parte 1/videos/video_con_ruido.mp4'); %Cargar video
fr = v.NumberOfFrames; % cantidad de frames
m = v.Height; % dimensiones
n = v.Width;
Y2 = uint8(zeros(m, n, 3, fr)); %Convertir a formato 8bits
%Aplicar el filtro IAMFA-I
for i = 1 : fr
  Vr = readFrame(v);
  Y2(:,:,:,i)= IAMFA_I(Vr(:,:,:));
end
%Creacion del video sin ruido 2
video = VideoWriter('../Parte 1/videos/video_sin_ruido_alg2.mp4'); %Escribir el video 
for i = 1 : fr
    writeVideo(video, Y2(:,:,:, i)); %Escribir el video
end
close(video)