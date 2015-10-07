function duration(vs,fs,d) #That function cut samples length of any sound according to their duration.
    if(d<=size(vs)[1]/fs-1/fs)
    k=int64(d*fs+1)
    Vs=zeros(k,size(vs)[2])
    for j=1:size(vs)[2]
        for i=1:size(vs)[1]
            if(i<k+1)
        Vs[i,j]=vs[i,j]
            end
        end
    end
    return Vs
    else
        error("Tiempo excedido")
    end
end
#Inicio del programa

dur=5; # duration of sound signal
using WAV #That package let me read any sound signal and convert that signal in samples
using PyPlot #Plot Pakage 
using DSP #function for Digital Signal Processing 
close("all")

archivo1="C:\\JULIA\\Grab6.wav"
vs1, fs1 = wavread(archivo1)
Vs1=duration(vs1,fs1,dur)
Vs1
length((Vs1))
archivo2="C:\\JULIA\\Grab7.wav"
vs2, fs2 = wavread(archivo2)
Vs2=duration(vs2,fs2,dur)
Vs2
archivo3="C:\\JULIA\\Grab8.wav"
vs3, fs3 = wavread(archivo3)
Vs3=duration(vs3,fs3,dur)
Vs3

dt=1/fs1;
#te=[dt:dt:dt*(size(Vs1)[1])]
t=linspace(dt,dt*size(Vs1)[1],size(Vs1)[1])
plot(t,Vs1[:,1])
##plot(te,Vs1[:,1])
ruido1=0.006/20*rand(size(t))
#Señales con ruido
x1=Vs1[:,1]+ruido1
x2=Vs2[:,1]+ruido1
x3=Vs3[:,1]+ruido1

f=linspace(-1*fs1/2,1*fs1/2,length(t))
figure(1)
espectro1=abs(fftshift(fft(x1)/length(t)))
espectro2=abs(fftshift(fft(x2)/length(t)))
espectro3=abs(fftshift(fft(x3)/length(t)))
subplot(3,2,1)
plot(f,espectro1)
title("Primera señal")
subplot(3,2,3)
plot(f,espectro2)
title("Segunda señal")
subplot(3,2,5)
plot(f,espectro3)
title("Tercera señal")
#filtrado de señal con ruido

#Filtracion del ruido

    #Primera señal
response1=Lowpass(3000,fs=fs1)
orden=Butterworth(10);
filtrada1=filt(digitalfilter(response1,orden),x1)
FILTRADA1=abs(fftshift(fft(filtrada1)/length(t)))
subplot(3,2,2)
plot(f,FILTRADA1)
title("Primera señal filtrada 3Khz")

    #Segunda señal
response2=Lowpass(3000,fs=fs2)
orden=Butterworth(10);
filtrada2=filt(digitalfilter(response2,orden),x2)
FILTRADA2=abs(fftshift(fft(filtrada2)/length(t)))
subplot(3,2,4)
plot(f,FILTRADA2)
title("Segunda señal filtrada 3Khz")


    #Tercera señal
response3=Lowpass(4000,fs=fs3)
orden=Butterworth(10);
filtrada3=filt(digitalfilter(response3,orden),x3)
FILTRADA3=abs(fftshift(fft(filtrada3)/length(t)))
subplot(3,2,6)
plot(f,FILTRADA3)
title("Tercera señal filtrada 4Khz")

    #ModulacionAM Doble Banda lateral
figure(2)
title("ModulacionAM")
dbl2=filtrada2.*cos(2*pi*3500*t)
DBL2=abs(fftshift(fft(dbl2)/length(t)))
subplot(2,2,1)
plot(f,DBL2)
title("Modulacion 3.5Khz segunda señal (DBL)")
response22=Bandpass(3500,6500,fs=fs2)
blu2=filt(digitalfilter(response22,orden),dbl2)
BLU2=abs(fftshift(fft(blu2)/length(t)))
subplot(2,2,2)
plot(f,BLU2)
title("BLU segunda señal")
dbl3=filtrada3.*cos(2*pi*7000*t)
DBL3=abs(fftshift(fft(dbl3)/length(t)))
subplot(2,2,3)
plot(f,DBL3)
title("Modulacion 7Khz tercera señal (DBL)")
response33=Bandpass(7000,11000,fs=fs3)
blu3=filt(digitalfilter(response33,orden),dbl3)
BLU3=abs(fftshift(fft(blu3)/length(t)))
subplot(2,2,4)
plot(f,BLU3)
title("BLU tercera señal")
figure(3)
plot(f,FILTRADA1)
plot(f,BLU2)
plot(f,BLU3)
title("Señal FDM")
    #Señal FDM con ruido
suma=filtrada1+blu2+blu3+ruido1
FDM=abs(fftshift(fft(suma)/length(t)))
figure(4)
subplot(3,1,1)
plot(f,FDM)
title("Señal FDM con ruido")
    #Filtracion de señal FDM
response_FDM=Lowpass(11000,fs=fs1)
orden_FDM=Butterworth(15)
fil_FDM=filt(digitalfilter(response_FDM,orden_FDM),suma)
FIL_FDM=abs(fftshift(fft(fil_FDM)/length(t)))
subplot(3,1,2)
plot(f,FIL_FDM)
title("Señal FDM filtrada")
    #ModulacionFDM
mod_FDM=fil_FDM.*cos(2*pi*11100*t)
MOD_FDM=abs(fftshift(fft(mod_FDM)/length(t)))
subplot(3,1,3)
plot(f,MOD_FDM)
title("FDM modulada a 11.2Khz")
