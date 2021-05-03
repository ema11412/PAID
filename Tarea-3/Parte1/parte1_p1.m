clc; clear;

pkg load image;

% carga de imagenes. 
A = imread("img/fondo_verde.jpg");
B = imread("img/playa.jpg");

[m, n, r] = size(A);
% matriz donde se guarda la imagen resultante.
C = zeros(m, n, r, "uint8");

% definimos la tolerancia.
tol_rb = 80;
tol_g = 100;

% verificacion de los pixeles verdes.
X = ones(m, n, r);
X(:, :, 1) = (A(:, :, 1) <= tol_rb) & (A(:, :, 2) >= (255 - tol_g)) & (A(:, :, 3) <= tol_rb);
X(:, :, 2) = (A(:, :, 1) <= tol_rb) & (A(:, :, 2) >= (255 - tol_g)) & (A(:, :, 3) <= tol_rb);
X(:, :, 3) = (A(:, :, 1) <= tol_rb) & (A(:, :, 2) >= (255 - tol_g)) & (A(:, :, 3) <= tol_rb);

% creacion de la imagen.
C(X == 1) = B(X == 1);
C(X == 0) = A(X == 0);

imshow(C);
