# -*- coding: utf-8 -*-
"""
Created on Mon May 18 15:59:00 2020

@author: qiu
"""

def TCN_model(filters, kernel_size, dilations, dropout,a,b):  
    import numpy as np
    from tensorflow.keras import Sequential
    from tensorflow.keras.callbacks import Callback
    from tensorflow.keras.datasets import imdb
    from tensorflow.keras.layers import Dense, Dropout, Embedding
    from tensorflow.keras.preprocessing import sequence
    from tensorflow.keras import optimizers
    from tensorflow.keras.layers import MaxPooling1D

    from tcn import TCN

    
    model = Sequential()
    model.add(TCN(nb_filters=filters,
              kernel_size=kernel_size,
              dilations=dilations, input_shape=(a, b),
                 return_sequences=False))
              #dilations=[1, 2, 4, 8, 16, 32, 64]))
    model.add(Dropout(dropout))
    #model.add(MaxPooling1D(pool_size=2, strides=None, padding='valid', data_format='channels_last'))
    #model.add(TCN(nb_filters=filters,
    #          kernel_size=kernel_size,
    #          dilations=dilations,
    #             return_sequences=False))
    #model.add(Dropout(dropout))
    model.add(Dense(1))
    #adm= optimizers.Adam(beta_1=0.9, beta_2=0.999, amsgrad=False, decay= 0.005)
    model.compile(optimizer='adam', loss='mean_squared_error', metrics=['accuracy'])
    
    return model 
