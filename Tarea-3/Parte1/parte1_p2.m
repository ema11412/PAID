clc; clear;

pkg load image;

%carga de imagenes
A = imread("img/fondo_verde.jpg");
B = imread("img/playa.jpg");

[m, n, r] = size(A);
C = zeros(m, n, r, "uint8");

% Creacion de tolerancias separadas para mejores resultados
tol_g = 140;
tol_rb = 80;

% Se verifican solo los pixeles verdes
X = zeros(m, n, r);
X(:, :, 1) = (A(:, :, 1) <= tol_rb) & (A(:, :, 2) >= (255 - tol_g)) & (A(:, :, 3) <= tol_rb);
X(:, :, 2) = (A(:, :, 1) <= tol_rb) & (A(:, :, 2) >= (255 - tol_g)) & (A(:, :, 3) <= tol_rb);
X(:, :, 3) = (A(:, :, 1) <= tol_rb) & (A(:, :, 2) >= (255 - tol_g)) & (A(:, :, 3) <= tol_rb);

C(X == 1) = B(X == 1);
C(X == 0) = A(X == 0);
Old = C;
Z = strel('square', 3);

% Matriz Binaria
b_tol_g = 140;
b_tol_rb = 80;

T = zeros(m, n);
T((A(:, :, 1) <= b_tol_rb) & (A(:, :, 2) >= (255 - b_tol_g)) & (A(:, :, 3) <= b_tol_rb)) = 1;

T = ~T;
% Obtencion de la silueta
Y = imerode(T, Z);
S = zeros(m, n, r);

S(:, :, 1) = T & ~Y;
S(:, :, 2) = T & ~Y;
S(:, :, 3) = T & ~Y;

% Conv Kernel
K = [0.073235 0.176765 0.073235; 0.176765 0 0.176765; 0.073235 0.176765 0.073235];
C = im2double(C);

Df = zeros(m, n, r);

Df(:, :, 1) = C(:, :, 1);
Df(:, :, 2) = C(:, :, 2);
Df(:, :, 3) = C(:, :, 3);

%iteraciones para la convolucion.
iter = 40;

%Se realiza la convolucion varias veces.
%Para mejorar la eliminacion de la silueta o borde verde.
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


%Se imprimen las imagenes.
subplot(2, 2, 1);
imshow(Old);
title("Original Image");

subplot(2, 2, 2);
imshow(C);
title("New Image");


subplot(2, 2, [3 4]);
imshow(S);
title("Silueta");