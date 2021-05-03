clc; clear;
%Paquetes necesarios
pkg load video;
pkg load image;

% Archivos utilizados.
V1 = VideoReader('img/video_avion.mp4');
V2 = VideoReader('img/video_cielo.mp4');
frames = V1.NumberOfFrames; 

c_matrix_frame = zeros(V1.Height, V1.Width, 3, frames, "uint8");

C = zeros(V1.Height, V1.Width, 3, "uint8");

tol_g = 160;
tol_rb = 80;
X = zeros(V1.Height, V1.Width, 3);

b_tol_g = 140;
b_tol_rb = 80;
T = zeros(V1.Height, V1.Width);

K = [0.073235 0.176765 0.073235; 0.176765 0 0.176765; 0.073235 0.176765 0.073235];
iter = 45;
Df = zeros(V1.Height, V1.Width, 3);

Z = strel('square', 3);

S = zeros(V1.Height, V1.Width, 3);

m = V1.Height;
n = V1.Width;

%Medir el tiempo usando Tic  -  Toc
tic
% Aplicacion del croma.
for k = 1:frames
    S = zeros(V1.Height, V1.Width, 3);
    T = zeros(V1.Height, V1.Width);
    X = zeros(V1.Height, V1.Width, 3);
    
    A = readFrame(V1); 
    B = readFrame(V2);

    X(:, :, 1) = (A(:, :, 1) <= tol_rb) & (A(:, :, 2) >= (255 - tol_g)) & (A(:, :, 3) <= tol_rb);
    X(:, :, 2) = (A(:, :, 1) <= tol_rb) & (A(:, :, 2) >= (255 - tol_g)) & (A(:, :, 3) <= tol_rb);
    X(:, :, 3) = (A(:, :, 1) <= tol_rb) & (A(:, :, 2) >= (255 - tol_g)) & (A(:, :, 3) <= tol_rb);

    C(X == 1) = B(X == 1);
    C(X == 0) = A(X == 0); 


    T((A(:, :, 1) <= b_tol_rb) & (A(:, :, 2) >= (255 - b_tol_g)) & (A(:, :, 3) <= b_tol_rb)) = 1;

    T = ~T;
    
    % Silueta para cada frame.
    Y = imerode(T, Z);   
    S(:, :, 1) = T & ~Y;
    S(:, :, 2) = T & ~Y;
    S(:, :, 3) = T & ~Y;

    Df(:, :, 1) = C(:, :, 1);
    Df(:, :, 2) = C(:, :, 2);
    Df(:, :, 3) = C(:, :, 3);

    for i = 1:iter
      for j = 1:3
        U = conv2(Df(:, :, j), K);
        U = U(2 : m + 1, 2 : n + 1);
        Df(:, :, j) = U;
      endfor
    endfor



    Df = im2uint8(Df);
    C = im2uint8(C);

    C(S == 1) = Df(S == 1);

    c_matrix_frame(:, :, :, k) = C; 
endfor


% Creacion del video.
video = VideoWriter('video_croma.mp4');
% Grabacion del video
for i = 1:frames
  writeVideo(video, c_matrix_frame(:,:,:,i)); 
endfor
toc
% Fin del tiempo.

% indicador final.
display('Finalizado')
% cierra video.
close(video)