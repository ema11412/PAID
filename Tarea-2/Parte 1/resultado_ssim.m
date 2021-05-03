clc; clear;

% Carga de paquetes
% ------------------------
pkg load image;
pkg load video;
% ------------------------

% Carga de videos.
original = VideoReader("videos/video_original.mp4");
reconstruction1 = VideoReader("videos/video_sin_ruido_alg1.mp4");
reconstruction2 = VideoReader("videos/video_sin_ruido_alg2.mp4");


% Se extrae la cantidad de cuadros de los que esta compuesto el video
frames = original.NumberOfFrames;
% Aca se guarda los valores SSIM por cuadro de los videos.
ssimV1 = [];
ssimV2 = [];
% Aca se guardan los valores para luego sacar promedio
TotalSSIM1 = 0;
TotalSSIM2 = 0;




% Se recorre por cuadros los videos mientras se compara con las reconstrucciones
for i = 1:frames
  
  % Se saca el frame correcpondiente en cada video.
  originalFrame = rgb2gray(readFrame(original, i));
  rec1Frame = rgb2gray(readFrame(reconstruction1, i));
  rec2Frame = rgb2gray(readFrame(reconstruction2, i));
  
  % Se calcula el SSIM con el frame de cada recosntruccion y el original.
  [ssimValue1,_] = ssim(originalFrame, rec1Frame);
  [ssimValue2,_] = ssim(originalFrame, rec2Frame);
  
  % Se almacena en la variable TOTAL para sacar el promedio.
  TotalSSIM1 += ssimValue1;
  TotalSSIM2 += ssimValue2;
  
  % Se guarda el valor de SSIM en el vector, para graficar.
  ssimV1 = [ssimV1 ssimValue1];
  ssimV2 = [ssimV2 ssimValue2];

endfor




% Se saca el valor promedio para comparar cual es mayor
promedioSSIM1 = TotalSSIM1 / frames;
promedioSSIM2 = TotalSSIM2 / frames;


% Se grafican los valores ssim--------------------------------------------------
plot(1:frames, ssimV1,1:frames, ssimV2);
xlabel("Frames");
ylabel("Valores de SSIM");
title(["Recontruccion 1(azul) - Promedio: " num2str(promedioSSIM1, 5) " vs Recontruccion 2(naranja) - Promedio" num2str(promedioSSIM2, 5)])