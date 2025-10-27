%% Digital Modulation Simulation in MATLAB
clc; 
clear;
close all;

% Parameters
N = 1000;          % Number of bits
SNR_dB = 0:2:14;   % SNR range in dB

%% Generate random bit sequence
bits = randi([0 1], 1, N);

%% BPSK Modulation
bpsk_symbols = 2*bits-1;  % 0->-1, 1->1

% Initialize BER array
BER_BPSK = zeros(1,length(SNR_dB));

% AWGN Channel
for i = 1:length(SNR_dB)
    rx = bpsk_symbols + 1/sqrt(2)*(10^(-SNR_dB(i)/20))*randn(1,N);
    rx_bits = rx > 0;
    BER_BPSK(i) = sum(bits ~= rx_bits)/N;
end

%% QPSK Modulation
qpsk_symbols = (2*randi([0 1],1,N/2)-1) + 1j*(2*randi([0 1],1,N/2)-1);
BER_QPSK = zeros(1,length(SNR_dB));
for i = 1:length(SNR_dB)
    rx = qpsk_symbols + 1/sqrt(2)*(10^(-SNR_dB(i)/20))*(randn(1,N/2)+1j*randn(1,N/2));
    rx_bits = [real(rx)>0; imag(rx)>0];
    tx_bits = [real(qpsk_symbols)>0; imag(qpsk_symbols)>0];
    BER_QPSK(i) = sum(tx_bits(:) ~= rx_bits(:))/N;
end

%% Plot BER for BPSK and QPSK
figure;
semilogy(SNR_dB, BER_BPSK,'-o','LineWidth',2); hold on;
semilogy(SNR_dB, BER_QPSK,'-s','LineWidth',2);
grid on; xlabel('SNR (dB)'); ylabel('Bit Error Rate (BER)');
legend('BPSK','QPSK'); title('Digital Modulation BER vs SNR');
