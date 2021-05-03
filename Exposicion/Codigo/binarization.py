import cv2
import numpy as np
from matplotlib import pyplot as plt

#pc es la imagen 
gray = cv2.imread('resultadoWatershed.png', cv2.IMREAD_GRAYSCALE)


#100 es el valor utilizado
t, dst = cv2.threshold(gray, 160, 255, cv2.THRESH_BINARY)
#exporta el resultado de la binarizacion
#cv2.imwrite('export.jpg', dst)
cv2.imshow('export.jpg', dst) 
#imgplot = plt.imshow(dst)

cv2.waitKey(0)