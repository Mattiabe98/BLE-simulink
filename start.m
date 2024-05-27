clear all;
SNRvalues = [-8:2:16];
Limitvalues = [0:0.1:1];

BER1M = zeros(1,length(SNRvalues));
BER2M = zeros(1,length(SNRvalues));
BER500K = zeros(1,length(SNRvalues));
BER125K = zeros(1,length(SNRvalues));

modes = {'LE1M','LE2M','LE500K','LE125K'};

for Limit = Limitvalues
    j = 1;
for i = SNRvalues
    SNR = i
    sim('waveformSimulink_blocchi', 1);
    BER1M(j) = ErrorVec1M(1);
    BER2M(j) = ErrorVec2M(1);
    BER500K(j) = ErrorVec500K(1);
    BER125K(j) = ErrorVec125K(1);
    j = j + 1;
end


figure;

semilogy(SNRvalues, BER1M, ['o' 'b' '-']);
hold on;
semilogy(SNRvalues, BER2M, ['x' 'c' '-']);
hold on;
semilogy(SNRvalues, BER500K, ['*' 'm' '-']);
hold on;
semilogy(SNRvalues, BER125K, ['s' 'r' '-']);
hold on;

grid on;
xlabel('SNR (dB)');
ylabel('BER');
legend(modes);
title(['BER per BLE con rumore AWGN, Limit = ', num2str(Limit), ]);

end