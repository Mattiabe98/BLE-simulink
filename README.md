# BLE-simulink
Modello Simulink per trasmissione Bluetooth Low Energy e misura BER su canale AWGN, sviluppato come prova finale per il corso di Sistemi per le Comunicazioni - PoliMi.

## Introduzione

Il Bluetooth Low Energy (BLE) è una tecnologia wireless emergente sviluppata per le comunicazioni a corta distanza. A differenza del precedente Bluetooth, BLE è stato sviluppato come una soluzione a bassa potenza per controllare e monitorare applicazioni di vario genere, in particolare per l’Internet of Things (IoT). BLE è una particolare funzione della specifica 4.0 del Bluetooth.
## Obiettivo
Sviluppo di un modello BLE su Simulink e calcolo del bit error rate (BER) su canale AWGN e/o in presenza di imperfezioni a radiofrequenza (RF).

## Specifiche

![image](https://github.com/Mattiabe98/BLE-simulink/assets/49247389/f48a4c2b-d2c5-48da-ab00-d86888412c23)


**Modalità di trasmissione:**

◦	LE1M: trasmissione non codificata a 1 Mbps a livello fisico

◦	LE2M: trasmissione non codificata a 2 Mbps a livello fisico

◦	LE500K: trasmissione codificata a 500 Kbps a livello fisico

◦	LE125K: trasmissione codificata a 125 Kbps a livello fisico


## Specifiche pacchetto BLE
Un pacchetto BLE è composto da più campi:
•	Preambolo: dipende dalla modalità di trasmissione; LE1M usa un preambolo di 8 bit di zero e uno alternati (01010101). LE2M usa un preambolo di 16 bit sempre alternati. LE500K e LE125K usano un preambolo di 80 bit ripetendo dieci volte la sequenza ‘00111100’.

•	Access address: specifica l’indirizzo di connessione condiviso tra due dispositivi BLE usando una sequenza a 32 bit. Essendo in una simulazione con solo due dispositivi, si usa l’access address predefinito.

•	Payload: messaggio in input contenente sia il PDU (protocol data unit) che il CRC (cyclic redundancy check). 
Ha grandezza massima di 2080 bit.


Inoltre, nelle modulazioni codificate, è presente anche un coding indicator di 2 bit per differenziare le due modalità di trasmissione (LE125K e LE500K) e due termination fields composti da due vettori da 3 bit per correzione dell’errore di codifica.

![image](https://github.com/Mattiabe98/BLE-simulink/assets/49247389/0192ee27-096d-450d-9448-c949cf11b307)


## Specifiche a livello fisico
Bluetooth Low Energy |	Bluetooth classico

Sensibilità ricevitore (dBm)	-87 a -93 |	-90

Potenza di trasmissione (dBm)	-20 a 10	| 20/4/0 (classe 1/2/3)


## Spiegazione progetto
Prendendo spunto dagli esempi scritti in codice Matlab da Mathworks, abbiamo replicato il modello di trasmissione BLE usando blocchi Simulink.
Per ogni modalità di trasmissione abbiamo creato un subsystem composto da:
1.	Generazione del sequenza binaria casuale
In base alla modalità di trasmissione viene generata una sequenza binaria casuale di 1000 bit con bitrate uguale alla velocità di trasmissione.
2.	Costruzione pacchetto
Nella modulazione uncoded, il pacchetto viene costruito concatenando il preambolo, l’access address e il messaggio sbiancato. Nella modulazione coded il pacchetto viene costruito concatenando il preambolo e il messaggio prima sbiancato e poi codificato, insieme all’access address.
Il messaggio viene sbiancato per decorrelare tutti i campioni della sequenza.
3.	Modulazione GMSK
4.	Canale AWGN: Aggiunge rumore bianco gaussiano al segnale con un seed casuale e parametro SNR configurabile dal programma.
6.	Demodulazione
7.	Calcolo bit error rate

Il bit error rate viene calcolato mediante un blocco che riceve in input sia il messaggio trasmesso che il messaggio ricevuto.
Per simulare imperfezioni a radiofrequenza possiamo ricorrere ad un blocco di saturazione che replica il passaggio del segnale tramite un amplificatore lineare con valore ‘Limit’, svolgendo la funzione di limitatore in ampiezza. Il segnale in uscita avrà valore massimo di ampiezza uguale a ‘Limit’.
Il programma Matlab inizializza un vettore con tutti i valori interessati di SNR (‘SNRvalues’) e la costante ‘Limit’.  Tramite un ciclo for simula per ogni valore di SNR e per ogni modalità di trasmissione il modello BLE e ne calcola il BER. Terminata la simulazione, i valori vengono raffigurati su un grafico logaritmico.

Valori SNR usati

EbNo = -2:2:8;

    % Set signal to noise ratio (SNR) points based on mode
    % For Coded PHY's (LE500K and LE125K), the code rate factor is included
    % in SNR calculation as 1/2 rate FEC encoder is used.
    if any(strcmp(phyMode,{'LE1M','LE2M'}))
        snrVec = EbNo - 10*log10(sps);
    else
        codeRate = 1/2;
        snrVec = EbNo + 10*log10(codeRate) - 10*log10(sps);
    end
Con sps = 4 il range di SNR è da -8 a 2 per le modulazioni uncoded, da -11 a -1 per quelle coded a causa dell’encoder FEC.



## Osservazioni

![image](https://github.com/Mattiabe98/BLE-simulink/assets/49247389/7a3c7d93-9e53-4253-ac91-88082bc9fb1a)

Analizzando il grafico ottenuto, si può notare che le modalità di trasmissione coded, anche se più lente rispetto a quello uncoded, hanno maggiore affidabilità a pari SNR, grazie ad un BER più basso.
All’aumentare dell’SNR il BER delle modalità di trasmissione coded scende molto più velocemente, fino ad arrivare a zero.

Facendo varie prove con diversi valori di ‘Limit’, abbiamo notato che sopra 0.1, il grafico assume un andamento simile ad un canale con solo AWGN.

![image](https://github.com/Mattiabe98/BLE-simulink/assets/49247389/2365b6db-97f3-4bbd-b08c-dad82d898fea)
