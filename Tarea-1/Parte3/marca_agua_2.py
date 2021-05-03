import numpy as np
from matplotlib import image as img
from matplotlib import pyplot as plt
from scipy.fftpack import dct, idct
from numpy import r_

np.set_printoptions(suppress=True)


def apply2Ddct(matrix):
    return dct(dct(matrix, axis=0, norm='ortho'), axis=1, norm='ortho')


def applyInverse2Ddct(matrix):
    return idct(idct(matrix, axis=0, norm='ortho'), axis=1, norm='ortho')


def getSmatrix(originalImage):
    # Carga la imagen original y la marca de agua
    originalImage = img.imread(originalImage).astype(float)

    # Obtiene las dimensiones de la imagen original
    rows, cols = originalImage.shape

    dctImage = np.zeros((rows, cols))

    A = np.zeros((256, 256))

    # divide la imagen en bloques de 8x8 y obtiene el valor DC de cada bloque

    aj = 0

    for i in r_[:rows:4]:
        for j in r_[:cols:4]:
            # Aplica DCT al bloque
            dctBlock = apply2Ddct(originalImage[i:(i + 4), j:(j + 4)])
            dctImage[i:(i + 4), j:(j + 4)] = dctBlock
            # Guarda el DC value en matriz A.
            A[i // 4, aj] = dctBlock[0][0]

            if aj == 255:
                aj = 0
            else:
                aj += 1

    # Aplica SVD a la matriz obtenida de 256x256.
    U, S, V = np.linalg.svd(A)

    return S


def extractWatermark(image, U1, S, V1):
    watermarkedImage = img.imread(image).astype(float)

    rows, cols = watermarkedImage.shape

    dctImage = np.zeros((rows, cols))

    # crea una matriz para almacenar los valores DC de los bloques 4x4
    A_star = np.zeros((256, 256))

    aj = 0

    for i in r_[:rows:4]:
        for j in r_[:cols:4]:
            # Aplica DCT al bloque 4x4
            dctBlock = apply2Ddct(watermarkedImage[i:(i + 4), j:(j + 4)])
            dctImage[i:(i + 4), j:(j + 4)] = dctBlock
            # Guarda el DC value en matriz A*.
            A_star[i // 4, aj] = dctBlock[0][0]

            if aj == 255:
                aj = 0
            else:
                aj += 1

    U_star, S1_star, V_star = np.linalg.svd(A_star)

    D_star = U1 @ np.diag(S1_star) @ V1.T

    alpha = 0.1

    # calcula la matriz de la marca de agua.
    watermark = 1/alpha * (D_star - np.diag(S))

    fig, (ax1, ax2) = plt.subplots(1, 2)

    ax1.imshow(watermarkedImage.astype(np.uint8), cmap='gray')
    ax1.set_title('Imagen con ruido')

    ax2.imshow(watermark, cmap='gray', vmax=255, vmin=0)
    ax2.set_title('Marca extraída')

    plt.show()


U1 = np.loadtxt("U1.mat")
V1 = np.loadtxt("V1.mat")
S = getSmatrix("imagen3.jpg")

extractWatermark("imagen2.jpg", U1, S, V1)


