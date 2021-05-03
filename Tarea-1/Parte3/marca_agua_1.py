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


def embedWatermark(image, mark):
    # Carga la imagen original y la marca de agua
    originalImage = img.imread(image).astype(float)
    watermark = img.imread(mark).astype(float)

    # Obtiene las dimensiones de la imagen original
    rows, cols = originalImage.shape

    dctImage = np.zeros((rows, cols))

    A = np.zeros((64, 64))

    # divide la imagen en bloques de 8x8 y obtiene el valor DC de cada bloque

    aj = 0

    for i in r_[:rows:8]:
        for j in r_[:cols:8]:
            # Aplica DCT al bloque
            dctBlock = apply2Ddct(originalImage[i:(i + 8), j:(j + 8)])
            dctImage[i:(i + 8), j:(j + 8)] = dctBlock
            # Guarda el DC value en matriz A.
            A[i // 8, aj] = dctBlock[0][0]

            if aj == 63:
                aj = 0
            else:
                aj += 1

    # Aplica SVD a la matriz obtenida de 64x64 con los nuevos valores.
    U, S, V = np.linalg.svd(A)

    alpha = 0.1

    newMatrix = np.add(np.diag(S), alpha * watermark)

    U1, S1, V1 = np.linalg.svd(newMatrix)

    # Crea matriz con los nuevos valores DC
    newA = U @ np.diag(S1) @ V

    watermarkedImage = np.zeros((rows, cols))

    # Cambia los valores DC y aplica transformada inversa a cada bloque.
    aj = 0
    for i in r_[:rows:8]:
        for j in r_[:cols:8]:
            currentBlock = dctImage[i:(i + 8), j:(j + 8)]
            currentBlock[0][0] = newA[i // 8, aj]
            watermarkedImage[i:(i + 8), j:(j + 8)] = applyInverse2Ddct(currentBlock)
            if aj == 63:
                aj = 0
            else:
                aj += 1

    return watermarkedImage, U1, V1, S


def extractWatermark(image):

    watermarkedImage = image[0]
    U1 = image[1]
    V1 = image[2]
    S = image[3]

    # divide la imagen en bloques de 8x8 y obtiene el valor DC de cada bloque
    rows, cols = watermarkedImage.shape

    dctImage = np.zeros((rows, cols))

    A_star = np.zeros((64, 64))

    aj = 0

    # Extrae bloques de 8x8 de la imagen marcada y les aplica DCT de nuevo.
    for i in r_[:rows:8]:
        for j in r_[:cols:8]:
            # Aplica DCT al bloque
            dctBlock = apply2Ddct(watermarkedImage[i:(i + 8), j:(j + 8)])
            dctImage[i:(i + 8), j:(j + 8)] = dctBlock
            # Guarda el DC value en matriz A.
            A_star[i // 8, aj] = dctBlock[0][0]

            if aj == 63:
                aj = 0
            else:
                aj += 1

    U_star, S1_star, V_star = np.linalg.svd(A_star)

    D_star = U1 @ np.diag(S1_star) @ V1

    alpha = 0.1

    # genera la matriz con la marca de agua.
    watermark = 1/alpha * (D_star - np.diag(S))

    # plots
    fig, axs = plt.subplots(2, 2)

    axs[0, 0].imshow(img.imread('imagen1.jpg'), cmap='gray')
    axs[0, 0].set_title('Imagen Original')
    axs[0, 0].set_yticklabels([])
    axs[0, 0].set_xticklabels([])

    axs[0, 1].imshow(img.imread('marca.jpg'), cmap='gray')
    axs[0, 1].set_title('Marca de agua')
    axs[0, 1].set_yticklabels([])
    axs[0, 1].set_xticklabels([])

    axs[1, 0].imshow(watermarkedImage, cmap='gray')
    axs[1, 0].set_title('Imagen con marca de agua')
    axs[1, 0].set_yticklabels([])
    axs[1, 0].set_xticklabels([])

    axs[1, 1].imshow(watermark, cmap='gray')
    axs[1, 1].set_title('Marca de agua extraída')
    axs[1, 1].set_yticklabels([])
    axs[1, 1].set_xticklabels([])

    plt.show()


extractWatermark(embedWatermark('imagen1.jpg', 'marca.jpg'))
