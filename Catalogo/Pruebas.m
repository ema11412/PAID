pkg load image

% dilatacion y erosión

A = imread('Imagenes9/imagen11.jpg');
subplot(1, 3, 1)
imshow(A)
title('Imagen Original')

[m, n] = size(A);
C = uint8(zeros(m, n)); % imagen de salida.


% dilatación
#Bordes

disp('dil')
C(1,1)=max(max(A(1:2, 1:2)));
C(1,n)=max(max(A(1:2, n-1:n)));
C(m,1)=max(max(A(m-1:m, 1:2)));
C(m,n)=max(max(A(m-1:m, n-1:n)));

for x = 2: m-1
    C(x,1)=max(max(A(x-1:x+1, 1:2)));
    C(x,n)=max(max(A(x-1:x+1, n-1:n)));
endfor

for y = 2: n-1
    C(1,y)=max(max(A(1:2, y-1:y+1)));
    C(m,y)=max(max(A(m-1:m, y-1:y+1)));
endfor

for x = 2: m-1
    for y = 2: n-1
        C(x, y) = max(max(A(x-1:x+1, y-1:y+1)));
    endfor
endfor

subplot(1, 3, 2)
imshow(C)
title('Dilatacion')

% Erosión

disp('Erosion')
C(x,1)=min(min(A(1:2, 1:2)));
C(x,1)=min(min(A(1:2, n-1:n)));
C(x,1)=min(min(A(m-1:m, 1:2)));
C(x,1)=min(min(A(m-1:m, n-1:n)));

for x = 2: m-1
    C(x,1)=min(min(A(x-1:x+1, 1:2)));
    C(x,n)=min(min(A(x-1:x+1, n-1:n)));
endfor

for y = 2: n-1
    C(1,y)=min(min(A(1:2, y-1:y+1)));
    C(m,y)=min(min(A(m-1:m, y-1:y+1)));
endfor

for x = 2: m-1
    for y = 2: n-1
        D(x, y) = min(min(A(x-1:x+1, y-1:y+1)));
    endfor
endfor

subplot(1, 3, 3)
imshow(D)
title('Erosion')
