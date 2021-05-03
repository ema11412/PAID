# -*- coding: utf-8 -*-
"""
Created on Fri Oct  9 10:21:19 2020

@author:    Ema
            Luis
            Marcelo
"""


import numpy
import matplotlib.pyplot as plt 
import numpy as np
from matplotlib import image as img

      
    
    
def main():
    """
    __________________________________________________________________________
    Esta funcion es la encargada de realizan la reconstruccion de imagenes
    En especial imagenes satelitales, en blanco y negro.
    
    No retorna como tal, pero muestra las imagenes tanto la imagen a limpiar
    como la imagen reconstruida con distinto valores de r
    
    Imagenes cargadas en la base de datos DB: 416
    Valores de r tomados: 1,40, 120, 220, 300, 380, 416
    __________________________________________________________________________

    """
    #Se carga la imagen que se desea la limpieza.
    oImg = img.imread('img\\limpiar.jpg')
    #se convierte la matriz en un array de numpy
    oImg = np.asarray(oImg)

    #total de imagenes de la base de datos.
    total = 416
    
    r = [1,40, 120, 220, 300, 380, 416]
    m, n = np.asarray(oImg).shape

    #Se crean las matrices
    B = np.zeros((n*m,total))
    C = np.zeros((n*m,total))
    
    
    
    i=1
    #Cargamos las DB de imagenes con ruido y sin ruido.
    while i<=total:
        #se carga imagen limpia de la carpeta /original
        v_limpio0 = img.imread('original\\sat_original' + str(i) +'.jpg')
        #se convierte la matriz en un array de numpy
        v_limpio  = np.reshape(v_limpio0, (1, n*m))
        
        #se carga imagen con ruido de la carpeta /ruido
        v_ruido0  = img.imread('ruido\\sat_ruido' + str(i) +'.jpg')
        #se convierte la matriz en un array de numpy
        v_ruido   = np.reshape(v_ruido0, (1,n*m))
        
        #Se almacena como columna la imagen limpia en la matriz de DB
        C[:,i-1] = v_limpio
        #Se almacena como columna la imagen con ruido en la matriz de DB
        B[:,i-1] = v_ruido
        
        #se incrementa el contador para pasar a la siguiente imagen
        i+=1
    
    #Se calcula el rango de la matriz B
    s = numpy.linalg.matrix_rank(B)
    
    #Se descompone en valores signgulares b
    Ub, Sb1, Vb = np.linalg.svd(B)
    
    #SE TRANSPONE Vb ya que el SVD de python da esta matriz transpuesta
    Vb = np.transpose(Vb)

    #Se toman las primeras s columnas de la matriz Vb.
    Vs = Vb[:,:s]

    #Se calcula Ps como C * Vs * Vs'
    Ps = C @ Vs @ np.transpose(Vs)
    
    
    #Se descompone en valores signgulares Pr
    U, S1, V = np.linalg.svd(Ps)
    
    #SE TRANSPONE V ya que el SVD de python da esta matriz transpuesta
    V = np.transpose(V)
    
    #Se convierte en diagonal el valor S, ya que el svd devuelve un vector
    #Y no una matriz diagonal
    S = np.diag(S1)
    
    #Se crea la matriz de salida o limpia.
    nImg = np.zeros((m,n))
    
    #Indice que recorre el vector r, el cual tiene la cantidad a utilizar
    x=0
    
    while x<len(r):
        #Se toman las primeras r columnas de U
        Ur = U[:,:r[x]]
        #Se toman las primeras r columnas y r filas de de S
        Sr = S[:r[x],:r[x]]
        #Se toman las primeras r columnas de V
        Vr = V[:,:r[x]]
        #Se calcula Pr como Ur * Sr * Vr'
        Pr = Ur @ Sr @ np.transpose(Vr)
        
        #Se calcula el valor de la pseudo inversa de B
        Bt = np.linalg.pinv(B)
        
        #Se calcula el filtro Z, como Pr * Bt
        Z = Pr @ Bt
        #Se le aplica el filtro a la imagen, pero esta en forma de vector columna
        clean = Z @ np.reshape(oImg,(n*m,1))
        
        #Se reescala la imagen ya que debe ser mxn como la imagen original.
        imgClean = np.reshape(clean,(m,n))
        
        #Se asigna a nImg el valor de la imagen filtrada
        nImg = imgClean
        
        #Grafica
        #----------------------------------------------------------------------
        #Se realiza la asignacion de los espacios para graficar en un 1 x 2
        fig, (ax1, ax2) = plt.subplots(1, 2)
        #A la primera se le asigna la imagen sin filtro
        ax1.imshow(oImg, cmap='gray')
        #Se le asigna un titulo a esa imagen 1,1
        ax1.set_title('Imagen con ruido')
        #Se saca el valor int del vector, el r de la iteracion actual.
        index = r[x]
        #se crea el titulo para la imagen filtrada
        titulo = "Imagen con r=" +str(index)
        #Se asigna al segundo espacio la imagen reconstruida
        ax2.imshow(nImg, cmap='gray')
        #Se le asigna un titulo a la imagen 1,2
        ax2.set_title(titulo)
        
        #Se incrementa el valor del indice que recorre el vector r
        x+=1



main()






    
    
