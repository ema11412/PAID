clc; clear; close all; %Limpiar la linea de comandos
pkg load image; %Cargar el paquete de imagenes
pkg load video; %Cargar paquete de video

v  = VideoReader('../Parte 1/videos/video_original.mp4'); %Cargar video

fr = v.NumberOfFrames; % cantidad de frames
m = v.Height; % dimensiones
n = v.Width;
Y = uint8(zeros(m, n, 3, fr)); %Convertir a formato 8bits
for i = 1 : fr
  Vr = readFrame(v);
  Y(:,:,:,i)= imnoise(Vr(:,:,:),"salt & pepper",0.05); %Agregar ruido, por defecto es 0.05
end

%Creacion del video con ruido
video = VideoWriter('../Parte 1/videos/video_con_ruido.mp4'); %Escribir el video 
for i = 1 : fr
    writeVideo(video, Y(:,:,:, i)); %Escribir el video
end
close(video)