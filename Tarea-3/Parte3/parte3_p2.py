from matplotlib import pyplot as plt
import numpy as np
import cv2


def rgb2gray(rgb):
    return np.dot(rgb[..., :3], [0.2989, 0.5870, 0.1140])


base_image = plt.imread("imagen3.png")

# En caso de que la imagen se detecte como RGB, se pasa a escala de grises.
if len(base_image.shape) > 2:
    base_image = rgb2gray(base_image)

m, n = base_image.shape

# Reduccion de ruido con filtro gaussiano, utilizando kernel de 3x3
blurred = np.multiply(cv2.GaussianBlur(base_image, (3, 3), cv2.BORDER_DEFAULT), 255).astype(np.uint8)

# deteccion de bordes (filtro paso altas)
edges = cv2.Canny(blurred, 100, 200)

# convierte a imagen binaria
edges = np.where(edges >= 0.5, 1, 0)

p = int(round(np.sqrt(n**2 + m**2)))

# acumulador
acc = np.zeros((m, n, p))

# obtiene los indices de los bordes detectados. "x" y "y" son vectores con indices
x, y = np.nonzero(edges)

# recorre los bordes y actualiza acumulador.
for xi, yi in zip(x, y):
    for a in range(1, m):
        for b in range(1, n):
            r = np.sqrt((xi - a)**2 + (yi - b)**2)
            if r > 0:
                acc[a, b, int(round(r))] += 1/(2*np.pi*r)


output = np.zeros(blurred.shape)

a, b, r = np.where(acc >= 0.5)

for ai, bi, ri in zip(a, b, r):
    if ri > 15:
        output = cv2.circle(output, (bi, ai), ri, (255, 0, 0), 1)

fig, (ax1, ax2, ax3) = plt.subplots(1, 3)
ax1.imshow(base_image, cmap='gray')
ax1.set_title("Imagen Original")
ax2.imshow(edges, cmap='gray')
ax2.set_title('Bordes')
ax3.imshow(output, cmap='gray')
ax3.set_title("Círculos detectados")
plt.show()